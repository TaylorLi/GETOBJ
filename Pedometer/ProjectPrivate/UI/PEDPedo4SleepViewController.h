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
#import "PEDPedoData4SleepViewController.h"

@interface PEDPedo4SleepViewController : PEDUIBaseViewController<V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>{
    
    
}

@property (strong,nonatomic)  NSDate* referenceDate;
@property (strong, nonatomic) PEDPedoData4SleepViewController *pedPedoData4SleepViewController;
@property (strong, nonatomic) IBOutlet V8HorizontalPickerView *monthSelectView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrDay;
@property (weak, nonatomic) IBOutlet UILabel *lblDate4ActualSleepTime;
@property (weak, nonatomic) IBOutlet UILabel *lblHour4ActualSleepTime;
@property (weak, nonatomic) IBOutlet UILabel *lblMinute4ActualSleepTime;
@property (weak, nonatomic) IBOutlet UILabel *lblRemark4TimeToBed;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeToBeb;
@property (weak, nonatomic) IBOutlet UILabel *lblRemark4TimeToFallSleep;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeToFallSleep;
@property (weak, nonatomic) IBOutlet UILabel *lblTimes;
@property (weak, nonatomic) IBOutlet UILabel *lblRemark4WakeUpTime;
@property (weak, nonatomic) IBOutlet UILabel *lblWakeUpTime;
@property (weak, nonatomic) IBOutlet UILabel *lblHour4InBedTime;
@property (weak, nonatomic) IBOutlet UILabel *lblMinute4InBedTime;
@property (strong, nonatomic) IBOutlet UIView *viewPedoContainView;

- (void) initData;
- (void) initDataByDate:(NSDate *) date;

@end
