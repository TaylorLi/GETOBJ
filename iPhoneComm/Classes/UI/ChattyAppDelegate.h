//
//  ChattyAppDelegate.h
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

#import <UIKit/UIKit.h>
#import "Room.h"
//#import "BluetoothManager.h"
//#import "BluetoothDevice.h"
#import "Reachability.h"
#import "LocalRoom.h"
#import <CoreBluetooth/CBCentralManager.h>

@class ChattyViewController, ChatRoomViewController, WelcomeViewController, ScoreControlViewController,ScoreBoardViewController;


@interface ChattyAppDelegate : NSObject <UIApplicationDelegate,CBCentralManagerDelegate> {
  UIWindow *window;
  ChattyViewController *viewController;
  WelcomeViewController *welcomeViewController;
  ScoreControlViewController *scoreControlViewController;
  ScoreBoardViewController *scoreBoardViewController;
    // bluetooth manager
    //BluetoothManager *btManager;
    Reachability* wifiReach;
    CBCentralManager *centralManager;
}
@property (weak, nonatomic) IBOutlet UISplitViewController *splitSettingViewController;
@property (weak, nonatomic) IBOutlet UISplitViewController *duringMathSplitViewCtl;

@property(nonatomic, strong) IBOutlet UIWindow *window;
@property(nonatomic, strong) IBOutlet ChattyViewController *viewController;
@property(nonatomic, strong) IBOutlet WelcomeViewController *welcomeViewController;
@property(nonatomic, strong) IBOutlet ScoreControlViewController *scoreControlViewController;
@property(nonatomic, strong) IBOutlet ScoreBoardViewController *scoreBoardViewController;

// Main instance of the app delegate
+ (ChattyAppDelegate*)getInstance;

// Show chat room
// Go back to the room selection
- (void)showRoomSelection;

//Show board in server
-(void) showScoreBoard:(LocalRoom *)room;
//Show Controller in client
-(void) showScoreControlRoom:(Room *) room;

-(void) showGameSettingView;
-(void) showDuringMatchSettingView:(NSInteger)tabIndex;

-(void) swithView:(UIViewController *) controller;


@end
