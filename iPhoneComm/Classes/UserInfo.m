//
//  UserInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/4.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

@synthesize pwd,name,email,userId,createTime;

-(NSString*) primaryKey{
    return @"userId";
}

@end
