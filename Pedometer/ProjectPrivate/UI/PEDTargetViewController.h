//
//  PEDSecondViewController.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEDTargetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;
@property (weak, nonatomic) IBOutlet UILabel *lblStepTarget;
@property (weak, nonatomic) IBOutlet UILabel *lblStepAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblStepRemain;
@property (weak, nonatomic) IBOutlet UIImageView *imgVStep;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceTarget;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceRemain;
@property (weak, nonatomic) IBOutlet UIImageView *imgVDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblCaloriesTarget;
@property (weak, nonatomic) IBOutlet UILabel *lblCaloriesAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblCaloriesRemain;
@property (weak, nonatomic) IBOutlet UIImageView *imgVCalories;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;

- (CGFloat)percentOfTarget:(CGFloat) target withRemain:(CGFloat) remain;
- (void) initData;
@end
