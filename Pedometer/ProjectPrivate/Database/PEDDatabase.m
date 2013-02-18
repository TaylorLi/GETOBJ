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
#import "PEDPedoDateLog.h"


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
                             @"CREATE TABLE IF NOT EXISTS [PEDUserInfo] ([userId] VARCHAR(36) PRIMARY KEY NOT NULL ,[userName] VARCHAR(50) not null,[age] INTEGER,[unit] INTEGER,[stride] FLOAT,[height] FLOAT,[weight] float,[gender] VARCHAR(1),[isCurrentSetting] BOOL,[createDate] TIMESTAMP)",@"ClientInfo",
                             @"CREATE TABLE IF NOT EXISTS [PEDPedoDateLog] ([logId] VARCHAR(36) PRIMARY KEY NOT NULL ,[logDate] TIMESTAMP,[activeTime] float,[step] INTEGER,[distance] float,[caloriesBurned] FLOAT,[avgSpeed] FLOAT,[avgPace] FLOAT,[relatedUserInfoId] VARCHAR(36))",@"CommandMsg",                             
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
