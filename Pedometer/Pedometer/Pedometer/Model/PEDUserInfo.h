//
//  PEDUserInfo.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEDUserInfo : NSObjectSerialization<SqliteORMDelegate>
@property (nonatomic,strong) NSString *userId;
@property (nonatomic) BOOL isCurrentSetting;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic) DistanceUnit unit;
@property (nonatomic) NSTimeInterval stride;
@property (nonatomic)  NSTimeInterval height;
@property (nonatomic) NSTimeInterval weight;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic) NSInteger age;
@property (nonatomic,strong) NSDate *createDate;
@end
