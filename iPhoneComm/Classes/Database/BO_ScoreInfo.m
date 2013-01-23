//
//  BO_ScoreInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_ScoreInfo.h"
#import "ScoreInfo.h"

static BO_ScoreInfo* instance;

@implementation BO_ScoreInfo

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[ScoreInfo class] primaryKey:@"scoreId"];
    if(self){
        
    }
    return self;
}

+ (BO_ScoreInfo*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_ScoreInfo alloc] init];
    }
    return instance;
}

-(NSArray *)queryScoreByGameId:(NSString *)gameId
{
   return [self queryList:@"select * from ScoreInfo where gameId=? order by createTime desc" parameters:[[NSArray alloc] initWithObjects:gameId, nil]];
}
-(NSArray *)queryScoreByGameId:(NSString *)gameId andMatchSeq:(NSInteger)matchSeq
{
    return [self queryList:@"select si.*,jc.displayName clientName from ScoreInfo si inner join JudgeClientInfo jc on si.clientId=jc.clientId  inner join MatchInfo mi on si.matchId=mi.matchId where si.gameId=? and mi.currentMatch=? order by createTime desc" parameters:[[NSArray alloc] initWithObjects:gameId,[NSNumber numberWithInt:matchSeq], nil]];
}

-(NSArray *)queryScoreStaticByGameId:(NSString *)gameId matchId:(NSString *)_matchId roundSeq:(NSInteger)_roundSeq
{
    NSString *sql=@"select t.score,t.swipeType,c.sequence,count(*) from ( \
    SELECT case swipeType \
    when 0 then blueSideScore \
    else redSideScore end score,scoreId,gameId,clientId,clientUUid,swipeType,matchId,roundSeq FROM ScoreInfo \
        where gameId=? and matchId=? \
       %@ ) t inner join JudgeClientInfo c on t.clientid=c.clientid \
        group by t.score,t.swipeType,c.sequence";
    NSMutableArray *params=[[NSMutableArray alloc] initWithObjects:gameId,_matchId, nil];
    if(_roundSeq>0){
        sql=[NSString stringWithFormat:sql,@" and roundSeq=? "];
        [params addObject:[NSNumber numberWithInt:_roundSeq]];
    }
    else{
        sql=[NSString stringWithFormat:sql,@""];
    }
    NSArray *scoreStatics=[self queryList:sql parameters:params processFunc:^id(id sender,FMResultSet * resultSet) {
        NSArray *arry=[[NSArray alloc] initWithObjects:
                       [NSNumber numberWithInt:[resultSet intForColumnIndex:0]],//score
                       [NSNumber numberWithInt:[resultSet intForColumnIndex:1]],//0:blue,1:red
                       [NSNumber numberWithInt:[resultSet intForColumnIndex:2]],//judge sequence
                       [NSNumber numberWithInt:[resultSet intForColumnIndex:3]],//group count
                       nil];
        return arry;
    }];
    return scoreStatics;
}

/*查询各个分数的统计
 select t.score,t.swipeType,count(*) from (
 SELECT case swipeType
 when 0 then blueSideScore
 else redSideScore end score,scoreId,gameId,clientId,clientUUid,swipeType,matchId,roundSeq FROM ScoreInfo
 where gameId='F34E650F-7AA8-44C0-B3E6-7054F875A0F1' and matchId='E0C17505-2261-48F4-902B-0E8B274BEFC3'
 and roundSeq=1 ) t
 where t.score=1
 group by t.swipeType,t.score
*/ 
@end
