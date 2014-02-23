//
//  PEDPedoData4SleepViewController.m
//  Pedometer
//
//  Created by Yuheng Li on 13-5-13.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDPedoData4SleepViewController.h"
#import "PEDPedo4SleepViewController.h"
#import "PEDAppDelegate.h"
#import "DialogBoxContainer.h"
#import "AppConfig.h"
#import "BO_PEDSleepData.h"
#import "PEDSleepData.h"
#import "PEDPedometerDataHelper.h"
#import "PEDPedoDataRowView4Sleep.h"
@interface PEDPedoData4SleepViewController  ()
{
    
}

-(NSArray *) getPedoDataResourcesWithTargetId:(NSString*) targetId referedDate:(NSDate *) referDate;

-(void)displayPedometerDetailByDate:(NSDate *)date;
-(void)setDatePickerLabelHidden:(BOOL)yes;
@end

@implementation PEDPedoData4SleepViewController

//@synthesize imgVDataTop;
//
//@synthesize lblLastUpdate;
//@synthesize lblUserName;
@synthesize lblDate;
@synthesize lblDate4ActualSleepTime;
@synthesize lblHour4ActualSleepTime;
@synthesize lblMinute4ActualSleepTime;
@synthesize lblRemark4TimeToBed;
@synthesize lblTimeToBed;
@synthesize lblRemark4TimeToFallSleep;
@synthesize lblTimeToFallSleep;
@synthesize lblTimesAwaken;

//@synthesize lblPrevDate;
//@synthesize lblPrevHour4ActualSleepTime;
//@synthesize lblPrevMinute4ActualSleepTime;
//@synthesize lblPrevRemark4TimeToBed;
//@synthesize lblPrevTimeToBed;
//@synthesize lblPrevRemark4TimeToFallSleep;
//@synthesize lblPrevTimeToFallSleep;
//@synthesize lblPrevTimesAwaken;
//@synthesize lblPrevRemark4Minute;
//@synthesize lblPrevRemark4Hour;

//@synthesize lblCurrDate;
//@synthesize lblCurrHour4ActualSleepTime;
//@synthesize lblCurrMinute4ActualSleepTime;
//@synthesize lblCurrRemark4TimeToBed;
//@synthesize lblCurrTimeToBed;
//@synthesize lblCurrRemark4TimeToFallSleep;
//@synthesize lblCurrTimeToFallSleep;
//@synthesize lblCurrTimesAwaken;
//@synthesize lblCurrRemark4Minute;
//@synthesize lblCurrRemark4Hour;
//
//@synthesize lblNextDate;
//@synthesize lblNextHour4ActualSleepTime;
//@synthesize lblNextMinute4ActualSleepTime;
//@synthesize lblNextRemark4TimeToBed;
//@synthesize lblNextTimeToBed;
//@synthesize lblNextRemark4TimeToFallSleep;
//@synthesize lblNextTimeToFallSleep;
//@synthesize lblNextTimesAwaken;
//@synthesize lblNextRemark4Minute;
//@synthesize lblNextRemark4Hour;

@synthesize referenceDate;
@synthesize dayPickerView;
@synthesize showDataRows;
//@synthesize monthSelectView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        UIImage *tabbarImage = [UIImage imageNamed:@"second.png"] ;
        //        UITabBarItem *barItem = [[UITabBarItem alloc]initWithTitle:@"" image:tabbarImage tag:1];
        //        self.tabBarItem = barItem;
        //  monthArray = [NSMutableArray arrayWithObjects:@"JUN,12", @"JUL,12", @"AUG,12", @"SEP,12", @"OCT,12", @"NOV,12", @"DEC,12", nil];
        showDataRowsCount = 3;
        [self initLable];
        
        if(showDataRows==nil){
            showDataRows =[[NSMutableArray alloc] initWithCapacity:showDataRowsCount];
            for(int i=0;i<showDataRowsCount;i++){
                PEDPedoDataRowView4Sleep *row =  [PEDPedoDataRowView4Sleep instanceView:nil];
                row.frame = CGRectMake(50, 333+(i*53), 227.0f, 43.0f);
                [self.view addSubview:row];
                [showDataRows addObject:row];
            }
        }
        dayPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(50.f, 333.f, 227.f, 159.f)];
        dayPickerView.dataSource = self;
        dayPickerView.delegate = self;
        //[dayPickerView reloadData];
        [self.view addSubview:dayPickerView];
        [self initMonthSelectorWithX:55.f Height:298.f];
        //[self initDataByDate:referenceDate];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void) initLable{
