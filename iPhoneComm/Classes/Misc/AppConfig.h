//
//  AppConfig.h
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

#import <Foundation/Foundation.h>
#import "Definition.h"
#import "ServerSetting.h"
#import "GameInfo.h"
#import "AppSetting.h"
//当前处在那个环节

@interface AppConfig : NSObject {
  NSString* name;
  NSString* password;   
}

@property (copy) NSString* name;
@property (strong) NSString* password;
@property  NSTimeInterval timeout;
@property BOOL isIPAD;
@property BOOL networkUsingWifi;
//@property (strong) NSMutableSet *invalidServerPeerIds;
@property (strong) NSString *uuid;
//当前进行的比赛信息
@property(strong,nonatomic) GameInfo *currentGameInfo;
@property (nonatomic) AppStep currentAppStep;
//@property (nonatomic) JudgeDevice currentJudgeDevice;
@property BOOL isGameStart;
@property NSInteger profileIndex;
@property  NSTimeInterval requestTimeout;
@property (nonatomic,strong) AppSetting *settngs;
@property BOOL hasValidActive;
// Singleton - one instance for the whole app
+ (AppConfig*)getInstance;

+(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation;
+ (BOOL)shouldAutorotateToInterfaceOrientationLandscape:(UIInterfaceOrientation)interfaceOrientation;
-(void)saveGameInfoToFile;
-(void)restoreGameInfoFromFile;
-(void)saveProfileIndexToFile;
-(void)restoreProfileIndexFromFile;
-(void)saveAppSettingToFile;
-(void)restoreAppSettingFromFile;
-(BOOL)testIfProductHasValidateWithSN:(NSString *)_productSN encryptSN:(NSString *)encryptKey;
-(BOOL) testIfProductHasValidate;
-(BOOL) productSNValidate;

@end
