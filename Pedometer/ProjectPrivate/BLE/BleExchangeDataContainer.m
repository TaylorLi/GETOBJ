//
//  BleExchangeDataContainer.m
//  Pedometer
//
//  Created by JILI Du on 13/3/3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "BleExchangeDataContainer.h"
#import "PEDSleepData.h"
#import "PEDPedometerData.h"
#import "PEDTarget.h"
#import "PEDUserInfo.h"


@implementation BleExchangeDataContainer

@synthesize isConnectingEnd,isConnectingStart,target,pedoData,sleepData,exchageType,pedoDataIndex,sleepDataIndex;


-(id)init
{
    self=[super init];
    if(self){
        isConnectingStart =YES;
        isConnectingEnd=NO;
        pedoData = [[NSMutableDictionary alloc] init];
        sleepData = [[NSMutableDictionary alloc] init];
        exchageType=ExchangeTypeNone;
        pedoDataIndex=-1;
        sleepDataIndex=-1;
    }
    return self;
}
@end
