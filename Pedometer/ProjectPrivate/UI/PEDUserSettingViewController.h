//
//  PEDSecondViewController.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "GETUIScrollInputView.h"
#import "PickerExtendView.h"

#define kFeetComponent 0
#define kInchComponent 1

@interface PEDUserSettingViewController : GETUIScrollInputView<MFMailComposeViewControllerDelegate,PickerExtendViewDelegate, PickerExtendViewDataSource>{
    UISegmentedControl* segUnit;
    UISegmentedControl* segGender;
    UILabel *unitSegTitleLeft;
    UILabel *unitSegTitleRight;
    UILabel *genderSegTitleLeft;
    UILabel *genderSegTitleRight;
    NSTimeInterval cacheHeight;
    PEDUserInfo *cacheUserInfo4Metric;
    PEDUserInfo *cacheUserInfo4English;
    MeasureUnit  currentUnit;
}
@property (weak, nonatomic) IBOutlet UILabel *lblStrideUnit;
@property (weak, nonatomic) IBOutlet UILabel *lblWeightUnit;

@property (weak, nonatomic) IBOutlet UILabel *lblHeightUnit;


@property (weak, nonatomic) IBOutlet UITextField *txbUserName;
@property (weak, nonatomic) IBOutlet UITextField *txbStride;
@property (weak, nonatomic) IBOutlet UITextField *txbHeight;
@property (weak, nonatomic) IBOutlet UITextField *txbWeight;
@property (weak, nonatomic) IBOutlet UITextField *txbAge;
@property (weak,nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak,nonatomic) IBOutlet UIButton *genderImage;
@property (strong, nonatomic) IBOutlet PickerExtendView *pvInchFeet;

- (IBAction)settingClick:(id)sender;
- (IBAction)contactUsClick:(id)sender;
- (IBAction)homePageClick:(id)sender;
- (IBAction)confirmClick:(id)sender;
@end
