//
//  TKDDatabase.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/2.
//  Copyright (c) 2012年 GET. All rights reserved.
//

/*
 eg.:
 NSArray *settings = [[TKDDatabase getInstance] queryAllServerSetttingList];
 NSObject *obj=[[TKDDatabase getInstance] queryObject:@"05BDF8D1-38D2-447E-9FF7-1F77D4E19484"];
 */
#import <Foundation/Foundation.h>

@class ServerSetting,GameInfo;

@interface TKDDatabase : NSObject
- (id) init;
+ (TKDDatabase*) getInstance;

-(void)setupServerDatabase;
-(void)dropDatabase;
-(void)clearDatabase;

@end
