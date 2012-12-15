//
//  DOBase.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOBase : NSObject
{
    
}

@property (nonatomic,strong) NSString *primaryKey;
@property (nonatomic,unsafe_unretained) Class modelType;

-(BOOL)saveObject:(id)model;
-(BOOL)updateObject:(id)model;
-(BOOL)insertObject:(id)model;
-(NSArray *)queryAllList;
-(id)queryObjectById:(NSString *)idValue;
-(int)countOfQuery:(NSString *)sql;
-(id)initWithModelTypeAndPrimaryKey:(Class) type primaryKey:(NSString *)key;
- (NSArray *)queryList:(NSString *)sql parameters:(id)param;
- (id)queryObjectBySql:(NSString *)sql parameters:(id)param;
-(BOOL)deleteObjectById:(NSString *)idValue;
@end
