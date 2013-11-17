//
//  PEDPedometerData.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDPedometerData.h"

@implementation PEDPedometerData


@synthesize dataId,activeTime,step,calorie,distance,optDate,updateDate,targetId;

-(id) init
{
    self=[super init];
    if(self)
    {
        dataId = [UtilHelper stringWithUUID];   
        updateDate=[NSDate date];
    }
    return self;
}

@end
