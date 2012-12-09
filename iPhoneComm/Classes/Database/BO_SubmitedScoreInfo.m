//
//  BO_SubmitedScoreInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/9.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_SubmitedScoreInfo.h"
#import "SubmitedScoreInfo.h"

static BO_SubmitedScoreInfo* instance;

@implementation BO_SubmitedScoreInfo

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[SubmitedScoreInfo class] primaryKey:@"submitedScoreId"];
    if(self){
        
    }
    return self;
}

+ (BO_SubmitedScoreInfo*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_SubmitedScoreInfo alloc] init];
    }
    return instance;
}

@end
