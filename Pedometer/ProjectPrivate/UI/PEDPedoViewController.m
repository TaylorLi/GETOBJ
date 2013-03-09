//
//  PEDSecondViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDPedoViewController.h"
#import "PEDPedoDataViewController.h"
#import "PEDPedometerData.h"
#import "BO_PEDPedometerData.h"
#import "UtilHelper.h"
#import "PEDPedometerCalcHelper.h"
#import "PEDPedometerDataHelper.h"

@interface PEDPedoViewController ()

-(void)showPedoDetailOfNextDate:(UITapGestureRecognizer*)recognizer ;
-(void) showPedoDetailOfPrevDate:(UITapGestureRecognizer*)recognizer;
- (void) initDataByDate:(NSDate *) date;
@end

@implementation PEDPedoViewController
@synthesize pedPedoDataViewController;
@synthesize monthSelectView;
@synthesize lblUserName;
@synthesize lblLastUpdate;
@synthesize lblCurrDay;
@synthesize lblStepAmount;
@synthesize lblDistanceAmount;
@synthesize lblDistanceUnit;
@synthesize lblCaloriesAmount;
@synthesize lblActivityTime;
@synthesize lblSpeedAmount;
@synthesize lblSpeedUnit;
@synthesize lblPaceAmount;
@synthesize lblPaceUnit;
@synthesize viewPedoContainView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        monthArray = [NSMutableArray arrayWithObjects:@"JUN,12", @"JUL,12", @"AUG,12", @"SEP,12", @"OCT,12", @"NOV,12", @"DEC,12", nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self initMonthSelectorWithX:0 Height:331.f];
    
    [self initData];
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPedoDetailOfNextDate:)];   
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];   
    [self.viewPedoContainView addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPedoDetailOfPrevDate:)];   
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];   
    [self.viewPedoContainView addGestureRecognizer:leftRecognizer];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setLblUserName:nil];
    [self setLblLastUpdate:nil];
    [self setLblCurrDay:nil];
    [self setLblStepAmount:nil];
    [self setLblDistanceAmount:nil];
    [self setLblDistanceUnit:nil];
    [self setLblCaloriesAmount:nil];
    [self setLblActivityTime:nil];
    [self setLblSpeedAmount:nil];
    [self setLblSpeedUnit:nil];
    [self setLblPaceAmount:nil];
    [self setLblPaceUnit:nil];
    [self setViewPedoContainView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.navigationController.navigationBarHidden){
        self.navigationController.navigationBar.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//-(void) dayStatisticsClick{
//    PEDPedoDataViewController *pedPedoDataViewController = [[PEDPedoDataViewController alloc]init];
//    [self.navigationController pushViewController:pedPedoDataViewController animated:YES];
//    //[self.view insertSubview:pedPedoDataViewController.view atIndex:0];
//    //    [self.navigationController presentModalViewController:pedPedoDataViewController animated:YES];
//    //   [self presentModalViewController:pedPedoDataViewController animated:NO]; 
//}

- (void) initData
{
    NSDate *lastUploadDate = [[BO_PEDPedometerData getInstance] getLastUploadDate:[AppConfig getInstance].settings.target.targetId];
    [self initDataByDate:lastUploadDate];
}

- (void) initDataByDate:(NSDate *) date{
    referenceDate=date;
    if(referenceDate==nil)
        referenceDate=[NSDate date];
    PEDPedometerData *currPedometerData = [[BO_PEDPedometerData getInstance] getWithTarget:[AppConfig getInstance].settings.target.targetId withDate:referenceDate];
    PEDUserInfo *userInfo = [AppConfig getInstance].settings.userInfo;
    if(!currPedometerData){
        currPedometerData=[[PEDPedometerData alloc] init];
        currPedometerData.optDate=referenceDate;
    }
    lblLastUpdate.text = [UtilHelper formateDate:[[BO_PEDPedometerData getInstance] getLastUpdateDate:[AppConfig getInstance].settings.target.targetId] withFormat:@"dd/MM/yy"];
    lblUserName.text = userInfo.userName;
    lblCurrDay.text = [UtilHelper formateDate:currPedometerData.optDate withFormat:@"dd/MM/yy"];        
    lblStepAmount.text = [NSString stringWithFormat:@"%i", currPedometerData.step];
    
    int h, m, s;
    h = (int)currPedometerData.activeTime / 3600;
    m = (int)currPedometerData.activeTime % 3600 / 60;
    s = (int)currPedometerData.activeTime % 3600 % 60;
    NSTimeInterval distance = userInfo.measureFormat == MEASURE_UNIT_METRIC ? currPedometerData.distance : [PEDPedometerCalcHelper convertKmToMile:currPedometerData.distance];
    lblActivityTime.text = [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
    lblCaloriesAmount.text = [NSString stringWithFormat:@"%.0f", currPedometerData.calorie];
    lblDistanceAmount.text = [NSString stringWithFormat:@"%.1f", distance];
    lblSpeedAmount.text = [NSString stringWithFormat:@"%.1f", [PEDPedometerCalcHelper calAvgSpeedByDistance:currPedometerData.distance inTime:currPedometerData.activeTime withMeasureUnit:userInfo.measureFormat]];
    lblPaceAmount.text = [NSString stringWithFormat:@"%.1f", [PEDPedometerCalcHelper calAvgPaceByDistance:currPedometerData.distance inTime:currPedometerData.activeTime withMeasureUnit:userInfo.measureFormat]];
    lblDistanceUnit.text = [PEDPedometerCalcHelper getDistanceUnit:userInfo.measureFormat withWordFormat:YES];
    lblSpeedUnit.text = [NSString stringWithFormat:@"%@/hr", [PEDPedometerCalcHelper getDistanceUnit:userInfo.measureFormat withWordFormat:YES]];
    lblPaceUnit.text = [NSString stringWithFormat:@"Min/%@", [PEDPedometerCalcHelper getDistanceUnit:userInfo.measureFormat withWordFormat:YES]];    
    [self reloadPickerToMidOfDate:referenceDate];    
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    NSDate *date =  [UtilHelper convertDate:[NSString stringWithFormat:@"01 %@", [monthArray objectAtIndex:index]] withFormat:@"dd MMM yyyy"];
    if(index!=3){        
        [self reloadPickerToMidOfDate:date];
    }
    NSDate *dateTo=[date addMonths:1];
    if([referenceDate timeIntervalSinceDate:dateTo]<0 &&[referenceDate timeIntervalSinceDate:date]>=0){
    }
    else{
        //判断是否属于同一个月，不是的话跳到指定月份
        NSDate *selectDate=[[BO_PEDPedometerData getInstance] getLastDateWithTarget:[AppConfig getInstance].settings.target.targetId between:date to:dateTo];
        if(selectDate)
            [self initDataByDate:selectDate];
    }
}

-(void)horizontalPickerView:(V8HorizontalPickerView *)picker didDoubleClickElementAtIndex:(NSInteger)index {
    NSLog(@"----%d", index);
    if(pedPedoDataViewController == nil){
        pedPedoDataViewController = [[PEDPedoDataViewController alloc]init];
    }
    // pedPedoDataViewController.dayRemark = index;
    NSDate *dateFrom =  [UtilHelper convertDate:[NSString stringWithFormat:@"01 %@", [monthArray objectAtIndex:index]] withFormat:@"dd MMM yyyy"];
    NSDate *dateTo=[dateFrom addMonths:1];
    NSDate *selectedDate;
    if([referenceDate timeIntervalSinceDate:dateTo]<0 &&[referenceDate timeIntervalSinceDate:dateFrom]>=0){
        //
        selectedDate=referenceDate;
    }
    else{
        //不属于同一个月，不是的话跳到指定月份
        NSDate *selectDate=[[BO_PEDPedometerData getInstance] getLastDateWithTarget:[AppConfig getInstance].settings.target.targetId between:dateFrom to:dateTo];
        if(selectDate)
            selectedDate=selectDate;
        else{
            NSDate *lastUploadDate = [[BO_PEDPedometerData getInstance] getLastUploadDate:[AppConfig getInstance].settings.target.targetId];
            
            selectedDate=lastUploadDate?lastUploadDate:[NSDate date];
        }
    }
    
    [pedPedoDataViewController initDataByDate:selectedDate];
    [self.navigationController pushViewController:pedPedoDataViewController animated:YES];
}


-(void)showPedoDetailOfNextDate:(UITapGestureRecognizer*)recognizer 
{
    NSDate* nextDate =  [[BO_PEDPedometerData getInstance] getNextOptDate:referenceDate withTarget:[AppConfig getInstance].settings.target.targetId];
    if(nextDate==nil)
        return;
    [self initDataByDate:nextDate];
}
-(void) showPedoDetailOfPrevDate:(UITapGestureRecognizer*)recognizer 
{
    NSDate *previosDate =   [[BO_PEDPedometerData getInstance] getPreviosOptDate:referenceDate withTarget:[AppConfig getInstance].settings.target.targetId];
    if(previosDate==nil)
        return;
    [self initDataByDate:previosDate];
}
@end
