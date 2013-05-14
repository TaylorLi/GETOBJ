//
//  PEDBarchart4SleepViewController.h
//  Pedometer
//
//  Created by TaylorLi on 13-5-13.
//
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"
#import "V8HorizontalPickerViewProtocol.h"
#import "PEDUIBaseViewController.h"

@interface PEDBarchart4SleepViewController : PEDUIBaseViewController<CPTPlotDataSource,V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>
{
@private
    CPTXYGraph *barChart;
    NSTimer *timer;
    NSMutableArray *dayArray;
    NSInteger dayRemark;
    NSDate *referenceDate;
    NSMutableDictionary *statisticsData;
    NSMutableArray *barIdArray;
    BOOL isLargeView;
    NSMutableArray *tempControlPool;
    BOOL isFirstLoad;
}

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *graphicHostView;
@property (strong, nonatomic) IBOutlet V8HorizontalPickerView *monthSelectView;
@property (readwrite, retain, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;

@property (weak, nonatomic) IBOutlet UIButton *btnActualSleepTime;
@property (weak, nonatomic) IBOutlet UIButton *btnTimesAwaken;
@property (weak, nonatomic) IBOutlet UIButton *btnInBedTime;

- (IBAction)btnActualSleepTimeClick:(id)sender;
- (IBAction)btnTimesAwakenClick:(id)sender;
- (IBAction)btnInBedTimeClick:(id)sender;

-(void) genBarchart;
-(void) initData;
- (void) initDataByDate:(NSDate *) date;

@end
