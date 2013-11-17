//
//  PeerServerDelegate.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/17.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PeerServer;

@protocol PeerServerDelegate <NSObject>

// Server has been terminated because of an error
- (void) serverFailed:(PeerServer*)server reason:(NSString*)reason;

// Server has accepted a new connection and it needs to be processed
- (void) handleNewConnection:(NSString*)peerId;

@end
