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
#import "IntegerInputTableViewCell.h"
#import "RotateTableViewController.h"

#define kTagScoreJugdeName 1
#define kTagScoreSide 2
#define kTagScoreNum 3
#define kTagScoreCreateTime 4

typedef enum {    
    TableViewJudgeTable=0,
    TableViewDetailReport=1,
    TableViewSummaryReport=2
} TableViewType;

typedef enum {
    gsTabMatchSetting=0,    
    gsTabMiscSetting,
    gsTabReferee,
    gsTabReport,
    gsTabMainMenu
} DuringMatchSettingTabs;

@interface DuringMatchSettingDetailControllerHD : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate,SimplePickerInputTableViewCellDelegate,TimePickerTableViewCellDelegate,StringInputTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate,IntegerInputTableViewCellDelegate> 
{
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    id detailItem;
	UIBarButtonItem *startButton;
    Boolean isChangeSetting;
    NSMutableDictionary *detailScoreLogs;//round,logs
    NSArray *tabControlls;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *startButton;
@property (nonatomic,assign) ScoreBoardViewController *relateGameServer;
@property (strong,nonatomic) JMStaticContentTableViewController *detailControllerMatch;
@property (strong,nonatomic) JMStaticContentTableViewController *detailControllerMisc;
@property (strong,nonatomic) RotateTableViewController *detailControllerJudge;
@property (strong,nonatomic) UINavigationController *detailControllerReportNav;
@property (strong,nonatomic) RotateTableViewController *detailControllerMatchDetailReport;
@property (strong,nonatomic) JMStaticContentTableViewController *detailControllerMainMenu;
@property (strong,nonatomic) GameInfo *orgGameInfo;
@property (nonatomic) NSTimeInterval currentRemainTime;
@property (strong,nonatomic) UIButton *btnRestartServer;
@property (nonatomic) NSInteger showingTabIndex;

- (IBAction)touchSaveButton;
- (IBAction)cancelSave;
-(void) bindSettingGroupData:(int)group;
-(void)endMatch;
-(void)refreshDatasource;
-(void)bindAllInfo;
@end