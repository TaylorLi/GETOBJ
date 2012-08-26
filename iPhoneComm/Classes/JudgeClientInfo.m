//
//  JudgeClientInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/21.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "JudgeClientInfo.h"

@implementation JudgeClientInfo

@synthesize sessionId;
@synthesize displayName;
@synthesize uuid;
@synthesize peerId;
@synthesize hasConnected;
@synthesize lastHeartbeatDate;


-(id) initWithSessionId:(NSString*) _sessionId andDisplayName:(NSString *)_displayName
                andUuid:(NSString *) _uuid andPeerId:(NSString *)_peerId
{
    self=[super init];
    if(self)
    {
        self.sessionId=_sessionId;
        self.displayName=_displayName;
        self.uuid=_uuid;
        self.peerId=_peerId;
    }
    return self;
}

-(NSDictionary*) proxyForJson {
    NSDictionary *result=[NSDictionary dictionaryWithObjectsAndKeys:self.sessionId==nil?[NSNull null]: self.sessionId,@"sessionId",self.displayName==nil?[NSNull null]:self.displayName,@"displayName",self.uuid==nil?[NSNull null]:self.uuid,@"uuid",self.peerId ==nil?[NSNull null]:self.peerId,@"peerId",[NSNumber numberWithBool: self.hasConnected],@"hasConnected",self.lastHeartbeatDate,@"lastHeartbeatDate",nil];
    return result;
}

-(id)initWithDictionary:(NSDictionary *) disc
{
    if(!(self = [super init]))
    {
        return nil;
    }
    self.sessionId=[disc objectForKey:@"sessionId"];
    self.displayName=[disc objectForKey:@"displayName"];
    self.uuid=[disc objectForKey:@"uuid"];
    self.peerId=[disc objectForKey:@"peerId"];
    self.hasConnected=[[disc objectForKey:@"hasConnected"] boolValue];
    self.lastHeartbeatDate=[disc objectForKey:@"lastHeartbeatDate"];
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"displayName:%@,hasConnected:%i,uuid:%@,peerId:%@,last heartbeate date:%@",displayName,hasConnected,uuid,peerId,[UtilHelper formateTime:lastHeartbeatDate]];
}

@end
