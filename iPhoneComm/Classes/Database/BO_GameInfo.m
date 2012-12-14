//
//  BO_GameInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_GameInfo.h"
#import "GameInfo.h"
#import "BO_ServerSetting.h"
#import "BO_JudgeClientInfo.h"
#import "BO_MatchInfo.h"
#import "JudgeClientInfo.h"
#import "GameInfo.h"
#import "ServerSetting.h"

static BO_GameInfo* instance;
@implementation BO_GameInfo

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[GameInfo class] primaryKey:@"gameId"];
    if(self){
        
    }
    return self;
}

+ (BO_GameInfo*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_GameInfo alloc] init];
    }
    return instance;
}

-(BOOL)AddGameInfo:(GameInfo *)gameInfo
{
    if([self insertObject:gameInfo])
    {        
        if([[BO_ServerSetting getInstance] insertObject:gameInfo.gameSetting])
        {            
            if([[BO_MatchInfo getInstance] insertObject:gameInfo.currentMatchInfo]){
                return YES;
            }
        }
    }    
    return NO;    
}

-(BOOL)updateAllGameInfo:(GameInfo *)gameInfo
{
    if(gameInfo.gameId==nil)
        return YES;
    if([self updateObject:gameInfo])
    {        
        if([[BO_ServerSetting getInstance] updateObject:gameInfo.gameSetting])
        {            
            if([[BO_MatchInfo getInstance] updateObject:gameInfo.currentMatchInfo]){
                for (JudgeClientInfo *cltInfo in gameInfo.clients.allValues) {
                   if([[BO_JudgeClientInfo getInstance] saveObject:cltInfo]==NO){
                       return NO;
                   }
                }
                return YES;
            }
        }
    }    
    return NO;
}

-(BOOL)hasUncompletedGame
{
    return [self countOfQuery:@"select count(*) from GameInfo where gameEnded=0 and gameStart=1"]>0; 
}
-(GameInfo *)getlastUncompletedGame
{
   GameInfo *gameInfo = [self queryObjectBySql:@"select * from GameInfo where gameEnded=0 and gameStart=1 order by gameStartTime desc limit 1" parameters:nil];
    if(gameInfo!=nil){        
        gameInfo.gameSetting= [[BO_ServerSetting getInstance] queryObjectBySql:@"select * from ServerSetting where gameId=?" parameters:[[NSArray alloc] initWithObjects:gameInfo.gameId,nil]];
        gameInfo.currentMatchInfo=[[BO_MatchInfo getInstance] queryObjectBySql:@"select * from MatchInfo where gameId=? and currentMatch=?" parameters:[[NSArray alloc] initWithObjects:gameInfo.gameId,[NSNumber numberWithInt:gameInfo.currentMatch] , nil]];
        gameInfo.clients=[[NSMutableDictionary alloc] init];
        for (JudgeClientInfo *clt in [[BO_JudgeClientInfo getInstance] queryList:@"select * from JudgeClientInfo where gameId=?" parameters:[[NSArray alloc] initWithObjects:gameInfo.gameId,nil]]) {
            [gameInfo.clients setObject:clt forKey:clt.uuid];
        }
    }
    return gameInfo;
}


@end
