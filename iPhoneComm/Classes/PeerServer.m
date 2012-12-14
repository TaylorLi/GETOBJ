//
//  PeerUtil.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/15.
//  Copyright (c) 2012年 GET. All rights reserved.
//
#import "Definition.h"
#import "PeerServer.h"
#import "ServerSetting.h"
#import "AppConfig.h"
@implementation PeerServer
#pragma mark -
#pragma mark property

@synthesize requiredClientCount;
@synthesize svcSetting;
@synthesize delegate;
@synthesize gkSessionDelegate;
@synthesize serverSession,serverFullName;

#pragma mark -
#pragma mark construction
-(id) init{
    if(!(self = [super init]))
    {
        return nil;
    }
    self.requiredClientCount=0;
    return self;
}

#pragma mark -
#pragma mark Public Function
- (BOOL)start:(ServerSetting *) setting
{
    svcSetting=setting;
    // Restarting?
    if ( serverSession != nil ) {
        [self stop];
    }
    NSLog(@"%@",svcSetting.gameName);
    /*
     [NSString stringWithFormat:@"%@%@||%@||%@",KEY_PEER_SERVER_PREFIX,uid,
     svcSetting.gameName,svcSetting.password]
     */
    //NSString *uid = [[UIDevice currentDevice] uniqueIdentifier];
    NSString *displayName=[NSString stringWithFormat:@"%@||%@||%@",KEY_PEER_SEVICE_TYPE_SERVER,[svcSetting.serverName stringByReplacingOccurrencesOfString:@" " withString:@"_"],svcSetting.password==nil?@"":svcSetting.password];
	serverSession = [[GKSession alloc] initWithSessionID:KEY_PEER_SESSION_ID 
                                             displayName:displayName
                                            sessionMode: GKSessionModePeer ];
	if( !serverSession ) {
		[delegate serverFailed:self reason:@"Failed to publish service via Bluetooth (duplicate server name?)"];
        return NO;
	}    
    serverSession.delegate = gkSessionDelegate;
    serverSession.available = YES;
    [serverSession setDataReceiveHandler:gkSessionDelegate withContext:nil];
    NSLog(@"New Server Start:%@,Desc:%@",serverSession.peerID,displayName);
    serverFullName=displayName;
    
    return YES;
}

-(void)stop;
{
    serverSession.available = NO;
    [serverSession disconnectFromAllPeers];
    [serverSession setDataReceiveHandler: nil withContext: nil];
    serverSession=nil;
    svcSetting=nil;
}
@end
