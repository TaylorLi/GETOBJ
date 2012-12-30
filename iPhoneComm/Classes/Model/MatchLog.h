//
//  MatchLog.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define enu
@interface MatchLog : NSObjectSerialization<SqliteORMDelegate>

@property (nonatomic,strong) NSString *logId;
@property (nonatomic,strong) NSString *matchId;
@property (nonatomic) NSInteger round;
@property (nonatomic,strong) NSDate *createTime;
@property (nonatomic,strong) NSString *roundTime;
@property (nonatomic,strong) NSString *blueScoreByJudge1;
@property (nonatomic,strong) NSString *blueScoreByJudge2;
@property (nonatomic,strong) NSString *blueScoreByJudge3;
@property (nonatomic,strong) NSString *blueScoreByJudge4;
@property (nonatomic,strong) NSString *redScoreByJudge1;
@property (nonatomic,strong) NSString *redScoreByJudge2;
@property (nonatomic,strong) NSString *redScoreByJudge3;
@property (nonatomic,strong) NSString *redScoreByJudge4;
@property (nonatomic,strong) NSString *blueEvents;
@property (nonatomic,strong) NSString *redEvents;
@property (nonatomic,strong) NSString *blueScore;
@property (nonatomic,strong) NSString *redScore;
@property (nonatomic) BOOL isSubmitedScore;
@property (nonatomic,strong) NSString *submitedScoreInfo;

-(id) initWithMatchId:(NSString *)_matchId andRound:(NSInteger)_round andblueScoreByJudge1:(NSString *)_blueScoreByJudge1
   andblueScoreByJudge2:(NSString *)_blueScoreByJudge2 andblueScoreByJudge3:(NSString *)_blueScoreByJudge3 andblueScoreByJudge4:(NSString *)_blueScoreByJudge4 andredScoreByJudge1:(NSString *)_redScoreByJudge1
  andredScoreByJudge2:(NSString *)_redScoreByJudge2 andredScoreByJudge3:(NSString *)_redScoreByJudge3 andredScoreByJudge4:(NSString *)_redScoreByJudge4 andEvents:(NSString *) _events andBlueScore:(NSString *)_blueScore andRedScore:(NSString *)_redScore andIsSubmitedScore:(BOOL)_isSubmitedScore
 andSubmitedScoreInfo:(NSString *)_submitedScoreInfo andRoundTime:(NSString *)_roundTime andEventType:(EventType)_eventType; 


-(id) initWithMatchId:(NSString *)_matchId andRound:(NSInteger)_round andEvents:(NSString *) _events andBlueScore:(NSString *)_blueScore andRedScore:(NSString *)_redScore  andIsSubmitedScore:(BOOL)_isSubmitedScore andSubmitedScoreInfo:(NSString *)_submitedScoreInfo andRoundTime:(NSString *)_roundTime andEventType:(EventType)_eventType; 

@end
