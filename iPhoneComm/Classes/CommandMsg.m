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

-(void)dealloc{
    [type release];
    [desc release];
    [data release];
    [from release];
}

-(id)initWithType:(NSString *)_type andFrom:(NSString *)_from andDesc:(NSString *)_desc andData:(id)_data{
    if(!(self = [super init]))
    {
        return nil;
    }
    // Initialize members    
    self.type=_type;
    self.from=_from;
    self.desc=_desc;
    self.data=_data;
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
    return self;
}

-(NSDictionary*) proxyForJson {
    NSDictionary *result=[NSDictionary dictionaryWithObjectsAndKeys:self.from,@"from",self.data,@"data",self.type,@"type",self.desc,@"desc", nil];
    return result;
}
@end
