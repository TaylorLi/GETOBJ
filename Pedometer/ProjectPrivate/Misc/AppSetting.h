//
//  AppSetting.h
//  TKD Score
//
//  Created by Eagle Du on 13/1/2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEDUserInfo.h"
#import "PEDTarget.h"

@interface AppSetting : NSObjectSerialization<NSCopying,NSCoding>

@property  NSTimeInterval requestTimeout;
@property NSTimeInterval bleConnectionTimeout;
@property NSTimeInterval bleOperateTimeout;
@property (nonatomic,strong) PEDUserInfo *userInfo;
@property (nonatomic) NSInteger showDateCount;
@property (nonatomic,strong) PEDTarget *target;
@property PlusType plusType;

-(void) initTargetData;
-(void) saveSetting;
@end
