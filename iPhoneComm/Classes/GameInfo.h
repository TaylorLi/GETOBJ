//
//  GameInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/21.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definition.h"

@class ServerSetting,JudgeClientInfo;
@interface GameInfo : NSObjectSerialization<NSCopying,NSCoding,SqliteORMDelegate>
{
    GameStates _gameStatus;
}
@property (nonatomic,strong) NSString *gameId;
@property (nonatomic,strong) ServerSetting *gameSetting;
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

@property (nonatomic,strong)NSString *serverPeerId;
@property (nonatomic,strong)NSString *serverUuid;
@property (nonatomic,strong)NSString *serverFullName;
@property (nonatomic,strong) NSString *serverUserId;

@property (nonatomic,strong) NSMutableDictionary *clients;
@property (nonatomic,strong)NSDate *serverLastHeartbeatDate;
@property BOOL gameStart;
//比赛正常完成，包括完成和退出
@property BOOL gameEnded;
//比赛开始时间，从比赛正式开始时刻算起
@property (nonatomic,strong) NSDate *gameStartTime;
//比赛结束时间，比赛完成时的时刻，如果比赛为正常完成，改值为0
@property (nonatomic,strong) NSDate *gameEndTime;

-(id) initWithGameSetting:(ServerSetting *)setting;
-(id)initWithDictionary:(NSDictionary *) disc;
-(NSDictionary *)gameStatusInfo;
-(BOOL)allClientsReady;
-(JudgeClientInfo *)clientBySequence:(int)sequence;
-(void) resetGameInfo;
@end
