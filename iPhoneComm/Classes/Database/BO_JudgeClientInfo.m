//
//  BO_JugdeClientInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_JudgeClientInfo.h"

#import "JudgeClientInfo.h"

static BO_JudgeClientInfo* instance;

@implementation BO_JudgeClientInfo

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[JudgeClientInfo class] primaryKey:@"clientId"];
    if(self){
        
    }
    return self;
}

+ (BO_JudgeClientInfo*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_JudgeClientInfo alloc] init];
    }
    return instance;
}

@end
