//
//  BO_MatchInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_MatchInfo.h"
#import "MatchInfo.h"

static BO_MatchInfo* instance;

@implementation BO_MatchInfo

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[MatchInfo class] primaryKey:@"matchId"];
    if(self){
        
    }
    return self;
}

+ (BO_MatchInfo*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_MatchInfo alloc] init];
    }
    return instance;
}

@end
