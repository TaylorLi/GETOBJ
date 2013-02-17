//
//  PEDPedoDateLog.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDPedoDateLog.h"

@implementation PEDPedoDateLog

@synthesize logId,logDate,avgPace,activeTime,avgSpeed,step,caloriesBurned,distance,relatedUserInfoId;

-(id) init
{
    self=[super init];
    if(self)
    {
        logId = [UtilHelper stringWithUUID];   
        logDate=[NSDate date];
    }
    return self;
}
@end
