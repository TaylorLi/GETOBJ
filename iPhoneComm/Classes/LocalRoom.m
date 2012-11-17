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
#import "JudgeClientInfo.h"
#import "GameInfo.h"

// Private properties
//@interface LocalRoom ()
//@property(nonatomic,retain) Server* server;
//@property(nonatomic,retain) NSMutableSet* clients;
//@end

@class ServerSetting;

@implementation LocalRoom

@synthesize server, clients,gameInfo,bluetoothServer,isRestoredGame;

// Initialization
- (id)init {
    self=[super init];
    if([AppConfig getInstance].networkUsingWifi)
    {    
        clients = [[NSMutableSet alloc] init];
    }
    isRestoredGame = NO;
    return self;
}

- (id)initWithGameInfo:(GameInfo *)info
{
    self=[super init];
    if(self)
    {
        gameInfo=  info;
        isRestoredGame = NO;
    }
    return self;
}
// Cleanup
- (void)dealloc {
    self.gameInfo=nil;
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
        if(gameInfo.gameSetting.currentJudgeDevice==JudgeDeviceiPhone)            
            return [self startBluetoothServer];
        else
            return YES;
    }
}

-(BOOL) startBluetoothServer
{
    if(bluetoothServer!=nil){
        [self stop];
    }
    bluetoothServer=[[PeerServer alloc] init];        
    gameInfo.serverUuid=[AppConfig getInstance].uuid;
    bluetoothServer.delegate=self;
    bluetoothServer.gkSessionDelegate=self;
    if(![bluetoothServer start:gameInfo.gameSetting]){
        self.bluetoothServer=nil;
        return NO;
    }
    else{
        gameInfo.serverPeerId=bluetoothServer.serverSession.peerID;
        gameInfo.serverFullName=bluetoothServer.serverFullName;
        return YES;
    } 
}

-(BOOL) testUnavailableAndRestart
{
    if(bluetoothServer==nil||bluetoothServer==nil||bluetoothServer.serverSession==nil||
       !bluetoothServer.serverSession.available){
        [bluetoothServer stop];
        bluetoothServer=nil;
        return [self startBluetoothServer];
    }
    else{
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
        if(gameInfo.gameSetting.currentJudgeDevice==JudgeDeviceiPhone)   
        {
            [bluetoothServer stop];
            self.bluetoothServer=nil;
        }
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
        if(gameInfo.gameSetting.currentJudgeDevice==JudgeDeviceiPhone)   {
            if([bluetoothServer.serverSession peersWithConnectionState:GKPeerStateConnected].count==0)
                return;
            SBJsonWriter *wr=[[SBJsonWriter alloc] init];
            NSLog(@"Server %@ Send client Command:%@",[bluetoothServer.serverSession displayName],[wr stringWithObject:cmdMsg]);
            NSData *data=[wr dataWithObject:cmdMsg];
            if(wr.error!=nil)
            {
                NSLog(@"JSON Serialize error:obj:%@,detail:%@",wr.error,cmdMsg.description);
            }
            else
            {
                [bluetoothServer.serverSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
            }
        }
    }
}
- (void)sendCommand:(CommandMsg *) cmdMsg andPeerId:(NSString *)peerId andSendDataReliable:(BOOL)reliable{
    if([AppConfig getInstance].networkUsingWifi)
    {
        [clients makeObjectsPerformSelector:@selector(sendNetworkPacket:) withObject:cmdMsg];
    }
    else{
        if([bluetoothServer.serverSession peersWithConnectionState:GKPeerStateConnected].count>0)
        {
            if(gameInfo.gameSetting.currentJudgeDevice==JudgeDeviceiPhone)   {
                SBJsonWriter *wr=[[SBJsonWriter alloc] init];
                NSData *data=[wr dataWithObject:cmdMsg];
                //NSLog(@"JSON Serilize:%@",[wr stringWithObject:cmdMsg]);
                if(wr.error!=nil)
                {
                    NSLog(@"JSON Serialize error:obj:%@,detail:%@",wr.error,cmdMsg.description);
                }
                else{
                    NSError *error;
                    //NSLog(@"Server %@ Send client Command:%@",[bluetoothServer.serverSession displayName],[wr stringWithObject:cmdMsg]);
                    if (peerId!=nil&&![peerId isEqualToString:@""]) {
                        [bluetoothServer.serverSession sendData:data toPeers:
                         [NSArray arrayWithObject:peerId] withDataMode:reliable?GKSendDataReliable:GKSendDataUnreliable error:&error];
                    }
                    else{
                        [bluetoothServer.serverSession sendDataToAllPeers:data withDataMode:reliable?GKSendDataReliable:GKSendDataUnreliable error:&error];
                    } 
                    if(error!=nil)
                        NSLog(@"Send cmd to client error:%@",error);
                }
            }
        }
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
    CommandMsg *cmd=[[CommandMsg alloc] initWithDictionary:packet];
    [delegate processCmd:cmd];
    
    // Broadcast this message to all connected clients, including the one that sent it
    //    [clients makeObjectsPerformSelector:@selector(sendNetworkPacket:) withObject:packet];
}

#pragma mark -
#pragma mark GKSession delegate bluetooth
- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{
    NSError *parseError = nil;
    //    if([gameInfo allClientsReady]){
    //        [session disconnectPeerFromAllPeers:peerID];
    //    }else{
    [session acceptConnectionFromPeer:peerID error:&parseError];
    
    //    }
    //    int connectedNum=0;
    //    for (JudgeClientInfo *clt in gameInfo.clients.allValues) {
    //        if(clt.hasConnected){
    //            connectedNum++;
    //        }
    //    }
    //    if(connectedNum<gameInfo.needClientsCount){    
    //    }else{
    //        [session denyConnectionFromPeer:peerID];
    //    }
    
}




/* Indicates a connection error occurred with a peer, which includes connection request failures, or disconnects due to timeouts.
 */
- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
    NSLog(@"Local room(Server) connectionWithPeerFailed:%@",error);
    for (JudgeClientInfo *clt in gameInfo.clients.allValues) {
        if(clt.peerId==peerID){
            clt.hasConnected=NO;
        }
    }
    
}

/* Indicates an error occurred with the session such as failing to make available.
 */
- (void)session:(GKSession *)session didFailWithError:(NSError *)error{
    NSLog(@"Local room(Server) didFailWithError:%@",error);
    [self testUnavailableAndRestart];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    NSLog(@"Server receive peer %@(%@) State change:%i",peerID,[session displayNameForPeer:peerID],state);
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
    //NSLog([NSString stringWithUTF8String:(const char*)[data bytes]]);
    SBJsonParser *parser= [[SBJsonParser alloc] init];    
    NSMutableDictionary* packet =[parser objectWithData:data];
    if(parser.error!=nil)
    {
        NSLog(@"JSON Deserilize error:%@",parser.error);
    }
    else{
        
        CommandMsg *cmd=[[CommandMsg alloc] initWithDictionary:packet];
        [delegate processCmd:cmd];
    }
    
    
}

@end
