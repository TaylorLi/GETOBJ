//
//  PEDTarget.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDTarget.h"
#import "PEDUserInfo.h"

@implementation PEDTarget

@synthesize targetId,remainStep,targetStep,remainCalorie,targetCalorie,remainDistance,targetDistance,updateDate,userId;

-(id) initWithUserInfo:(PEDUserInfo*)user
{
    self=[super init];
    if(self){
         targetId = [UtilHelper stringWithUUID];
        remainStep =100000;
        targetStep=100000;
       targetCalorie = remainCalorie=[PEDPedometerCalcHelper calCalorieByStep:targetStep stride:user.stride weight:user.weight];
        remainDistance=targetDistance=[PEDPedometerCalcHelper calDistanceByStep:targetStep stride:user.stride];
        updateDate=[NSDate date];
        userId=user.userId;
    }
    return self;
}
@end
