//
//  PEDSecondViewController.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>
#import "PEDUIBaseViewController.h"

@interface PEDGraphsViewController : PEDUIBaseViewController<CPTPlotDataSource, CPTAxisDelegate>
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

-(void)timerFired;
@end
