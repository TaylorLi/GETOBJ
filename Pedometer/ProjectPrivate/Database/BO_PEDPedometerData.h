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

-(NSArray *)queryListFromDateNeedEmptySorted:(NSDate *)dateFrom toDate:(NSDate *) dateTo withTargetId:(NSString*) targetId;

-(NSArray *)queryListToDate:(NSDate *) dateTo withDateRange:(NSInteger) range withTargetId:(NSString*) targetId;
-(NSArray *)queryListToDateByDefaultRange:(NSDate *) dateTo withTargetId:(NSString*) targetId;

-(PEDPedometerData *)getLastUploadData :(NSString*) targetId;

-(NSDate *)getLastUploadDate :(NSString*) targetId;

@end
