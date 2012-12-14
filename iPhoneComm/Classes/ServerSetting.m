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
@synthesize pointGap,serverName,screeningArea,skipScreening,enableGapScore,startScreening,pointGapAvailRound,availScoreWithJudgesCount,availTimeDuringScoreCalc,maxWarningCount,restAndReorganizationTime,serverLoopMaxDelay;
@synthesize currentJudgeDevice,profileName,isDefaultProfile,createDate,uuid,settingId,gameId,settingType,userId,lastUsingDate,profileId;

-(NSString *)description
{
    return [NSString stringWithFormat:@"Setting Id:%@,Game Name:%@,Game Desc:%@,Pwd:%@,Round Time:%f,Rest Time:%f,Round Count:%i,Judge Count:%i, Red Name:%@,Red Desc:%@,Blue Name:%@,Blue Desc:%@,enable Point Gap:%i,pointGapAvailRound:%i",settingId,gameName,gameDesc,password,roundTime,restTime,roundCount,judgeCount, redSideName,redSideDesc,blueSideName,blueSideDesc,enableGapScore,pointGapAvailRound];
}

-(id) initWithDefault
{
    self=[super init];
      if (self) {   
          settingId=[UtilHelper stringWithUUID];
          [self reset];
          createDate=[NSDate date];
    }
    return self;
}
-(void) reset
{
    profileName=@"System Default Profile";
    uuid=[AppConfig getInstance].uuid;
    gameDesc=@"Men 80KG Welter";
    gameName=@"Match";
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
    availScoreWithJudgesCount=3;
    availTimeDuringScoreCalc=1;
    maxWarningCount=8;
    restAndReorganizationTime=60;
    serverLoopMaxDelay = 1;
    currentJudgeDevice= JudgeDeviceKeyboard;
    settingType=SettingTypeProfile; 
    isDefaultProfile=YES;
}
-(void) renewSettingForGame{
    profileId=settingId;
    settingId=[UtilHelper stringWithUUID];
    createDate=[NSDate date];
    settingType=SettingTypeGameRelated;
    isDefaultProfile=NO;
    lastUsingDate=createDate;
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
    copyObj.availScoreWithJudgesCount=self.availScoreWithJudgesCount;
    copyObj.availTimeDuringScoreCalc=self.availTimeDuringScoreCalc;
    copyObj.maxWarningCount=self.maxWarningCount;
    copyObj.restAndReorganizationTime=self.restAndReorganizationTime;
    copyObj.profileName=self.profileName;
    copyObj.isDefaultProfile=self.isDefaultProfile;
    copyObj.uuid=self.uuid;
    return copyObj;
}
/*NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:gameDesc forKey:@"gameDesc"];  
    [aCoder encodeObject:gameName forKey:@"gameName"];  
    [aCoder encodeObject:redSideDesc forKey:@"redSideDesc"];  
    [aCoder encodeObject:redSideName forKey:@"redSideName"];
    [aCoder encodeObject:blueSideDesc forKey:@"blueSideDesc"];  
    [aCoder encodeObject:blueSideName forKey:@"blueSideName"];  
    [aCoder encodeObject:password forKey:@"password"];  
    [aCoder encodeInt:roundCount forKey:@"roundCount"];
    [aCoder encodeDouble:roundTime forKey:@"roundTime"];  
    [aCoder encodeDouble:restTime forKey:@"restTime"];  
    [aCoder encodeInt:pointGap forKey:@"pointGap"];  
    [aCoder encodeObject:serverName forKey:@"serverName"];
    [aCoder encodeObject:screeningArea forKey:@"screeningArea"];  
    [aCoder encodeInt:skipScreening forKey:@"skipScreening"];  
    [aCoder encodeBool:enableGapScore forKey:@"enableGapScore"];  
    [aCoder encodeInt:startScreening forKey:@"startScreening"];
    [aCoder encodeInt:pointGapAvailRound forKey:@"pointGapAvailRound"];  
    [aCoder encodeInt:judgeCount forKey:@"judgeCount"];  
    [aCoder encodeBool:enableGapScore forKey:@"enableGapScore"];  
    [aCoder encodeInt:availScoreWithJudesCount forKey:@"availScoreWithJudesCount"];
    [aCoder encodeDouble:availTimeDuringScoreCalc forKey:@"availTimeDuringScoreCalc"];
    [aCoder encodeInt:maxWarningCount forKey:@"maxWarningCount"];
    [aCoder encodeDouble:restAndReorganizationTime forKey:@"restAndReorganizationTime"];  
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init]) {  
        self.gameDesc=[decoder decodeObjectForKey:@"gameDesc"];
        self.gameName=[decoder decodeObjectForKey:@"gameName"];
        self.redSideDesc=[decoder decodeObjectForKey:@"redSideDesc"];
        self.redSideName=[decoder decodeObjectForKey:@"redSideName"];
        self.blueSideDesc=[decoder decodeObjectForKey:@"blueSideDesc"];
        self.blueSideName=[decoder decodeObjectForKey:@"blueSideName"];
        self.password=[decoder decodeObjectForKey:@"password"];
        self.roundCount=[decoder decodeInt32ForKey:@"roundCount"];
        self.roundTime=[decoder decodeDoubleForKey:@"roundTime"];  
        self.restTime=[decoder decodeDoubleForKey:@"restTime"];
        self.pointGap=[decoder decodeInt32ForKey:@"pointGap"];
        self.serverName=[decoder decodeObjectForKey:@"serverName"];
        self.screeningArea=[decoder decodeObjectForKey:@"screeningArea"];
        self.skipScreening=[decoder decodeInt32ForKey:@"skipScreening"]                         ;
        self.enableGapScore=[decoder decodeBoolForKey:@"enableGapScore"];
        self.startScreening=[decoder decodeInt32ForKey:@"startScreening"];
        self.pointGapAvailRound=[decoder decodeInt32ForKey:@"pointGapAvailRound"];
        self.judgeCount=[decoder decodeInt32ForKey:@"judgeCount"];
        self.availScoreWithJudesCount=[decoder decodeInt32ForKey:@"availScoreWithJudesCount"];
        self.availTimeDuringScoreCalc=[decoder decodeDoubleForKey:@"availTimeDuringScoreCalc"];
        self.maxWarningCount=[decoder decodeInt32ForKey:@"maxWarningCount"];
        self.restAndReorganizationTime=[decoder decodeDoubleForKey:@"restAndReorganizationTime"];
    }  
    return self;  
}
*/
-(void)dealloc
{

}
@end

