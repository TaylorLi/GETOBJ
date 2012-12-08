//
//  MatchInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/4.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "MatchInfo.h"

@implementation MatchInfo

@synthesize currentRound,redSideScore,blueSideScore,currentRemainTime,blueSideWarning,redSideWarning,preGameStatus,pointGapReached,warningMaxReached,statusRemark,winByType,gameId,isRedToBeWinner,gameStatus,currentMatch;

-(NSString*) primaryKey{
    return @"matchId";
}
@end
