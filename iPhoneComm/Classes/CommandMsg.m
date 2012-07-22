//
//  CommandMsg.m
//  Chatty
//
//  Created by Eagle Du on 12/7/7.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "CommandMsg.h"

@implementation CommandMsg

@synthesize type;
@synthesize desc;
@synthesize data;
@synthesize from;
@synthesize date;

-(void)dealloc{
    [desc release];
    [data release];
    [from release];
    [type release];
}

-(id)initWithType:(PacketCodes)_type andFrom:(NSString *)_from andDesc:(NSString *)_desc andData:(id)_data andDate:(NSDate *)_date{
    if(!(self = [super init]))
    {
        return nil;
    }
    // Initialize members    
    self.type=[NSNumber numberWithInt:_type];
    self.from=_from;
    self.desc=_desc;
    self.data=_data;
    self.date=_date;
    return self;
}
-(id)initWithDictionary:(NSDictionary *) disc
{
    if(!(self = [super init]))
    {
        return nil;
    }
    self.from=[disc objectForKey:@"from"];
    self.data=[disc objectForKey:@"data"];
    self.type=[disc objectForKey:@"type"];
    self.desc=[disc objectForKey:@"desc"];
    NSNumber *d=[disc objectForKey:@"date"];
    self.date=[NSDate dateWithTimeIntervalSince1970:[d doubleValue]]; 
    return self;
}

-(NSDictionary*) proxyForJson {
    id dataInfo;
    if([data respondsToSelector:@selector(proxyForJson)])
        {
            dataInfo=[data performSelector:@selector(proxyForJson)];
        }
    else
    dataInfo=self.data;
    NSDictionary *result=[NSDictionary dictionaryWithObjectsAndKeys:self.from==nil?[NSNull null]:self.from,@"from",dataInfo==nil?[NSNull null]: dataInfo,@"data",self.type,@"type",self.desc==nil?[NSNull null]:self.desc,@"desc",[NSNumber numberWithDouble:[self.date timeIntervalSince1970] ],@"date", nil];
    return result;
}
@end
