//
//  BO_ScoreInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOBase.h"

@class ScoreInfo;
@interface BO_ScoreInfo : BOBase

+ (BO_ScoreInfo*) getInstance;

-(NSArray *)queryScoreByGameId:(NSString *)gameId;
-(NSArray *)queryScoreByGameId:(NSString *)gameId andMatchSeq:(NSInteger)matchSeq;
-(NSArray *)queryScoreStaticByGameId:(NSString *)gameId matchId:(NSString *)_matchId roundSeq:(NSInteger)_roundSeq;

@end
