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

@interface GameSettingDetailControllerHD : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate,SimplePickerInputTableViewCellDelegate,TimePickerTableViewCellDelegate,StringInputTableViewCellDelegate,IntegerInputTableViewCellDelegate> 
{
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    id detailItem;
	UIBarButtonItem *startButton;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *startButton;
@property (strong,nonatomic) JMStaticContentTableViewController *detailController0;
@property (strong,nonatomic) JMStaticContentTableViewController *detailController1;
@property (strong,nonatomic) JMStaticContentTableViewController *detailController2;
@property (strong,nonatomic) JMStaticContentTableViewController *detailController3;
@property (strong,nonatomic) JMStaticContentTableViewController *detailController4;
- (IBAction)touchSaveButton;
-(void) bindSettingGroupData:(int)group;
-(void)resetSetting;

@end