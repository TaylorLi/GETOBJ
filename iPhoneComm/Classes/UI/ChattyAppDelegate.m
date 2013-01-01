//
//  ChattyAppDelegate.m
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

#import "ChattyAppDelegate.h"
#import "ChattyViewController.h"
#import "WelcomeViewController.h"
#import "DuringMatchSettingRootControllerHD.h"
#import "DuringMatchSettingDetailControllerHD.h"
#import "ScoreControlViewController.h"
#import "ScoreBoardViewController.h"
#import "UIHelper.h"
#import "AppConfig.h"
#import <GameKit/GameKit.h>
#import "KeyBoradEventInfo.h"
#import "TKDDatabase.h"
#import "BO_GameInfo.h"

static ChattyAppDelegate* _instance;

@interface ChattyAppDelegate()
-(void) showConfrimMsg:(NSString*) title message:(NSString*)msg;
/*
-(void)detectBluetoothStatus;
-(void)testNetworkStatus;
*/
-(void)processByAppStatus;
@end

@implementation ChattyAppDelegate

@synthesize splitSettingViewController;
@synthesize duringMathSplitViewCtl;
@synthesize window;
@synthesize viewController;
@synthesize welcomeViewController;
@synthesize scoreControlViewController;
@synthesize scoreBoardViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
      [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone]; 
    // Allow other classes to use us
    //不自动锁屏
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    _instance = self;
    
    // Override point for customization after app launch
    [window addSubview:welcomeViewController.view];   
    [window makeKeyAndVisible];
    
    // Greet user
    //[window bringSubviewToFront:welcomeViewController.view];
    
    // 监测网络情况
    //NSLog(@"%@,%@",[AppConfig getInstance].uuid,[UtilHelper stringWithUUID]);
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    NSMutableArray * discoveredPeripherals = [NSMutableArray new];
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    [centralManager scanForPeripheralsWithServices:discoveredPeripherals options:options];
    /* 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    */
    //蓝牙键盘监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardPress:)
                                                 name: @"UIEventGSEventKeyUpNotification"
                                               object: nil];
    
    wifiReach = [Reachability reachabilityForLocalWiFi];	
    [wifiReach startNotifier];
    //btManager = [BluetoothManager sharedInstance];
    //[self performSelector:@selector(testNetworkStatus) withObject:nil afterDelay:1];
    [welcomeViewController activate];
    welcomeViewController=nil;
    if([AppConfig getInstance].isIPAD)
        [[TKDDatabase getInstance] setupServerDatabase];
}

- (void)dealloc {
    centralManager=nil;
}


+ (ChattyAppDelegate*)getInstance {
    return _instance;
}

-(void) swithView:(UIView *) view{
    for (UIView *subView in window.subviews) {
        if(subView.superview!=nil){
        [subView removeFromSuperview];
            }
    }
    [window insertSubview:view atIndex:0];
}
// Show screen with room selection
- (void)showRoomSelection {
    [AppConfig getInstance].currentAppStep=AppStepServerBrowser;
    [self swithView:viewController.view];
    [viewController activate];
}

-(void) showScoreBoard:(LocalRoom *)room{
    [AppConfig getInstance].currentAppStep=AppStepServer;
    [self swithView:scoreBoardViewController.view];
    scoreBoardViewController.chatRoom = room;
    [scoreBoardViewController activate];
}

-(void) showScoreControlRoom:(RemoteRoom *) room{
    [AppConfig getInstance].currentAppStep=AppStepClient;
    scoreControlViewController.chatRoom = room;
    [scoreControlViewController activate];
    
    [self swithView:scoreControlViewController.view];
}

-(void) showGameSettingView{
    [AppConfig getInstance].currentAppStep=AppStepServerBrowser;    
    [splitSettingViewController setWantsFullScreenLayout:YES];
    [self swithView:splitSettingViewController.view];
}
-(void) showDuringMatchSettingView:(NSInteger)tabIndex
{
    [AppConfig getInstance].currentAppStep=AppStepServer;
    [duringMathSplitViewCtl setWantsFullScreenLayout:YES];
    UINavigationController *navControl= [duringMathSplitViewCtl.viewControllers objectAtIndex:0];
    DuringMatchSettingRootControllerHD *rootControl=(DuringMatchSettingRootControllerHD *)navControl.topViewController; 
    DuringMatchSettingDetailControllerHD *detailControl = [duringMathSplitViewCtl.viewControllers objectAtIndex:1];
    rootControl.showingTabIndex=tabIndex;
    detailControl.showingTabIndex=tabIndex;
    [self swithView:duringMathSplitViewCtl.view];
    [detailControl refreshDatasource];
}
-(void) showConfrimMsg:(NSString*) title message:(NSString*)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
    [alertView show];
}
/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [btManager setPowered:YES];
    [btManager setEnabled:YES];
    [self performSelector:@selector(detectBluetoothStatus) withObject:nil afterDelay:2];
}
-(void)detectBluetoothStatus
{
    if(![btManager enabled]){
        [UIHelper showAlert:@"Error" message:@"Failre to turn on your bluetooth device." func:nil];
        return;
    }
    //detect network status
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(bluetoothAvailabilityChanged:)
     name:@"BluetoothPowerChangedNotification"
     object:nil];
    [wifiReach startNotifier];
}

