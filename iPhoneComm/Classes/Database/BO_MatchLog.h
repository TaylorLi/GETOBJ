//
//  BO_MatchInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOBase.h"

@class MatchLog;
@interface BO_MatchLog : BOBase

+ (BO_MatchLog*) getInstance;


-(NSArray *)queryLogByMatchId:(NSString *)matchId andRoundSeq:(NSInteger) roundSeq;
@end
