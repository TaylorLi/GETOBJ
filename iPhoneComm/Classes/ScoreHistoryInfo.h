//
//  ScoreHistoryInfo.h
//  TKD Score
//
//  Created by Yuheng Li on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreHistoryInfo : NSObject

@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;
@property (nonatomic, retain) NSMutableArray *uuids;
@property (nonatomic, retain) NSTimer *calTimer;
@property (nonatomic, retain) NSString *sideKey;
@property (nonatomic, retain) NSString *scoreKey;

-(id) initWithInfo:(NSDate *) _startTime andEndTime:(NSDate *) _endTime andSideKey:(NSString *) _sideKey andScoreKey:(NSString *) _scoreKey  andUuids:(NSMutableArray *) _uuids;

-(id) initWithInfo:(NSDate *) _startTime andEndTime:(NSDate *) _endTime andSideKey:(NSString *) _sideKey andScoreKey:(NSString *) _scoreKey andUuid:(NSString *) _uuid;

//-(id)initWithDictionary:(NSDictionary *) disc;

@end
