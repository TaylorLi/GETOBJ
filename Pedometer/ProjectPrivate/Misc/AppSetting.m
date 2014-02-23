//
//  AppSetting.m
//  TKD Score
//
//  Created by Eagle Du on 13/1/2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "AppSetting.h"
#import "BO_PEDUserInfo.h"
#import "PEDUserInfo.h"
#import "BleDefinition.h"
#import "BO_PEDTarget.h"
#import "PEDTarget.h"

@implementation AppSetting

@synthesize requestTimeout;
@synthesize bleOperateTimeout;
@synthesize bleConnectionTimeout;
@synthesize userInfo,showDateCount;
@synthesize target;
@synthesize plusType;
@synthesize chartIntervalLength;
@synthesize chartIntervalLength4Sleep;


- (id) init {
    self=[super init];
    if(self){
        bleOperateTimeout=BLE_OPERATE_TIMEOUT;
        bleConnectionTimeout=BLE_CONNECTION_TIMEOUT;
        requestTimeout=30;
        showDateCount=7;
        chartIntervalLength = 8;
        chartIntervalLength4Sleep = 5;
        userInfo=[[BO_PEDUserInfo getInstance] retreiveCurrentUser];
        [self initTargetData];
        /*
        if(userInfo==nil){
            userInfo=[[PEDUserInfo alloc] initWithDefault];
            [[BO_PEDUserInfo getInstance] insertObject:userInfo];
        }
        target = [[BO_PEDTarget getInstance] queryTargetByUserId: userInfo.userId];
        if(target==nil){
           target= [[PEDTarget alloc] initWithUserInfo:userInfo];
           [[BO_PEDTarget getInstance] insertObject:target];
        }
         */
        plusType = PLUS_NONE;
    }
    return self;
}

-(void) initTargetData{
    if(userInfo!=nil){
        target = [[BO_PEDTarget getInstance] queryTargetByUserId: userInfo.userId];
        if(target==nil){
            target= [[PEDTarget alloc] initWithUserInfo:userInfo];
            [[BO_PEDTarget getInstance] insertObject:target];
        }
    }    
}


-(void) saveSetting
{
    if(userInfo)
        [[BO_PEDUserInfo getInstance] updateObject:userInfo];
    if(target)
        [[BO_PEDTarget getInstance] saveObject:target];
}

@end
