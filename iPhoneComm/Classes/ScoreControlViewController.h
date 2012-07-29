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


@class  UILoadingBox;

@interface ScoreControlViewController : UIViewController<RoomDelegate> {
    UILabel     *label;
    CGPoint     gestureStartPoint;
    RemoteRoom* chatRoom;
    Boolean isBlueSide;
    UILoadingBox* loadingBox;
    NSTimer *gameLoopTimer;
    NSDate *serverLastMsgDate;
    GameStates preGameStates;
    UIAlertView *tipBox;
    AlertView *reConnectBox;
    BOOL isReconnect;
    BOOL isExit;
    
}
@property (nonatomic, strong) IBOutlet UILabel *label;
@property(nonatomic,strong) RemoteRoom* chatRoom;
@property CGPoint gestureStartPoint;
@property CGFloat screenWidth;

- (void)eraseText;
// Exit back to the welcome screen
- (IBAction)exit;

// View is active, start everything up
- (void)activate;

-(void)sendScore:(NSInteger)score;
-(void)reportSwipe:(NSInteger)score fromGestureRecognizer:(UIGestureRecognizer *) recognizer;
//-(void)setStyleBySide;
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
@end