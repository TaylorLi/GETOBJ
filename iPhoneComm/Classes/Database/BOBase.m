//
//  DOBase.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BOBase.h"
#import "Database.h"
#import "TKDDatabase.h"

@implementation BOBase

@synthesize modelType;
@synthesize primaryKey;

-(id)initWithModelTypeAndPrimaryKey:(Class) type primaryKey:(NSString *)key
{
    self=[super init];
    if(self){
        modelType=type;
        primaryKey=key;        
    }
    return self;
}

-(int)countOfQuery:(NSString *)sql{
    int count=0;
    NSNumber *scala= [[Database getInstance] queryScala:sql];
    count= [scala intValue];
    return  count;
}

-(BOOL)saveObject:(id)model
{
    return [[Database getInstance] saveObject:model primaryKeyName:primaryKey];
}
-(BOOL)updateObject:(id)model
{
    return [[Database getInstance] updateObject:model primaryKeyName:primaryKey];
}
-(BOOL)insertObject:(id)model
{
    return [[Database getInstance] insertObject:model];
}

- (NSArray *)queryAllList
{
    return [[Database getInstance] queryAllList:modelType];
}
- (id)queryObjectById:(NSString *)idValue
{
    return [[Database getInstance] queryObject:modelType withPrimaryKeyValue:idValue primaryKeyName:primaryKey];
}
- (id)queryObjectBySql:(NSString *)sql parameters:(id)param
{
    NSArray *array = [[Database getInstance] queryList:sql andType:modelType parameters:param];
    if(array==nil ||array.count==0)
        return nil;
    else
        return [array objectAtIndex:0];
}
- (NSArray *)queryList:(NSString *)sql parameters:(id)param
{
    return [[Database getInstance] queryList:sql andType:modelType parameters:param];
}

@end
