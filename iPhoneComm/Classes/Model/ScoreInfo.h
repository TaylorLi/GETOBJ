//
//  ScoreInfo.h
//  TKD Score
//
//  Created by Yuheng Li on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definition.h"

@interface ScoreInfo : NSObjectSerialization<SqliteORMDelegate>

@property int blueSideScore;
@property int redSideScore;
@property SwipeType swipeType;
@property (nonatomic, retain) NSDate *createTime;
@property (nonatomic,copy) NSString *clientUuid;
@property (nonatomic,copy) NSString *gameId;
@property (nonatomic,copy) NSString *clientId;
@property (nonatomic,copy) NSString *scoreId;
@property int roundSeq;
@property (nonatomic,copy) NSString *matchId;
//@property BOOL successSubmited;

#pragma mark -
#pragma  mark just use in table view
@property (nonatomic,strong) NSString *clientName;
#pragma mark -

-(id) init;
-(id) initWithBlueSide:(int)_blueScore andDateNow:(NSDate *)_datenow;
-(id) initWithRedSide:(int)_redScore andDateNow:(NSDate *)_datenow;
-(id) initWithInfo:(SwipeType)_swipeType andBlueScore:(int)_blueScore andRedScore:(int)_redScore andDateNow:(NSDate *)_datenow;
-(id)initWithDictionary:(NSDictionary *) disc;
-(NSDictionary*) proxyForJson;
@end
