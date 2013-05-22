//
//  PEDSleepData.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDSleepData.h"

@implementation PEDSleepData

@synthesize updateDate,dataId,optDate,inBedTime,timeToBed,awakenTime,timeToWakeup,actualSleepTime,timeToFallSleep,targetId;

-(id) init
{
    self=[super init];
    if(self)
    {
        dataId = [UtilHelper stringWithUUID];   
        updateDate=[NSDate date];
        timeToBed = -1;
        timeToWakeup = -1;
        timeToFallSleep = -1;
    }
    return self;
}

@end