//    NSArray *array = [[NSArray alloc] initWithObjects:lblLastUpdate,lblUserName,lblDate,lblHour4ActualSleepTime,lblMinute4ActualSleepTime,lblRemark4TimeToBed,lblTimeToBed,lblRemark4TimeToFallSleep,lblTimeToFallSleep,lblTimesAwaken,lblPrevDate,lblPrevHour4ActualSleepTime,lblPrevMinute4ActualSleepTime,lblPrevRemark4TimeToBed,lblPrevTimeToBed,lblPrevRemark4TimeToFallSleep,lblPrevTimeToFallSleep,lblPrevTimesAwaken,lblCurrDate,lblCurrHour4ActualSleepTime,lblCurrMinute4ActualSleepTime,lblCurrRemark4TimeToBed,lblCurrTimeToBed,lblCurrRemark4TimeToFallSleep,lblCurrTimeToFallSleep,lblCurrTimesAwaken,lblNextDate,lblNextHour4ActualSleepTime,lblNextMinute4ActualSleepTime,lblNextRemark4TimeToBed,lblNextTimeToBed,lblNextRemark4TimeToFallSleep,lblNextTimeToFallSleep,lblNextTimesAwaken,nil];
    NSArray *array = [[NSArray alloc] initWithObjects:lblDate,lblHour4ActualSleepTime,lblMinute4ActualSleepTime,lblRemark4TimeToBed,lblTimeToBed,lblRemark4TimeToFallSleep,lblTimeToFallSleep,lblTimesAwaken,nil];
    for (UILabel *label in array) {
        label.text = @"";
    } 
}

-(void)doubleTap:(UITapGestureRecognizer*)recognizer  
{   if([PEDAppDelegate getInstance].sleepPedoViewController == nil){
    [PEDAppDelegate getInstance].sleepPedoViewController = [[PEDPedo4SleepViewController alloc]init];
}
    [[PEDAppDelegate getInstance].sleepPedoViewController initDataByDate: referenceDate];
    [self.navigationController popViewControllerAnimated:YES];     
}

-(void)handleSwipeUp:(UITapGestureRecognizer*)recognizer  
{  
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationWillStartSelector:@selector(handleSwipeUpStart:)];
    
    [UIView setAnimationDidStopSelector:@selector(handleSwipeUpStop:finished:)];
    
    [UIView setAnimationDelay:0.0f];
    
    [UIView setAnimationDuration:0.5f];
    
//    self.lblNextDate.frame = CGRectMake(44, 286, 48, 21);
//    self.lblNextStep.frame = CGRectMake(71, 303, 33, 21);
//    self.lblNextDistance.frame = CGRectMake(131, 303, 33, 21);
//    self.lblNextCalories.frame = CGRectMake(180, 303, 33, 21);
//    self.lblNextActTime.frame = CGRectMake(240, 303, 33, 21);
//    
//    self.lblCurrStep.alpha = 0.5f;
//    self.lblCurrDistance.alpha = 0.5f;
//    self.lblCurrDate.alpha = 0.5f;
//    self.lblCurrCalories.alpha = 0.5f;
//    self.lblCurrActTime.alpha = 0.5f;
    
    [UIView commitAnimations];    
} 

-(void)handleSwipeDown:(UITapGestureRecognizer*)recognizer  
{  
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationWillStartSelector:@selector(handleSwipeDownStart:)];
    
    [UIView setAnimationDidStopSelector:@selector(handleSwipeDownStop:finished:)];
    
    [UIView setAnimationDelay:0.0f];
    
    [UIView setAnimationDuration:0.5f];
    
//    self.lblPrevDate.frame = CGRectMake(44, 288, 48, 21);
//    self.lblPrevStep.frame = CGRectMake(71, 306, 33, 21);
//    self.lblPrevDistance.frame = CGRectMake(131, 306, 33, 21);
//    self.lblPrevCalories.frame = CGRectMake(180, 306, 33, 21);
//    self.lblPrevActTime.frame = CGRectMake(240, 306, 33, 21);
//    
//    self.lblCurrStep.alpha = 0.5f;
//    self.lblCurrDistance.alpha = 0.5f;
//    self.lblCurrDate.alpha = 0.5f;
//    self.lblCurrCalories.alpha = 0.5f;
//    self.lblCurrActTime.alpha = 0.5f;
    
    [UIView commitAnimations];      
} 

