//
//  MatchInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/4.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "MatchInfo.h"
#import "ServerSetting.h"
#import "RoundInfo.h"

@implementation MatchInfo

@synthesize currentRound,redSideScore,blueSideScore,currentRemainTime,blueSideWarning,redSideWarning,preGameStatus,pointGapReached,warningMaxReached,statusRemark,winByType,gameId,isRedToBeWinner,gameStatus,currentMatch,matchId,currentRoundInfo;

-(id) initWithGameSetting:(ServerSetting *)setting
{
    self=[super init];
    if(self)
    {
        matchId = [UtilHelper stringWithUUID];
        gameStatus=kStatePrepareGame;
        currentRound=1;
        currentRoundInfo=nil;
        currentMatch=setting.startScreening;
        blueSideScore=0;
        redSideScore=0;
        redSideWarning=0;
        blueSideWarning=0;
        winByType=kWinByPoint;        
    }
    return self;
}

-(void) resetMatchInfoToStart:(ServerSetting *)setting
{
    matchId = [UtilHelper stringWithUUID];
    gameStatus=kStatePrepareGame;
    currentRound=1;    
    currentRoundInfo=nil;
    currentMatch=setting.startScreening;
    blueSideScore=0;
    redSideScore=0;
    redSideWarning=0;
    blueSideWarning=0;
    winByType=kWinByPoint;
}

-(NSString *) description{
    return [NSString stringWithFormat:@"matchId:%@,gameStatus:%i,preGameStatus:%i,currentRound:%i,currentMatch:%i,current RemainTime:%f,\nblueSideScore:%i,blueSideWarning:%i,\nredSideScore:%i,redSideWarning:%i",matchId,self.gameStatus,self.preGameStatus,currentRound,currentMatch,currentRemainTime,blueSideScore,blueSideWarning,redSideScore,redSideWarning];
}

-(NSDictionary*) proxyForJson {
    //return [super proxyForJson];
    NSDictionary *result=[NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithDouble:self.currentRemainTime],@"currentRemainTime",
                          [NSNumber numberWithInt:self.gameStatus],@"gameStatus",
                          [NSNumber numberWithInt:self.currentRound],@"currentRound",
                          [NSNumber numberWithInt:self.currentMatch],@"currentMatch",
                          [NSNumber numberWithInt:self.blueSideScore],@"blueSideScore",
                          [NSNumber numberWithInt:self.redSideWarning],@"redSideWarmning",
                          [NSNumber numberWithInt:self.blueSideScore],@"blueSideScore",
                          [NSNumber numberWithInt:self.blueSideWarning],@"blueSideWarmning",
                          statusRemark,@"statusRemark",
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

@end
