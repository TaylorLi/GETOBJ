//
//  PEDPedoDateLog.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEDPedoDateLog : NSObjectSerialization<SqliteORMDelegate>

@property (nonatomic,strong) NSString *logId;
@property (nonatomic,strong) NSDate *logDate;
@property (nonatomic) NSTimeInterval activeTime;//second
@property (nonatomic) NSInteger step;//count
@property (nonatomic) NSTimeInterval distance;//m
@property (nonatomic) NSTimeInterval caloriesBurned;//cal
@property (nonatomic) NSTimeInterval avgSpeed;//m/s
@property (nonatomic) NSTimeInterval avgPace;//s/m;
@property (nonatomic,strong) NSString *relatedUserInfoId;

@end
