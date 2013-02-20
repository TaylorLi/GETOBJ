//
//  AppSetting.h
//  TKD Score
//
//  Created by Eagle Du on 13/1/2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEDUserInfo.h"

@interface AppSetting : NSObjectSerialization<NSCopying,NSCoding>

@property  NSTimeInterval requestTimeout;
@property NSTimeInterval bleConnectionTimeout;
@property NSTimeInterval bleOperateTimeout;
@property (nonatomic,strong) PEDUserInfo *userInfo;
@property (nonatomic) NSInteger showDateCount;

@end
