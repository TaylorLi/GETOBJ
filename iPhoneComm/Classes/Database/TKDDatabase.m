//
//  TKDDatabase.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/2.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "TKDDatabase.h"
#import "Database.h"
#import "FMDatabase.h"

static TKDDatabase* instance;

@interface TKDDatabase()


@end

@implementation TKDDatabase

- (id) init {
    self=[super init];
    if(self){
    }
    return self;
}
+ (TKDDatabase*) getInstance {
    @synchronized([TKDDatabase class]) {
        if ( instance == nil ) {
            instance = [[TKDDatabase alloc] init];
        }
    }
    return instance;
}

-(void)setupServerDatabase{
    
    //查询表是否存在
    //select count(*) from sqlite_master where table=***
    [[Database getInstance] openSession:^(id result) {
        FMDatabase *db=result;
        NSDictionary *array=[[NSDictionary alloc] initWithObjectsAndKeys:
                             @"CREATE TABLE [ServerSetting] ([settingId] VARCHAR(36) PRIMARY KEY NOT NULL , [uuid] VARCHAR(36), [gameName] VARCHAR(200) NOT NULL,[gameDesc] VARCHAR(200),[redSideName] VARCHAR(50) NOT NULL,[redSideDesc] VARCHAR(50),[blueSideName] VARCHAR(50),[blueSideDesc] VARCHAR(50),[password] VARCHAR(50),[roundCount] INTEGER,[roundTime] FLOAT,[restTime] FLOAT,[judgeCount] INTEGER,[screeningArea] VARCHAR(4),[startScreening] INTEGER,[skipScreening] INTEGER,[availScoreWithJudesCount] INTEGER,[availTimeDuringScoreCalc] FLOAT,[serverLoopMaxDelay] FLOAT,[enableGapScore] BOOL DEFAULT(1),[pointGap] INTEGER,[pointGapAvailRound] INTEGER,[serverName] VARCHAR(50),[maxWarningCount] INTEGER,[restAndReorganizationTime] FLOAT,[currentJudgeDevice] INTEGER, [profileName] VARCHAR(20), [isDefaultProfile] BOOL,[createDate] TIMESTAMP DEFAULT (datetime('now', 'localtime')),[gameId] VARCHAR(36))",@"ServerSetting",     
                             @"CREATE TABLE [ClientInfo] ([clientId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameId] VARCHAR(36) not null,[displayName] VARCHAR(50) not null,[uuid] VARCHAR(36),[peerId] VARCHAR(30),[sessionId] VARCHAR(30),[hasConnected] BOOL,[lastHeartbeatDate] TIMESTAMP,[sequence] INTEGER,[userId VARCHAR(36)])",@"ClientInfo",
                             @"CREATE TABLE [CommandMsg] ([msgId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameId] VARCHAR(36) not null,[type] INTEGER not null,[from] VARCHAR(36),[desc] VARCHAR(100),[date] TIMESTAMP DEFAULT (datetime('now', 'localtime')),[data] VARCHAR(100))",@"CommandMsg",
                             @"CREATE TABLE [ScoreInfo] ([scoreId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameId] VARCHAR(36) not null,[clientUuid] VARCHAR(36),[blueSideScore] INTEGER,[redSideScore] INTEGER,[swipeType] INTEGER,[createTime] TIMESTAMP DEFAULT (datetime('now', 'localtime')))",@"ScoreInfo",
                             @"CREATE TABLE [GameInfo] ([gameId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameStart] BOOL,[gameEnded] BOOL,[gameStartTime] TIMESTAMP,[gameEndTime] TIMESTAMP,[currentMatch] INTEGER,[serverPeerId] VARCHAR(36),[serverUuid] VARCHAR(36),[serverFullName] VARCHAR(100),[serverLastHeartbeatDate] TIMESTAMP,[serverUserId VARCHAR(36)])",@"GameInfo",
                             @"CREATE TABLE [MatchInfo] ([matchId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameId] VARCHAR(36) NOT NULL,[currentRemainTime] FLOAT,[currentRound] INTEGER,[redSideScore] INTEGER,[blueSideScore] INTEGER,[redSideWarning] INTEGER,[blueSideWarning] INTEGER,[gameStatus] INTEGER,[preGameStatus] INTEGER,[statusRemark] VARCHAR(50),[pointGapReached] BOOL,[warningMaxReached] BOOL,[winByType] INTEGER,[isRedToBeWinner] BOOL)",@"MatchInfo",
                             @"CREATE TABLE [UserInfo] ([userId] VARCHAR(36) PRIMARY KEY NOT NULL ,[name] VARCHAR(50) NOT NULL,[pwd] VARCHAR(50),[email] VARCHAR(50),[createTime] TIMESTAMP DEFAULT (datetime('now', 'localtime')))",@"UserInfo",
                             nil];
        for (NSString *tableName in array) {
            if(![[Database getInstance] tableExisted:tableName]){
                NSString *sql=[array objectForKey:tableName];
                BOOL res= [db executeUpdate:sql];
                if(!res){                
                    debugLog([NSString stringWithFormat:@"error to setup database:%@",tableName]);
                    return ;
                }    
            }
        }       
    }];
}

/*
 -(void)operateDatabase{
 [[Database getInstance] openSession:^(id result){
 FMDatabase *db=result;
 }];
 }
 */

@end
