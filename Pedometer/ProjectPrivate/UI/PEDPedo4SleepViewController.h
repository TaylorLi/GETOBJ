//
//  PEDPedo4SleepViewController.h
//  Pedometer
//
//  Created by Yuheng Li on 13-5-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"
#import "V8HorizontalPickerViewProtocol.h"
#import "PEDUIBaseViewController.h"
#import "PEDPedoDataViewController.h"

@interface PEDPedo4SleepViewController : PEDUIBaseViewController<V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>{
    
    
}

@property (strong,nonatomic)  NSDate* referenceDate;
@property (strong, nonatomic) PEDPedoDataViewController *pedPedoDataViewController;
@property (strong, nonatomic) IBOutlet V8HorizontalPickerView *monthSelectView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrDay;
@property (weak, nonatomic) IBOutlet UILabel *lblStepAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceUnit;
@property (weak, nonatomic) IBOutlet UILabel *lblCaloriesAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblActivityTime;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeedAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeedUnit;
@property (weak, nonatomic) IBOutlet UILabel *lblPaceAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblPaceUnit;
@property (strong, nonatomic) IBOutlet UIView *viewPedoContainView;

- (void) initData;
- (void) initDataByDate:(NSDate *) date;

@end