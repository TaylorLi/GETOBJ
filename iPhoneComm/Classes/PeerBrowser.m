//
//  PeerBrowser.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/16.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "Definition.h"
#import "ServerBrowserDelegate.h"
#import "PeerBrowser.h"
#import "ServerRelateInfo.h"
#import "AppConfig.h"

// Private properties and methods
@interface PeerBrowser ()

// Sort services alphabetically
- (void)sortServers;

@end

@implementation PeerBrowser

@synthesize servers;
@synthesize delegate;
@synthesize schSession;

// Initialize
- (id)init {
    self=[super init];
    return self;
}


// Cleanup
- (void)dealloc {
    if ( servers != nil ) {
        servers = nil;
    }
    peerIds=nil;
}


// Start browsing for servers
- (BOOL)start {
    // Restarting?
    if ( schSession != nil ) {
        [self stop];
    }
    if(servers!=nil)
        servers=nil;
    if (peerIds!=nil) {
        peerIds=nil;
    }
    servers = [[NSMutableArray alloc] init];
    peerIds=[[NSMutableArray alloc] init];
    //NSString *uid = [[UIDevice currentDevice] uniqueIdentifier];
    schPeerId=[NSString stringWithFormat:@"%@_%@",KEY_PEER_SEVICE_TYPE_SEARCH,[AppConfig getInstance].name];
	schSession = [[GKSession alloc] initWithSessionID:KEY_PEER_SESSION_ID 
                                          displayName:schPeerId
                                          sessionMode: GKSessionModeClient ];
	NSLog(@"Browser Peer Start:%@,Desc:%@",schSession.peerID,schPeerId);
    if( !schSession ) {
		return NO;
	}
    //[schSession setDataReceiveHandler:self withContext:nil];
    schSession.delegate = self;
    schSession.available = YES;
    return YES;
}

-(void)restartBrowser{
    [self start];
    [delegate updateServerList];
}
// Terminate current service browser and clean up
- (void)stop {
    if ( schSession == nil ) {
        return;
    }
    //[schSession disconnectFromAllPeers];
    schSession.available = NO;
    schSession = nil;
    peerIds=nil;
    servers=nil;
}


// Sort servers array by service names
- (void)sortServers {
    //[servers sortUsingSelector:@selector(compare:)];
}

#pragma GKSession Delagate

- (void)session:(GKSession *)session didFailWithError:(NSError *)error{
    NSLog(@"Server Browser %@ didFailWithError:%@",session.displayName,error);
}
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    NSLog(@"Browser receive peer(%@) State change:%i",[session displayNameForPeer:peerID],state);
    switch (state)
    {
            
        case GKPeerStateAvailable:           
            if (![peerIds containsObject:peerID] &&[[session displayNameForPeer:peerID] hasPrefix:KEY_PEER_SEVICE_TYPE_SERVER] ) {
                // Add it to our list
                ServerRelateInfo *sri=[[ServerRelateInfo alloc] init];
                sri.orgSeverName=[session displayNameForPeer:peerID];
                NSLog(@"Found Server PeerID:%@,DisplayName:%@",peerID,sri.orgSeverName);
                sri.peerId=peerID;
                sri.sessionId=session.sessionID;
                NSArray *servInfo = [sri.orgSeverName componentsSeparatedByString:@"||"]; 
                if (servInfo.count!=3) {
                    return;
                }
                //sri.uuid=[servInfo objectAtIndex:1];
                sri.displaySeverName=[[servInfo objectAtIndex:1] stringByReplacingOccurrencesOfString:@"_" withString:@" "];
                sri.password=[servInfo objectAtIndex:2];
                [servers addObject:sri];
                [peerIds addObject:sri.peerId];
                
                
                
                // Sort alphabetically and let our delegate know
                [self sortServers];
                [delegate updateServerList];
            }
            break;
        case GKPeerStateUnavailable:   
            for (ServerRelateInfo *sri in servers) {
                if([sri.peerId isEqualToString:peerID])
                {
                    for (int i=0;i<servers.count;i++) {
                        ServerRelateInfo *si=[servers objectAtIndex:i];
                        if(si.peerId==peerID){
                            [servers removeObjectAtIndex:i];
                            break;
                        }
                    }
                    [peerIds removeObject:peerID];
                    [self sortServers];
                    [delegate updateServerList];
                    break;
                }
            }
            break;
        case GKPeerStateConnected:                        
            break;
        case GKPeerStateDisconnected:   
            break;
        default:
            break;
    }       
    
}

@end
