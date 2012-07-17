//
//  ServerRelateInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/16.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "ServerRelateInfo.h"
//info of the seached sever

@implementation ServerRelateInfo

@synthesize peerId;
@synthesize password;
@synthesize orgSeverName;
@synthesize sessionId;
@synthesize displaySeverName;
@synthesize uuid;
@synthesize createTime;
-(void) dealloc
{
    peerId=nil;
    password=nil;
    orgSeverName=nil;
    sessionId=nil;
    displaySeverName=nil;
    createTime=nil;
}
-(NSString *)description
{
    if(createTime!=nil){
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle]; 
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle]; 
    //[dateFormatter setDateFormat:@"hh:mm:ss"] 
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"]; 
    NSLog(@"CreateTime:%@",[dateFormatter stringFromDate:createTime]);
    [dateFormatter release]; 
    }
    return [NSString stringWithFormat:@"PeerId:%@,Password:%@,OrgServerName:%@,SessionId:%@,displaySeverName:%@,UUID:%@,CreateTime:%@",peerId,password,orgSeverName,sessionId,displaySeverName,uuid,createTime];
}
@end
