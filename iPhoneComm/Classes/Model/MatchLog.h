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

@property (nonatomic,copy) NSString *logId;
@property (nonatomic,copy) NSString *matchId;
@property (nonatomic) NSInteger round;
@property (nonatomic,strong) NSDate *createTime;
@property (nonatomic,copy) NSString *roundTime;
@property (nonatomic,copy) NSString *blueScoreByJudge1;
@property (nonatomic,copy) NSString *blueScoreByJudge2;
@property (nonatomic,copy) NSString *blueScoreByJudge3;
@property (nonatomic,copy) NSString *blueScoreByJudge4;
@property (nonatomic,copy) NSString *redScoreByJudge1;
@property (nonatomic,copy) NSString *redScoreByJudge2;
@property (nonatomic,copy) NSString *redScoreByJudge3;
@property (nonatomic,copy) NSString *redScoreByJudge4;
@property (nonatomic,copy) NSString *blueEvents;
@property (nonatomic,copy) NSString *redEvents;
@property (nonatomic,copy) NSString *blueScore;
@property (nonatomic,copy) NSString *redScore;

-(id) initWithMatchId:(NSString *)_matchId andRound:(NSInteger)_round andblueScoreByJudge1:(NSString *)_blueScoreByJudge1
   andblueScoreByJudge2:(NSString *)_blueScoreByJudge2 andblueScoreByJudge3:(NSString *)_blueScoreByJudge3 andblueScoreByJudge4:(NSString *)_blueScoreByJudge4 andredScoreByJudge1:(NSString *)_redScoreByJudge1
  andredScoreByJudge2:(NSString *)_redScoreByJudge2 andredScoreByJudge3:(NSString *)_redScoreByJudge3 andredScoreByJudge4:(NSString *)_redScoreByJudge4 andEvents:(NSString *) _events andBlueScore:(NSString *)_blueScore andRedScore:(NSString *)_redScore  andRoundTime:(NSString *)_roundTime andEventType:(EventType)_eventType; 


-(id) initWithMatchId:(NSString *)_matchId andRound:(NSInteger)_round andEvents:(NSString *) _events andBlueScore:(NSString *)_blueScore andRedScore:(NSString *)_redScore andRoundTime:(NSString *)_roundTime andEventType:(EventType)_eventType; 

@end
