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
#import "Database.h"

@implementation NSObjectSerialization

- (void)encodeWithCoder:(NSCoder*)coder
{
    for (NSString *name in [Reflection getPropertiesNameAndType:[self class]].allKeys)
    {@try{
        id value = [self valueForKey:name];
        [coder encodeObject:value forKey:name];
    }@catch (NSException *ex) {
        NSLog(@"%@",ex);
    }
    }
}

- (id)initWithCoder:(NSCoder*)decoder
{
    if (self = [super init])
    {        
        NSDictionary *propeties=[Reflection getPropertiesNameAndType:[self class]];
        for (NSString *name in propeties.allKeys)
        {
            NSString *propertyType=[propeties valueForKey:name];
            id value = [decoder decodeObjectForKey:name];
            if(value==nil){
                if([propertyType isEqualToString:@"c"]){
                    value=[NSNumber numberWithBool:NO];
                }
                else if([propertyType isEqualToString:@"d"]){
                    value=[NSNumber numberWithFloat:0.0];
                }
                else if([propertyType isEqualToString:@"i"]){
                    value=[NSNumber numberWithInt:0];
                }
            }
            @try{
                [self setValue:value forKey:name];
            }@catch (NSException *ex) {
                NSLog(@"%@",ex) ;
            }
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

-(NSDictionary*) proxyForSqlite
{
    NSDictionary *propeties=[Reflection getPropertiesNameAndType:[self class]];
    NSMutableDictionary *result=[NSMutableDictionary dictionaryWithCapacity:propeties.count];
     NSArray *columnsOfTable=[[Database getInstance] columnsOfTableByTableName:NSStringFromClass([self class])];
    for (NSString *propertyName in propeties.allKeys) {
        @try{
            NSString *propertyType=[propeties valueForKey:propertyName];
            if(![columnsOfTable containsObject:propertyName])//classTye
            {
                continue;
            } 
            id value=[self valueForKey:propertyName];
            if([propertyType hasPrefix:@"@"])//classTye
            {               
                if(value==nil)
                    value=[NSNull null];                
            }
            if(value==nil){
                if([propertyType isEqualToString:@"c"]){
                    value=[NSNumber numberWithBool:NO];
                }
                else if([propertyType isEqualToString:@"d"]){
                    value=[NSNumber numberWithFloat:0.0];
                }
                else if([propertyType isEqualToString:@"i"]){
                    value=[NSNumber numberWithInt:0];
                }
            }
            [result setValue:value forKey:propertyName];
        }@catch (NSException *ex) {
            NSLog(@"%@",ex) ;
        }
    }
    return result;
    
}    

-(id)initWithDictionary:(NSDictionary *) dictionary
{
    if(!(self = [super init]))
    {
        return nil;
    }
    self=[self bindingWithDictionary:dictionary];
    return self;
}
-(id)bindingWithDictionary:(NSDictionary *) dictionary
{
    NSDictionary *propeties=[Reflection getPropertiesNameAndType:[self class]];
    for (NSString *propertyName in propeties.allKeys)
    {
        NSString *propertyType=[propeties valueForKey:propertyName];        
        for (NSString *key in dictionary.allKeys) {
            if([key isEqualToString:propertyName])
            {
                id value = [dictionary valueForKey:propertyName]; 
                
                if([propertyType hasPrefix:@"@"])//classTye
                {
                    if([propertyType hasPrefix:@"@\"NSDate\""])
                    {   
                        if([value isKindOfClass:[NSNumber class]])
                            value=[NSDate dateWithTimeIntervalSince1970:[(NSNumber *)value doubleValue]];
                    }
                }    
                if(value==[NSNull null])
                {
                    value=nil;
                }
                if([value isKindOfClass:[NSDictionary class]]){
                    id propValue=[self valueForKey:propertyName];
                    if([propValue respondsToSelector:@selector(initWithDictionary:)]){
                        propValue = [[[propValue class] alloc] initWithDictionary:value];
                    }
                    else
                        [self setValue:value forKey:propertyName];
                }
                else
                    [self setValue:value forKey:propertyName];
                break;
            }
        }
    }
    return self;
}
-(id) copyWithZone:(NSZone *)zone
{
    NSDictionary *propeties=[Reflection getPropertiesNameAndType:[self class]];
   id copyObject = [[[self class] allocWithZone:zone] init];
    for (NSString *propertyName in propeties.allKeys)
    {
        id value=[self valueForKey:propertyName]; 
        id newValue;
        if([value respondsToSelector:@selector(copyWithZone:)])
            {
                newValue=[value copyWithZone:zone];
            }
        else{
            newValue=value;
        }
        [copyObject setValue:newValue forKey:propertyName];
    }
    return copyObject;
}
@end
