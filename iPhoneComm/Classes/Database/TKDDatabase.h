//
//  TKDDatabase.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/2.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKDDatabase : NSObject
- (id) init;
+ (TKDDatabase*) getInstance;

-(void)setupServerDatabase;
@end
