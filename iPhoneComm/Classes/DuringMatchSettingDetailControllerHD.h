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
#import "ScoreBoardViewController.h"

@interface DuringMatchSettingDetailControllerHD : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate,SimplePickerInputTableViewCellDelegate,TimePickerTableViewCellDelegate,StringInputTableViewCellDelegate,UITableViewDataSource> 
{
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    id detailItem;
	UIBarButtonItem *startButton;
    Boolean isChangeSetting;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *startButton;
@property (nonatomic,assign) ScoreBoardViewController *relateGameServer;
@property (strong,nonatomic) JMStaticContentTableViewController *detailControllerMatch;
@property (strong,nonatomic) JMStaticContentTableViewController *detailControllerMisc;
@property (strong,nonatomic) UITableViewController *detailControllerJudge;
@property (strong,nonatomic) JMStaticContentTableViewController *detailControllerMainMenu;
@property (strong,nonatomic) GameInfo *orgGameInfo;

- (IBAction)touchSaveButton;
- (IBAction)cancelSave;
-(void) bindSettingGroupData:(int)group;
-(void)endMatch;
-(void)refreshJudges;

@end