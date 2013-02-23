//
//  PEDSecondViewController.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEDUserSettingViewController : UIViewController<UITextFieldDelegate>{
    UITextField *txtUserName;
    UITextField *txtStride;
    UITextField *txtHeight;
    UITextField *txtWeight;
    UITextField *txtAge;
    UISegmentedControl* segUnit;
    UISegmentedControl* segGender;
    UILabel *unitSegTitleLeft;
    UILabel *unitSegTitleRight;
    UILabel *genderSegTitleLeft;
    UILabel *genderSegTitleRight;
}

@property (weak, nonatomic) IBOutlet UIButton *btnSetting;
@property (weak, nonatomic) IBOutlet UIButton *btnContactUs;
@property (weak, nonatomic) IBOutlet UIButton *btnHomePage;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (weak, nonatomic) IBOutlet UILabel *heightUnit;

- (IBAction)settingClick:(id)sender;
- (IBAction)contactUsClick:(id)sender;
- (IBAction)homePageClick:(id)sender;
- (IBAction)confirmClick:(id)sender;

@end
