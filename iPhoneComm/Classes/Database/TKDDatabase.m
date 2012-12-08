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
                             @"CREATE TABLE IF NOT EXISTS [ServerSetting] ([settingId] VARCHAR(36) PRIMARY KEY NOT NULL , [uuid] VARCHAR(36), [gameName] VARCHAR(200) NOT NULL,[gameDesc] VARCHAR(200),[redSideName] VARCHAR(50) NOT NULL,[redSideDesc] VARCHAR(50),[blueSideName] VARCHAR(50),[blueSideDesc] VARCHAR(50),[password] VARCHAR(50),[roundCount] INTEGER,[roundTime] FLOAT,[restTime] FLOAT,[judgeCount] INTEGER,[screeningArea] VARCHAR(4),[startScreening] INTEGER,[skipScreening] INTEGER,[availScoreWithJudgesCount] INTEGER,[availTimeDuringScoreCalc] FLOAT,[serverLoopMaxDelay] FLOAT,[enableGapScore] BOOL DEFAULT(1),[pointGap] INTEGER,[pointGapAvailRound] INTEGER,[serverName] VARCHAR(50),[maxWarningCount] INTEGER,[restAndReorganizationTime] FLOAT,[currentJudgeDevice] INTEGER, [profileName] VARCHAR(20), [isDefaultProfile] BOOL,[createDate] TIMESTAMP DEFAULT (datetime('now', 'localtime')),[gameId] VARCHAR(36),[settingType] INTEGER)",@"ServerSetting",     
                             @"CREATE TABLE IF NOT EXISTS [ClientInfo] ([clientId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameId] VARCHAR(36) not null,[displayName] VARCHAR(50) not null,[uuid] VARCHAR(36),[peerId] VARCHAR(30),[sessionId] VARCHAR(30),[hasConnected] BOOL,[lastHeartbeatDate] TIMESTAMP,[sequence] INTEGER,[userId VARCHAR(36)])",@"ClientInfo",
                             @"CREATE TABLE IF NOT EXISTS [CommandMsg] ([msgId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameId] VARCHAR(36) not null,[type] INTEGER not null,[from] VARCHAR(36),[desc] VARCHAR(100),[date] TIMESTAMP DEFAULT (datetime('now', 'localtime')),[data] VARCHAR(100))",@"CommandMsg",
                             @"CREATE TABLE IF NOT EXISTS [ScoreInfo] ([scoreId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameId] VARCHAR(36) not null,[clientUuid] VARCHAR(36),[blueSideScore] INTEGER,[redSideScore] INTEGER,[swipeType] INTEGER,[createTime] TIMESTAMP DEFAULT (datetime('now', 'localtime')))",@"ScoreInfo",
                             @"CREATE TABLE IF NOT EXISTS [GameInfo] ([gameId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameStart] BOOL,[gameEnded] BOOL,[gameStartTime] TIMESTAMP,[gameEndTime] TIMESTAMP,[currentMatch] INTEGER,[serverPeerId] VARCHAR(36),[serverUuid] VARCHAR(36),[serverFullName] VARCHAR(100),[serverLastHeartbeatDate] TIMESTAMP,[serverUserId VARCHAR(36)])",@"GameInfo",
                             @"CREATE TABLE IF NOT EXISTS [MatchInfo] ([matchId] VARCHAR(36) PRIMARY KEY NOT NULL ,[gameId] VARCHAR(36) NOT NULL,[currentRemainTime] FLOAT,[currentRound] INTEGER,[redSideScore] INTEGER,[blueSideScore] INTEGER,[redSideWarning] INTEGER,[blueSideWarning] INTEGER,[gameStatus] INTEGER,[preGameStatus] INTEGER,[statusRemark] VARCHAR(50),[pointGapReached] BOOL,[warningMaxReached] BOOL,[winByType] INTEGER,[isRedToBeWinner] BOOL)",@"MatchInfo",
                             @"CREATE TABLE IF NOT EXISTS [UserInfo] ([userId] VARCHAR(36) PRIMARY KEY NOT NULL ,[name] VARCHAR(50) NOT NULL,[pwd] VARCHAR(50),[email] VARCHAR(50),[createTime] TIMESTAMP DEFAULT (datetime('now', 'localtime')))",@"UserInfo",
                             nil];
        for (NSString *tableName in array) {
            NSString *sql=[array objectForKey:tableName];
            BOOL res= [db executeUpdate:sql];
            if(!res){                
                NSLog(@"error to setup database:%@",tableName);
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

-(int)countOfQuery:(NSString *)sql{
    int count=0;
    NSNumber *scala= [[Database getInstance] queryScala:sql];
    count= [scala intValue];
    return  count;
}

-(BOOL)saveServerSetttingBySql:(ServerSetting *)setting
{
    BOOL __block success=YES;
    
    [[Database getInstance] openSession:^(id result) {
        FMDatabase *db=result;
        NSString *sql=@"insert into ServerSetting(settingid,uuid,gameName,gameDesc,redSideName,redSideDesc,blueSideName,blueSideDesc,password,roundCount,roundTime,restTime,judgeCount,screeningArea,startScreening,skipScreening,availScoreWithJudgesCount,availTimeDuringScoreCalc,serverLoopMaxDelay,enableGapScore,pointGap,pointGapAvailRound,serverName,maxWarningCount,restAndReorganizationTime,currentJudgeDevice,profileName,isDefaultProfile,createDate,gameId,settingType) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        /*使用NSArray需要保证不存在nil项*/        
        //NSArray *pars=[[NSArray alloc] initWithObjects:nil];
        if(setting.settingId==nil)
            setting.settingId=[UtilHelper stringWithUUID];
        success = [db executeUpdate:sql,setting.settingId,setting.uuid,setting.gameName,setting.gameDesc,setting.redSideName,setting.redSideDesc,setting.blueSideName,setting.blueSideDesc,setting.password,[NSNumber numberWithInt:setting.roundCount],[NSNumber numberWithFloat:setting.roundTime], [NSNumber numberWithFloat:setting.restTime],[NSNumber numberWithInt:setting.judgeCount],setting.screeningArea,[NSNumber numberWithInt:setting.startScreening], [NSNumber numberWithInt:setting.skipScreening],[NSNumber numberWithInt:setting.availScoreWithJudgesCount],[NSNumber numberWithFloat:setting.availTimeDuringScoreCalc],[NSNumber numberWithFloat:setting.serverLoopMaxDelay],[NSNumber numberWithBool:setting.enableGapScore],[NSNumber numberWithInt:setting.pointGap],[NSNumber numberWithInt:setting.pointGapAvailRound],setting.serverName,[NSNumber numberWithInt:setting.maxWarningCount],[NSNumber numberWithFloat:setting.restAndReorganizationTime],[NSNumber numberWithInt:setting.currentJudgeDevice],setting.profileName,[NSNumber numberWithBool:setting.isDefaultProfile],setting.createDate,setting.gameId,[NSNumber numberWithInt:setting.settingType]];
        if([db hadError])
            NSLog(@"Save ServerSetting Result %@",db.lastErrorMessage);
    }];
    return  success;
}

-(BOOL)saveServerSettting:(ServerSetting *)setting
{
    return [[Database getInstance] saveObject:setting];
}

- (NSArray *)queryAllServerSetttingList
{
    return [[Database getInstance] queryAllList:[ServerSetting class]];
}
- (ServerSetting *)queryObject:(NSString *)key
{
    return [[Database getInstance] queryObject:[ServerSetting class] withPrimaryKey:key];
}

-(BOOL)saveGame:(GameInfo *)game
{
    BOOL success=YES;
    return  success;
}


/*
 -(void)operateDatabase{
 [[Database getInstance] openSession:^(id result){
 FMDatabase *db=result;
 }];
 }
 */

@end
