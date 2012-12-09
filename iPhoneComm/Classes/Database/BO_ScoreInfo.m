//
//  BO_ScoreInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_ScoreInfo.h"
#import "ScoreInfo.h"

static BO_ScoreInfo* instance;

@implementation BO_ScoreInfo

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[ScoreInfo class] primaryKey:@"scoreId"];
    if(self){
        
    }
    return self;
}

+ (BO_ScoreInfo*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_ScoreInfo alloc] init];
    }
    return instance;
}

@end
