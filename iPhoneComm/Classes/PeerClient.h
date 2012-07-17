//
//  PeerClient.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/15.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "SBJson.h"

@interface PeerClient : NSObject
{
}
@property (nonatomic,retain) id gkSessionDelegate;
@property (nonatomic,retain) GKSession *gameSession;
@property (nonatomic,retain) NSString *serverPeerId;

-(id) initWithPeerId:(NSString *)peerId;
- (BOOL)start:(NSString *)playerName andTimeout:(NSTimeInterval) timeout;
- (void)stop;
- (void)sendNetworkPacket:(id)data;

@end