-(void)testNetworkStatus
{
    NetworkStatus netWorkStatus= [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus];
    if(netWorkStatus!=ReachableViaWiFi &&![btManager enabled])
    {
        [self showConfrimMsg:@"Information" message:@"This application need to use either bluetooth or wifi,continue to turn on bluetooth?"];
        return ; 
    }    
}
*/
/*wifi status change*/
/*
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    NSLog(@"Wifi status change:curent is %i",status);
    BluetoothManager *blManager=[BluetoothManager sharedInstance];
    if (![btManager enabled] && status != ReachableViaWiFi) {
        [UIHelper showAlert:@"Error" message:@"Network status changed,please turn on wifi or bluetooth." func:^(AlertView *a, NSInteger i) {
            blManager.enabled=YES;
            [self processByAppStatus];
        }];
    }
}
*/
-(void)keyboardPress:(NSNotification *)note {
   NSDictionary *info= [note userInfo];
    KeyBoradEventInfo *keyArgv=[[KeyBoradEventInfo alloc] init];
    keyArgv.keyCode=[((NSNumber *)[info objectForKey:@"keycode"]) shortValue];
    keyArgv.control=[((NSNumber *)[info objectForKey:@"control"]) boolValue];
 keyArgv.command=[((NSNumber *)[info objectForKey:@"command"]) boolValue];
     keyArgv.option=[((NSNumber *)[info objectForKey:@"option"]) boolValue];
     keyArgv.shift=[((NSNumber *)[info objectForKey:@"shift"]) boolValue];
    keyArgv.keyDesc=[UtilHelper getKeyCodeDesc:keyArgv.keyCode];
    NSLog(@"%@",keyArgv);
    AppConfig *config = [AppConfig getInstance];
    if(config.currentAppStep==AppStepServer && scoreBoardViewController.chatRoom.gameInfo.gameSetting.currentJudgeDevice==JudgeDeviceKeyboard)
    {
        [scoreBoardViewController bluetoothKeyboardPressed:keyArgv];
    }
}

/* Bluetooth notifications */
/*
- (void)bluetoothAvailabilityChanged:(NSNotification *)notification {
    BluetoothManager *blManager=[BluetoothManager sharedInstance];
    NSLog(@"NOTIFICATION:bluetoothAvailabilityChanged called. BT State: %d", [ blManager enabled]);     
    if (![btManager enabled] && [wifiReach currentReachabilityStatus] != ReachableViaWiFi)
        [UIHelper showAlert:@"Error" message:@"Network status changed,continue to turn on bluetooth." func:^(AlertView *a, NSInteger i) {
            blManager.enabled=YES;
            [self processByAppStatus];
        }];
}
*/ 

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}
- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    
}
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}
#pragma mark -
#pragma mark AppDelegate

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"Become Active");
    [[AppConfig getInstance] restoreGameInfoFromFile];
    
}
-(void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"Resign Active");
    [[AppConfig getInstance] saveGameInfoToFile];  
    [[BO_GameInfo getInstance] updateAllGameInfo:[AppConfig getInstance].currentGameInfo];
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
   NSLog(@"Enter Background");
    return;
}

-(void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"Enter Foreround");
    [self processByAppStatus];
    return;
}
-(void)processByAppStatus
{
    if([AppConfig getInstance].currentAppStep==AppStepStart)
        return;
    else 
    {
        GKSession *sess;
        switch ([AppConfig getInstance].currentAppStep) {
            case AppStepServerBrowser:{
                sess=viewController.peerServerBrowser.schSession;
                [viewController.peerServerBrowser restartBrowser];
            }
                break;
            case AppStepServer:
            {
                sess=scoreBoardViewController.chatRoom.bluetoothServer.serverSession;
                [scoreBoardViewController.chatRoom testUnavailableAndRestart];
            }
                break;
            case AppStepClient:
            {
                sess=scoreControlViewController.chatRoom.bluetoothClient.gameSession;
                [scoreControlViewController tryToReconnect];
            }
                break;
            default:
                break;
        }
        /*
        NSLog(@"BLUE Session %@ ID:%@,Available:%i,Peer ID:%@,Mode:%i",sess.displayName, sess.sessionID,sess.available,sess.peerID,sess.sessionMode);  
        NSArray *array=[sess peersWithConnectionState:GKPeerStateAvailable];
        NSLog(@"GKPeerStateAvailable Peer:%i",array.count); 
        array=[sess peersWithConnectionState:GKPeerStateConnected];
        NSLog(@"GKPeerStateConnected Peer:%i",array.count);
        array=[sess peersWithConnectionState:GKPeerStateDisconnected];
        NSLog(@"GKPeerStateDisconnected Peer:%i",array.count); 
        array=[sess peersWithConnectionState:GKPeerStateUnavailable];
        NSLog(@"GKPeerStateUnavailable Peer:%i",array.count); 
        array=[sess peersWithConnectionState:GKPeerStateConnecting];
        NSLog(@"GKPeerStateConnecting Peer:%i",array.count);
        */
        if(!sess.isAvailable){
            sess.available=YES;
        }
    }
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"Receive memory warning");
}

-(void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"Application Terminate");
    [[AppConfig getInstance] saveGameInfoToFile];
}

#if __IPAD_OS_VERSION_MAX_ALLOWED >= __IPAD_6_0

typedef enum {
    UIInterfaceOrientationMaskPortrait = (1 << UIInterfaceOrientationPortrait),
    UIInterfaceOrientationMaskLandscapeLeft = (1 << UIInterfaceOrientationLandscapeLeft),
    UIInterfaceOrientationMaskLandscapeRight = (1 << UIInterfaceOrientationLandscapeRight),
    UIInterfaceOrientationMaskPortraitUpsideDown = (1 << UIInterfaceOrientationPortraitUpsideDown),
    UIInterfaceOrientationMaskLandscape =
    (UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight),
    UIInterfaceOrientationMaskAll =
    (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft |
     UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown),
    UIInterfaceOrientationMaskAllButUpsideDown =
    (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft |
     UIInterfaceOrientationMaskLandscapeRight),
} UIInterfaceOrientationMask;

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft |
            UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown);
    
    
}
#endif

@end
