//
//  PEDSecondViewController.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PEDUserSettingViewController : UIViewController<UITextFieldDelegate, MFMailComposeViewControllerDelegate>{
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
@property (weak, nonatomic) IBOutlet UITextField *txbUserName;
@property (weak, nonatomic) IBOutlet UITextField *txbStride;
@property (weak, nonatomic) IBOutlet UITextField *txbHeight;
@property (weak, nonatomic) IBOutlet UITextField *txbWeight;
@property (weak, nonatomic) IBOutlet UITextField *txbAge;

- (IBAction)settingClick:(id)sender;
- (IBAction)contactUsClick:(id)sender;
- (IBAction)homePageClick:(id)sender;
- (IBAction)confirmClick:(id)sender;
@end
