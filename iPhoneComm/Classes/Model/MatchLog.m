//
//  MatchLog.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MatchLog.h"

@implementation MatchLog

@synthesize logId,round,blueScore,redScore, blueEvents,redEvents,matchId,createTime,roundTime,isSubmitedScore,redScoreByJudge1,redScoreByJudge2,redScoreByJudge3,redScoreByJudge4,blueScoreByJudge1,blueScoreByJudge2,blueScoreByJudge3,blueScoreByJudge4,submitedScoreInfo;

-(id)init
{
    self=[super init];
    if(self)
        {
            self.logId=[UtilHelper stringWithUUID];
            self.createTime=[NSDate date];
        }
    return self;
}
-(id) initWithMatchId:(NSString *)_matchId andRound:(NSInteger)_round andblueScoreByJudge1:(NSString *)_blueScoreByJudge1
   andblueScoreByJudge2:(NSString *)_blueScoreByJudge2 andblueScoreByJudge3:(NSString *)_blueScoreByJudge3 andblueScoreByJudge4:(NSString *)_blueScoreByJudge4 andredScoreByJudge1:(NSString *)_redScoreByJudge1
    andredScoreByJudge2:(NSString *)_redScoreByJudge2 andredScoreByJudge3:(NSString *)_redScoreByJudge3 andredScoreByJudge4:(NSString *)_redScoreByJudge4 andEvents:(NSString *) _events andBlueScore:(NSString *)_blueScore andRedScore:(NSString *)_redScore andIsSubmitedScore:(BOOL)_isSubmitedScore
 andSubmitedScoreInfo:(NSString *)_submitedScoreInfo andRoundTime:(NSString *)_roundTime andEventType:(EventType)_eventType
{
    self=[self init];
    if(self){
        matchId = _matchId;
        round = _round;
        blueScoreByJudge1= _blueScoreByJudge1;
        blueScoreByJudge2 = _blueScoreByJudge2;
        blueScoreByJudge3 = _blueScoreByJudge3;
        blueScoreByJudge4 = _blueScoreByJudge4;
        redScoreByJudge1 = _redScoreByJudge1;
        redScoreByJudge2 = _redScoreByJudge2;
        redScoreByJudge3 = _redScoreByJudge3;
        redScoreByJudge4 = _redScoreByJudge4;
        if(_eventType==EventBlue)
        {
            blueEvents=_events;     
        }
        else if(_eventType==EventRed){
            redEvents=_events;
        }
        else{
            blueEvents=_events;   
            redEvents=_events;
        }
        blueScore = _blueScore;
        redScore= _redScore;
        isSubmitedScore = _isSubmitedScore;
        submitedScoreInfo = submitedScoreInfo;
        roundTime=_roundTime;
    }
    return self;
}

-(id) initWithMatchId:(NSString *)_matchId andRound:(NSInteger)_round andEvents:(NSString *) _events andBlueScore:(NSString *)_blueScore andRedScore:(NSString *)_redScore andIsSubmitedScore:(BOOL)_isSubmitedScore andSubmitedScoreInfo:(NSString *)_submitedScoreInfo andRoundTime:(NSString *)_roundTime andEventType:(EventType)_eventType{
    self=[self init];
    if(self){
        matchId = _matchId;
        round = _round;
        if(_eventType==EventBlue)
        {
            blueEvents=_events;     
        }
        else if(_eventType==EventRed){
            redEvents=_events;
        }
        else{
            blueEvents=_events;   
            redEvents=_events;
        }
        blueScore=_blueScore;
        redScore=_redScore;
        isSubmitedScore = _isSubmitedScore;
        submitedScoreInfo = submitedScoreInfo;
        roundTime=_roundTime;
    }
    return self;
}
@end
