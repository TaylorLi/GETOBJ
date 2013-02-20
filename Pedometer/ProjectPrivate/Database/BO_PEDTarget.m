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

-(PEDTarget *)queryTargetByUserId:(NSString *)userId
{
    return [self queryObjectBySql:@"select * from PEDTarget where userId=?" parameters:[[NSArray alloc] initWithObjects:userId, nil]];
}
@end
