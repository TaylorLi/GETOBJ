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
#import "ScoreControlViewController.h"
#import "ScoreBoardViewController.h"
#import "UIHelper.h"
#import "AppConfig.h"

static ChattyAppDelegate* _instance;

@interface ChattyAppDelegate()
-(void) swithView:(UIView *) view;
-(void) showConfrimMsg:(NSString*) title message:(NSString*)msg;
-(void)detectBluetoothStatus;
-(void)testNetworkStatus;
@end

@implementation ChattyAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize welcomeViewController;
@synthesize scoreControlViewController;
@synthesize scoreBoardViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
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
    
    wifiReach = [Reachability reachabilityForLocalWiFi];	
    btManager = [BluetoothManager sharedInstance];
    [self performSelector:@selector(testNetworkStatus) withObject:nil afterDelay:1];
    [welcomeViewController activate];
}

- (void)dealloc {
    
}


+ (ChattyAppDelegate*)getInstance {
    return _instance;
}

-(void) swithView:(UIView *) view{
    for (UIView *subView in window.subviews) {
        [subView removeFromSuperview];
    }
    [window insertSubview:view atIndex:0];
}
// Show screen with room selection
- (void)showRoomSelection {
    [self swithView:viewController.view];
    [viewController activate];
}

-(void) showScoreBoard:(Room *)room{
    NSLog(@"%i",scoreBoardViewController.view.superview==nil);
    [self swithView:scoreBoardViewController.view];
    scoreBoardViewController.chatRoom = room;
    [scoreBoardViewController activate];
}

-(void) showScoreControlRoom:(RemoteRoom *) room{
    scoreControlViewController.chatRoom = room;
    [scoreControlViewController activate];
    
    [self swithView:scoreControlViewController.view];
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
    if([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus]!=ReachableViaWiFi &&![btManager enabled])
    {
        [self showConfrimMsg:@"Information" message:@"This application need to use either bluetooth or wifi,continue to turn on bluetooth?"];
        return ; 
    }    
}
/*wifi status change*/
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    NSLog(@"Wifi status change:curent is %i",status);
    if (![btManager enabled] && status != ReachableViaWiFi) {
        [UIHelper showAlert:@"Error" message:@"Network status changed,please restart the app." func:nil];
    }
}


/* Bluetooth notifications */
- (void)bluetoothAvailabilityChanged:(NSNotification *)notification {
    BluetoothManager *blManager=[BluetoothManager sharedInstance];
    NSLog(@"NOTIFICATION:bluetoothAvailabilityChanged called. BT State: %d", [ blManager enabled]);     
    if (![btManager enabled] && [wifiReach currentReachabilityStatus] != ReachableViaWiFi)
        [UIHelper showAlert:@"Error" message:@"Network status changed,please restart the app." func:nil];
}

@end
