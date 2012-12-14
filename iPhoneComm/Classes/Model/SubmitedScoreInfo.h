//
//  SubmitedScoreInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/9.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubmitedScoreInfo : NSObjectSerialization<SqliteORMDelegate>

@property int score;
@property BOOL isForRedSide;
@property (nonatomic, retain) NSDate *createTime;
//array of submit clients,comma seperate
@property (nonatomic,strong) NSString *clientUuids;
@property (nonatomic,strong) NSString *gameId;
@property (nonatomic,strong) NSString *submitedScoreId;
@property int roundSeq;
@property (nonatomic,strong) NSString *matchId;
@property (nonatomic) BOOL isSubmitByClient;
@property (nonatomic) ScoreOperateType optType;

-(id)initWithSubmitScore:(int)_score isForRedSide:(BOOL)_forRedSide gameId:(NSString *)_gameId matchId:(NSString *)_matchId roundSeq:(int)_roundSeq clientUuids:(NSArray *)_uuids isSubmitByClient:(BOOL)_byClient andScoreOperateType:(ScoreOperateType)_optType;

@end
