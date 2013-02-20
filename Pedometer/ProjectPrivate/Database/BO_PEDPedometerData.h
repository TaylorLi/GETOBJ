//
//  BO_MatchInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOBase.h"

@class PEDPedometerData;
@interface BO_PEDPedometerData : BOBase

+ (BO_PEDPedometerData*) getInstance;


//-(NSArray *)queryLogByMatchId:(NSString *)matchId andRoundSeq:(NSInteger) roundSeq;

-(NSArray *)queryListFromDateNeedEmptySorted:(NSDate *)dateFrom toDate:(NSDate *) dateTo;

-(NSArray *)queryListToDate:(NSDate *) dateTo withDateRange:(NSInteger) range;
-(NSArray *)queryListToDateByDefaultRange:(NSDate *) dateTo;

-(PEDPedometerData *)getLastUploadData;

-(NSDate *)getLastUploadDate;

@end
