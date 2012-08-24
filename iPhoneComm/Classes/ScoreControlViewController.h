//
//  SwipesViewController.h
//  Swipes
//
//  Created by Dave Mark on 12/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameInfo.h"
#import "RemoteRoom.h"
#import "RoomDelegate.h"
#import "AlertView.h"
#import "ScoreInfo.h"


@class  UILoadingBox;

@interface ScoreControlViewController : UIViewController<RoomDelegate> {
    UILabel     *label;
    CGPoint     gestureStartPoint;
    RemoteRoom* chatRoom;
    UILoadingBox* loadingBox;
    NSTimer *gameLoopTimer;
//    NSTimer *sendLoopTimer;
    NSDate *serverLastMsgDate;
    GameStates preGameStates;
    UIAlertView *tipBox;
    AlertView *reConnectBox;
    BOOL isReconnect;
    BOOL hasEverConnectd;
    BOOL isExit;
    BOOL isDoingReconnect;
    
}
@property (nonatomic, strong) IBOutlet UILabel *label;
@property(nonatomic,strong) RemoteRoom* chatRoom;
@property CGPoint gestureStartPoint;
@property CGFloat screenWidth;
@property (strong, nonatomic) IBOutlet UIView *viewBlue;
@property (strong, nonatomic) IBOutlet UIView *viewRed;
@property (strong, nonatomic) IBOutlet UIImageView *imgBlueScore;
@property (strong, nonatomic) IBOutlet UIImageView *imgRedScore;
@property (strong, nonatomic) IBOutlet UIButton *btnMenuHideBackground;
@property (strong, nonatomic) IBOutlet UIButton *btnMenuHide;
@property (strong, nonatomic) IBOutlet UIButton *btnMenuShow;
@property (strong, nonatomic) IBOutlet UIImageView *imgMenuShowBackground;

@property (strong, nonatomic) IBOutlet UIImageView *imgConnectiondicator;
- (void)eraseText;
// Exit back to the welcome screen
- (IBAction)exit;
- (IBAction)showMenu:(id)sender;
-(IBAction)hideMenu:(id)sender;
-(void)hideMenuWithAnimate;

// View is active, start everything up
- (void)activate;

-(void)sendScore;
//-(void)setStyleBySide;
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
-(void)tryToReconnect;
@end