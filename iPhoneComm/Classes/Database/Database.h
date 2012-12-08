//
//  Database.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/2.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface Database : NSObject
- (id) init;
+ (Database*) getInstance;

- (void)setupDatabase:(FuncResultBlock) func;
-(void)openSession:(FuncResultBlock) func;
-(void)queryData:(NSString *)sql handleDataRow:(FuncResultBlock) rowFunc;
- (NSArray *)queryList:(NSString *)sql andType:(Class)type parameters:(id)param;
- (NSArray *)queryAllList:(Class)type;
-(id)queryObject:(Class)type withPrimaryKey:(id)key;
-(BOOL)clearTableData:(NSString *) tableName;
- (id)queryScala:(NSString *)sql;
-(BOOL)tableExisted:(NSString *)tableName;
-(BOOL) insertObject:(id)obj;
-(BOOL) updateObject:(id)obj;
-(BOOL) saveObject:(id)obj;

@end
