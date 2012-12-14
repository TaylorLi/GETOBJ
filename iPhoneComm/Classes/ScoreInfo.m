//
//  ScoreInfo.m
//  TKD Score
//
//  Created by Yuheng Li on 12-8-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScoreInfo.h"

@implementation ScoreInfo

@synthesize blueSideScore;
@synthesize redSideScore;
@synthesize swipeType;
@synthesize createTime;
@synthesize clientUuid;
@synthesize gameId;
@synthesize clientId;
@synthesize scoreId,matchId,roundSeq;
//@synthesize successSubmited;

#pragma mark -
#pragma  mark just use in table view
@synthesize clientName;
#pragma mark -
-(id) init{
    return [self initWithInfo:kSideBlue andBlueScore:0 andRedScore:0 andDateNow:nil];
}

-(id) initWithBlueSide:(int)_blueScore andDateNow:(NSDate *)_datenow{
    return [self initWithInfo:kSideBlue andBlueScore:_blueScore andRedScore:0 andDateNow:_datenow];
}

-(id) initWithRedSide:(int)_redScore andDateNow:(NSDate *)_datenow{
    return [self initWithInfo:kSideRed andBlueScore:0 andRedScore:_redScore andDateNow:_datenow];
}

-(id) initWithInfo:(SwipeType)_swipeType andBlueScore:(int)_blueScore andRedScore:(int)_redScore andDateNow:(NSDate *)_datenow
{
    self = [super init];
    if (self) {
        scoreId=[UtilHelper stringWithUUID];
        self.redSideScore = _redScore;
        self.blueSideScore = _blueScore;
        self.swipeType = _swipeType;
        if(_datenow==nil){
            self.createTime = [NSDate date];
        }else{
            self.createTime = _datenow;
        }
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *) disc
{
    self = [super init];
    if (self) {
        scoreId=[UtilHelper stringWithUUID];
        NSNumber *nDate=[disc objectForKey:@"datetime"];
        self.createTime=[NSDate dateWithTimeIntervalSince1970:[nDate doubleValue]];
        self.swipeType=[[disc objectForKey:@"swipeType"] intValue]; 
        self.blueSideScore=[[disc objectForKey:@"blueSideScore"] intValue];
        self.redSideScore=[[disc objectForKey:@"redSideScore"] intValue];
    }
    return self;
}

-(NSDictionary*) proxyForJson {
    NSDictionary *result=[NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:self.blueSideScore],@"blueSideScore",
                          [NSNumber numberWithInt:self.redSideScore],@"redSideScore",
                          [NSNumber numberWithInt:self.swipeType],@"swipeType",
                          [NSNumber numberWithDouble:[self.createTime timeIntervalSince1970] ],@"datetime", nil];
    return result;
}

@end
