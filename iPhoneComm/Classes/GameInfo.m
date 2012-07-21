//
//  GameInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/21.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "GameInfo.h"
#import "ServerSetting.h"

@implementation GameInfo

@synthesize gameSetting,gameStatus,serverUuid,currentRound,redSideScore,serverPeerId,blueSideScore,currentRemainTime,currentMatch,clients,needClientsCount;
-(void) dealloc
{
    [gameSetting release];
    [serverUuid release];
    [serverPeerId release];
    [clients release];
}

-(id) initWithGameSetting:(ServerSetting *)setting
{
    self=[super init];
    if(self)
    {
        gameSetting=setting;
        gameStatus=kStatePrepareGame;
        currentRound=1;
        currentRemainTime=setting.roundTime;
        currentMatch=1;
        blueSideScore=0;
        redSideScore=0;
        needClientsCount=2;
        clients=[[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
