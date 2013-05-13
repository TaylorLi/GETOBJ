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

-(NSArray *)queryListFromDateNeedEmptySorted:(NSDate *)dateFrom toDate:(NSDate *) dateTo withTargetId:(NSString*) targetId;

-(NSArray *)queryListToDate:(NSDate *) dateTo withDateRange:(NSInteger) range withTargetId:(NSString*) targetId;
-(NSArray *)queryListToDateByDefaultRange:(NSDate *) dateTo withTargetId:(NSString*) targetId;

-(PEDSleepData *)getLastUploadData :(NSString*) targetId;

-(NSDate *)getLastUploadDate :(NSString*) targetId;

-(PEDSleepData *)getWithTarget :(NSString*) targetId withDate:(NSDate *)date;
-(NSDate *)getLastUpdateDate :(NSString*) targetId;
-(NSDate *)getPreviosOptDate :(NSDate*) date withTarget:(NSString *)target;
-(NSDate *)getNextOptDate :(NSDate*) date withTarget:(NSString *)target;
-(NSDate *)getLastDateWithTarget:(NSString *)target between:(NSDate *)datefrom to:(NSDate *)dateTo;
-(PEDSleepData *)getFirstUploadData :(NSString*) targetId;

@end
