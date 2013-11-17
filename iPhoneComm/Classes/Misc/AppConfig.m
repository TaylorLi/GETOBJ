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
#import "BO_ServerSetting.h"
#import "SecretHelper.h"
#import "Reachability.h"
#import "RequestManager.h"

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
@synthesize profileIndex;
@synthesize requestTimeout;
@synthesize settngs;
@synthesize hasValidActive;

//@synthesize currentJudgeDevice;

// Initialization
- (id) init {
    self=[super init];
    self.name = @"unknown";
    networkUsingWifi=NO;
    //NSLog(@"%f",[UIScreen mainScreen].bounds.size.width);
    isIPAD=YES;    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        isIPAD=NO;
    }
    else{
        //应用程序的名称和版本号等信息都保存在mainBundle的一个字典中，用下面代码可以取出来。
        
        NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
        //NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
        NSString *appName =[infoDict objectForKey:@"CFBundleDisplayName"];
        if([appName hasSuffix:@"HD"]){
            isIPAD=YES;
        }
        else{
            isIPAD=NO;
        }
    }
    
    requestTimeout=20;
    timeout=30;
    //invalidServerPeerIds=[[NSMutableSet alloc] init];
    uuid=[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    currentAppStep=AppStepStart;
    //currentJudgeDevice=JudgeDeviceKeyboard;
    isGameStart=NO;
    [self restoreProfileIndexFromFile];
    [self restoreAppSettingFromFile];    
    hasValidActive=[self testIfProductHasValidate];
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
+(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

+ (BOOL)shouldAutorotate
{
    return YES;
}
-(void)saveGameInfoToFile
{
    [UtilHelper serializeObjectToFile:KEY_FILE_SETTING withObject:currentGameInfo dataKey:KEY_FILE_SETTING_GAME_INFO];
    [self saveAppSettingToFile];
    //NSLog(@"Save Game Info to file:%@",currentGameInfo);
}
-(void)restoreGameInfoFromFile
{
    if([UtilHelper isFileExist:KEY_FILE_SETTING])
    {
        currentGameInfo =  [UtilHelper deserializeFromFile:KEY_FILE_SETTING dataKey:KEY_FILE_SETTING_GAME_INFO];
        //NSLog(@"Restore Game Info from file:%@",currentGameInfo);
    }
    [self restoreAppSettingFromFile];
    hasValidActive=[self testIfProductHasValidate];
}

-(void)saveAppSettingToFile
{
    [UtilHelper serializeObjectToFile:KEY_FILE_SETTING withObject:settngs dataKey:KEY_FILE_APP_SETTING];
}
-(void)restoreAppSettingFromFile
{
    if([UtilHelper isFileExist:KEY_FILE_SETTING])
    {
        settngs =  [UtilHelper deserializeFromFile:KEY_FILE_SETTING dataKey:KEY_FILE_APP_SETTING];
    }
    if(settngs==nil){
        settngs =[[AppSetting alloc] init];
    }
}

-(BOOL) testIfProductHasValidate{
   return [self testIfProductHasValidateWithSN:settngs.productSN encryptSN:settngs.enctryProductSN];
}

-(BOOL)testIfProductHasValidateWithSN:(NSString *)_productSN encryptSN:(NSString *)encryptKey
{
    if(encryptKey==nil||[encryptKey isEqualToString:@""])
    {
        return NO;
    }
    else{
        @try {
            
            NSString *descrptKey=[SecretHelper md5:[NSString stringWithFormat:@"TKD|%@|%@",_productSN,uuid]];            
            if([descrptKey isEqualToString:encryptKey])
            {
                return YES;     
            }
            else
                return NO;
        }
        @catch (NSException *exception) {
            return NO;
        }
        @finally {
            
        }        
    }
}
-(BOOL) productSNValidate
{
    if([self testIfProductHasValidate]){
        NetworkStatus status = [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus];
        if(status==ReachableViaWiFi){
            //10天联网时验证一次
            if(fabs([settngs.lastProductSNValidateDate timeIntervalSinceNow])>3600*24*10)
            {
                return [RequestManager isActiveCurrentDeviceWithProductSN:settngs.productSN];  
            }
            else
            {
                return YES;
            }
        }
        return YES;
    }
    else{
        return NO;
    }
}

-(void)saveProfileIndexToFile
{
    [UtilHelper serializeObjectToFile:KEY_FILE_SETTING withObject:[NSNumber numberWithInt:profileIndex] dataKey:KEY_FILE_PROFILE_INDEX];
    //NSLog(@"Save Game Info to file:%@",currentGameInfo);
}
-(void)restoreProfileIndexFromFile
{
    if([UtilHelper isFileExist:KEY_FILE_SETTING])
    {
        @try {
            profileIndex =  [[UtilHelper deserializeFromFile:KEY_FILE_SETTING dataKey:KEY_FILE_PROFILE_INDEX] intValue];
        }
        @catch (NSException *exception) {
            profileIndex=1;
        }
        @finally {
            if(profileIndex<1)
                profileIndex=1;
        }        
        //NSLog(@"Restore Game Info from file:%@",currentGameInfo);
    }
}
-(void)dealloc
{
    
}
@end
