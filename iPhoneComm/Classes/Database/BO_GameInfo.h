//
//  BO_GameInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOBase.h"
@class GameInfo;

@interface BO_GameInfo : BOBase

+ (BO_GameInfo*) getInstance;

-(BOOL)AddGameInfo:(GameInfo *)gameInfo;


-(BOOL)hasUncompletedGame;
-(GameInfo *)getlastUncompletedGame;
-(BOOL)updateAllGameInfo:(GameInfo *)gameInfo;
-(void) updateAlluncompletedGameToEnd;

@end
