//
//  BO_MatchInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_PEDUserInfo.h"
#import "PEDUserInfo.h"

static BO_PEDUserInfo* instance;

@implementation BO_PEDUserInfo

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[PEDUserInfo class] primaryKey:@"userId"];
    if(self){
        
    }
    return self;
}

+ (BO_PEDUserInfo*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_PEDUserInfo alloc] init];
    }
    return instance;
}

-(PEDUserInfo *) retreiveCurrentUser
{
   PEDUserInfo *obj = [self queryObjectBySql:@"select * from PEDUserInfo where isCurrentUser=1" parameters:nil];
    if(obj){
        //[obj convertUnit:MEASURE_UNIT_METRIC];
    }
    return obj;
}

/*
-(NSArray *)queryLogByMatchId:(NSString *)matchId andRoundSeq:(NSInteger) roundSeq
{
    return [self queryList:@"select * from MatchLog where matchId=? and round=? order by createTime desc" parameters:[[NSArray alloc] initWithObjects:matchId,[NSNumber numberWithInt:roundSeq], nil]];
}
 */
-(PEDUserInfo *) retreiveUserByName:(NSString *)name
{
    PEDUserInfo *obj = [self queryObjectBySql:@"select * from PEDUserInfo where Username=?" parameters:[[NSArray alloc]  initWithObjects:name, nil]];                                                                                                   
    if(obj){
        //[obj convertUnit:MEASURE_UNIT_METRIC];
    }
    return obj;
}

-(BOOL) updateUserProfileNotToBeCurrent
{
    return [self executeNoQuery:@"update PEDUserInfo set isCurrentUser=0 where isCurrentUser=1" parameters:nil];
             
}

@end
