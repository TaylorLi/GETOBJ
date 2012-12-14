//
//  Extendtion.m
//  TKD Score
//
//  Created by Eagle Du on 12/9/7.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "NSDictionary+Extendtion.h"

@implementation NSDictionary (Extending)
-(BOOL)containKey:(id)key
{
    for (id k in [self allKeys]) {
        if([key isKindOfClass:[NSString class]]){
            if([key isEqualToString:k])
                return YES;
        }
        else if([key isKindOfClass:[NSNumber class]]){
            if([key doubleValue]==[k doubleValue])
                return YES;
        }
        else if(k==key)
            return YES;
    }
    return NO;
}
@end;
