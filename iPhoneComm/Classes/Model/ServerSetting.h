//
//  ServerSetting.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/14.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kroundCount 0
#define kroundTime 1
#define krestTime 2
#define kpointGap 3
#define kserverName 4
#define kscreeningArea 5
#define kskipScreening 6
#define kenableTopScore 7
#define kstartScreening 8
#define kpointGapAvailRound 9
#define kjudgeCount 10
#define kavailScoreWithJudesCount 11
#define kavailTimeDuringScoreCalc 12
#define krestAndReOrgTime 13
#define kmaxWarmningCount 14
#define kgameName 15
#define kgameDesc 16
#define kredSideName 17
#define kredSideDesc 18
#define kblueSideName 19
#define kblueSideDesc 20
#define kpassword 21
#define kCurrentTime 22
#define kServerRefresh 23
#define kDeviceType 24
#define kProfileName 25
#define kFightTime 26

@interface ServerSetting : NSObjectSerialization<NSCopying,SqliteORMDelegate>
{
    NSString *gameName;
    NSString *gameDesc;
    NSString *redSideName;
    NSString *redSideDesc;
    NSString *blueSideName;
    NSString *blueSideDesc;
    NSString *password;
    NSTimeInterval roundTime;
    NSTimeInterval restTime;
    NSInteger roundCount;
    NSInteger judgeCount;
}
//比赛名称
@property (nonatomic,copy) NSString *gameName;
//比赛备注
@property (nonatomic,copy) NSString *gameDesc;
//红方名称
@property (nonatomic,copy) NSString *redSideName;
//红方描述
@property (nonatomic,copy) NSString *redSideDesc;
//蓝方名称
@property (nonatomic,copy) NSString *blueSideName;
//蓝方描述
@property (nonatomic,copy) NSString *blueSideDesc;
//服务器加入密码
@property (nonatomic,copy) NSString *password;
//回合数
@property NSInteger roundCount;
//回合时间
@property NSTimeInterval roundTime;
//休息时间
@property NSTimeInterval restTime;
//裁判数量
@property NSInteger judgeCount;
//场区
@property (nonatomic,copy) NSString *screeningArea;
//开始场次
@property NSInteger startScreening;
//跳场
@property NSInteger skipScreening;
//判分标准,多少个副裁判评分分数有效
@property NSInteger availScoreWithJudgesCount;
//得分计算缓冲时间
@property NSTimeInterval availTimeDuringScoreCalc;
//此时间范围内计算客户端发送的分数
@property NSTimeInterval serverLoopMaxDelay;
//是否计算得分差距分数
@property BOOL enableGapScore;
//得分差距在多少分即算比赛结束
@property NSInteger pointGap;
//得分差距在哪个回合开始计算
@property NSInteger pointGapAvailRound;
//服务器名称
@property (nonatomic,copy) NSString *serverName;
//最大警告数
@property NSInteger maxWarningCount;
//暂停并整理时间
@property NSTimeInterval restAndReorganizationTime;
//客户端使用的设备类型
@property (nonatomic) JudgeDevice currentJudgeDevice;
@property (nonatomic,copy) NSString *profileName;
@property (nonatomic,strong) NSDate *createDate;
@property BOOL isDefaultProfile;
@property (nonatomic,strong) NSString *uuid;
@property (nonatomic,strong) NSString *settingId;
@property (nonatomic,strong) NSString *gameId;
@property  GameSettingType settingType;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSDate *lastUsingDate;
@property (nonatomic,strong) NSString *profileId;
@property (nonatomic) NSTimeInterval fightTimeInterval;

-(id) initWithDefault;
-(id) initWithGameName:(NSString *)_gameName andGameDesc:(NSString *)_gameDesc
        andRedSideName:(NSString *)_redSideName andRedSideDesc:(NSString *)_redSideDesc andBlueSideName:(NSString *)_blueSideName andBlueSideDesc:(NSString *)_blueSideDesc andPassword:(NSString *)_password andRoundCount:(NSInteger)_roundCount andRoundTime:(NSTimeInterval)_roundTime andRestTime:(NSTimeInterval) _restTime;
-(void) reset;
-(void) renewSettingForGame;
@end
