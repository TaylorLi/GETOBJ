//
//  MatchInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/4.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ServerSetting;
@interface MatchInfo : NSObjectSerialization<SqliteORMDelegate>

@property (nonatomic,strong) NSString *matchId;
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

-(id) initWithGameSetting:(ServerSetting *)setting;
-(void) resetMatchInfoToStart:(ServerSetting *)setting;

@end
