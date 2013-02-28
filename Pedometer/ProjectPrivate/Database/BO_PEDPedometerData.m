//
//  BO_MatchInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_PEDPedometerData.h"
#import "PEDPedometerData.h"

static BO_PEDPedometerData* instance;

@implementation BO_PEDPedometerData

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[PEDPedometerData class] primaryKey:@"dataId"];
    if(self){
        
    }
    return self;
}

+ (BO_PEDPedometerData*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_PEDPedometerData alloc] init];
    }
    return instance;
}
//获取一段时间内的所有数据
-(NSArray *)queryListFromDate:(NSDate *)dateFrom toDate:(NSDate *) dateTo withTargetId:(NSString*) targetId
{
    return [self queryList:@"select * from PEDPedometerData where targetId=? and optDate between ? and ? order by optDate" parameters:[[NSArray alloc] initWithObjects:targetId,dateFrom,dateTo, nil]];
}
//获取一段时间内的所有数据，如果是空数据的话取空值
-(NSArray *)queryListFromDateNeedEmptySorted:(NSDate *)dateFrom toDate:(NSDate *) dateTo withTargetId:(NSString*) targetId
{
    NSArray *array =  [self queryListFromDate:dateFrom toDate:dateTo withTargetId: targetId];
  NSMutableArray *sortArray=[[NSMutableArray alloc] init];  
    NSTimeInterval totalDays =  [dateTo timeIntervalSinceDate:dateFrom]/24/3600;
    for (NSTimeInterval i=0; i<=totalDays; i++) {
        NSDate *date=[dateFrom dateByAddingTimeInterval:i*3600*24];
        BOOL find=NO;
        for (PEDPedometerData *data in array) {
           if([data.optDate timeIntervalSinceDate:date]==0)
               {
                   find=YES;
                   [sortArray addObject:data];
                   break;
               }
        }
        if(!find){
            [sortArray addObject:nil]; 
        }
    }
  return sortArray;  
}

-(NSArray *)queryListToDate:(NSDate *) dateTo withDateRange:(NSInteger) range withTargetId:(NSString*) targetId
{
    NSDate *dateFrom=[dateTo dateByAddingTimeInterval:range*-1*24*3600];
    return [self queryListFromDateNeedEmptySorted:dateFrom toDate:dateTo withTargetId: targetId];
}

-(NSArray *)queryListToDateByDefaultRange:(NSDate *) dateTo withTargetId:(NSString*) targetId
{
    return [self queryListToDate:dateTo withDateRange:[AppConfig getInstance].settings.showDateCount withTargetId: targetId];
}


-(PEDPedometerData *)getLastUploadData :(NSString*) targetId
{
    return [self queryObjectBySql:@"select * from PEDPedometerData where targetId = ? order by optDate desc LIMIT 1" parameters:[[NSArray alloc] initWithObjects:targetId, nil]];
}

-(NSDate *)getLastUploadDate :(NSString*) targetId
{
    PEDPedometerData *data=[self getLastUploadData :targetId];
    if(data)
        return  data.optDate;
    else
        return nil;
}

@end
