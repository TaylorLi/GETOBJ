//
//  ServerSetting.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/14.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "ServerSetting.h"

@implementation ServerSetting

@synthesize redSideDesc;
@synthesize  redSideName;
@synthesize blueSideDesc;
@synthesize blueSideName;
@synthesize gameDesc;
@synthesize gameName;
@synthesize password;
@synthesize roundTime;
@synthesize roundCount;

-(NSString *)description
{
    return [NSString stringWithFormat:@"Name:%@,Desc:%@,Pwd:%@,Time:%f,Round:%i,Red Name:%@,Red Desc:%@,Blue Name:%@,Blue Desc:%@",gameName,gameDesc,password,roundTime,roundCount, redSideName,redSideDesc,blueSideName,blueSideDesc];
}
@end
