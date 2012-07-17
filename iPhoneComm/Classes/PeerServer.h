//
//  PeerUtil.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/15.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "PeerServerDelegate.h"

@class ServerSetting;

@interface PeerServer : NSObject
{
    GKSession *serverSession;
    id<PeerServerDelegate> delegate;
    id gkSessionDelegate;
}

@property (nonatomic,retain) id<PeerServerDelegate> delegate;
@property NSInteger requiredClientCount;
@property (nonatomic,retain) ServerSetting *svcSetting;
@property (nonatomic,retain) id<GKSessionDelegate> gkSessionDelegate;
@property (nonatomic,retain) GKSession *serverSession;
- (BOOL)start:(ServerSetting *) setting;
- (void)stop;

@end
