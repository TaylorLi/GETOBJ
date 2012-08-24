//
//  ServerSetting.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/14.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "ServerSetting.h"
#import "AppConfig.h"

@implementation ServerSetting

@synthesize redSideDesc;
@synthesize redSideName;
@synthesize blueSideDesc;
@synthesize blueSideName;
@synthesize gameDesc;
@synthesize gameName;
@synthesize password;
@synthesize roundTime;
@synthesize restTime;
@synthesize roundCount;
@synthesize judgeCount;
@synthesize pointGap,serverName,screeningArea,skipScreening,enableGapScore,startScreening,pointGapAvailRound,availScoreWithJudesCount,availTimeDuringScoreCalc,maxWarningCount,restAndReorganizationTime,serverLoopMaxDelay;

-(NSString *)description
{
    return [NSString stringWithFormat:@"Name:%@,Desc:%@,Pwd:%@,Time:%f,Round:%i,Red Name:%@,Red Desc:%@,Blue Name:%@,Blue Desc:%@",gameName,gameDesc,password,roundTime,roundCount, redSideName,redSideDesc,blueSideName,blueSideDesc];
}

-(id) initWithDefault
{
    self=[super init];
      if (self) {   
          [self reset];
    }
    return self;
}
-(void) reset
{
    gameDesc=@"Men 80KG Welter";
    gameName=@"China South Korea match";
    redSideDesc=@"";
    redSideName=@"PLAYER RED";
    blueSideDesc=@"";
    blueSideName=@"PLAYER BLUE";
    password=nil;
    roundCount=3;
    roundTime=2*60;
    restTime=30;
    pointGap=12;
    serverName=[AppConfig getInstance].name;
    screeningArea=@"A";
    skipScreening=1;
    enableGapScore=YES;
    startScreening=1;
    pointGapAvailRound=2;
    judgeCount=4;
    availScoreWithJudesCount=3;
    availTimeDuringScoreCalc=1;
    maxWarningCount=8;
    restAndReorganizationTime=60;
    serverLoopMaxDelay = 1;
}
-(id) initWithGameName:(NSString *)_gameName andGameDesc:(NSString *)_gameDesc
        andRedSideName:(NSString *)_redSideName andRedSideDesc:(NSString *)_redSideDesc andBlueSideName:(NSString *)_blueSideName andBlueSideDesc:(NSString *)_blueSideDesc andPassword:(NSString *)_password andRoundCount:(NSInteger)_roundCount andRoundTime:(NSTimeInterval)_roundTime andRestTime:(NSTimeInterval) _restTime
{
    self=[self initWithDefault];
    if (self) {   
        gameDesc=_gameDesc;
        gameName=_gameName;
        redSideDesc=_redSideDesc;
        redSideName=_redSideName;
        blueSideDesc=_blueSideDesc;
        blueSideName=_blueSideName;
        password=_password;
        roundCount=_roundCount;
        roundTime=_roundTime;
        restTime=_restTime;
    }
    return self;
}

-(id) copyWithZone:(NSZone *)zone
{
    ServerSetting *copyObj=[[ServerSetting allocWithZone:zone] init];
    copyObj.gameDesc=[self.gameDesc copyWithZone:zone];
    copyObj.gameName=[self.gameName copyWithZone:zone];
    copyObj.redSideDesc=[self.redSideDesc copyWithZone:zone];
    copyObj.redSideName=[self.redSideName copyWithZone:zone];
    copyObj.blueSideDesc=[self.blueSideDesc copyWithZone:zone];
    copyObj.blueSideName=[self.blueSideName copyWithZone:zone];
    copyObj.password=[self.password copyWithZone:zone];
    copyObj.roundCount=self.roundCount;
    copyObj.roundTime=self.roundTime;  
    copyObj.restTime=self.restTime;
    copyObj.pointGap=self.pointGap;
    copyObj.serverName=self.serverName;
    copyObj.screeningArea=[self.screeningArea copyWithZone:zone];
    copyObj.skipScreening=self.skipScreening;
    copyObj.enableGapScore=self.enableGapScore;
    copyObj.startScreening=self.startScreening;
    copyObj.pointGapAvailRound=self.pointGapAvailRound;
    copyObj.judgeCount=self.judgeCount;
    copyObj.availScoreWithJudesCount=self.availScoreWithJudesCount;
    copyObj.availTimeDuringScoreCalc=self.availTimeDuringScoreCalc;
    copyObj.maxWarningCount=self.maxWarningCount;
    copyObj.restAndReorganizationTime=self.restAndReorganizationTime;
    return copyObj;
}
-(void)dealloc
{

}
@end

