//
//  PEDFirstViewController.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"
#import "V8HorizontalPickerViewProtocol.h"
#import "PEDUIBaseViewController.h"

@interface PEDBarchartViewController : PEDUIBaseViewController<CPTPlotDataSource,V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>
{
@private
    CPTXYGraph *barChart;
    NSTimer *timer;
    NSMutableArray *monthArray;
    NSMutableArray *dayArray;
    NSInteger dayRemark;
    NSMutableDictionary *statisticsData;
    NSMutableArray *barIdArray;
    BOOL isLargeView;
    NSMutableArray *tempControlPool;
    NSDate *referenceDate;
}

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *graphicHostView;
@property (strong, nonatomic) IBOutlet V8HorizontalPickerView *monthSelectView;
@property (readwrite, retain, nonatomic) NSTimer *timer;
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