//
//  Reflection.m
//  TKD Score
//
//  Created by Eagle Du on 12/8/26.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "Reflection.h"
#import  <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>

static NSMutableDictionary *classReflectionProperties;

@interface Reflection()

+(NSArray *)getNameOfProperties:(Class)classType;

@end
@implementation Reflection

+(NSArray *)getNameOfProperties:(Class)classType
{
    u_int count;
    objc_property_t* properties = class_copyPropertyList(classType, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    return propertyArray;
}

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    //NSLog(@"original property type:%@",[NSString stringWithUTF8String:attributes]);
    /*
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }
    }
     
    return "@";
    */
    return attributes;
}

+(NSDictionary *)getPropertiesNameAndType:(Class)classType
{
    if(classReflectionProperties==nil){
        classReflectionProperties=[[NSMutableDictionary alloc] init];
    }
    NSString *className=NSStringFromClass(classType);
    if([classReflectionProperties containKey:className]){
        return [classReflectionProperties objectForKey:className];
    }
    u_int count;
    objc_property_t* properties = class_copyPropertyList(classType, &count);
    NSMutableDictionary* propertyArray = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        NSString *key=[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        /* original property type:T@"NSString",&,N,VmatchId
           original property type:Ti,VcurrentRound
         */
        NSString *orgPropertyType=[NSString  stringWithCString:getPropertyType(properties[i]) encoding:NSUTF8StringEncoding];
        NSString *propertyType=@"@";
        if(orgPropertyType!=nil&&[orgPropertyType characterAtIndex:0]=='T'){
            NSRange range = [orgPropertyType rangeOfString:@","];
            if(range.location>0){
                propertyType=[orgPropertyType substringWithRange:NSMakeRange(1, range.location-1)];
            }else{
                propertyType=[orgPropertyType substringFromIndex:1];
            }
        }    
        //NSLog(@"slice property name:%@ type:%@",key,propertyType);
        [propertyArray setValue:propertyType forKey:key];
    }
    free(properties);
    [classReflectionProperties setObject:propertyArray forKey:className];
    return propertyArray;
}


@end
