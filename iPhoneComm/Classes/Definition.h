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
    kStatePrepareGame=0,//wait for prepare the game and other judges
	kStateWaitJudge=1,//wait for judge
	kStateRunning=2,//game has run now
    kStateCalcScore=3,//wait other juge to send score and calc result score
    
	//用比赛属性playerReconnect代替，这样可以避免改变服务器的状态
    kStateMultiplayerReconnect=4,//judge has lost
    kStateRoundRest=5,//round rest
    kStateGamePause=6,//game stop
    kStateGameEnd=7,//game has complete
    kStateGameExit=8,//game exit
} GameStates;

//defined command type

#define kSideBlue @"blue"
#define kSideRed @"red"

//test last heartbeat time span
#define  kHeartbeatTimeMaxDelay  1.5
//loop for event interval
#define  kHeartbeatTimeInterval  0.12

@interface Definition : NSObject

@end
