//
//  ServerSetting.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/14.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "ServerSetting.h"

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

-(NSString *)description
{
    return [NSString stringWithFormat:@"Name:%@,Desc:%@,Pwd:%@,Time:%f,Round:%i,Red Name:%@,Red Desc:%@,Blue Name:%@,Blue Desc:%@",gameName,gameDesc,password,roundTime,roundCount, redSideName,redSideDesc,blueSideName,blueSideDesc];
}

-(id) initWithDefault
{
    self=[super init];
      if (self) {   
          gameDesc=@"Men 80KG Welter";
          gameName=@"China South Korea match";
          redSideDesc=@"CN";
          redSideName=@"Wu Kong Sun";
          blueSideDesc=@"KR";
          blueSideName=@"Aks Kim";
          password=nil;
          roundCount=3;
          roundTime=1*2;
          restTime=3;
    }
    return self;
}
-(id) initWithGameName:(NSString *)_gameName andGameDesc:(NSString *)_gameDesc
        andRedSideName:(NSString *)_redSideName andRedSideDesc:(NSString *)_redSideDesc andBlueSideName:(NSString *)_blueSideName andBlueSideDesc:(NSString *)_blueSideDesc andPassword:(NSString *)_password andRoundCount:(NSInteger)_roundCount andRoundTime:(NSTimeInterval)_roundTime andRestTime:(NSTimeInterval) _restTime
{
    self=[super init];
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
    return copyObj;
}
-(void)dealloc
{
    gameDesc=nil;
    gameName=nil;
    redSideDesc=nil;;
    redSideName=nil;;
    blueSideDesc=nil;;
    blueSideName=nil;;
    password=nil;;
}
@end

