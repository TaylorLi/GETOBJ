//
//  BO_MatchInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_MatchLog.h"
#import "MatchLog.h"

static BO_MatchLog* instance;

@implementation BO_MatchLog

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[MatchLog class] primaryKey:@"logId"];
    if(self){
        
    }
    return self;
}

+ (BO_MatchLog*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_MatchLog alloc] init];
    }
    return instance;
}

-(NSArray *)queryLogByMatchId:(NSString *)matchId andRoundSeq:(NSInteger) roundSeq
{
    return [self queryList:@"select * from MatchLog where matchId=? and round=? order by createTime desc" parameters:[[NSArray alloc] initWithObjects:matchId,[NSNumber numberWithInt:roundSeq], nil]];
}
@end
