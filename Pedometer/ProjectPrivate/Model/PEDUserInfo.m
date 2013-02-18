//
//  PEDUserInfo.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDUserInfo.h"

@implementation PEDUserInfo

@synthesize userId,userName,age,unit,gender,height,stride,weight,isCurrentSetting,createDate;

-(id) init
{
    self=[super init];
    if(self)
    {
        userId = [UtilHelper stringWithUUID];   
        userName=[UtilHelper deviceName];
        age=26;
        unit=UNIT_METRIC;
        gender=@"M";
        height=183.0;//cm
        weight=90;//kg
        stride=70;//cm
        isCurrentSetting=YES;
        createDate=[NSDate date];
    }
    return self;
}

@end
