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
#import "MatchInfo.h"

@implementation GameInfo

@synthesize gameSetting,serverUuid,serverPeerId,clients,serverLastHeartbeatDate,gameStart,serverFullName,gameEnded,gameEndTime,gameStartTime,gameId,serverUserId,currentMatchInfo,currentMatch;

-(id) initWithGameSetting:(ServerSetting *)setting
{
    self=[super init];
    if(self)
    {
        gameSetting=setting;
        gameSetting.gameId=gameId;
        gameStart=NO;
        gameEnded=NO;
        gameStartTime=nil;
        gameEndTime=nil;      
        clients=[[NSMutableDictionary alloc] init];
        currentMatchInfo=[[MatchInfo alloc] initWithGameSetting:setting];
        currentMatch=currentMatchInfo.currentMatch;
    }
    return self;
}

-(void) resetGameInfoToStart
{    
    gameId = [UtilHelper stringWithUUID];
    gameStart=NO;
    gameEnded=NO;
    gameStartTime=nil;
    gameEndTime=nil;
    clients=[[NSMutableDictionary alloc] init];
    [gameSetting renewSettingForGame];
    gameSetting.gameId=gameId;
    if(currentMatchInfo==nil){
        currentMatchInfo=[[MatchInfo alloc] initWithGameSetting:gameSetting];
    }
    else{
        [currentMatchInfo resetMatchInfoToStart:gameSetting];
    }
    currentMatch=currentMatchInfo.currentMatch;
    currentMatchInfo.gameId=gameId;
}

-(void) rollToNextMatch
{
   MatchInfo *nextMatch =[[MatchInfo alloc] initWithGameSetting:gameSetting];
   currentMatch+=gameSetting.skipScreening;
   nextMatch.currentMatch=currentMatch;
   nextMatch.gameId=gameId;
    currentMatchInfo=nil;
    currentMatchInfo=nextMatch;    
}
-(NSString *) description{
    return [NSString stringWithFormat:@"gameId:%@,server peerId:%@,server Uuid:%@,\nserverLastHeartbeatDate:%@,Game Start:%i,\ngameSetting:[%@],\nclients:[%@],\nStarted:%i,StartTime:%@,Ended:%i,EndTime:%@,Current Match Info:[%@]",gameId,self.serverPeerId,self.serverUuid,[UtilHelper formateTime: self.serverLastHeartbeatDate],gameStart,gameSetting,clients,gameStart,[UtilHelper formateTime:gameStartTime],gameEnded,[UtilHelper formateTime:gameEndTime],currentMatchInfo];
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

-(NSDictionary*) proxyForJson {
    //return [super proxyForJson];
    NSDictionary *result=[NSDictionary dictionaryWithObjectsAndKeys:
                          self.serverPeerId==nil?[NSNull null]:self.serverPeerId,@"serverPeerId",
                          self.serverUuid==nil?[NSNull null]:self.serverUuid,@"serverUuid",
                          [NSNumber numberWithInt:self.currentMatch],@"currentMatch",
                                                   [NSNumber numberWithDouble:[self.gameStartTime timeIntervalSince1970]],@"gameStartTime",
                          [NSNumber numberWithDouble:[self.gameEndTime timeIntervalSince1970]],@"gameEndTime",
                          [NSNumber numberWithBool:self.gameStart],@"gameStart",
                          [NSNumber numberWithBool:self.gameEnded],@"gameEnded",
                          self.currentMatchInfo==nil?[NSNull null]:self.currentMatchInfo,@"currentMatchInfo",
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
    self.serverPeerId=[disc objectForKey:@"serverPeerId"];
    self.serverUuid=[disc objectForKey:@"serverUuid"];
    self.currentMatch=[[disc objectForKey:@"currentMatch"] intValue];
    //self.gameStartTime=[NSDate dateWithTimeIntervalSince1970:[[disc objectForKey:@"gameStartTime"] doubleValue]];
    //self.gameEndTime=[NSDate dateWithTimeIntervalSince1970:[[disc objectForKey:@"gameEndTime"] doubleValue]];
    self.currentMatchInfo=[[MatchInfo alloc] initWithDictionary:[disc objectForKey:@"currentMatchInfo"]];
    //NSNumber *inv=[disc objectForKey:@"lastHeartbeatDate"];
    //self.serverLastHeartbeatDate=[NSDate dateWithTimeIntervalSince1970:[inv doubleValue]];
    return self;
}



-(NSDictionary *)gameStatusInfo
{
    NSDictionary *result=[NSDictionary dictionaryWithObjectsAndKeys:
                          self.serverPeerId==nil?[NSNull null]:self.serverPeerId,@"serverPeerId",
                          [NSNumber numberWithInt:self.currentMatchInfo.gameStatus],@"gameStatus",nil];
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
