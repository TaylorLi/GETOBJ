//
//  BO_UserInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_UserInfo.h"
#import "UserInfo.h"

static BO_UserInfo* instance;

@implementation BO_UserInfo

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[UserInfo class] primaryKey:@"userId"];
    if(self){
        
    }
    return self;
}

+ (BO_UserInfo*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_UserInfo alloc] init];
    }
    return instance;
}

@end
