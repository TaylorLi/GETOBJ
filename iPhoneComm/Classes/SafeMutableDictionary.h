//
//  ddd.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/22.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SafeMutableDictionary : NSMutableDictionary
{
    NSLock *lock;
    NSMutableDictionary *underlyingDictionary;
}

@end
