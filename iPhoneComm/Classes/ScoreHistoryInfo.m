//
//  ScoreHistoryInfo.m
//  TKD Score
//
//  Created by Yuheng Li on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScoreHistoryInfo.h"
#import "ScoreInfo.h"

@implementation ScoreHistoryInfo

@synthesize startTime, endTime, uuids, calTimer, sideKey, scoreKey;

-(id) initWithInfo:(NSDate *) _startTime andEndTime:(NSDate *) _endTime andSideKey:(NSString *) _sideKey andScoreKey:(NSString *) _scoreKey andUuids:(NSMutableArray *) _uuids{
    self = [super init];
    if (self) {
        self.startTime = _startTime;
        self.endTime = _endTime;
        self.uuids = _uuids;
        self.sideKey = _sideKey;
        self.scoreKey = _scoreKey;
        if(self.startTime==nil){
            self.startTime = [NSDate date];
        }
        if(self.uuids==nil){
            uuids = [[NSMutableArray alloc]initWithObjects:nil];
        }
//        if(self.scoreInfos==nil){
//            scoreInfos=[[NSMutableArray alloc] init];
//        }
    }
    return self;
}

-(id) initWithInfo:(NSDate *) _startTime andEndTime:(NSDate *) _endTime andSideKey:(NSString *) _sideKey andScoreKey:(NSString *) _scoreKey andUuid:(NSString *) _uuid{
    self = [self  initWithInfo:_startTime andEndTime:_endTime andSideKey:_sideKey andScoreKey:_scoreKey andUuids:nil];
    if(_uuid != nil){
        [self.uuids addObject:_uuid];
        //[scoreInfos addObject:scoreInfo];
        //NSLog(@"his infos:%i",scoreInfos.count);
    }
    return self;
}

//-(id)initWithDictionary:(NSDictionary *) disc
//{
//    self = [super init];
//    if (self) {
//        NSNumber *nStartTime=[disc objectForKey:@"startTime"];
//        NSNumber *nEndTime=[disc objectForKey:@"endTime"];
//        self.startTime=[NSDate dateWithTimeIntervalSince1970:[nStartTime doubleValue]];
//        self.endTime=[NSDate dateWithTimeIntervalSince1970:[nEndTime doubleValue]];
//        self.sideKey=[disc objectForKey:@"sideKey"];
//        self.scoreKey=[disc objectForKey:@"scoreKey"];
//        self.uuids=[disc objectForKey:@"uuids"];
//    }
//    return self;
//}
//
//-(NSDictionary*) proxyForJson {
//    NSDictionary *result=[NSDictionary dictionaryWithObjectsAndKeys:
//                          self.sideKey==nil?[NSNull null]:self.sideKey,@"sideKey",
//                          self.scoreKey==nil?[NSNull null]:self.scoreKey,@"scoreKey",
//                          //[NSTimer t:self.calTimer],@"calTimer",
//                          self.uuids==nil?[NSNull null]:[NSMutableArray arrayWithObjects:self.uuids, nil],@"uuids",
//                          [NSNumber numberWithDouble:[self.startTime timeIntervalSince1970] ],@"endTime",
//                          [NSNumber numberWithDouble:[self.startTime timeIntervalSince1970] ],@"startTime", nil];
//    return result;
//}

@end
