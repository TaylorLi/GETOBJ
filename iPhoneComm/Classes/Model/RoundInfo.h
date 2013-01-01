//
//  RoundInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoundInfo : NSObjectSerialization<SqliteORMDelegate>

@property (nonatomic,strong) NSString *roundId;
@property (nonatomic,strong) NSString *matchId;
@property (nonatomic) NSInteger round;
@property (nonatomic,strong) NSDate *startTime;
@property (nonatomic,strong) NSDate *endTime;
//本回合得分
@property (nonatomic) NSInteger blueScore;
@property (nonatomic) NSInteger redScore;
//本回合警告
@property (nonatomic) NSInteger blueWarnming;
@property (nonatomic) NSInteger redWarnming;
@property (nonatomic) BOOL roundWinnerisBlue;

-(id) initWithRoundSeq:(NSInteger) _round andMatchId:(NSString *) _matchId andStartTime:(NSDate *) _startTime;

@end
