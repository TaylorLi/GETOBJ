//
//  LocalRoom.m
//  Chatty
//
//  Copyright (c) 2009 Peter Bakhyryev <peter@byteclub.com>, ByteClub LLC
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import "LocalRoom.h"
#import "Connection.h"
#import "ServerSetting.h"
#import "AppConfig.h"
#import "ServerSetting.h"
#import "GameInfo.h"
// Private properties
//@interface LocalRoom ()
//@property(nonatomic,retain) Server* server;
//@property(nonatomic,retain) NSMutableSet* clients;
//@end

@class ServerSetting;

@implementation LocalRoom

@synthesize server, clients,gameInfo,bluetoothServer;

// Initialization
- (id)init {
    if([AppConfig getInstance].networkUsingWifi)
    {    
        clients = [[NSMutableSet alloc] init];
    }
    return self;
}

- (id)initWithGameInfo:(GameInfo *)info
{
    self=[super init];
    if(self)
        {
            gameInfo=  info;
        }
     return self;
}
// Cleanup
- (void)dealloc {
    self.clients = nil;
    self.server = nil;
    self.gameInfo=nil;
    [self.gameInfo release];
    self.bluetoothServer=nil;
    [super dealloc];
}


// Start the server and announce self
- (BOOL)start{
    if([AppConfig getInstance].networkUsingWifi){
        // Create new instance of the server and start it up
        server = [[Server alloc] init];
        
        // We will be processing server events
        server.delegate = self;
        
        // Try to start it up
        if ( ! [server start] ) {
            self.server = nil;
            return NO;
        }
        [delegate alreadyConnectToServer];
        return YES;
    }else
    {
        bluetoothServer=[[PeerServer alloc] init];
        bluetoothServer.delegate=self;
        bluetoothServer.gkSessionDelegate=self;
        if(![bluetoothServer start:gameInfo.gameSetting]){
            self.bluetoothServer=nil;
            return NO;
        }
        else
            return YES;
    }
}


// Stop everything
- (void)stop {
    // Destroy server
    if([AppConfig getInstance].networkUsingWifi)
    {  
        [server stop];
        self.server = nil;
        
        // Close all connections
        [clients makeObjectsPerformSelector:@selector(close)];
    }
    else{
        [bluetoothServer stop];
        self.bluetoothServer=nil;
    }
}


// Send chat message to all connected clients
- (void)sendCommand:(CommandMsg *) cmdMsg{
    // Display message locally
    //[delegate processCmd:cmdMsg];
    
    // Create network packet to be sent to all clients
    
    // Send it out
    if([AppConfig getInstance].networkUsingWifi)
    {  
        [clients makeObjectsPerformSelector:@selector(sendNetworkPacket:) withObject:cmdMsg];
    }
    else
    {
        
    }
}


#pragma mark -
#pragma mark ServerDelegate Method Implementations

// Server has failed. Stop the world.
- (void) serverFailed:(Server*)server reason:(NSString*)reason {
    // Stop everything and let our delegate know
    [self stop];
    [delegate roomTerminated:self reason:reason];
}


// New client connected to our server. Add it.
- (void) handleNewConnection:(Connection*)connection {
    // Delegate everything to us
    connection.delegate = self;
    
    // Add to our list of clients
    [clients addObject:connection];
}


#pragma mark -
#pragma mark ConnectionDelegate Method Implementations

// We won't be initiating connections, so this is not important
- (void) connectionAttemptFailed:(Connection*)connection {
}


// One of the clients disconnected, remove it from our list
- (void) connectionTerminated:(Connection*)connection {
    [clients removeObject:connection];
}


// One of connected clients sent a chat message. Propagate it further.
- (void) receivedNetworkPacket:(NSDictionary*)packet viaConnection:(Connection*)connection {
    // Display message locally
    CommandMsg *cmd=[[[CommandMsg alloc] initWithDictionary:packet] autorelease];
    [delegate processCmd:cmd];
    
    // Broadcast this message to all connected clients, including the one that sent it
//    [clients makeObjectsPerformSelector:@selector(sendNetworkPacket:) withObject:packet];
}

#pragma mark -
#pragma mark GKSession delegate bluetooth
- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
    NSError *parseError = nil;
    [session acceptConnectionFromPeer:peerID error:&parseError];
    
}




/* Indicates a connection error occurred with a peer, which includes connection request failures, or disconnects due to timeouts.
 */
- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
    
    
}

/* Indicates an error occurred with the session such as failing to make available.
 */
- (void)session:(GKSession *)session didFailWithError:(NSError *)error{
    
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    switch (state)
    {
            
        case GKPeerStateAvailable:
            break;
        case GKPeerStateUnavailable:
            /**
             First time lose a server;
             */
            
            break;
        case GKPeerStateConnected:
            // Record the peerID of the other peer.
            // Inform your game that a peer has connected.
            
            
            /**
             For Peer - Peer mode, you need HERE to check whether the connected peers count reaches expected player count,
             then to initialize the game.
             */            
            
           //client has connected
            
            break;
        case GKPeerStateDisconnected:
            
            break;
        default:
            break;
    }       
    
}


- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    //NSDictionary* packet = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
    NSMutableDictionary* packet =[[[[SBJsonParser alloc] init] objectWithData:data] autorelease];
    CommandMsg *cmd=[[[CommandMsg alloc] initWithDictionary:packet] autorelease];
    [delegate processCmd:cmd];
    //NSLog([NSString stringWithUTF8String:(const char*)[data bytes]]);
    
}

@end
