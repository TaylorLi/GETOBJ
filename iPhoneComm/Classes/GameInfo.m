//
//  GameInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/21.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "GameInfo.h"
#import "ServerSetting.h"
#import "JudgeClientInfo.h"

@implementation GameInfo

@synthesize gameSetting,gameStatus,serverUuid,currentRound,redSideScore,serverPeerId,blueSideScore,currentRemainTime,currentMatch,clients,serverLastHeartbeatDate,blueSideWarning,redSideWarning,preGameStatus,pointGapReached,warningMaxReached,statusRemark,gameStart,serverFullName,gameEnded,gameEndTime,gameStartTime,winByType,gameId,isRedToBeWinner,serverUserId;

-(id) initWithGameSetting:(ServerSetting *)setting
{
    self=[super init];
    if(self)
    {
        //gameSetting=[setting copyWithZone:nil];
        gameSetting=setting;
        gameStatus=kStatePrepareGame;
        currentRound=1;        
        currentMatch=setting.startScreening;
        blueSideScore=0;
        redSideScore=0;
        redSideWarning=0;
        blueSideWarning=0;
        gameStart=NO;
        gameEnded=NO;
        gameStartTime=nil;
        gameEndTime=nil;
        winByType=kWinByPoint;
        clients=[[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) resetGameInfo
{
    gameStatus=kStatePrepareGame;
    currentRound=1;        
    currentMatch=gameSetting.startScreening;
    blueSideScore=0;
    redSideScore=0;
    redSideWarning=0;
    blueSideWarning=0;
    gameStart=NO;
    gameEnded=NO;
    gameStartTime=nil;
    gameEndTime=nil;
    winByType=kWinByPoint;
    clients=[[NSMutableDictionary alloc] init];
}

-(NSDictionary*) proxyForJson {
    //return [super proxyForJson];
    NSDictionary *result=[NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithDouble:self.currentRemainTime],@"currentRemainTime",
                          self.serverPeerId==nil?[NSNull null]:self.serverPeerId,@"serverPeerId",
                          self.serverUuid==nil?[NSNull null]:self.serverUuid,@"serverUuid",
                          [NSNumber numberWithInt:self.gameStatus],@"gameStatus",[NSNumber numberWithInt:self.currentRound],@"currentRound",
                          [NSNumber numberWithInt:self.currentMatch],@"currentMatch",[NSNumber numberWithInt:self.blueSideScore],@"blueSideScore",
                          [NSNumber numberWithInt:self.redSideWarning],@"redSideWarmning",
                          [NSNumber numberWithInt:self.blueSideScore],@"blueSideScore",
                          [NSNumber numberWithInt:self.blueSideWarning],@"blueSideWarmning",
                          statusRemark,@"statusRemark",
                          [NSNumber numberWithDouble:[self.gameStartTime timeIntervalSince1970]],@"gameStartTime",
                          [NSNumber numberWithDouble:[self.gameEndTime timeIntervalSince1970]],@"gameEndTime",
                          [NSNumber numberWithBool:self.gameStart],@"gameStart",
                           [NSNumber numberWithBool:self.gameEnded],@"gameEnded",
                          nil];
    /*
     [NSNumber numberWithDouble:[self.serverLastHeartbeatDate timeIntervalSince1970]],@"lastHeartbeatDate", 
     */
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
    self.statusRemark=[disc objectForKey:@"statusRemark"];
    //NSNumber *inv=[disc objectForKey:@"lastHeartbeatDate"];
    //self.serverLastHeartbeatDate=[NSDate dateWithTimeIntervalSince1970:[inv doubleValue]];
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
    copyObj.statusRemark=[self.statusRemark copy];
    copyObj.gameStart=self.gameStart;
    copyObj.gameEndTime=[self.gameEndTime copy];
    copyObj.gameStartTime=[self.gameStartTime copy];
    copyObj.gameEnded=self.gameEnded;
    return  copyObj;
}
-(NSString *) description{
    return [NSString stringWithFormat:@"server peerId:%@,server Uuid:%@,\ngameStatus:%i,preGameStatus:%i,serverLastHeartbeatDate:%@,\ncurrentRound:%i,currentMatch:%i,Game Start:%i,\ngameSetting:[%@],\nclients:[%@],\nStarted:%i,StartTime:%@,Ended:%i,EndTime:%@,current RemainTime:%f,\nblueSideScore:%i,blueSideWarning:%i,\nredSideScore:%i,redSideWarning:%i",self.serverPeerId,self.serverUuid,self.gameStatus,self.preGameStatus,[UtilHelper formateTime: self.serverLastHeartbeatDate],currentRound,currentMatch,gameStart,gameSetting,clients,gameStart,[UtilHelper formateTime:gameStartTime],gameEnded,[UtilHelper formateTime:gameEndTime],currentRemainTime,blueSideScore,blueSideWarning,redSideScore,redSideWarning];
}
#pragma mark -
#pragma mark NSCoding


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

-(NSDictionary *)gameStatusInfo
{
    NSDictionary *result=[NSDictionary dictionaryWithObjectsAndKeys:
                          self.serverPeerId==nil?[NSNull null]:self.serverPeerId,@"serverPeerId",
                          [NSNumber numberWithInt:self.gameStatus],@"gameStatus",nil];
    return result;
}

-(BOOL)allClientsReady
{
    int availCount=0;
    for (JudgeClientInfo *clt in clients.allValues) {
        if(clt.hasConnected)
            availCount++;
    }
    return availCount==gameSetting.judgeCount;
}

-(JudgeClientInfo *)clientBySequence:(int)sequence
{
    for (JudgeClientInfo *clt in clients.allValues) {
        if(clt.sequence==sequence)
            return clt;
    }
    return nil;
}
@end
