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

@end
