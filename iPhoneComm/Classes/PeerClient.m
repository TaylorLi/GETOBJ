//
//  PeerClient.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/15.
//  Copyright (c) 2012年 GET. All rights reserved.
//
#import "Definition.h"
#import "PeerClient.h"

@implementation PeerClient

#pragma mark -
#pragma mark property

@synthesize gkSessionDelegate;
@synthesize gameSession;
@synthesize serverPeerId;

#pragma mark -
#pragma mark construction
-(id) initWithPeerId:(NSString *)peerId{
    if(!(self = [super init]))
    {
        return nil;
    }
    serverPeerId=peerId;
    return self;
}
-(void)dealloc{
    gameSession=nil;
    serverPeerId=nil;
}

#pragma mark -
#pragma mark Public Function
- (BOOL)start:(NSString *)playerName andTimeout:(NSTimeInterval) timeout
{
    // Restarting?
    if ( gameSession != nil ) {
        [self stop];
    }
    
    /*
     [NSString stringWithFormat:@"%@%@||%@||%@",KEY_PEER_SERVER_PREFIX,uid,
     svcSetting.gameName,svcSetting.password]
     */
    //NSString *uid = [[UIDevice currentDevice] uniqueIdentifier];
    NSString *displayName=[NSString stringWithFormat:@"%@||%@",KEY_PEER_SEVICE_TYPE_CLIENT,playerName];
	gameSession = [[GKSession alloc] initWithSessionID:KEY_PEER_SESSION_ID 
                                           displayName:displayName
                                           sessionMode: GKSessionModePeer ];
	if( !gameSession ) {
        return NO;
	}
    
    gameSession.delegate = self.gkSessionDelegate;
    [gameSession setDataReceiveHandler:gkSessionDelegate withContext:nil];
    gameSession.available = YES;
    NSLog(@"New Client %@ prepare connect to %@",gameSession.peerID, serverPeerId);
    //delay to find the server first
    return YES;
}

-(void)stop;
{
    gameSession.available = NO;
    [gameSession disconnectFromAllPeers];
    gameSession=nil;
}

// Send network message,json object
- (void)sendNetworkPacket:(id)packet {
    
    // Encode packet
    NSData* rawPacket=  [[[[SBJsonWriter alloc] init] dataWithObject:packet] autorelease];
    //NSDictionary packet;
    //NSData* rawPacket = [NSKeyedArchiver archivedDataWithRootObject:packet];
    
    // Write header: lengh of raw packet
    NSArray *peerIds=[[NSArray alloc] initWithObjects:serverPeerId, nil];
    [gameSession sendData:rawPacket toPeers:peerIds withDataMode:GKSendDataReliable error:nil];
}

@end
