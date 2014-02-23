//
//  PEDPedo4SleepViewController.m
//  Pedometer
//
//  Created by Yuheng Li on 13-5-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDPedo4SleepViewController.h"
#import "PEDPedoData4SleepViewController.h"
#import "PEDSleepData.h"
#import "BO_PEDSleepData.h"
#import "UtilHelper.h"
#import "PEDPedometerCalcHelper.h"
#import "PEDPedometerDataHelper.h"
#import "PEDAppDelegate.h"


@interface PEDPedo4SleepViewController ()

-(void)showPedoDetailOfNextDate:(UITapGestureRecognizer*)recognizer ;
-(void) showPedoDetailOfPrevDate:(UITapGestureRecognizer*)recognizer;

@end

@implementation PEDPedo4SleepViewController
@synthesize referenceDate;
@synthesize pedPedoData4SleepViewController;
@synthesize monthSelectView;
@synthesize lblUserName;
@synthesize lblLastUpdate;
@synthesize lblCurrDay;
@synthesize lblDate4ActualSleepTime;
@synthesize lblHour4ActualSleepTime;
@synthesize lblMinute4ActualSleepTime;
@synthesize lblRemark4TimeToBed;
@synthesize lblTimeToBeb;
@synthesize lblRemark4TimeToFallSleep;
@synthesize lblTimeToFallSleep;
@synthesize lblTimes;
@synthesize lblRemark4WakeUpTime;
@synthesize lblWakeUpTime;
@synthesize lblHour4InBedTime;
@synthesize lblMinute4InBedTime;
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
    
    [self initMonthSelectorWithX:60.f Height:64.f isForPedo:NO];
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPedoDetailOfNextDate:)];   
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];   
    [self.viewPedoContainView addGestureRecognizer:rightRecognizer];
    
    UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swithToPedoDateListView:)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    [self.viewPedoContainView addGestureRecognizer:doubleRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPedoDetailOfPrevDate:)];   
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];   
    [self.viewPedoContainView addGestureRecognizer:leftRecognizer];
    [self initData];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setLblUserName:nil];
    [self setLblLastUpdate:nil];
    [self setLblCurrDay:nil];
    [self setViewPedoContainView:nil];
    [self setLblHour4ActualSleepTime:nil];
    [self setLblMinute4ActualSleepTime:nil];
    [self setLblRemark4TimeToBed:nil];
    [self setLblTimeToBeb:nil];
    [self setLblRemark4TimeToFallSleep:nil];
    [self setLblTimeToFallSleep:nil];
    [self setLblTimes:nil];
    [self setLblRemark4WakeUpTime:nil];
    [self setLblWakeUpTime:nil];
    [self setLblHour4InBedTime:nil];
    [self setLblMinute4InBedTime:nil];
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
    NSDate *lastUploadDate = [[BO_PEDSleepData getInstance] getLastUploadDate:[AppConfig getInstance].settings.target.targetId];
    [self initDataByDate:lastUploadDate];
}

