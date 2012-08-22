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
@synthesize datetime;

-(id) init{
    return [self initWithInfo:nil andBlueScore:0 andRedScore:0 andDateNow:nil];
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
        self.redSideScore = _redScore;
        self.blueSideScore = _blueScore;
        self.swipeType = _swipeType;
        if(_datenow==nil){
            self.datetime = [NSDate date];
        }else{
            self.datetime = _datenow;
        }
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *) disc
{
    self = [super init];
    if (self) {
        NSNumber *nDate=[disc objectForKey:@"datetime"];
        self.datetime=[NSDate dateWithTimeIntervalSince1970:[nDate doubleValue]];
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
                          [NSNumber numberWithDouble:[self.datetime timeIntervalSince1970] ],@"datetime", nil];
    return result;
}

@end
