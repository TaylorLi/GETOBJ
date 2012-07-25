//
//  ScoreBoardViewController.h
//  Chatty
//
//  Created by Eagle Du on 12/6/30.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalRoom.h"
#import "RoomDelegate.h"
#import "UIWaitForUserViewController.h"
#import "RoundRestTimeViewController.h"
#import "DDActionHeaderView.h"

@interface ScoreBoardViewController : UIViewController<RoomDelegate,UAModalPanelDelegate>{
    LocalRoom* chatRoom;
    UILabel *lblGameName;
    UILabel *lblRedImg1;
    UILabel *lblRedImg2;
    UILabel *lblRedImg3;
    UILabel *lblRedImg4;
    UILabel *lblBlueImg1;
    UILabel *lblBlueImg2;
    UILabel *lblBlueImg3;
    UILabel *lblBlueImg4;
    UILabel *lblRedImg5;
    UILabel *lblRedImg6;
    UILabel *lblRedImg7;
    UILabel *lblRedImg8;
    UILabel *lblBlueImg5;
    UILabel *lblBlueImg6;
    UILabel *lblBlueImg7;
    UILabel *lblBlueImg8;
    UILabel *lblRedTotal;
    UILabel *lblBlueTotal;
    UITextView *txtHistory;
    UILabel *lblCoachName;
    NSDictionary *dicSideFlags;
    NSTimer *timer;
    UIWaitForUserViewController *waitUserPanel;
    RoundRestTimeViewController *roundResetPanel;
    DDActionHeaderView *actionHeaderView;
    NSTimer *gameLoopTimer;
    BOOL clientChange;
    NSMutableArray *cmdHis;
}

@property (nonatomic, retain) IBOutlet UILabel *lblGameName;
@property (nonatomic, retain) IBOutlet UILabel *lblRedImg1;
@property (nonatomic, retain) IBOutlet UILabel *lblRedImg2;
@property (nonatomic, retain) IBOutlet UILabel *lblRedImg3;
@property (nonatomic, retain) IBOutlet UILabel *lblRedImg4;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueImg1;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueImg2;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueImg3;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueImg4;
@property (nonatomic, retain) IBOutlet UILabel *lblRedImg5;
@property (nonatomic, retain) IBOutlet UILabel *lblRedImg6;
@property (nonatomic, retain) IBOutlet UILabel *lblRedImg7;
@property (nonatomic, retain) IBOutlet UILabel *lblRedImg8;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueImg5;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueImg6;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueImg7;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueImg8;
@property (nonatomic, retain) IBOutlet UILabel *lblRedTotal;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueTotal;
@property (nonatomic, retain) IBOutlet UILabel *lblCoachName;
@property (nonatomic, retain) IBOutlet UITextView *txtHistory;
@property(nonatomic,retain) Room* chatRoom;
@property (retain, nonatomic) IBOutlet UILabel *lblGameDesc;
@property (retain, nonatomic) IBOutlet UILabel *lblBluePlayerName;
@property (retain, nonatomic) IBOutlet UILabel *lblBluePlayerDesc;
@property (retain, nonatomic) IBOutlet UILabel *lblTime;
@property (retain, nonatomic) IBOutlet UILabel *lblRoundSeq;
@property (retain, nonatomic) IBOutlet UILabel *lblRedPlayerDesc;
@property (retain, nonatomic) IBOutlet UILabel *lblRedPlayerName;
@property(nonatomic, retain) DDActionHeaderView *actionHeaderView;

// Exit back to the welcome screen
- (IBAction)exit;

- (IBAction)permit;

// View is active, start everything up
- (void)activate;

- (void)eraseText;

-(void)showWaitingUserBox;

@end
