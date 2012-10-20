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
@interface GameInfo : NSObjectSerialization<NSCopying,NSCoding>
{
    GameStates _gameStatus;
}

@property (nonatomic,strong) ServerSetting *gameSetting;
@property NSTimeInterval currentRemainTime;
@property NSInteger currentRound;
@property NSInteger currentMatch;
@property NSInteger redSideScore;
@property NSInteger blueSideScore;
@property NSInteger redSideWarning;
@property NSInteger blueSideWarning;
@property (nonatomic,strong)NSString *serverPeerId;
@property (nonatomic,strong)NSString *serverUuid;
@property (nonatomic,strong)NSString *serverFullName;
@property (nonatomic,assign)GameStates gameStatus;
@property (nonatomic,strong) NSMutableDictionary *clients;
@property (nonatomic,strong)NSDate *serverLastHeartbeatDate;
@property (nonatomic,assign)  GameStates preGameStatus;
@property (nonatomic,strong)NSString *statusRemark;
@property BOOL gameStart;

@property  BOOL pointGapReached;
@property  BOOL warningMaxReached;
-(id) initWithGameSetting:(ServerSetting *)setting;
-(id)initWithDictionary:(NSDictionary *) disc;
-(NSDictionary *)gameStatusInfo;
-(BOOL)allClientsReady;
-(JudgeClientInfo *)clientBySequence:(int)sequence;
@end
