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
	NETWORK_ACK = 0,					// no packet
	NETWORK_HEARTBEAT=1,				// send of entire state at regular intervals
    NETWORK_REPORT_SCORE=2,            //score send to server
    NETWORK_CLIENT_INFO=3,            //report client info
    NETWORK_SERVER_STATUS=4,          //server status
    NETWORK_SERVER_WHOLE_INFO=5,      //whole info of server
    NETWORK_NEED_REPORT_SELF=6,       //when receive this message,send self info
    NETWORK_INVALID_CLIENT=7,         //client password or uuid invalid
} PacketCodes;

typedef enum {
    kStatePrepareGame=0,//wait for prepare the game and other judges
	kStateWaitJudge=1,//wait for judge
	kStateRunning=2,//game has run now
    kStateCalcScore=3,//wait other juge to send score and calc result score
    
	//用比赛属性playerReconnect代替，这样可以避免改变服务器的状态
    kStateMultiplayerReconnect=4,//judge has lost
    kStateRoundReset=5,//round rest
    kStateGamePause=6,//game stop
    kStateGameEnd=7,//game has complete
    kStateGameExit=8,//game exit
} GameStates;

typedef enum{
    kSideBlue=0, //blue
    kSideRed=1, //red
    kSideBoth=2, //both
}SwipeType;

//defined command type

//test last heartbeat time span
//loop for event interval
//#define  kHeartbeatTimeInterval  0.12

//服务器消息循环的时间间隔，主要在与检测分数提交后是否有效的判断
#define kServerLoopInterval 0.1
//服务器检测客户端连接状态的时间间隔
#define kServerTestClientHearbeatTime 4
#define kServerHeartbeatTimeInterval 0.4

//客户端发送心跳信息的间隔
#define kClientHeartbeatTimeInterval 0.4
//客户端检测服务器连接状态的时间间隔
#define kClientTestServerHearbeatTime 4
#define kClientTestServerHearbeatTimeWhenPause 6
//用户滑动分数板的时间间隔，在此时间间隔内可多次滑动，超过此时间间隔则发送信息
#define kClientLoopInterval4Swipe 0.5
//处于哪种角色中
typedef enum{
    AppStepStart=0,
    AppStepServerBrowser=1,
    AppStepServer=2,
    AppStepClient=3,
    
} AppStep;

@interface Definition : NSObject

@end