-(void)handleSwipeUpStart:(CAAnimation *)anim

{
    
    log4Info(@"animation is start ...");
    
}


-(void)handleSwipeUpStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(![[referenceDate addDays:-1] inSameMonth:referenceDate])
        return;
    
//    self.lblNextDate.frame = CGRectMake(44, 243, 48, 21);
//    self.lblNextStep.frame = CGRectMake(71, 261, 33, 21);
//    self.lblNextDistance.frame = CGRectMake(131, 261, 33, 21);
//    self.lblNextCalories.frame = CGRectMake(180, 261, 33, 21);
//    self.lblNextActTime.frame = CGRectMake(240, 261, 33, 21);
//    
//    self.lblCurrStep.alpha = 1.0f;
//    self.lblCurrDistance.alpha = 1.0f;
//    self.lblCurrDate.alpha = 1.0f;
//    self.lblCurrCalories.alpha = 1.0f;
//    self.lblCurrActTime.alpha = 1.0f;
    
    referenceDate = [referenceDate addDays:-1];
    dayPickerView.selectedRow=referenceDate.day-1;
    [self displayPedometerDetailByDate:referenceDate];
}

-(void)handleSwipeDownStart:(CAAnimation *)anim

{
    log4Info(@"animation is start ...");
}


-(void)handleSwipeDownStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(![[referenceDate addDays:1] inSameMonth:referenceDate])
        return;
    
//    self.lblPrevDate.frame = CGRectMake(44, 286, 48, 21);
//    self.lblPrevStep.frame = CGRectMake(71, 303, 33, 21);
//    self.lblPrevDistance.frame = CGRectMake(131, 303, 33, 21);
//    self.lblPrevCalories.frame = CGRectMake(180, 303, 33, 21);
//    self.lblPrevActTime.frame = CGRectMake(240, 303, 33, 21);
//    
//    self.lblCurrStep.alpha = 1.0f;
//    self.lblCurrDistance.alpha = 1.0f;
//    self.lblCurrDate.alpha = 1.0f;
//    self.lblCurrCalories.alpha = 1.0f;
//    self.lblCurrActTime.alpha = 1.0f;
    
    referenceDate = [referenceDate addDays:1];
    dayPickerView.selectedRow=referenceDate.day-1;
    [self displayPedometerDetailByDate:referenceDate];
    //[self setDatePickerLabelHidden:NO];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
//    [self setImgVDataTop:nil];
    [self setLblDate:nil];
//    [self setLblLastUpdate:nil];
//    [self setLblUserName:nil];
    [self setDayPickerView:nil];
    [self setLblHour4ActualSleepTime:nil];
    [self setLblMinute4ActualSleepTime:nil];
    [self setLblRemark4TimeToBed:nil];
    [self setLblTimeToBed:nil];
    [self setLblRemark4TimeToFallSleep:nil];
    [self setLblTimeToFallSleep:nil];
    [self setLblTimesAwaken:nil];

//    [self setLblPrevDate:nil];
//    [self setLblPrevHour4ActualSleepTime:nil];
//    [self setLblPrevMinute4ActualSleepTime:nil];
//    [self setLblPrevRemark4TimeToBed:nil];
//    [self setLblPrevTimeToBed:nil];
//    [self setLblPrevRemark4TimeToFallSleep:nil];
//    [self setLblPrevTimeToFallSleep:nil];
//    [self setLblPrevTimesAwaken:nil];
//    [self setLblPrevRemark4Hour:nil];
//    [self setLblPrevRemark4Minute:nil];
//    [self setLblCurrDate:nil];
//    [self setLblCurrHour4ActualSleepTime:nil];
//    [self setLblCurrMinute4ActualSleepTime:nil];
//    [self setLblCurrRemark4TimeToBed:nil];
//    [self setLblCurrTimeToBed:nil];
//    [self setLblCurrRemark4TimeToFallSleep:nil];
//    [self setLblCurrTimeToFallSleep:nil];
//    [self setLblCurrTimesAwaken:nil];
//    [self setLblCurrRemark4Hour:nil];
//    [self setLblCurrRemark4Minute:nil];
//    [self setLblNextDate:nil];
//    [self setLblNextHour4ActualSleepTime:nil];
//    [self setLblNextMinute4ActualSleepTime:nil];
//    [self setLblNextRemark4TimeToBed:nil];
//    [self setLblNextTimeToBed:nil];
//    [self setLblNextRemark4TimeToFallSleep:nil];
//    [self setLblNextTimeToFallSleep:nil];
//    [self setLblNextTimesAwaken:nil];
//    [self setLblNextRemark4Hour:nil];
//    [self setLblNextRemark4Minute:nil];
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
//    [[PEDAppDelegate getInstance] setCustomerTabBarControllerBackground:[UIImage imageNamed:@"data_bg.png"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
//    [[PEDAppDelegate getInstance] setCustomerTabBarControllerBackground:[UIImage imageNamed:@"pedo_bg.png"]];
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

