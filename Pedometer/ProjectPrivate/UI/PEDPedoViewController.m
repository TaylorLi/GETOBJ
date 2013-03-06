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


- (void) initData{
    PEDPedometerData *currPedometerData = [[BO_PEDPedometerData getInstance] getLastUploadData:[AppConfig getInstance].settings.target.targetId];
    PEDUserInfo *userInfo = [AppConfig getInstance].settings.userInfo;
    lblLastUpdate.text = [UtilHelper formateDate:currPedometerData.optDate withFormat:@"dd/MM/yy"];
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
    
    [self reloadPickerToMidOfDate:currPedometerData.optDate];
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    if(index!=3){
        NSDate *date =  [UtilHelper convertDate:[NSString stringWithFormat:@"01 %@", [monthArray objectAtIndex:index]] withFormat:@"dd MMM yyyy"];
        [self reloadPickerToMidOfDate:date];
    }
    pedPedoDataViewController = [[PEDPedoDataViewController alloc]init];
    [self.navigationController pushViewController:pedPedoDataViewController animated:YES];
}

@end
