//
//  Database.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/2.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "Database.h"
#import "FMDatabase.h"
#import "Reflection.h"

static Database* instance;

@interface Database()

@property (nonatomic, retain) NSString * dbPath;

@end

@implementation Database


@synthesize dbPath;

- (id) init {
    self=[super init];
    if(self){
        tableColumns=[[NSMutableDictionary alloc] init];
        NSString * doc = PATH_OF_CACHE;
        NSString * path = [doc stringByAppendingPathComponent:@"TKDScore.sqlite"];
        dbPath=path;
        NSLog(@"数据库地址是:%@",dbPath);
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

-(NSArray *)columnsOfTableByTableName:(NSString *)tableName{
    if([tableColumns containKey:tableName]){
        return [tableColumns objectForKey:tableName];
    }else{
        NSString *sql=[NSString stringWithFormat:@"pragma table_info(%@);",tableName];
       __block NSMutableArray *columns=[[NSMutableArray alloc] init];
        [self queryData:sql handleDataRow:^(id result) {
            FMResultSet * rs=result;
            [columns addObject:[rs stringForColumn:@"name"]];
        }];
        return columns;
    }
}

-(NSArray *)columnsOfTableByTableType:(Class)tableClass{
    return [self columnsOfTableByTableName:NSStringFromClass(tableClass)];
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
            NSLog(@"[sqlite] error when open db");
        }
        if([db hadError]){            
            NSLog(@"[sqlite] setupDatabase error,%@",db.lastErrorMessage);
        }
    }
}

-(void)openSession:(FuncResultBlock) func{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        if(func!=nil)
        {
            func(db);
            if([db hadError]){            
                NSLog(@"[sqlite] open session to executeFunction error,%@",db.lastErrorMessage);
            }
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
        if([db hadError]){            
            NSLog(@"[sqlite] query Data error:[%@],result:%@",sql,db.lastErrorMessage);
        }
        [db close];
    }
}
- (NSArray *)queryList:(NSString *)sql andType:(Class)type parameters:(id)param {
    NSMutableArray *result=[[NSMutableArray alloc] init];
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        FMResultSet * rs;        
        if([param isKindOfClass:[NSArray class]]){
            rs= [db executeQuery:sql withArgumentsInArray:param];
        }
        else if([param isKindOfClass:[NSDictionary class]]){
            rs= [db executeQuery:sql withParameterDictionary:param];
        }else{
            rs= [db executeQuery:sql];
        }   
        
        while ([rs next]) {            
            id obj =  [[type alloc] init];    
            NSDictionary *dic =  [rs resultDictionary];
            if([obj respondsToSelector:@selector(initWithDictionary:)])
            {
                obj=[obj bindingWithDictionary:dic];
            }
            [result addObject:obj];
        }
        if([db hadError]){            
            NSLog(@"[sqlite] query queryList error:[%@],error detail:%@",sql,db.lastErrorMessage);
        }

        [db close];
    }
    return result;
}

- (NSArray *)queryList:(NSString *)sql parameters:(id)param processFunc:(FuncProcessBlock)func {
    NSMutableArray *result=[[NSMutableArray alloc] init];
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        FMResultSet * rs;        
        if([param isKindOfClass:[NSArray class]]){
            rs= [db executeQuery:sql withArgumentsInArray:param];
        }
        else if([param isKindOfClass:[NSDictionary class]]){
            rs= [db executeQuery:sql withParameterDictionary:param];
        }else{
            rs= [db executeQuery:sql];
        }   
        
        while ([rs next]) {   
            id obj=func(self,rs);
            [result addObject:obj];
        }
        if([db hadError]){            
            NSLog(@"[sqlite] query queryList error:[%@],error detail:%@",sql,db.lastErrorMessage);
        }
        
        [db close];
    }
    return result;
}

- (NSArray *)queryAllList:(Class)type{
    NSString *tableName=NSStringFromClass(type);
    return [self queryList:[NSString stringWithFormat:@"select * from %@",tableName] andType:type parameters:nil];
}
-(id)queryObject:(Class)type withPrimaryKeyValue:(id)value primaryKeyName:(NSString *)primaryKey{
    NSString *tableName=NSStringFromClass(type);
    NSArray *list = [self queryList:[NSString stringWithFormat:@"select * from %@ where %@ = ?",tableName,primaryKey] andType:type parameters:[[NSArray alloc] initWithObjects:value, nil]];
    if(list==nil||list.count==0)
        return nil;
    else
        return [list objectAtIndex:0];
}
- (id)queryScala:(NSString *)sql
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    id result=nil; 
    if ([db open]) {
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            result = [rs objectForColumnIndex:0];
        }
        if([db hadError]){            
            NSLog(@"[sqlite] query scala error:[%@],error detail:%@",sql,db.lastErrorMessage);
        }
        [db close];
    }
    return result;
}