- (IBAction)connectToDevice:(id)sender {
    
}

- (IBAction)btnPrevDataClick:(id)sender {
    [self handleSwipeUp:nil];
}

- (IBAction)btnNextDataClick:(id)sender {
    [self handleSwipeDown:nil];
}

-(NSArray *) getPedoDataResourcesWithTargetId:(NSString*) targetId referedDate:(NSDate *) referDate{
    NSDate *dateFrom = [referDate addDays:-1];
    NSDate *dateTo = [referDate addDays:1];
    NSArray *pedoDataArray = [[BO_PEDSleepData getInstance] queryListFromDateNeedEmptySorted:dateFrom toDate:dateTo withTargetId:targetId];
    return pedoDataArray;
}

-(NSArray *) getPedoDataResourcesByMonthWithTargetId:(NSString*) targetId referedDate:(NSDate *) referDate{
    NSDate *dateFrom =  [referDate firstMonthDate];
    NSDate *dateTo=[[dateFrom addMonths:1] addDays:-1];
    NSDate *dateNow = [NSDate date];
    if([[UtilHelper formateDate:dateNow withFormat:@"MMM yyyy"] isEqualToString:[UtilHelper formateDate:dateTo withFormat:@"MMM yyyy"]]){
        dateTo = dateNow;
    }
    NSArray *pedoDataArray = [[BO_PEDSleepData getInstance] queryListFromDateNeedEmptySorted:dateFrom toDate:dateTo withTargetId:targetId];
    return pedoDataArray;
}

- (void) initData
{
    NSDate *lastUploadDate = [[BO_PEDSleepData getInstance] getLastUploadDate:[AppConfig getInstance].settings.target.targetId];
    [self initDataByDate:lastUploadDate];
}
- (void) initDataByDate:(NSDate *) date
{
    @try {
        NSDate *orginDate=[referenceDate copy];
        if(date==nil){
            if(referenceDate==nil)
                referenceDate=[NSDate date];
        }
        else
            referenceDate=date;
//        PEDUserInfo *userInfo = [AppConfig getInstance].settings.userInfo;
        NSString* targetId = [AppConfig getInstance].settings.target.targetId;
//        self.lblUserName.text = userInfo.userName;
//        self.lblLastUpdate.text = [UtilHelper formateDate:[[BO_PEDSleepData getInstance] getLastUpdateDate:[AppConfig getInstance].settings.target.targetId] withFormat:@"dd/MM/yy"];    
        if(daysData==nil || ![date inSameMonth:orginDate]){
            daysData=[self getPedoDataResourcesByMonthWithTargetId:targetId referedDate:referenceDate];
            [dayPickerView reloadData];
        }
        [self reloadPickerToMidOfDate:referenceDate];
        dayPickerView.selectedRow=referenceDate.day-1;
//        for (UIView *view in [dayPickerView visibleViews]) {
//            view.hidden=YES;
//        }
        [self initCurrentData:date];
//        [self displayPedometerDetailByDate:referenceDate];
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }   
}

