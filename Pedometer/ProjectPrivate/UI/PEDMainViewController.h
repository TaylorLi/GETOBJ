//
//  PEDSecondViewController.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PEDMainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnFitPlus;
@property (weak, nonatomic) IBOutlet UIButton *btnHealthPlus;
@property (weak, nonatomic) IBOutlet UIButton *btnSportPlus;


- (IBAction)fitPlusClick:(id)sender;
- (IBAction)healthPlusClick:(id)sender;
- (IBAction)sportPlusClick:(id)sender;
- (IBAction)settingClick:(id)sender;
- (IBAction)contactUsClick:(id)sender;
- (IBAction)homePageClick:(id)sender;
@end
