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
#import "PermitControlView.h"
#import "UIHelper.h"

static ChattyAppDelegate* _instance;

@interface ChattyAppDelegate()
    -(void) swithView:(UIView *) view;
@end

@implementation ChattyAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize welcomeViewController;
@synthesize scoreControlViewController;
@synthesize scoreBoardViewController;
@synthesize permitViewController;

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
    [welcomeViewController activate];
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(bluetoothAvailabilityChanged:)
//     name:@"BluetoothAvailabilityChangedNotification"
//     object:nil];
}

/* Bluetooth notifications */
- (void)bluetoothAvailabilityChanged:(NSNotification *)notification {
//    BluetoothManager *blManager=[BluetoothManager sharedInstance];
//    NSLog(@"NOTIFICATION:bluetoothAvailabilityChanged called. BT State: %d", [ blManager enabled]);     
//    [UIHelper showAlert:@"Error" message:@"Bluetooth status changed,please restart the app." delegate:nil];
}

- (void)dealloc {
    [viewController release];
    [welcomeViewController release];
    [scoreBoardViewController release];
    [scoreControlViewController release];
    [permitViewController release];
    [window release];
    [super dealloc];
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

-(void) showScoreControlRoom:(Room *) room{
    scoreControlViewController.chatRoom = room;
    [scoreControlViewController activate];
    
    [self swithView:scoreControlViewController.view];}

-(void) showPermitControl:(Room *)room validatePassword:(Boolean)isValatePassword setServerPassword: (NSString*) serverPassword{
    permitViewController.chatRoom = room;
    permitViewController.isValidatePassword = isValatePassword;
    permitViewController.serverPassword = serverPassword;
    
    [permitViewController activate];
    
    [self swithView:permitViewController.view];
}

@end
