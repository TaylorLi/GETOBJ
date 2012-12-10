//
//  GameSettingDetailControllerHD.h
//  TKD Score
//
//  Created by Eagle Du on 12/8/11.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMStaticContentTableViewController.h"
#import "SimplePickerInputTableViewCell.h"
#import "TimePickerTableViewCell.h"
#import "StringInputTableViewCell.h"
#import "IntegerInputTableViewCell.h"

@interface GameSettingDetailControllerHD : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate,SimplePickerInputTableViewCellDelegate,TimePickerTableViewCellDelegate,StringInputTableViewCellDelegate,IntegerInputTableViewCellDelegate,UITableViewDataSource> 
{
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    id detailItem;
	UIBarButtonItem *startButton;
    NSArray *availProfiles;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *startButton;
@property (strong,nonatomic) JMStaticContentTableViewController *detailControllerGameSetting;
@property (strong,nonatomic) JMStaticContentTableViewController *detailControllerRoundSetting;
@property (strong,nonatomic) JMStaticContentTableViewController *detailControllerMatchSetting;
@property (strong,nonatomic) JMStaticContentTableViewController *detailControllerCourtSetting;
@property (strong,nonatomic) JMStaticContentTableViewController *detailControllerSystemSetting;
@property (strong,nonatomic) UITableViewController *detailControllerProfile;
@property (strong, nonatomic) IBOutlet UILabel *lblProfileName;
@property (strong,nonatomic) NSString *selectedProfileId;
- (IBAction)touchSaveButton;
- (void)startGame:(BOOL)isCallByRestoreFromGameInfo;
-(void) bindSettingGroupData:(int)group;
-(void)resetSetting;

@end