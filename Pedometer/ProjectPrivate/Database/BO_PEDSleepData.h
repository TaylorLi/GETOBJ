//
//  BO_MatchInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOBase.h"

@class PEDSleepData;

@interface BO_PEDSleepData : BOBase

+ (BO_PEDSleepData*) getInstance;


//-(NSArray *)queryLogByMatchId:(NSString *)matchId andRoundSeq:(NSInteger) roundSeq;
-(PEDSleepData *)getWithTarget :(NSString*) targetId withDate:(NSDate *)date;

@end
