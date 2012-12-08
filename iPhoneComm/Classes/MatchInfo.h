//
//  MatchInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/4.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchInfo : NSObjectSerialization<SqliteORMDelegate>

@property (nonatomic,strong) NSString *gameId;
@property NSTimeInterval currentRemainTime;
@property NSInteger currentRound;
@property NSInteger currentMatch;
@property NSInteger redSideScore;
@property NSInteger blueSideScore;
@property NSInteger redSideWarning;
@property NSInteger blueSideWarning;
@property (nonatomic,assign)GameStates gameStatus;
@property (nonatomic,assign)  GameStates preGameStatus;
@property  BOOL pointGapReached;
@property  BOOL warningMaxReached;
@property (nonatomic,strong)NSString *statusRemark;
@property WinType winByType;
@property BOOL isRedToBeWinner;

@end
