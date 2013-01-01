//
//  BO_SubmitedScoreInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/9.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_SubmitedScoreInfo.h"
#import "SubmitedScoreInfo.h"

static BO_SubmitedScoreInfo* instance;

@implementation BO_SubmitedScoreInfo

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[SubmitedScoreInfo class] primaryKey:@"submitedScoreId"];
    if(self){
        
    }
    return self;
}

+ (BO_SubmitedScoreInfo*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_SubmitedScoreInfo alloc] init];
    }
    return instance;
}

-(NSDictionary *)querySideScoreOfRoundSeq:(NSInteger) roundSeq matchId:(NSString *) _matchId
{
//取回合总得分
   NSString *sql=@"SELECT sum(case isForRedSide \
           when 1 then score \
           else 0 end) ,sum(case isForRedSide \
                            when 0 then score \
                            else 0 end) FROM SubmitedScoreInfo where optType in (0,1) and matchId=?";
    NSMutableArray *parmas=[[NSMutableArray alloc] initWithObjects:_matchId, nil];
    if(roundSeq!=0){
        sql=[NSString stringWithFormat:@"%@ and roundSeq=?",sql];
        [parmas addObject:[NSNumber numberWithInt:roundSeq]];
    }
    NSArray *redBlueScore=[self queryList:sql parameters:parmas processFunc:^id(id sender,FMResultSet * resultSet) {
       NSArray *arry=[[NSArray alloc] initWithObjects:
       [NSNumber numberWithInt:[resultSet intForColumnIndex:0]],
        [NSNumber numberWithInt:[resultSet intForColumnIndex:1]],
                      nil];
        return arry;
    }];
    NSMutableDictionary *result=[[NSMutableDictionary alloc] initWithCapacity:4];
    if(redBlueScore!=nil&&redBlueScore.count>0){
        NSArray *scoreInfo=[redBlueScore objectAtIndex:0];
        [result setObject:[scoreInfo objectAtIndex:0] forKey:@"RED_SCORE"];
        [result setObject:[scoreInfo objectAtIndex:1] forKey:@"BLUE_SCORE"];
    }
    //取回合总警告
    NSString *sqlWarmning=@"SELECT sum(case isForRedSide \
    when 1 then score \
    else 0 end) ,sum(case isForRedSide \
    when 0 then score \
    else 0 end) FROM SubmitedScoreInfo where optType in (2) and matchId=?";
    if(roundSeq!=0){
        sqlWarmning=[NSString stringWithFormat:@"%@ and roundSeq=?",sqlWarmning];
    }
    NSArray *redBlueWarmning=[self queryList:sqlWarmning parameters:parmas processFunc:^id(id sender,FMResultSet * resultSet) {
        NSArray *arry=[[NSArray alloc] initWithObjects:
                       [NSNumber numberWithInt:[resultSet intForColumnIndex:0]],
                       [NSNumber numberWithInt:[resultSet intForColumnIndex:1]],
                       nil];
        return arry;
    }];
    if(redBlueWarmning!=nil&&redBlueWarmning.count>0){
        NSArray *scoreInfo=[redBlueWarmning objectAtIndex:0];
        [result setObject:[scoreInfo objectAtIndex:0] forKey:@"RED_WARMNING"];
        [result setObject:[scoreInfo objectAtIndex:1] forKey:@"BLUE_WARMNING"];
    }
    return result;
    
}
@end
