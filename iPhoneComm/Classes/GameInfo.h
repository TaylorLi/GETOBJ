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
@interface GameInfo : NSObject

@property (nonatomic,retain) ServerSetting *gameSetting;
@property NSTimeInterval currentRemainTime;
@property NSInteger currentRound;
@property NSInteger currentMatch;
@property NSInteger redSideScore;
@property NSInteger blueSideScore;
@property (nonatomic,retain)NSString *serverPeerId;
@property (nonatomic,retain)NSString *serverUuid;
@property GameStates gameStatus;
@property (nonatomic,retain) NSMutableDictionary *clients;
@property NSInteger needClientsCount;
-(id) initWithGameSetting:(ServerSetting *)setting;
@end
