//
//  GameSetting.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/10.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFPickerView.h"

#define klblCellTag 1
#define ktxtFieldTag 2
#define kMiniuteComponent 1
#define kSecondComponent   0

@class  TPKeyboardAvoidingScrollView;

@interface GameSettingViewController : UIViewController<AFPickerViewDataSource, AFPickerViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    int minutes;
}
@property (nonatomic,retain) IBOutlet TPKeyboardAvoidingScrollView *settingView;
@property (retain, nonatomic) IBOutlet UITextField *txtGameName;
@property (retain, nonatomic) IBOutlet UITextField *txtGameDesc;
@property (retain, nonatomic) IBOutlet UITextField *txtRedSideName;
@property (retain, nonatomic) IBOutlet UITextField *txtRedSidePlace;
@property (retain, nonatomic) IBOutlet UITextField *txtblueSideName;
@property (retain, nonatomic) IBOutlet UITextField *txtBlueSidePlace;
@property (retain, nonatomic) IBOutlet UISwitch *sldPsw;
@property (retain, nonatomic) IBOutlet UITextField *txtPwd;
@property (retain, nonatomic) IBOutlet AFPickerView *selRoundTime;
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)chgUsagePwd:(id)sender;
- (IBAction)StartGame:(id)sender;
- (IBAction)backToSeverList:(id)sender;
- (IBAction)showTimePicker:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *roundTime;
@property (retain, nonatomic) IBOutlet UITextField *roundCount;
@end
