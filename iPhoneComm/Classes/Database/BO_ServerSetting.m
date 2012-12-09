//
//  BO_GameSetting.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_ServerSetting.h"
#import "ServerSetting.h"

static BO_ServerSetting* instance;

@implementation BO_ServerSetting

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[ServerSetting class] primaryKey:@"settingId"];
    if(self){
        
    }
    return self;
}

+ (BO_ServerSetting*) getInstance {
    if ( instance == nil ) {
            instance = [[BO_ServerSetting alloc] init];
    }
    return instance;
}

-(ServerSetting*) getSettingLastUsedProfile
{
  return [self queryObjectBySql:@"select * from ServerSetting  where settingType=?  order by lastUsingDate desc,createDate desc LIMIT 1" parameters:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:SettingTypeProfile], nil]];  
}

-(ServerSetting*) getDefaultProfile
{
    return [self queryObjectBySql:@"select * from ServerSetting  where settingType=? and isDefaultProfile=1 order by lastUsingDate desc,createDate desc LIMIT 1" parameters:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:SettingTypeProfile], nil]];  
}
@end
