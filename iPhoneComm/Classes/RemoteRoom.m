//
//  RemoteRoom.m
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

#import "RemoteRoom.h"
#import "AppConfig.h"

// Private properties
@interface RemoteRoom ()
@property(nonatomic,strong) Connection* connection;
@end


@implementation RemoteRoom

@synthesize connection,clientInfo,serverInfo,bluetoothClient;

// Setup connection but don't connect yet
- (id)initWithHost:(NSString*)host andPort:(int)port {
    connection = [[Connection alloc] initWithHostAddress:host andPort:port];
    return self;
}


// Initialize and connect to a net service
- (id)initWithNetService:(NSNetService*)netService {
    connection = [[Connection alloc] initWithNetService:netService];
    return self;
}
-(id)initWithPeerId:(NSString *)serverPeerId{
    bluetoothClient=[[PeerClient alloc] initWithPeerId:serverPeerId];    
    return self;
}

// Cleanup


// Start everything up, connect to server
- (BOOL)start {
    isRunning=YES;
    if([AppConfig getInstance].networkUsingWifi)
    {
        if ( connection == nil ) {
            return NO;
        }
        
        // We are the delegate
        connection.delegate = self;
        
        BOOL success= [connection connect];
        if(success)
        {[delegate alreadyConnectToServer];
            return YES;
        }
        else{
            [delegate failureToConnectToServer];
            return NO;
        }
    }else{
        if ( bluetoothClient == nil ) {
            return NO;
        }        
        bluetoothClient.gkSessionDelegate=self;
        [bluetoothClient start:[AppConfig getInstance].name  andTimeout:[AppConfig getInstance].timeout];
        NSString *uid = [AppConfig getInstance].uuid;
        clientInfo =[[JudgeClientInfo alloc] initWithSessionId:nil andDisplayName:[AppConfig getInstance].name andUuid:uid andPeerId:bluetoothClient.gameSession.peerID];
        return YES;
    }
}
-(BOOL) restart
{
    isRunning=YES;
        if(bluetoothClient!=nil){
            [bluetoothClient stop];             
        }
        bluetoothClient=[[PeerClient alloc] initWithPeerId:serverInfo.serverPeerId];
        bluetoothClient.gkSessionDelegate=self;
        [bluetoothClient start:[AppConfig getInstance].name  andTimeout:[AppConfig getInstance].timeout];
        NSString *uid = [AppConfig getInstance].uuid;
        clientInfo =[[JudgeClientInfo alloc] initWithSessionId:nil andDisplayName:clientInfo.displayName andUuid:uid andPeerId:bluetoothClient.gameSession.peerID];
        return YES;
}

// Stop everything, disconnect from server
- (void)stop {
    isRunning=NO;
    if ( connection == nil ) {
        return;
    }
    
    [connection close];
    self.connection = nil;
}


// Send chat message to the server
- (void)sendCommand:(CommandMsg *) cmdMsg {
    // Create network packet to be sent to all clients
    // Send it out
    if([AppConfig getInstance].networkUsingWifi)
    {
        [connection sendNetworkPacket:cmdMsg];
    }
    else{
        [bluetoothClient sendNetworkPacket:cmdMsg];
    }
}
- (void)sendCommand:(CommandMsg *) cmdMsg andPeerId:(NSString *)peerId andSendDataReliable:(BOOL)reliable{
    if([AppConfig getInstance].networkUsingWifi)
    {
        [connection sendNetworkPacket:cmdMsg];
    }
    else{
        [bluetoothClient sendNetworkPacket:cmdMsg];
    }
}

#pragma mark -
#pragma mark ConnectionDelegate Method Implementations

- (void)connectionAttemptFailed:(Connection*)connection {
    //[delegate roomTerminated:self reason:@"Wasn't able to connect to server"];
}


- (void)connectionTerminated:(Connection*)connection {
    [delegate roomTerminated:self reason:@"Connection to server closed"];
}


- (void)receivedNetworkPacket:(NSMutableDictionary*)packet viaConnection:(Connection*)connection {
    // Display message locally
    CommandMsg *cmd=[[CommandMsg alloc] initWithDictionary:packet];
    [delegate processCmd:cmd];
}


#pragma mark GKSession delegate bluetooth
- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID{    
    
}




/* Indicates a connection error occurred with a peer, which includes connection request failures, or disconnects due to timeouts.
 */
- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error{
    if(isRunning){
        [[AppConfig getInstance].invalidServerPeerIds addObject:peerID];
        [delegate failureToConnectToServer];
        isRunning=NO;
    }
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
            if([peerID isEqualToString:bluetoothClient.serverPeerId])
            {
                [bluetoothClient.gameSession connectToPeer:bluetoothClient.serverPeerId withTimeout:[AppConfig getInstance].timeout];
            }
            break;
        case GKPeerStateUnavailable:
            /**
             First time lose a server;
             */
            if(isRunning && [peerID isEqualToString:bluetoothClient.serverPeerId]){  
                [[AppConfig getInstance].invalidServerPeerIds addObject:peerID];
                //[delegate roomTerminated:self reason:@"Server has disconnect"];
            }
            break;
        case GKPeerStateConnected:
            // Record the peerID of the other peer.
            // Inform your game that a peer has connected.
            
            /**
             For Peer - Peer mode, you need HERE to check whether the connected peers count reaches expected player count,
             then to initialize the game.
             */            
            
            if([peerID isEqualToString:bluetoothClient.serverPeerId]){  
                //bluetoothClient.gameSession.available=NO;
                [delegate alreadyConnectToServer];                
            }
            
            break;
        case GKPeerStateDisconnected:
            /*first StateDisconnected,then stateUnavailale,then connectionWithPeerFailed 
             */
            if(isRunning && [peerID isEqualToString:bluetoothClient.serverPeerId]){  
                [[AppConfig getInstance].invalidServerPeerIds addObject:peerID];
                isRunning=NO;
                //self terminate
                [delegate roomTerminated:self reason:@"Server has disconnect"];
            }
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

-(BOOL) isConnected
{
    if(bluetoothClient==nil)
        {
            return NO;    
        }
    else{
        return [bluetoothClient.gameSession peersWithConnectionState:GKPeerStateConnected].count>0;
    }
}
@end
