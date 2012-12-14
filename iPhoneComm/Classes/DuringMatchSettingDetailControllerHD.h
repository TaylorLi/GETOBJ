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

#define kTagScoreJugdeName 1
#define kTagScoreSide 2
#define kTagScoreNum 3
#define kTagScoreCreateTime 4

typedef enum {    
    TableViewJudgeTable=0,
    TableViewDetailReport=1,
    TableViewSummaryReport=2
} TableViewType;

@interface DuringMatchSettingDetailControllerHD : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate,SimplePickerInputTableViewCellDelegate,TimePickerTableViewCellDelegate,StringInputTableViewCellDelegate,UITableViewDataSource> 
{
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    id detailItem;
	UIBarButtonItem *startButton;
    Boolean isChangeSetting;
    NSMutableDictionary *detailScoreLogs;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *startButton;
@property (nonatomic,assign) ScoreBoardViewController *relateGameServer;
@property (strong,nonatomic) JMStaticContentTableViewController *detailControllerMatch;
@property (strong,nonatomic) JMStaticContentTableViewController *detailControllerMisc;
@property (strong,nonatomic) UITableViewController *detailControllerJudge;
@property (strong,nonatomic) UITableViewController *detailControllerMatchDetailReport;
@property (strong,nonatomic) JMStaticContentTableViewController *detailControllerMainMenu;
@property (strong,nonatomic) GameInfo *orgGameInfo;
@property (nonatomic) NSTimeInterval currentRemainTime;
@property (strong,nonatomic) UIButton *btnRestartServer;

- (IBAction)touchSaveButton;
- (IBAction)cancelSave;
-(void) bindSettingGroupData:(int)group;
-(void)endMatch;
-(void)refreshJudges;

@end