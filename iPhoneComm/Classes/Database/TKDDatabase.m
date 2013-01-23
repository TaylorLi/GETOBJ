//
//  TKDDatabase.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/2.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "TKDDatabase.h"
#import "Database.h"
#import "ServerSetting.h"
#import "GameInfo.h"
#import "JudgeClientInfo.h"
#import "ScoreInfo.h"
#import "CommandMsg.h"


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
                             @"CREATE TABLE IF NOT EXISTS [ServerSetting] ([settingId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameId] VARCHAR(36), [uuid] VARCHAR(36), [gameName] VARCHAR(200) NOT NULL,[gameDesc] VARCHAR(200),[redSideName] VARCHAR(50) NOT NULL,[redSideDesc] VARCHAR(50),[blueSideName] VARCHAR(50),[blueSideDesc] VARCHAR(50),[password] VARCHAR(50),[roundCount] INTEGER,[roundTime] FLOAT,[restTime] FLOAT,[judgeCount] INTEGER,[screeningArea] VARCHAR(4),[startScreening] INTEGER,[skipScreening] INTEGER,[availScoreWithJudgesCount] INTEGER,[availTimeDuringScoreCalc] FLOAT,[serverLoopMaxDelay] FLOAT,[enableGapScore] BOOL DEFAULT(1),[pointGap] INTEGER,[pointGapAvailRound] INTEGER,[serverName] VARCHAR(50),[maxWarningCount] INTEGER,[restAndReorganizationTime] FLOAT,[currentJudgeDevice] INTEGER, [profileName] VARCHAR(20), [isDefaultProfile] BOOL,[createDate] TIMESTAMP DEFAULT (datetime('now', 'localtime')),[lastUsingDate] TIMESTAMP,[settingType] INTEGER,[userId] VARCHAR(36),[profileId] VARCHAR(36),[fightTimeInterval] FLOAT,isRememberClients BOOL DEFAULT(1) NOT NULL)",@"ServerSetting",     
                             @"CREATE TABLE IF NOT EXISTS [JudgeClientInfo] ([clientId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameId] VARCHAR(36) not null,[displayName] VARCHAR(50) not null,[uuid] VARCHAR(36),[peerId] VARCHAR(30),[sessionId] VARCHAR(30),[hasConnected] BOOL,[lastHeartbeatDate] TIMESTAMP,[sequence] INTEGER,[userId] VARCHAR(36))",@"ClientInfo",
                             @"CREATE TABLE IF NOT EXISTS [CommandMsg] ([msgId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameId] VARCHAR(36) not null,[type] INTEGER not null,[from] VARCHAR(36),[desc] VARCHAR(100),[date] TIMESTAMP DEFAULT (datetime('now', 'localtime')),[data] VARCHAR(100))",@"CommandMsg",
                             @"CREATE TABLE IF NOT EXISTS [ScoreInfo] ([scoreId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameId] VARCHAR(36) not null,[clientId] VARCHAR(36),[clientUuid] VARCHAR(36),[blueSideScore] INTEGER,[redSideScore] INTEGER,[swipeType] INTEGER,[createTime] TIMESTAMP DEFAULT (datetime('now', 'localtime')) NOT NULL,[matchId] VARCHAR(36),[roundSeq] INTEGER)",@"ScoreInfo",
                              @"CREATE TABLE IF NOT EXISTS [SubmitedScoreInfo] ([submitedScoreId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameId] VARCHAR(36) not null,[isForRedSide] BOOL DEFAULT(0),[score] INTEGER,[clientUuids] VARCHAR(180),[createTime] TIMESTAMP DEFAULT (datetime('now', 'localtime')) NOT NULL,[matchId] VARCHAR(36),[roundSeq] INTEGER,[isSubmitByClient] BOOL DEFAULT(1),[optType] INTEGER)",@"SubmitedScoreInfo",
                             @"CREATE TABLE IF NOT EXISTS [GameInfo] ([gameId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameStart] BOOL,[gameEnded] BOOL,[gameStartTime] TIMESTAMP,[gameEndTime] TIMESTAMP,[currentMatch] INTEGER,[serverPeerId] VARCHAR(36),[serverUuid] VARCHAR(36),[serverFullName] VARCHAR(100),[serverLastHeartbeatDate] TIMESTAMP,[serverUserId] VARCHAR(36))",@"GameInfo",
                             @"CREATE TABLE IF NOT EXISTS [MatchInfo] ([matchId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameId] VARCHAR(36) NOT NULL,[currentMatch] INTEGER,[currentRemainTime] FLOAT,[currentRound] INTEGER,[redSideScore] INTEGER,[blueSideScore] INTEGER,[redSideWarning] INTEGER,[blueSideWarning] INTEGER,[gameStatus] INTEGER,[preGameStatus] INTEGER,[statusRemark] VARCHAR(50),[pointGapReached] BOOL,[warningMaxReached] BOOL,[winByType] INTEGER,[isRedToBeWinner] BOOL)",@"MatchInfo",
                             @"CREATE TABLE IF NOT EXISTS [UserInfo] ([userId] VARCHAR(36) PRIMARY KEY NOT NULL ,[name] VARCHAR(50) NOT NULL,[pwd] VARCHAR(50),[email] VARCHAR(50),[createTime] TIMESTAMP DEFAULT (datetime('now', 'localtime')) NOT NULL)",@"UserInfo",
                             @"CREATE TABLE IF NOT EXISTS [MatchLog] ([logId] VARCHAR(36) PRIMARY KEY NOT NULL,[matchId] VARCHAR(36)NOT NULL ,[round] INTEGER,[createTime] TIMESTAMP DEFAULT (datetime('now', 'localtime')) NOT NULL,[roundTime] VARCHAR(9),blueScoreByJudge1 VARCHAR(2),blueScoreByJudge2 VARCHAR(2),blueScoreByJudge3 VARCHAR(2),blueScoreByJudge4 VARCHAR(2),redScoreByJudge1 VARCHAR(2),redScoreByJudge2 VARCHAR(2),redScoreByJudge3 VARCHAR(2),redScoreByJudge4 VARCHAR(2),  [blueEvents] VARCHAR(100),[redEvents] VARCHAR(100),[blueScore] VARCHAR(10),[redScore] VARCHAR(10))",@"MatchLog",
                              @"CREATE TABLE IF NOT EXISTS [RoundInfo] ([roundId] VARCHAR(36) PRIMARY KEY NOT NULL,[matchId] VARCHAR(36)NOT NULL ,[round] INTEGER,[startTime] TIMESTAMP DEFAULT (datetime('now', 'localtime')) NOT NULL,[endTime] TIMESTAMP DEFAULT (datetime('now', 'localtime')),[blueScore] INTEGER,[redScore] INTEGER,[blueWarnming] INTEGER,[redWarnming] INTEGER,[roundWinnerisBlue] BOOL)",@"RoundInfo",
                             nil];
        for (NSString *tableName in array) {
            NSString *sql=[array objectForKey:tableName];
            BOOL res= [db executeUpdate:sql];
            if(!res){                
                NSLog(@"error to setup database:%@,sql:%@",tableName,sql);
                return ;
            }                
        }   
        //1.0.8.11 add isRememberClients BOOL DEFAULT(1) NOT NULL
        if(![[Database getInstance] isColumnExistedOfTable:@"ServerSetting" column:@"isRememberClients"]){
            NSString *dbUpdateSql=@"alter table serversetting add isRememberClients BOOL DEFAULT(1) NOT NULL";
            BOOL res= [db executeUpdate:dbUpdateSql];
            if(!res){                
                NSLog(@"error to update database:%@",dbUpdateSql);
                return ;
            } 
        }    
        /*
         for (NSString *tableName in array) {
         if(![[Database getInstance] tableExisted:tableName]){
         NSString *sql=[array objectForKey:tableName];
         BOOL res= [db executeUpdate:sql];
         if(!res){                
         NSLog(@"error to setup database:%@",tableName);
         return ;
         }    
         }
         } 
         */
    }];
}
-(void)dropDatabase
{
    [[Database getInstance] openSession:^(id result) {
        FMDatabase *db=result;
        NSString *sql=@"select name from sqlite_master wehre type='table'";
        FMResultSet *rs=[db executeQuery:sql];
        NSString *tableName;
        NSString *dropTableSql;
        while ([rs next]) {
            tableName = [rs stringForColumnIndex:0];
            dropTableSql=[NSString stringWithFormat:@"drop table %@",tableName];
            [db executeUpdate:dropTableSql];
        }
    }];
}

-(void)clearDatabase
{
    [[Database getInstance] openSession:^(id result) {
        FMDatabase *db=result;
        NSString *sql=@"select name from sqlite_master wehre type='table'";
        FMResultSet *rs=[db executeQuery:sql];
        NSString *tableName;
        NSString *dropTableSql;
        while ([rs next]) {
            tableName = [rs stringForColumnIndex:0];
            dropTableSql=[NSString stringWithFormat:@"delete from %@",tableName];
            [db executeUpdate:dropTableSql];
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
