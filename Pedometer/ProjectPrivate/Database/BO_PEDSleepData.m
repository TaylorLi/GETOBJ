//
//  BO_MatchInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_PEDSleepData.h"
#import "PEDSleepData.h"

static BO_PEDSleepData* instance;

@implementation BO_PEDSleepData

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[PEDSleepData class] primaryKey:@"dataId"];
    if(self){
        
    }
    return self;
}

+ (BO_PEDSleepData*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_PEDSleepData alloc] init];
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
