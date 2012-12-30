//
//  BO_MatchInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_RoundInfo.h"
#import "RoundInfo.h"

static BO_RoundInfo* instance;

@implementation BO_RoundInfo

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[RoundInfo class] primaryKey:@"roundId"];
    if(self){
        
    }
    return self;
}

+ (BO_RoundInfo*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_RoundInfo alloc] init];
    }
    return instance;
}

@end
