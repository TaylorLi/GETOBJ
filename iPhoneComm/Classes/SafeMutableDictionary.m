//
//  ddd.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/22.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "SafeMutableDictionary.h"

@implementation SafeMutableDictionary

- (id)init
{
    if (self = [super init]) {
        lock = [[NSLock alloc] init];
        underlyingDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}


// forward all the calls with the lock held
- (id) forward: (SEL) sel : (id)args
{
    [lock lock];
    @try {
        return [underlyingDictionary performSelector:sel withObject:args];
    }
    @finally {
        [lock unlock];
    }
}

@end


