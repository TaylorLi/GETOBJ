//
//  PEDPedometerData.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEDPedometerData : NSObjectSerialization<SqliteORMDelegate>

@property (nonatomic,strong) NSString *dataId;
@property (nonatomic,strong) NSDate *optDate;//记录日期
@property (nonatomic) NSInteger step;
@property (nonatomic) NSTimeInterval activeTime;//second
@property (nonatomic) NSTimeInterval distance;//km
@property (nonatomic) NSTimeInterval calorie;//cal
@property (nonatomic,strong) NSDate *updateDate;//创建日期
@property (nonatomic,strong) NSString *targetId;

@end
