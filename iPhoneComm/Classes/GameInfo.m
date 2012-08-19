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

@synthesize gameSetting,gameStatus,serverUuid,currentRound,redSideScore,serverPeerId,blueSideScore,currentRemainTime,currentMatch,clients,needClientsCount,serverLastHeartbeatDate,blueSideWarning,redSideWarning,preGameStatus,pointGapReached,warningMaxReached;

-(id) initWithGameSetting:(ServerSetting *)setting
{
    self=[super init];
    if(self)
    {
        gameSetting=[setting copyWithZone:nil];
        gameStatus=kStatePrepareGame;
        currentRound=setting.startScreening;        
        currentMatch=1;
        blueSideScore=0;
        redSideScore=0;
        redSideWarning=0;
        blueSideWarning=0;
        needClientsCount=setting.judgeCount;
        clients=[[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSDictionary*) proxyForJson {
    NSDictionary *result=[NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithDouble:self.currentRemainTime],@"currentRemainTime",
                          self.serverPeerId==nil?[NSNull null]:self.serverPeerId,@"serverPeerId",
                          self.serverUuid==nil?[NSNull null]:self.serverUuid,@"serverUuid",
                          [NSNumber numberWithInt:self.gameStatus],@"gameStatus",[NSNumber numberWithInt:self.currentRound],@"currentRound",
                          [NSNumber numberWithInt:self.currentMatch],@"currentMatch",[NSNumber numberWithInt:self.blueSideScore],@"blueSideScore",
                          [NSNumber numberWithInt:self.redSideWarning],@"redSideWarmning",
                          [NSNumber numberWithInt:self.blueSideScore],@"blueSideScore",
                          [NSNumber numberWithInt:self.blueSideWarning],@"blueSideWarmning",[NSNumber numberWithDouble:[self.serverLastHeartbeatDate timeIntervalSince1970]],@"lastHeartbeatDate", nil];
    return result;
}

-(id)initWithDictionary:(NSDictionary *) disc
{
    if(!(self = [super init]))
    {
        return nil;
    }
    self.currentRemainTime=[[disc objectForKey:@"currentRemainTime"] doubleValue];
    self.serverPeerId=[disc objectForKey:@"serverPeerId"];
    self.serverUuid=[disc objectForKey:@"serverUuid"];
    self.gameStatus=[[disc objectForKey:@"gameStatus"] intValue]; 
    self.currentRound=[[disc objectForKey:@"currentRound"] intValue];
    self.currentMatch=[[disc objectForKey:@"currentMatch"] intValue];
    self.blueSideScore=[[disc objectForKey:@"blueSideScore"] intValue];
    self.redSideScore=[[disc objectForKey:@"redSideScore"] intValue];
    self.blueSideWarning=[[disc objectForKey:@"blueSideWarmning"] intValue];
    self.redSideWarning=[[disc objectForKey:@"redSideWarmning"] intValue];
    NSNumber *inv=[disc objectForKey:@"lastHeartbeatDate"];
    self.serverLastHeartbeatDate=[NSDate dateWithTimeIntervalSince1970:[inv doubleValue]];
    return self;
}

-(id) copyWithZone:(NSZone *)zone
{
    GameInfo *copyObj=[[GameInfo allocWithZone:zone] init];
    copyObj.currentRemainTime= self.currentRemainTime;
    copyObj.serverPeerId=[self.serverPeerId copy];
    copyObj.serverUuid= [self.serverUuid copy];
    copyObj.gameStatus=self.gameStatus; 
    copyObj.currentRound=self.currentRound;
    copyObj.currentMatch=self.currentMatch;
    copyObj.blueSideScore=self.blueSideScore;
    copyObj.redSideScore=self.redSideScore;
    copyObj.blueSideWarning=self.blueSideWarning;
    copyObj.redSideWarning=self.redSideWarning;
    copyObj.serverLastHeartbeatDate=[self.serverLastHeartbeatDate copy];
    copyObj.clients=[self.clients copy];
    copyObj.gameSetting=[self.gameSetting copy];
    return  copyObj;
}
-(NSString *) description{
    return [NSString stringWithFormat:@"Uuid:%@,peerId:%@,gameStatus:%d,serverLastHeartbeatDate:%@",self.serverUuid,self.serverPeerId,self.gameStatus,[UtilHelper formateTime: self.serverLastHeartbeatDate]];
}
/*
-(BOOL)getPointGapReached
{
    return gameSetting.enableGapScore&&currentRound>=gameSetting.pointGapAvailRound && fabs(redSideScore-blueSideScore)>=gameSetting.pointGap;
}

-(BOOL)gtWarningMaxReached
{
   return blueSideWarning==gameSetting.maxWarningCount||redSideWarning==gameSetting.maxWarningCount;
}
*/
@end
