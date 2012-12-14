//
//  KeyBoradEventInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/9/6.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "KeyBoradEventInfo.h"

@implementation KeyBoradEventInfo

@synthesize keyCode,command,control,keyDesc,option,shift;

-(NSString *)description
{
    return  [NSString stringWithFormat:@"Bluetooth key event,code:%i,desc:%@,command:%i,control:%i,option:%i,shift:%i",keyCode,keyDesc,command,control,option,shift];
}
@end