-(BOOL)tableExisted:(NSString *)tableName
{
    NSNumber* num= [self queryScala:[NSString stringWithFormat:@"select count(*) from sqlite_master where name='%@'",
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
             NSLog(@"[sqlite] delete all table [] data error:[%@],error detail:%@",tableName,db.lastErrorMessage);
            hasError=YES;
        } else {
            NSLog(@"succ to deleta db data");
        }       
        [db close];
        
    }
    else{
        hasError=YES;
    }
    return !hasError;
}

-(BOOL) insertObject:(id)obj
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    BOOL hasError=NO;
    if ([db open]) {
        NSString *tableName=NSStringFromClass([obj class]);
        NSMutableString *sbColumns=[[NSMutableString alloc] initWithCapacity:50];
        NSMutableString *sbValueHolder=[[NSMutableString alloc] initWithCapacity:50];
        NSDictionary *columns=[Reflection getPropertiesNameAndType:[obj class]];
        NSArray *columnsOfTable=[self columnsOfTableByTableName:tableName];
        for (NSString *col in columns.allKeys) {
            if(![columnsOfTable containsObject:col])//classTye
            {
                continue;
            }            
            [sbColumns appendFormat:@"%@,",col];
            [sbValueHolder appendFormat:@":%@,",col];
        }
        NSString * sql =[NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@)",tableName,[sbColumns substringToIndex:[sbColumns length]-1],[sbValueHolder substringToIndex:[sbValueHolder length]-1]];
        NSDictionary *paramDict=nil;
        if([obj respondsToSelector:(@selector(proxyForSqlite))]){
            paramDict=[obj proxyForSqlite];
        }        
        
        BOOL res = [db executeUpdate:sql withParameterDictionary:paramDict];
        if (!res) {          
            NSLog(@"[sqlite] insert data error:[%@],error detail:%@",sql,db.lastErrorMessage);
            hasError=YES;
        } else {
            NSLog(@"success to insert db data:%@",tableName);
        }        
        [db close];
        
    }
    else{
        hasError=YES;
    }
    return !hasError;
}

-(BOOL) updateObject:(id)obj primaryKeyName:(NSString *)primaryKey{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    BOOL hasError=NO;
    if ([db open]) {
        NSString *tableName=NSStringFromClass([obj class]);
        NSMutableString *sbColumns=[[NSMutableString alloc] initWithCapacity:50];
        NSDictionary *columns=[Reflection getPropertiesNameAndType:[obj class]];
        NSArray *columnsOfTable=[self columnsOfTableByTableName:tableName];
        for (NSString *col in columns.allKeys) {
            if(![columnsOfTable containsObject:col])//classTye
            {
                continue;
            }   
            if(![col isEqualToString:primaryKey])
                [sbColumns appendFormat:@"%@=:%@,",col,col];
        }
        NSString * sql =[NSString stringWithFormat:@"UPDATE %@ SET %@ where %@=:%@",tableName,[sbColumns substringToIndex:[sbColumns length]-1],primaryKey,primaryKey];
        NSDictionary *paramDict=nil;
        if([obj respondsToSelector:(@selector(proxyForSqlite))]){
            paramDict=[obj proxyForSqlite];
        }                
        BOOL res = [db executeUpdate:sql withParameterDictionary:paramDict];
        if (!res) {          
            NSLog(@"[sqlite] update data error:[%@],error detail:%@",sql,db.lastErrorMessage);
            hasError=YES;
        } else {
            NSLog(@"success to update db data:%@",tableName);
        }        
        [db close];       
        
    }
    else{
        hasError=YES;
    }
    return !hasError;
}

-(BOOL) saveObject:(id)obj primaryKeyName:(NSString *)primaryKey{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    BOOL hasError=NO;
    if ([db open]) {
        NSString *tableName=NSStringFromClass([obj class]);
        id value=[obj valueForKey:primaryKey];
        
        NSString *sql=[NSString stringWithFormat:@"select count(*) from %@ where %@=?",tableName,primaryKey];
        NSNumber *result;
        FMResultSet * rs = [db executeQuery:sql,value];
        while ([rs next]) {
            result = [rs objectForColumnIndex:0];
        }
        if([db hadError]){            
            NSLog(@"[sqlite] query row if existed error:[%@],error detail:%@",sql,db.lastErrorMessage);
        }else{
            [db close];
            if([result intValue]>0){
                return [self updateObject:obj primaryKeyName:primaryKey];
            }
            else{
                return [self insertObject:obj];
            }
        }
    }
    else{
        hasError=YES;
    }
    return !hasError;
}
-(BOOL)deleteObject:(Class)type withPrimaryKeyValue:(id)value primaryKeyName:(NSString *)primaryKey
{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    BOOL hasError=NO;
    if ([db open]) {
        NSString *tableName=NSStringFromClass(type);
        NSString * sql =[NSString stringWithFormat:@"delete from %@ where %@ = ?",tableName,primaryKey];
        BOOL res = [db executeUpdate:sql, value];
        if (!res) {
            NSLog(@"[sqlite] delete table [] data error:[%@],error detail:%@",tableName,db.lastErrorMessage);
            hasError=YES;
        } else {
            NSLog(@"succ to deleta db data");
        }       
        [db close];
    }
    else{
        hasError=YES;
    }
    return !hasError;
}
@end
