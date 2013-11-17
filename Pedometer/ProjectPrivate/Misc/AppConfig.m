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
#import "BO_PEDUserInfo.h"
#import "BO_PEDTarget.h"
#import "UIDevice+IdentifierAddition.h"


static AppConfig* instance;

@implementation AppConfig

@synthesize uuid;
@synthesize isIPAD;
@synthesize settings;


//@synthesize currentJudgeDevice;

// Initialization
- (id) init {
    self=[super init];
    isIPAD=YES;    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        isIPAD=NO;
    }
    else{        
        isIPAD=YES;
    }    
    uuid=[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    [self restoreAppSetting];   
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

+ (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        return interfaceOrientation== UIInterfaceOrientationLandscapeRight||interfaceOrientation== UIInterfaceOrientationLandscapeLeft;
}

-(void)saveAppSetting
{
    [settings saveSetting];
}
-(void)restoreAppSetting
{
    if(settings==nil || settings.userInfo==nil){
        settings =[[AppSetting alloc] init];
    }else{
        settings.userInfo = [[BO_PEDUserInfo getInstance] retreiveCurrentUser];
        settings.target = [[BO_PEDTarget getInstance] queryTargetByUserId: settings.userInfo.userId];
    }
}

-(void)saveAppConfig
{
    [self saveAppSetting];
}

-(void)restoreAppConfig
{
    [self restoreAppSetting];
}

-(void)saveUserInfo:(PEDUserInfo *)user
{
    if([AppConfig getInstance].settings.userInfo==nil)
    {
        
    }
    else{
        if(![[AppConfig getInstance].settings.userInfo.userName isEqualToString:user.userName]){
           PEDUserInfo *preUser = [[BO_PEDUserInfo getInstance] retreiveUserByName:user.userName];
            if(preUser!=nil){
                user.userId=preUser.userId;
            }
        }
    }
    [[BO_PEDUserInfo getInstance] updateUserProfileNotToBeCurrent];
    [[BO_PEDUserInfo getInstance] saveObject:user];
    [AppConfig getInstance].settings.userInfo=user;
    [[AppConfig getInstance].settings initTargetData];}

-(void)dealloc
{
    
}
@end
