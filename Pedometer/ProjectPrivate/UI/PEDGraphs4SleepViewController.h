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

@interface PEDGraphs4SleepViewController : UIViewController
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
@property (weak, nonatomic) IBOutlet UIButton *btnActTime;
@property (weak, nonatomic) IBOutlet UIButton *btnStep;
@property (weak, nonatomic) IBOutlet UIButton *btnDistance;
@property (weak, nonatomic) IBOutlet UIButton *btnAvgSpeed;
@property (weak, nonatomic) IBOutlet UIButton *btnCalories;
@property (weak, nonatomic) IBOutlet UIButton *btnAvgPace;

- (IBAction)btnSetpClick:(id)sender;
- (IBAction)btnActTimeClick:(id)sender;
- (IBAction)btnDistanceClick:(id)sender;
- (IBAction)btnCaloriesClick:(id)sender;
- (IBAction)btnAvgSpeedClick:(id)sender;
- (IBAction)btnAvgPaceClick:(id)sender;

-(void) genCurvechart;
-(void) initData;
- (void) initDataByDate:(NSDate *) date;
@end
