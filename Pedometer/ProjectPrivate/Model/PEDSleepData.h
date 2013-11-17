//
//  PEDSleepData.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEDSleepData : NSObjectSerialization<SqliteORMDelegate>

@property (nonatomic,strong) NSString *dataId;
@property (nonatomic,strong) NSDate *optDate;
@property (nonatomic,strong) NSDate *updateDate;
/*无效时间表示方式 -1*/
@property (nonatomic) NSTimeInterval timeToBed;//23:00 second
@property (nonatomic) NSTimeInterval timeToWakeup;
@property (nonatomic) NSTimeInterval timeToFallSleep;
@property (nonatomic) NSTimeInterval awakenTime;
@property (nonatomic) NSTimeInterval inBedTime;
@property (nonatomic) NSTimeInterval actualSleepTime;
@property (nonatomic,strong) NSString *targetId;

@end
