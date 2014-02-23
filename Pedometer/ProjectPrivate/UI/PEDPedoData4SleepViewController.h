//
//  PEDPedoData4SleepViewController.h
//  Pedometer
//
//  Created by Yuheng Li on 13-5-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"
#import "V8HorizontalPickerViewProtocol.h"
#import "UAModalPanel.h"
#import "DialogBoxContainer.h"
#import "PEDUIBaseViewController.h"
#import "AFPickerView.h"
#import "PEDPedoDataRowView4Sleep.h"

@interface PEDPedoData4SleepViewController : PEDUIBaseViewController<UAModalPanelDelegate,DialogBoxDelegate,AFPickerViewDataSource, AFPickerViewDelegate>
{
    DialogBoxContainer *regPannel;    
    NSArray *daysData;
    int showDataRowsCount;
}


//@property (weak, nonatomic) IBOutlet UIImageView *imgVDataTop;

//@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;
//@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDate4ActualSleepTime;
@property (weak, nonatomic) IBOutlet UILabel *lblHour4ActualSleepTime;
@property (weak, nonatomic) IBOutlet UILabel *lblMinute4ActualSleepTime;
@property (weak, nonatomic) IBOutlet UILabel *lblRemark4TimeToBed;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeToBed;
@property (weak, nonatomic) IBOutlet UILabel *lblRemark4TimeToFallSleep;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeToFallSleep;
@property (weak, nonatomic) IBOutlet UILabel *lblTimesAwaken;

//@property (weak, nonatomic) IBOutlet UILabel *lblPrevDate;
//@property (weak, nonatomic) IBOutlet UILabel *lblPrevHour4ActualSleepTime;
//@property (weak, nonatomic) IBOutlet UILabel *lblPrevMinute4ActualSleepTime;
//@property (weak, nonatomic) IBOutlet UILabel *lblPrevRemark4TimeToBed;
//@property (weak, nonatomic) IBOutlet UILabel *lblPrevTimeToBed;
//@property (weak, nonatomic) IBOutlet UILabel *lblPrevRemark4TimeToFallSleep;
//@property (weak, nonatomic) IBOutlet UILabel *lblPrevTimeToFallSleep;
//@property (weak, nonatomic) IBOutlet UILabel *lblPrevTimesAwaken;
//@property (weak, nonatomic) IBOutlet UILabel *lblPrevRemark4Hour;
//@property (weak, nonatomic) IBOutlet UILabel *lblPrevRemark4Minute;
//
//@property (weak, nonatomic) IBOutlet UILabel *lblCurrDate;
//@property (weak, nonatomic) IBOutlet UILabel *lblCurrHour4ActualSleepTime;
//@property (weak, nonatomic) IBOutlet UILabel *lblCurrMinute4ActualSleepTime;
//@property (weak, nonatomic) IBOutlet UILabel *lblCurrRemark4TimeToBed;
//@property (weak, nonatomic) IBOutlet UILabel *lblCurrTimeToBed;
//@property (weak, nonatomic) IBOutlet UILabel *lblCurrRemark4TimeToFallSleep;
//@property (weak, nonatomic) IBOutlet UILabel *lblCurrTimeToFallSleep;
//@property (weak, nonatomic) IBOutlet UILabel *lblCurrTimesAwaken;
//@property (weak, nonatomic) IBOutlet UILabel *lblCurrRemark4Hour;
//@property (weak, nonatomic) IBOutlet UILabel *lblCurrRemark4Minute;
//
//@property (weak, nonatomic) IBOutlet UILabel *lblNextDate;
//@property (weak, nonatomic) IBOutlet UILabel *lblNextHour4ActualSleepTime;
//@property (weak, nonatomic) IBOutlet UILabel *lblNextMinute4ActualSleepTime;
//@property (weak, nonatomic) IBOutlet UILabel *lblNextRemark4TimeToBed;
//@property (weak, nonatomic) IBOutlet UILabel *lblNextTimeToBed;
//@property (weak, nonatomic) IBOutlet UILabel *lblNextRemark4TimeToFallSleep;
//@property (weak, nonatomic) IBOutlet UILabel *lblNextTimeToFallSleep;
//@property (weak, nonatomic) IBOutlet UILabel *lblNextTimesAwaken;
//@property (weak, nonatomic) IBOutlet UILabel *lblNextRemark4Hour;
//@property (weak, nonatomic) IBOutlet UILabel *lblNextRemark4Minute;


@property (nonatomic,strong) NSDate *referenceDate;
@property (strong, nonatomic) IBOutlet AFPickerView *dayPickerView;
@property (strong,nonatomic) NSMutableArray *showDataRows;


//<V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>{
//    NSMutableArray *monthArray;
//}
//@property (strong, nonatomic) IBOutlet V8HorizontalPickerView *monthSelectView;
- (IBAction)btnPrevDataClick:(id)sender;
- (IBAction)btnNextDataClick:(id)sender;

- (void) initData;
- (void) initDataByDate:(NSDate *) date;
@end
