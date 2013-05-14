//
//  PEDGraphs4SleepViewController.h
//  Pedometer
//
//  Created by TaylorLi on 13-5-13.
//
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>
#import "PEDUIBaseViewController.h"

@interface PEDGraphs4SleepViewController : PEDUIBaseViewController<CPTPlotDataSource, CPTAxisDelegate>
{
    CPTXYGraph *graph;
    
    NSMutableArray *dataForPlot;
    NSMutableArray *dayArray;
    NSInteger dayRemark;
    NSDate *referenceDate;
    NSMutableDictionary *statisticsData;
    NSMutableArray *barIdArray;
    BOOL isLargeView;
    NSMutableArray *tempControlPool;
    BOOL isFirstLoad;
}


@property (readwrite, retain, nonatomic) NSMutableArray *dataForPlot;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *cptGraphHostingView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;


@property (weak, nonatomic) IBOutlet UIButton *btnActualSleepTime;
@property (weak, nonatomic) IBOutlet UIButton *btnTimesAwaken;
@property (weak, nonatomic) IBOutlet UIButton *btnInBedTime;

- (IBAction)btnActualSleepTimeClick:(id)sender;
- (IBAction)btnTimesAwakenClick:(id)sender;
- (IBAction)btnInBedTimeClick:(id)sender;

-(void) genCurvechart;
-(void) initData;
- (void) initDataByDate:(NSDate *) date;
@end
