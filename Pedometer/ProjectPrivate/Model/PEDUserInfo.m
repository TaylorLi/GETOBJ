//
//  PEDUserInfo.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDUserInfo.h"

@implementation PEDUserInfo

@synthesize userId,userName,age,measureFormat,gender,height,stride,weight,updateDate;

-(id) init
{
    self=[super init];
    if(self)
    {
        userId = [UtilHelper stringWithUUID];   
        userName=[UtilHelper deviceName];
        age=26;
        measureFormat=UNIT_METRIC;
        gender=FALSE;
        height=1.83;//cm
        weight=90;//kg
        stride=70;//cm
        updateDate=[NSDate date];
    }
    return self;
}

@end
