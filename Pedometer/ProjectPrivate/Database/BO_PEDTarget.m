//
//  BO_MatchInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_PEDTarget.h"
#import "PEDTarget.h"

static BO_PEDTarget* instance;

@implementation BO_PEDTarget

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[PEDTarget class] primaryKey:@"targetId"];
    if(self){
        
    }
    return self;
}

+ (BO_PEDTarget*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_PEDTarget alloc] init];
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
