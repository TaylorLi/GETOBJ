//
//  AppConfig.m
//  Chatty
//
//  Copyright (c) 2009 Peter Bakhyryev <peter@byteclub.com>, ByteClub LLC
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import "AppConfig.h"
#import "UIDevice+IdentifierAddition.h"
#import "TKDDatabase.h"

static AppConfig* instance;

@implementation AppConfig

@synthesize name;
@synthesize password;
@synthesize isIPAD;
@synthesize networkUsingWifi;
@synthesize timeout;
//@synthesize invalidServerPeerIds;
@synthesize uuid;
@synthesize currentAppStep;
//当前比赛信息
@synthesize currentGameInfo;
@synthesize isGameStart;
//@synthesize currentJudgeDevice;

// Initialization
- (id) init {
  self=[super init];
  self.name = @"unknown";
    networkUsingWifi=NO;
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.width);
  isIPAD=![[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone;  
    timeout=30;
    //invalidServerPeerIds=[[NSMutableSet alloc] init];
    uuid=[[UIDevice currentDevice] uniqueDeviceIdentifier];
    currentAppStep=AppStepStart;
    //currentJudgeDevice=JudgeDeviceKeyboard;
    isGameStart=NO;
  return self;
}


// Cleanup


// Automatically initialize if called for the first time
+ (AppConfig*) getInstance {
  @synchronized([AppConfig class]) {
    if ( instance == nil ) {
      instance = [[AppConfig alloc] init];
    }
  }
  
  return instance;
}
//其他页面，除比赛界面
+ (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if([AppConfig getInstance].isIPAD)
        return interfaceOrientation== UIInterfaceOrientationLandscapeRight||interfaceOrientation== UIInterfaceOrientationLandscapeLeft;
    else
        return interfaceOrientation== UIInterfaceOrientationLandscapeRight;
}
//控制主界面,分数主界面
+ (BOOL)shouldAutorotateToInterfaceOrientationLandscape:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if([AppConfig getInstance].isIPAD)
        return interfaceOrientation== UIInterfaceOrientationLandscapeRight||interfaceOrientation== UIInterfaceOrientationLandscapeLeft;
    else
        return  interfaceOrientation==UIInterfaceOrientationLandscapeRight;
}

-(void)saveGameInfoToFile
{
    [UtilHelper serializeObjectToFile:KEY_FILE_SETTING withObject:currentGameInfo dataKey:KEY_FILE_SETTING_GAME_INFO];
    NSLog(@"Game Info:%@",currentGameInfo);
}
-(void)restoreGameInfoFromFile
{
    if([UtilHelper isFileExist:KEY_FILE_SETTING])
    {
        currentGameInfo =  [UtilHelper deserializeFromFile:KEY_FILE_SETTING dataKey:KEY_FILE_SETTING_GAME_INFO];
        NSLog(@"Game Info:%@",currentGameInfo);
        [[TKDDatabase getInstance] saveServerSettting:currentGameInfo.gameSetting];
    }
}
-(void)dealloc
{
    
}
@end
