//
//  PEDPedometerData.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEDPedometerData : NSObject

@property (nonatomic,strong) NSString *dataId;
@property (nonatomic,strong) NSDate *optDate;
@property (nonatomic) NSInteger step;
@property (nonatomic,strong) NSDate *activeTime;//second
@property (nonatomic) NSTimeInterval distance;//km
@property (nonatomic) NSTimeInterval calorie;//cal
@property (nonatomic,strong) NSDate *updateDate;
@property (nonatomic,strong) NSString *targetId;

@end
