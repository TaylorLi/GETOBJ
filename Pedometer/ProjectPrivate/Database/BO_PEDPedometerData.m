//
//  BO_MatchInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_PEDPedometerData.h"
#import "PEDPedometerData.h"

static BO_PEDPedometerData* instance;

@implementation BO_PEDPedometerData

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[PEDPedometerData class] primaryKey:@"dataId"];
    if(self){
        
    }
    return self;
}

+ (BO_PEDPedometerData*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_PEDPedometerData alloc] init];
    }
    return instance;
}
/*
-(NSArray *)queryLogByMatchId:(NSString *)matchId andRoundSeq:(NSInteger) roundSeq
{
    return [self queryList:@"select * from MatchLog where matchId=? and round=? order by createTime desc" parameters:[[NSArray alloc] initWithObjects:matchId,[NSNumber numberWithInt:roundSeq], nil]];
}
*/
@end
