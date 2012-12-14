//
//  SubmitedScoreInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/9.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "SubmitedScoreInfo.h"

@implementation SubmitedScoreInfo

@synthesize score;
@synthesize createTime;
@synthesize clientUuids;
@synthesize gameId;
@synthesize submitedScoreId,matchId,roundSeq;
@synthesize isForRedSide,isSubmitByClient,optType;

-(id)initWithSubmitScore:(int)_score isForRedSide:(BOOL)_forRedSide gameId:(NSString *)_gameId matchId:(NSString *)_matchId roundSeq:(int)_roundSeq clientUuids:(NSArray *)_uuids isSubmitByClient:(BOOL)_byClient andScoreOperateType:(ScoreOperateType)_optType;
{
    if(self=[super init])
    {
        self.submitedScoreId=[UtilHelper stringWithUUID];
        self.createTime=[NSDate date];
        self.score=_score;
        self.isForRedSide=_forRedSide;
        self.gameId=_gameId;
        self.matchId=_matchId;
        self.roundSeq=_roundSeq;
        self.clientUuids=[UtilHelper ArrayToString:_uuids];
        self.isSubmitByClient=_byClient;
        self.optType=_optType;
    }
    return self;
}
@end
