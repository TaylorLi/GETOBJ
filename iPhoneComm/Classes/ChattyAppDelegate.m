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
#import "ChatRoomViewController.h"
#import "WelcomeViewController.h"
#import "ScoreControlViewController.h"
#import "ScoreBoardViewController.h"
#import "PermitControlView.h"

static ChattyAppDelegate* _instance;

@implementation ChattyAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize chatRoomViewController;
@synthesize welcomeViewController;
@synthesize scoreControlViewController;
@synthesize scoreBoardViewController;
@synthesize permitViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    // Allow other classes to use us
    _instance = self;
    
    // Override point for customization after app launch
    [window addSubview:chatRoomViewController.view];
    [window addSubview:viewController.view];
    [window addSubview:welcomeViewController.view];
    [window addSubview:scoreControlViewController.view];
    [window addSubview:scoreBoardViewController.view];
    [window addSubview:permitViewController.view];
    [window makeKeyAndVisible];
    
    // Greet user
    [window bringSubviewToFront:welcomeViewController.view];
    [welcomeViewController activate];
}


- (void)dealloc {
    [viewController release];
    [chatRoomViewController release];
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


// Show chat room
- (void)showChatRoom:(Room*)room {
  chatRoomViewController.chatRoom = room;
  [chatRoomViewController activate];
  
  [window bringSubviewToFront:chatRoomViewController.view];
}


// Show screen with room selection
- (void)showRoomSelection {
  [viewController activate];
  
  [window bringSubviewToFront:viewController.view];
}

-(void) showScoreBoard:(Room *)room{
    scoreBoardViewController.chatRoom = room;
    [scoreBoardViewController activate];
    
    [window bringSubviewToFront:scoreBoardViewController.view];
}

-(void) showScoreControlRoom:(Room *) room{
    scoreControlViewController.chatRoom = room;
    [scoreControlViewController activate];
    
    [window bringSubviewToFront:scoreControlViewController.view];
}

-(void) showPermitControl:(Room *)room validatePassword:(Boolean)isValatePassword setServerPassword: (NSString*) serverPassword{
    permitViewController.chatRoom = room;
    permitViewController.isValidatePassword = isValatePassword;
    permitViewController.serverPassword = serverPassword;
    
    [permitViewController activate];
    
    [window bringSubviewToFront:permitViewController.view];
}

@end
