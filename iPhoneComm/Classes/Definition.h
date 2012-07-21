//
//  Definition.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/16.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_PEER_SESSION_ID @"TKD Score"
#define KEY_PEER_SEVICE_TYPE_CLIENT @"C"
#define KEY_PEER_SEVICE_TYPE_SEARCH @"B"
#define KEY_PEER_SEVICE_TYPE_SERVER @"S"

typedef enum {
	NETWORK_ACK,					// no packet
	NETWORK_HEARTBEAT,				// send of entire state at regular intervals
    NETWORK_REPORT_SCORE,            //score send to server
    NETWORK_CLIENT_INFO,            //report client info
} PacketCodes;

typedef enum {
    kStatePrepareGame,//wait for prepare the game and other judges
	kStateWaitJudge,//wait for judge
	kStateRunning,//game has run now
    kStateCalcScore,//wait other juge to send score and calc result score
	kStateMultiplayerReconnect,//judge has lost
    kStateGamePause,//game stop
    kStateGameEnd,//game has complete
} GameStates;

//defined command type

#define kSideBlue @"blue"
#define kSideRed @"red"

@interface Definition : NSObject

@end
