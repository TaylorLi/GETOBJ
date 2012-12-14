//
//  GameInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/21.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definition.h"

@class ServerSetting,JudgeClientInfo,MatchInfo;
@interface GameInfo : NSObjectSerialization<NSCopying,NSCoding,SqliteORMDelegate>
{

}
@property (nonatomic,strong) NSString *gameId;
@property (nonatomic,strong) ServerSetting *gameSetting;
@property NSInteger currentMatch;
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
@property (nonatomic,strong) MatchInfo *currentMatchInfo;

-(id) initWithGameSetting:(ServerSetting *)setting;
-(NSDictionary *)gameStatusInfo;
-(BOOL)allClientsReady;
-(JudgeClientInfo *)clientBySequence:(int)sequence;
-(void) resetGameInfoToStart;
-(void) rollToNextMatch;
@end
