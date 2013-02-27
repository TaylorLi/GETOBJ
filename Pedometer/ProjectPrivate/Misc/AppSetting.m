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

@implementation AppSetting

@synthesize requestTimeout;
@synthesize bleOperateTimeout;
@synthesize bleConnectionTimeout;
@synthesize userInfo,showDateCount;
@synthesize target;
@synthesize plusType;


- (id) init {
    self=[super init];
    if(self){
        bleOperateTimeout=BLE_OPERATE_TIMEOUT;
        bleConnectionTimeout=BLE_CONNECTION_TIMEOUT;
        requestTimeout=30;
        showDateCount=7;
        userInfo=[[BO_PEDUserInfo getInstance] retreiveCurrentUser];
        target = [[BO_PEDTarget getInstance] queryTargetByUserId: userInfo.userId];
        plusType = PLUS_NONE;
        /*
        if(userInfo==nil){
            userInfo=[[PEDUserInfo alloc] initWithDefault];
            [[BO_PEDUserInfo getInstance] insertObject:userInfo];
        }
        */ 
    }
    return self;
}


@end
