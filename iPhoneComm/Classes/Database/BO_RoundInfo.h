//
//  BO_MatchInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOBase.h"

@class  RoundInfo;
@interface BO_RoundInfo : BOBase

+ (BO_RoundInfo*) getInstance;

-(RoundInfo *)retreiveRoundByMatchId:(NSString *)matchId andRoundSeq:(NSInteger) roundSeq;

-(NSArray *)queryListByMatchId:(NSString *)matchId;
@end
