//
//  Database.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/2.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "Database.h"
#import "FMDatabase.h"

static Database* instance;

@interface Database()

@property (nonatomic, retain) NSString * dbPath;

@end

@implementation Database


@synthesize dbPath;

- (id) init {
    self=[super init];
    if(self){
    }
    return self;
}
+ (Database*) getInstance {
    @synchronized([Database class]) {
        if ( instance == nil ) {
            instance = [[Database alloc] init];
        }
    }
    return instance;
}

- (void)setupDatabase:(FuncResultBlock) func {
    debugMethod();
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == NO) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            func(db);
            [db close];
        } else {
            debugLog(@"error when open db");
        }
    }
}

-(void)openSession:(FuncResultBlock) func{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        if(func!=nil)
        {
            func(db);
        }
        [db close];
    }
}

- (void)queryData:(NSString *)sql handleDataRow:(FuncResultBlock) rowFunc {
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            if(rowFunc!=nil){
                rowFunc(rs);
            }
        }
        [db close];
    }
}
- (id)queryScala:(NSString *)sql
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            return [rs objectForColumnIndex:0];
        }
        [db close];
    }
    return nil;
}

-(BOOL)tableExisted:(NSString *)tableName
{
   NSNumber* num= [self queryScala:[NSString stringWithFormat:@"select count(*) from sqlite_master where table=%@",
                      tableName]];
    return num!=nil&&[num intValue]>0;
}

- (BOOL)clearTableData:(NSString *) tableName {
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    BOOL hasError=NO;
    if ([db open]) {
        NSString * sql =[NSString stringWithFormat:@"delete from %@",tableName];
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            debugLog(@"error to delete db data");
            hasError=YES;
        } else {
            debugLog(@"succ to deleta db data");
        }
        [db close];
        
    }
    else{
        hasError=YES;
    }
    return !hasError;
}

@end