-(void) initCurrentData:(NSDate *) date
{
    if(daysData!=nil){
        NSInteger currentRow=[date day]-1;
        PEDSleepData *pedoMeterData = [daysData objectAtIndex:currentRow];
        int h, m, s;
        if(pedoMeterData && pedoMeterData.optDate != nil){
            h = (int)pedoMeterData.actualSleepTime / 3600;
            m = (int)pedoMeterData.actualSleepTime % 3600 / 60;
            s = (int)pedoMeterData.actualSleepTime % 3600 % 60;
            m = m + round(s/60);
            //                lblCurrDate.text = [UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"];
            //                lblCurrHour4ActualSleepTime.text = [NSString stringWithFormat:@"%d", h];
            //                lblCurrMinute4ActualSleepTime.text = [NSString stringWithFormat:@"%02d", m];
            //                lblCurrRemark4TimeToBed.text = [PEDPedometerDataHelper getSleepTimeRemark:pedoMeterData.timeToBed];
            //                lblCurrTimeToBed.text = [PEDPedometerDataHelper getSleepTimeString:pedoMeterData.timeToBed];
            //                lblCurrRemark4TimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeRemark:pedoMeterData.timeToFallSleep];
            //                lblCurrTimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeString:pedoMeterData.timeToFallSleep];
            //                lblCurrTimesAwaken.text = [NSString stringWithFormat:@"%.0f", pedoMeterData.awakenTime];
            lblDate.text = [UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"];
            lblDate4ActualSleepTime.text = [UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"];
            lblHour4ActualSleepTime.text = [NSString stringWithFormat:@"%d", h];
            lblMinute4ActualSleepTime.text = [NSString stringWithFormat:@"%02d", m];
            lblRemark4TimeToBed.text = [PEDPedometerDataHelper getSleepTimeRemark:pedoMeterData.timeToBed];
            lblTimeToBed.text = [PEDPedometerDataHelper getSleepTimeString:pedoMeterData.timeToBed];
            lblRemark4TimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeRemark:pedoMeterData.timeToFallSleep];
            lblTimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeString:pedoMeterData.timeToFallSleep];
            lblTimesAwaken.text = [NSString stringWithFormat:@"%.0f", pedoMeterData.awakenTime];
        }
    }
}

