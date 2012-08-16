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

#define kWaitBoxForReset 1
#define kWaitBoxForReOrg 2

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

@property (nonatomic, strong) IBOutlet UILabel *lblGameName;
@property (nonatomic, strong) IBOutlet UILabel *lblRedImg1;
@property (nonatomic, strong) IBOutlet UILabel *lblRedImg2;
@property (nonatomic, strong) IBOutlet UILabel *lblRedImg3;
@property (nonatomic, strong) IBOutlet UILabel *lblRedImg4;
@property (nonatomic, strong) IBOutlet UILabel *lblBlueImg1;
@property (nonatomic, strong) IBOutlet UILabel *lblBlueImg2;
@property (nonatomic, strong) IBOutlet UILabel *lblBlueImg3;
@property (nonatomic, strong) IBOutlet UILabel *lblBlueImg4;
@property (nonatomic, strong) IBOutlet UILabel *lblRedImg5;
@property (nonatomic, strong) IBOutlet UILabel *lblRedImg6;
@property (nonatomic, strong) IBOutlet UILabel *lblRedImg7;
@property (nonatomic, strong) IBOutlet UILabel *lblRedImg8;
@property (nonatomic, strong) IBOutlet UILabel *lblBlueImg5;
@property (nonatomic, strong) IBOutlet UILabel *lblBlueImg6;
@property (nonatomic, strong) IBOutlet UILabel *lblBlueImg7;
@property (nonatomic, strong) IBOutlet UILabel *lblBlueImg8;
@property (nonatomic, strong) IBOutlet UILabel *lblRedTotal;
@property (nonatomic, strong) IBOutlet UILabel *lblBlueTotal;
@property (nonatomic, strong) IBOutlet UILabel *lblCoachName;
@property (nonatomic, strong) IBOutlet UITextView *txtHistory;
@property(nonatomic,strong) LocalRoom* chatRoom;
@property (strong, nonatomic) IBOutlet UILabel *lblGameDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblBluePlayerName;
@property (strong, nonatomic) IBOutlet UILabel *lblBluePlayerDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;
@property (strong, nonatomic) IBOutlet UILabel *lblRoundSeq;
@property (strong, nonatomic) IBOutlet UILabel *lblRedPlayerDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblRedPlayerName;
@property(nonatomic, strong) DDActionHeaderView *actionHeaderView;
@property (strong, nonatomic) IBOutlet UILabel *lblScreening;
@property (strong, nonatomic) IBOutlet UIView *viewRedWarmningBox;
@property (strong, nonatomic) IBOutlet UIView *viewBlueWarmningBox;

// Exit back to the welcome screen
- (IBAction)exit;

// View is active, start everything up
- (void)activate;

- (void)eraseText;

-(void)showWaitingUserBox;

-(void)goToNextMatch;

-(void)updateForGameSetting:(BOOL)hasChange;
@end
