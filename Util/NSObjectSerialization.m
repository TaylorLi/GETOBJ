//
//  NSObject+Serialization.m
//  TKD Score
//
//  Created by Eagle Du on 12/8/25.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "NSObjectSerialization.h"
#import  <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import "Reflection.h"

@implementation NSObjectSerialization

- (void)encodeWithCoder:(NSCoder*)coder
{
    for (NSString *name in [Reflection getNameOfProperties:[self class]])
    {
        id value = [self valueForKey:name];
        [coder encodeObject:value forKey:name];
    }
}

- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init])
    {        
        for (NSString *name in [Reflection getNameOfProperties:[self class]])
        {
            id value = [decoder decodeObjectForKey:name];   
            [self setValue:value forKey:name];
        }
    }
    return self;
}

-(NSDictionary*) proxyForJson {
    NSDictionary *propeties=[Reflection getPropertiesNameAndType:[self class]];
    NSMutableDictionary *result=[NSMutableDictionary dictionaryWithCapacity:propeties.count];
    for (NSString *propertyName in propeties.allKeys) {
        NSString *propertyType=[propeties valueForKey:propertyName];
        id value=[self valueForKey:propertyName];
        if([propertyType hasPrefix:@"@"])//classTye
        {
            if(value==nil)
                value=[NSNull null];
            else{
                if([propertyType hasPrefix:@"@\"NSDate\""])
                {
                    value=[NSNumber numberWithDouble:[(NSDate *)value timeIntervalSince1970]];
                }
            }    
        }
        [result setValue:value forKey:propertyName];
    }
    return result;
}

-(id)initWithDictionary:(NSDictionary *) dictionary
{
    if(!(self = [super init]))
    {
        return nil;
    }
    NSDictionary *propeties=[Reflection getPropertiesNameAndType:[self class]];
    for (NSString *propertyName in propeties.allKeys)
    {
        NSString *propertyType=[propeties valueForKey:propertyName];
        NSString *typeName;           
        for (NSString *key in dictionary.allKeys) {
            if([key isEqualToString:propertyName])
            {
                id value = [dictionary valueForKey:propertyName]; 
                if([propertyType hasPrefix:@"@"])//classTye
                {
                    if([typeName hasPrefix:@"@\"NSDate\""])
                    {   value=[NSDate dateWithTimeIntervalSince1970:[(NSNumber *)value doubleValue]];
                    }
                } 
                [self setValue:value forKey:propertyName];
                break;
            }
        }
    }
    return self;
}
@end
