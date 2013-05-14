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
    
	[self initMonthSelectorWithX:0 Height:331.f];
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPedoDetailOfNextDate:)];   
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];   
    [self.viewPedoContainView addGestureRecognizer:rightRecognizer];
    
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
        referenceDate=date;
        if(referenceDate==nil)
            referenceDate=[NSDate date];
        PEDSleepData *currSleepData = [[BO_PEDSleepData getInstance] getWithTarget:[AppConfig getInstance].settings.target.targetId withDate:referenceDate];
        PEDUserInfo *userInfo = [AppConfig getInstance].settings.userInfo;
        if(!currSleepData){
            currSleepData=[[PEDSleepData alloc] init];
            currSleepData.optDate=referenceDate;
        }
        lblLastUpdate.text = [UtilHelper formateDate:[[BO_PEDSleepData getInstance] getLastUpdateDate:[AppConfig getInstance].settings.target.targetId] withFormat:@"dd/MM/yy"];
        lblUserName.text = userInfo.userName;
        lblCurrDay.text = [UtilHelper formateDate:currSleepData.optDate withFormat:@"dd/MM/yy"];    
        int h, m, s;
        h = (int)currSleepData.actualSleepTime / 3600;
        m = (int)currSleepData.actualSleepTime % 3600 / 60;
        s = (int)currSleepData.actualSleepTime % 3600 % 60;
        m = m + round(s/60);
        lblHour4ActualSleepTime.text = [NSString stringWithFormat:@"%d", h];
        lblMinute4ActualSleepTime.text = [NSString stringWithFormat:@"%02d", m];
        lblRemark4TimeToBed.text = [PEDPedometerDataHelper getSleepTimeRemark:currSleepData.timeToBed];
        lblTimeToBeb.text = [PEDPedometerDataHelper getSleepTimeString:currSleepData.timeToBed];
        lblRemark4TimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeRemark:currSleepData.timeToFallSleep];
        lblTimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeString:currSleepData.timeToFallSleep];
        lblTimes.text = [NSString stringWithFormat:@"%.0f", currSleepData.awakenTime];
        lblRemark4WakeUpTime.text = [PEDPedometerDataHelper getSleepTimeRemark:currSleepData.timeToWakeup];
        lblWakeUpTime.text = [PEDPedometerDataHelper getSleepTimeString:currSleepData.timeToWakeup];
        h = (int)currSleepData.inBedTime / 3600;
        m = (int)currSleepData.inBedTime % 3600 / 60;
        s = (int)currSleepData.inBedTime % 3600 % 60;
        m = m + round(s/60);
        lblHour4InBedTime.text = [NSString stringWithFormat:@"%d", h];
        lblMinute4InBedTime.text = [NSString stringWithFormat:@"%02d", m];
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
