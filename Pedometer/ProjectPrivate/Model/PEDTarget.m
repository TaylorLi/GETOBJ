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

@synthesize targetId,remainStep,targetStep,remainCalorie,targetCalorie,remainDistance,targetDistance,updateDate,userId,sleepDataCount,pedoDataCount;

-(id) initWithUserInfo:(PEDUserInfo*)user
{
    self=[super init];
    if(self){
         targetId = [UtilHelper stringWithUUID];
        //remainStep =100000;
        //targetStep=100000;
        /*         
         5, TARGET 的目标距离是用STRIDE X 目标步数
         
         例如: STRIDE = 50CM, 目标步数是10000, 目标距离= 10000 X 50 / 10000 = 50KM
         
         6, TARGET 的目标卡路里可按目标步数和余下步数的比例,
         
         例如: 接收到余下卡路里=401, 目标步数是10000, 余下步数是3878, 目标卡路里= 10000/3878 X 401 = 1034
         */
        //remainCalorie=[PEDPedometerCalcHelper calCalorieByStep:targetStep stride:user.stride weight:user.weight];
        //targetCalorie =
        //remainDistance=targetDistance=[PEDPedometerCalcHelper calDistanceByStep:targetStep stride:user.stride];
        //updateDate=[NSDate date];
        userId=user.userId;
    }
    return self;
}
@end
