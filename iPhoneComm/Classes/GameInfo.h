//
//  GameInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/21.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definition.h"

@class ServerSetting;
@interface GameInfo : NSObject<NSCopying>
{
    GameStates _gameStatus;
}

@property (nonatomic,strong) ServerSetting *gameSetting;
@property NSTimeInterval currentRemainTime;
@property NSInteger currentRound;
@property NSInteger currentMatch;
@property NSInteger redSideScore;
@property NSInteger blueSideScore;
@property NSInteger redSideWarmning;
@property NSInteger blueSideWarmning;
@property (nonatomic,strong)NSString *serverPeerId;
@property (nonatomic,strong)NSString *serverUuid;
@property (nonatomic,setter = setCurrentStatus:,getter = getCurrentStatus,assign)GameStates gameStatus;
@property (nonatomic,strong) NSMutableDictionary *clients;
@property NSInteger needClientsCount;
@property (nonatomic,strong)NSDate *serverLastHeartbeatDate;
@property (nonatomic,assign)  GameStates preGameStatus;
-(id) initWithGameSetting:(ServerSetting *)setting;
-(id)initWithDictionary:(NSDictionary *) disc;
@end
