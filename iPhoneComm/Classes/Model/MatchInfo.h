//
//  MatchInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/4.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServerSetting,RoundInfo;
@interface MatchInfo : NSObjectSerialization<SqliteORMDelegate>

@property (nonatomic,copy) NSString *matchId;
@property (nonatomic,copy) NSString *gameId;
@property NSTimeInterval currentRemainTime;
@property NSInteger currentRound;
@property (nonatomic,strong)  RoundInfo *currentRoundInfo;
@property NSInteger currentMatch;
@property NSInteger redSideScore;
@property NSInteger blueSideScore;
@property NSInteger redSideWarning;
@property NSInteger blueSideWarning;
@property (nonatomic,assign)GameStates gameStatus;
@property (nonatomic,assign)  GameStates preGameStatus;
@property  BOOL pointGapReached;
@property  BOOL warningMaxReached;
@property (nonatomic,copy)NSString *statusRemark;
@property WinType winByType;
@property BOOL isRedToBeWinner;

-(id) initWithGameSetting:(ServerSetting *)setting;
-(void) resetMatchInfoToStart:(ServerSetting *)setting;

@end
