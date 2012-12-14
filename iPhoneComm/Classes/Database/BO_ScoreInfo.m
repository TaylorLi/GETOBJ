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

@end