-(void)displayPedometerDetailByDate:(NSDate *)date
{
    @try {
        [self initCurrentData:date];
        NSMutableArray *pedoMeterDataArray=[[NSMutableArray alloc] initWithCapacity:showDataRowsCount];
        if(daysData!=nil){
            NSInteger currentRow=[date day]-1;
            PEDSleepData *pedoData4Sleep;
            for (int i = currentRow-showDataRowsCount/2; i<=currentRow+showDataRowsCount/2; i++) {
                if(i>0 && daysData.count>i){
                    pedoData4Sleep = [daysData objectAtIndex:i];
                }
                else{
                    pedoData4Sleep=[[PEDSleepData alloc] init];            
                }
                [pedoMeterDataArray addObject: pedoData4Sleep];
            }        
        }
        if(pedoMeterDataArray != nil){
            log4Info(@"%d", pedoMeterDataArray.count);
            for (int i=0; i<pedoMeterDataArray.count; i++) {
                PEDPedoDataRowView4Sleep *row =  [showDataRows objectAtIndex:i];
                [row bindByPedometerData:[pedoMeterDataArray objectAtIndex:i]];
            }
//            int h, m, s;
            //PEDSleepData *pedoMeterData = [pedoMeterDataArray objectAtIndex:2];
//            if(pedoMeterData && pedoMeterData.optDate != nil){
//                h = (int)pedoMeterData.actualSleepTime / 3600;
//                m = (int)pedoMeterData.actualSleepTime % 3600 / 60;
//                s = (int)pedoMeterData.actualSleepTime % 3600 % 60;
//                m = m + round(s/60);
//                lblNextDate.text = [UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"];
//                lblNextHour4ActualSleepTime.text = [NSString stringWithFormat:@"%d", h];
//                lblNextMinute4ActualSleepTime.text = [NSString stringWithFormat:@"%02d", m];
//                lblNextRemark4TimeToBed.text = [PEDPedometerDataHelper getSleepTimeRemark:pedoMeterData.timeToBed];
//                lblNextTimeToBed.text = [PEDPedometerDataHelper getSleepTimeString:pedoMeterData.timeToBed];
//                lblNextRemark4TimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeRemark:pedoMeterData.timeToFallSleep];
//                lblNextTimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeString:pedoMeterData.timeToFallSleep];
//                lblNextTimesAwaken.text = [NSString stringWithFormat:@"%.0f", pedoMeterData.awakenTime];
//            }
//            else{
//                lblNextDate.text = @"";
//                lblNextHour4ActualSleepTime.text = @"";
//                lblNextMinute4ActualSleepTime.text = @"";
//                lblNextRemark4TimeToBed.text = @"";
//                lblNextTimeToBed.text = @"";
//                lblNextRemark4TimeToFallSleep.text = @"";
//                lblNextTimeToFallSleep.text = @"";
//                lblNextTimesAwaken.text = @"";
//            }  
//            PEDSleepData *pedoMeterData = [pedoMeterDataArray objectAtIndex:0];
//            if(pedoMeterData && pedoMeterData.optDate != nil){
//                h = (int)pedoMeterData.actualSleepTime / 3600;
//                m = (int)pedoMeterData.actualSleepTime % 3600 / 60;
//                s = (int)pedoMeterData.actualSleepTime % 3600 % 60;
//                m = m + round(s/60);
//                lblCurrDate.text = [UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"];
//                lblCurrHour4ActualSleepTime.text = [NSString stringWithFormat:@"%d", h];
//                lblCurrMinute4ActualSleepTime.text = [NSString stringWithFormat:@"%02d", m];
//                lblCurrRemark4TimeToBed.text = [PEDPedometerDataHelper getSleepTimeRemark:pedoMeterData.timeToBed];
//                lblCurrTimeToBed.text = [PEDPedometerDataHelper getSleepTimeString:pedoMeterData.timeToBed];
//                lblCurrRemark4TimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeRemark:pedoMeterData.timeToFallSleep];
//                lblCurrTimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeString:pedoMeterData.timeToFallSleep];
//                lblCurrTimesAwaken.text = [NSString stringWithFormat:@"%.0f", pedoMeterData.awakenTime];
//                lblDate.text = [UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"];
//                lblHour4ActualSleepTime.text = [NSString stringWithFormat:@"%d", h];
//                lblMinute4ActualSleepTime.text = [NSString stringWithFormat:@"%02d", m];
//                lblRemark4TimeToBed.text = [PEDPedometerDataHelper getSleepTimeRemark:pedoMeterData.timeToBed];
//                lblTimeToBed.text = [PEDPedometerDataHelper getSleepTimeString:pedoMeterData.timeToBed];
//                lblRemark4TimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeRemark:pedoMeterData.timeToFallSleep];
//                lblTimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeString:pedoMeterData.timeToFallSleep];
//                lblTimesAwaken.text = [NSString stringWithFormat:@"%.0f", pedoMeterData.awakenTime];
           // }
//            else{
//                lblCurrDate.text = @"";
//                lblCurrHour4ActualSleepTime.text = @"";
//                lblCurrMinute4ActualSleepTime.text = @"";
//                lblCurrRemark4TimeToBed.text = @"";
//                lblCurrTimeToBed.text = @"";
//                lblCurrRemark4TimeToFallSleep.text = @"";
//                lblCurrTimeToFallSleep.text = @"";
//                lblCurrTimesAwaken.text = @"";
//            }
//            pedoMeterData = [pedoMeterDataArray objectAtIndex:0];
//            if(pedoMeterData && pedoMeterData.optDate != nil){
//                h = (int)pedoMeterData.actualSleepTime / 3600;
//                m = (int)pedoMeterData.actualSleepTime % 3600 / 60;
//                s = (int)pedoMeterData.actualSleepTime % 3600 % 60;
//                m = m + round(s/60);
//                lblPrevDate.text = [UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"];
//                lblPrevHour4ActualSleepTime.text = [NSString stringWithFormat:@"%d", h];
//                lblPrevMinute4ActualSleepTime.text = [NSString stringWithFormat:@"%02d", m];
//                lblPrevRemark4TimeToBed.text = [PEDPedometerDataHelper getSleepTimeRemark:pedoMeterData.timeToBed];
//                lblPrevTimeToBed.text = [PEDPedometerDataHelper getSleepTimeString:pedoMeterData.timeToBed];
//                lblPrevRemark4TimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeRemark:pedoMeterData.timeToFallSleep];
//                lblPrevTimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeString:pedoMeterData.timeToFallSleep];
//                lblPrevTimesAwaken.text = [NSString stringWithFormat:@"%.0f", pedoMeterData.awakenTime];
//            }
//            else{           
//                lblPrevDate.text = @"";
//                lblPrevHour4ActualSleepTime.text = @"";
//                lblPrevMinute4ActualSleepTime.text = @"";
//                lblPrevRemark4TimeToBed.text = @"";
//                lblPrevTimeToBed.text = @"";
//                lblPrevRemark4TimeToFallSleep.text = @"";
//                lblPrevTimeToFallSleep.text = @"";
//                lblPrevTimesAwaken.text = @"";
//            }
        }
        //[self setDatePickerLabelHidden:NO];
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
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
        NSDate *selectDate=[[BO_PEDSleepData getInstance] getLastDateWithTarget:[AppConfig getInstance].settings.target.targetId between:date to:dateTo];
        if(selectDate)
            [self initDataByDate:selectDate];
        else{
            [self initDataByDate:date];
        }
    }
}

