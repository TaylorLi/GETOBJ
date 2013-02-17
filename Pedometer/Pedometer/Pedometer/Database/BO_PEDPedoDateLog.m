//
//  BO_MatchInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_PEDPedoDateLog.h"
#import "PEDPedoDateLog.h"

static BO_PEDPedoDateLog* instance;

@implementation BO_PEDPedoDateLog

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[PEDPedoDateLog class] primaryKey:@"logId"];
    if(self){
        
    }
    return self;
}

+ (BO_PEDPedoDateLog*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_PEDPedoDateLog alloc] init];
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
