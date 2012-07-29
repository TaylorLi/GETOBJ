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
@property (nonatomic,strong) IBOutlet TPKeyboardAvoidingScrollView *settingView;
@property (strong, nonatomic) IBOutlet UITextField *txtGameName;
@property (strong, nonatomic) IBOutlet UITextField *txtGameDesc;
@property (strong, nonatomic) IBOutlet UITextField *txtRedSideName;
@property (strong, nonatomic) IBOutlet UITextField *txtRedSidePlace;
@property (strong, nonatomic) IBOutlet UITextField *txtblueSideName;
@property (strong, nonatomic) IBOutlet UITextField *txtBlueSidePlace;
@property (strong, nonatomic) IBOutlet UISwitch *sldPsw;
@property (strong, nonatomic) IBOutlet UITextField *txtPwd;
@property (strong, nonatomic) IBOutlet AFPickerView *selRoundTime;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)chgUsagePwd:(id)sender;
- (IBAction)StartGame:(id)sender;
- (IBAction)backToSeverList:(id)sender;
- (IBAction)showTimePicker:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *roundTime;
@property (strong, nonatomic) IBOutlet UITextField *roundCount;
@end
