//
//  TKDDatabase.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/2.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "PEDDatabase.h"
#import "Database.h"
#import "PEDUserInfo.h"
#import "PEDPedometerData.h"


static PEDDatabase* instance;

@interface PEDDatabase()


@end

@implementation PEDDatabase

- (id) init {
    self=[super init];
    if(self){
    }
    return self;
}
+ (PEDDatabase*) getInstance {
    @synchronized([PEDDatabase class]) {
        if ( instance == nil ) {
            instance = [[PEDDatabase alloc] init];
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
                             @"CREATE TABLE IF NOT EXISTS [PEDUserInfo] ([userId] VARCHAR(36) PRIMARY KEY NOT NULL ,[userName] VARCHAR(50) not null,[age] INTEGER,[measureFormat] INTEGER,[stride] FLOAT,[height] FLOAT,[weight] float,[gender] INTEGER,[updateDate] TIMESTAMP,[isCurrentUser] BOOL)",@"PEDUserInfo",
                             @"CREATE TABLE IF NOT EXISTS [PEDPedometerData] ([dataId] VARCHAR(36) PRIMARY KEY NOT NULL ,[optDate] TIMESTAMP,[activeTime] float,[step] INTEGER,[distance] float,[calorie] FLOAT,[updateDate] TIMESTAMP,[targetId] VARCHAR(36))",@"PEDPedometerData",      
                              @"CREATE TABLE IF NOT EXISTS [PEDSleepData] ([dataId] VARCHAR(36) PRIMARY KEY NOT NULL ,[optDate] TIMESTAMP,[timeToBed] float,[timeToWakeup] float,[timeToFallSleep] float,[awakenTime] FLOAT,[inBedTime] FLOAT,[actualSleepTime] FLOAT,[updateDate] TIMESTAMP,[targetId] VARCHAR(36))",@"PEDSleepData", 
                             @"CREATE TABLE IF NOT EXISTS [PEDTarget] ([targetId] VARCHAR(36) PRIMARY KEY NOT NULL ,[targetStep] VARCHAR(50) not null,[remainStep] INTEGER,[targetDistance] FLOAT,[remainDistance] FLOAT,[targetCalorie] FLOAT,[remainCalorie] float,[updateDate] TIMESTAMP,[userId] VARCHAR(36))",@"PEDTarget",
                             nil];
        for (NSString *tableName in array) {
            NSString *sql=[array objectForKey:tableName];
            BOOL res= [db executeUpdate:sql];
            if(!res){                
                NSLog(@"error to setup database:%@,sql:%@",tableName,sql);
                return ;
            }                
        }   
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
