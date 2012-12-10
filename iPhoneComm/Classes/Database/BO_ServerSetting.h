//
//  BO_GameSetting.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOBase.h"
#import "ServerSetting.h"

@interface BO_ServerSetting : BOBase

+ (BO_ServerSetting*) getInstance;
-(ServerSetting*) getSettingLastUsedProfile;
-(ServerSetting*) getDefaultProfile;
-(NSArray *) getProfiles;
@end
