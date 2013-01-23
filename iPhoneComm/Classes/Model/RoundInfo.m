//
//  RoundInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RoundInfo.h"

@implementation RoundInfo

@synthesize roundId,matchId,round,startTime,endTime,blueScore,redScore,redWarnming,blueWarnming,roundWinnerisBlue;


-(id) initWithRoundSeq:(NSInteger) _round andMatchId:(NSString *) _matchId andStartTime:(NSDate *) _startTime
{
    self=[super init];
    if(self)
    {
        self.roundId=[UtilHelper stringWithUUID];
        self.round=_round;
        self.matchId=_matchId;
        self.startTime=_startTime;
    }
    return  self;
}
@end