#pragma mark - AFPickerViewDataSource

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView
{        
    return [daysData count];
}


- (void)pickerView:(AFPickerView *)pickerView prepareForCell:(UIView *) cellView rowAtIndex:(NSInteger)rowIndex
{
    PEDSleepData *data = [daysData objectAtIndex:rowIndex];
    PEDPedoDataRowView4Sleep *view=(PEDPedoDataRowView4Sleep *)cellView;
    [view bindByPedometerData:data];
}

#pragma mark - AFPickerViewDelegate

- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row
{
    PEDSleepData *data= (PEDSleepData *)[daysData objectAtIndex:row];
    [self displayPedometerDetailByDate:data.optDate];
    referenceDate=data.optDate;
//    for (UIView *view in [pickerView visibleViews]) {
//        view.hidden=YES;
//    }
}

- (CGFloat)pickerView:(AFPickerView *)pickerView heightForRowAtIndexPath:(NSInteger)rowIndex
{
    return 53.0;
}

- (float)pickerViewRowHeight:(AFPickerView *)pickerView
{
    return 53.0;
}

-(UIView *)pickerView:(AFPickerView *)pickerView cellForRowAtIndexPath:(NSInteger)rowIndex
{
    return [PEDPedoDataRowView4Sleep instanceView:(PEDSleepData *)[daysData objectAtIndex:rowIndex]];
}

- (void)pickerViewDidStartScroll:(AFPickerView *)pickerView
{
//    for (UIView *view in [pickerView visibleViews]) {
//        view.hidden=NO;
//    }
    [self setDatePickerLabelHidden:YES];
}

-(void)setDatePickerLabelHidden:(BOOL)yes
{
//    NSArray *array = [[NSArray alloc] initWithObjects:lblPrevDate,lblPrevHour4ActualSleepTime,lblPrevMinute4ActualSleepTime,lblPrevRemark4TimeToBed,lblPrevTimeToBed,lblPrevRemark4TimeToFallSleep,lblPrevTimeToFallSleep,lblPrevTimesAwaken,lblCurrDate,lblCurrHour4ActualSleepTime,lblCurrMinute4ActualSleepTime,lblCurrRemark4TimeToBed,lblCurrTimeToBed,lblCurrRemark4TimeToFallSleep,lblCurrTimeToFallSleep,lblCurrTimesAwaken,lblNextDate,lblNextHour4ActualSleepTime,lblNextMinute4ActualSleepTime,lblNextRemark4TimeToBed,lblNextTimeToBed,lblNextRemark4TimeToFallSleep,lblNextTimeToFallSleep,lblNextTimesAwaken,nil];
    if(showDataRows!=nil){
        for (UIView *view in showDataRows) {
            view.hidden=yes;
        }
    }
}

-(void)pickerView:(AFPickerView *)pickerView didTapCenter:(UITapGestureRecognizer *)recognizer
{
    //[self doubleTap:recognizer];
}

-(void)pickerView:(AFPickerView *)pickerView didTapCenter:(UITapGestureRecognizer *)recognizer inStep:(NSInteger)step
{
    NSDate *seletedDate = [referenceDate addDays:step];
    //NSLog(@"Date:%@,Step:%i,selected Date:%@",referenceDate,step,seletedDate);
    [[PEDAppDelegate getInstance].sleepPedoViewController initDataByDate: seletedDate];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