- (void) initDataByDate:(NSDate *) date{
    @try {
        if(date==nil){
            if(referenceDate==nil)
                referenceDate=[NSDate date];
        }
        else
            referenceDate=date;
        PEDSleepData *currSleepData = [[BO_PEDSleepData getInstance] getWithTarget:[AppConfig getInstance].settings.target.targetId withDate:referenceDate];
        //PEDUserInfo *userInfo = [AppConfig getInstance].settings.userInfo;
        if(!currSleepData){
            currSleepData=[[PEDSleepData alloc] init];
            currSleepData.optDate=referenceDate;
        }
//        lblLastUpdate.text = [UtilHelper formateDate:[[BO_PEDSleepData getInstance] getLastUpdateDate:[AppConfig getInstance].settings.target.targetId] withFormat:@"dd/MM/yy"];
        //lblUserName.text = userInfo.userName;
        lblCurrDay.text = [UtilHelper formateDate:currSleepData.optDate withFormat:@"dd/MM/yy"];
        [lblCurrDay setFont:[UIFont fontWithName:USE_DEFAULT_FONT size:11.f]];
        lblDate4ActualSleepTime.text = [UtilHelper formateDate:currSleepData.optDate withFormat:@"dd/MM/yy"];
        [lblDate4ActualSleepTime setFont:[UIFont fontWithName:USE_DEFAULT_FONT size:11.f]];
        int h, m, s;
        h = (int)currSleepData.actualSleepTime / 3600;
        m = (int)currSleepData.actualSleepTime % 3600 / 60;
        s = (int)currSleepData.actualSleepTime % 3600 % 60;
        m = m + round(s/60);
        lblHour4ActualSleepTime.text = [NSString stringWithFormat:@"%d", h];
        [lblHour4ActualSleepTime setFont:[UIFont fontWithName:USE_DEFAULT_FONT size:33.f]];
        lblMinute4ActualSleepTime.text = [NSString stringWithFormat:@"%02d", m];
        [lblMinute4ActualSleepTime setFont:[UIFont fontWithName:USE_DEFAULT_FONT size:33.f]];
        lblRemark4TimeToBed.text = [PEDPedometerDataHelper getSleepTimeRemark:currSleepData.timeToBed];
        [lblRemark4TimeToBed setFont:[UIFont fontWithName:USE_DEFAULT_FONT size:21.f]];
        lblTimeToBeb.text = [PEDPedometerDataHelper getSleepTimeString:currSleepData.timeToBed];
        [lblTimeToBeb setFont:[UIFont fontWithName:USE_DEFAULT_FONT size:32.f]];
        lblRemark4TimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeRemark:currSleepData.timeToFallSleep];
        [lblRemark4TimeToFallSleep setFont:[UIFont fontWithName:USE_DEFAULT_FONT size:15.f]];
        lblTimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeString:currSleepData.timeToFallSleep];
        [lblTimeToFallSleep setFont:[UIFont fontWithName:USE_DEFAULT_FONT size:25.f]];
        lblTimes.text = [NSString stringWithFormat:@"%.0f", currSleepData.awakenTime];
        [lblTimes setFont:[UIFont fontWithName:USE_DEFAULT_FONT size:26.f]];
        lblRemark4WakeUpTime.text = [PEDPedometerDataHelper getSleepTimeRemark:currSleepData.timeToWakeup];
        [lblRemark4WakeUpTime setFont:[UIFont fontWithName:USE_DEFAULT_FONT size:16.f]];
        lblWakeUpTime.text = [PEDPedometerDataHelper getSleepTimeString:currSleepData.timeToWakeup];
        [lblWakeUpTime setFont:[UIFont fontWithName:USE_DEFAULT_FONT size:24.f]];
        h = (int)currSleepData.inBedTime / 3600;
        m = (int)currSleepData.inBedTime % 3600 / 60;
        s = (int)currSleepData.inBedTime % 3600 % 60;
        m = m + round(s/60);
        lblHour4InBedTime.text = [NSString stringWithFormat:@"%d", h];
        [lblHour4InBedTime setFont:[UIFont fontWithName:USE_DEFAULT_FONT size:20.f]];
        lblMinute4InBedTime.text = [NSString stringWithFormat:@"%02d", m];
        [lblMinute4InBedTime setFont:[UIFont fontWithName:USE_DEFAULT_FONT size:20.f]];
        [self reloadPickerToMidOfDate:referenceDate];    
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    @try {
        NSDate *date =  [UtilHelper convertDate:[NSString stringWithFormat:@"01 %@", [monthArray objectAtIndex:index]] withFormat:@"dd MMM yyyy"];
        if(index!=3){        
            [self reloadPickerToMidOfDate:date];
        }
        NSDate *dateTo=[date addMonths:1];
        if([referenceDate timeIntervalSinceDate:dateTo]<0 &&[referenceDate timeIntervalSinceDate:date]>=0){
        }
        else{
            //判断是否属于同一个月，不是的话跳到指定月份
            NSDate *selectDate=[[BO_PEDSleepData getInstance] getLastDateWithTarget:[AppConfig getInstance].settings.target.targetId between:date to:dateTo];
            if(selectDate)
                [self initDataByDate:selectDate];
            else{
                [self initDataByDate:date];
            }
        }
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
}

-(void)horizontalPickerView:(V8HorizontalPickerView *)picker didDoubleClickElementAtIndex:(NSInteger)index {
    @try {
        //log4Info(@"----%d", index);
        if([PEDAppDelegate getInstance].sleepPedoDataViewController == nil){
            [PEDAppDelegate getInstance].sleepPedoDataViewController = [[PEDPedoData4SleepViewController alloc]init];
        }
        pedPedoData4SleepViewController = [PEDAppDelegate getInstance].sleepPedoDataViewController;
        
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
            NSDate *selectDate=[[BO_PEDSleepData getInstance] getLastDateWithTarget:[AppConfig getInstance].settings.target.targetId between:dateFrom to:dateTo];
            if(selectDate)
                selectedDate=selectDate;
            else{
                NSDate *lastUploadDate = [[BO_PEDSleepData getInstance] getLastUploadDate:[AppConfig getInstance].settings.target.targetId];
                
                selectedDate=lastUploadDate?lastUploadDate:[NSDate date];
            }
        }    
        pedPedoData4SleepViewController.controlContainer=self.controlContainer;
        [self.navigationController pushViewController:pedPedoData4SleepViewController animated:YES];
        [pedPedoData4SleepViewController initDataByDate: selectedDate];
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
}

- (IBAction)swithToPedoDateListView:(id)sender
{
    if([PEDAppDelegate getInstance].sleepPedoDataViewController == nil){
        [PEDAppDelegate getInstance].sleepPedoDataViewController = [[PEDPedoData4SleepViewController alloc] init];
    }
    pedPedoData4SleepViewController = [PEDAppDelegate getInstance].sleepPedoDataViewController;
    pedPedoData4SleepViewController.controlContainer=self.controlContainer;
    pedPedoData4SleepViewController.referenceDate=referenceDate;
    [self.navigationController pushViewController:pedPedoData4SleepViewController animated:YES];
}

-(void)showPedoDetailOfNextDate:(UITapGestureRecognizer*)recognizer
{
    //NSDate* nextDate =  [[BO_PEDPedometerData getInstance] getNextOptDate:referenceDate withTarget:[AppConfig getInstance].settings.target.targetId];
    NSDate* nextDate=[referenceDate addDays:1];
    if([nextDate timeIntervalSinceNow]>0)
        nextDate=nil;
    if(nextDate==nil)
        return;
    [self initDataByDate:nextDate];
}
-(void) showPedoDetailOfPrevDate:(UITapGestureRecognizer*)recognizer 
{
    //NSDate *previosDate =   [[BO_PEDPedometerData getInstance] getPreviosOptDate:referenceDate withTarget:[AppConfig getInstance].settings.target.targetId];
    NSDate *previosDate=[referenceDate addDays:-1];
    if(previosDate==nil)
        return;
    [self initDataByDate:previosDate];
}
@end
