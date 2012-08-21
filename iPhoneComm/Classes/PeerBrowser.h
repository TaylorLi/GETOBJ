//
//  PeerBrowser.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/16.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>


@class ServerBrowserDelegate;

@interface PeerBrowser: NSObject <GKSessionDelegate>
{
    //arry of SeverRelateInfo
    NSMutableArray *servers;
    NSMutableArray *peerIds;
    id<ServerBrowserDelegate> delegate;
    NSString *schPeerId;
}

@property(nonatomic,readonly) NSMutableArray* servers;
@property(nonatomic,strong) id<ServerBrowserDelegate> delegate;
@property(nonatomic,strong)GKSession *schSession;

// Start browsing for bluetooth
- (BOOL)start;

// Stop everything
- (void)stop;

-(void)restartBrowser;

@end
