//
//  PEDSecondViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDPedoDataViewController.h"
#import "PEDPedoViewController.h"
#import "PEDAppDelegate.h"
#import "DialogBoxContainer.h"
#import "AppConfig.h"
#import "BO_PEDPedometerData.h"
#import "PEDPedometerData.h"
#import "PEDPedometerDataHelper.h"
#import "PEDPedoDataRowView.h"

@interface PEDPedoDataViewController  ()
{
    
}

-(NSArray *) getPedoDataResourcesWithTargetId:(NSString*) targetId referedDate:(NSDate *) referDate;

-(void)displayPedometerDetailByDate:(NSDate *)date;
-(void)setDatePickerLabelHidden:(BOOL)yes;
@end

@implementation PEDPedoDataViewController

@synthesize imgVDataTop;
@synthesize imgVDataMiddle;
@synthesize imgVDataBottom;
@synthesize imgVBehindTop;
@synthesize imgVBehindBottom;
@synthesize lblDistance;
@synthesize lblCalories;
@synthesize lblActivityTime;
@synthesize lblStep;
@synthesize lblDate;
@synthesize lblCurrDate;
@synthesize lblCurrStep;
@synthesize lblCurrDistance;
@synthesize lblCurrCalories;
@synthesize lblCurrActTime;
@synthesize lblPrevDate;
@synthesize lblPrevStep;
@synthesize lblPrevDistance;
@synthesize lblPrevCalories;
@synthesize lblPrevActTime;
@synthesize lblLastUpdate;
@synthesize lblUserName;
@synthesize lblNextDate;
@synthesize lblNextStep;
@synthesize lblNextDistance;
@synthesize lblNextCalories;
@synthesize lblNextActTime;

@synthesize referenceDate;
@synthesize dayPickerView;
//@synthesize monthSelectView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        UIImage *tabbarImage = [UIImage imageNamed:@"second.png"] ;
        //        UITabBarItem *barItem = [[UITabBarItem alloc]initWithTitle:@"" image:tabbarImage tag:1];
        //        self.tabBarItem = barItem;
        //  monthArray = [NSMutableArray arrayWithObjects:@"JUN,12", @"JUL,12", @"AUG,12", @"SEP,12", @"OCT,12", @"NOV,12", @"DEC,12", nil];
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void) initLable{
    self.lblDate.text = @"";
    self.lblStep.text = @"";
    self.lblDistance.text = @"";
    self.lblCalories.text = @"";
    self.lblActivityTime.text = @"";
    self.lblNextDate.text = @"";
    self.lblNextStep.text = @"";
    self.lblNextDistance.text = @"";
    self.lblNextCalories.text = @"";
    self.lblNextActTime.text = @"";
    self.lblCurrDate.text = @"";
    self.lblCurrStep.text = @"";
    self.lblCurrDistance.text = @"";
    self.lblCurrCalories.text = @"";
    self.lblCurrActTime.text = @"";
    self.lblPrevDate.text = @"";
    self.lblPrevStep.text = @"";
    self.lblPrevDistance.text = @"";
    self.lblPrevCalories.text = @"";
    self.lblPrevActTime.text = @"";
}

-(void)doubleTap:(UITapGestureRecognizer*)recognizer  
{  
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
    
    self.imgVDataBottom.image = [UIImage imageNamed:@"data_bottom_panel_full.png"];
    self.imgVDataBottom.frame = CGRectMake(0, 285, 320, 45);
    self.imgVDataBottom.alpha = 0.0f;
    self.imgVBehindBottom.alpha = 1.0f;
    self.imgVBehindBottom.frame = CGRectMake(0, 330, 320, 45);
    self.lblPrevDate.frame = CGRectMake(44, 286, 48, 21);
    self.lblPrevStep.frame = CGRectMake(71, 303, 33, 21);
    self.lblPrevDistance.frame = CGRectMake(131, 303, 33, 21);
    self.lblPrevCalories.frame = CGRectMake(180, 303, 33, 21);
    self.lblPrevActTime.frame = CGRectMake(240, 303, 33, 21);
    
    self.lblCurrStep.alpha = 0.5f;
    self.lblCurrDistance.alpha = 0.5f;
    self.lblCurrDate.alpha = 0.5f;
    self.lblCurrCalories.alpha = 0.5f;
    self.lblCurrActTime.alpha = 0.5f;
    
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
    
    self.imgVDataTop.image = [UIImage imageNamed:@"data_top_panel_full.png"];
    self.imgVDataTop.frame = CGRectMake(0, 283, 320, 45);
    self.imgVDataTop.alpha = 0.0f;
    self.imgVBehindTop.alpha = 1.0f;
    self.imgVBehindTop.frame = CGRectMake(0, 238, 320, 45);
    self.lblNextDate.frame = CGRectMake(44, 288, 48, 21);
    self.lblNextStep.frame = CGRectMake(71, 306, 33, 21);
    self.lblNextDistance.frame = CGRectMake(131, 306, 33, 21);
    self.lblNextCalories.frame = CGRectMake(180, 306, 33, 21);
    self.lblNextActTime.frame = CGRectMake(240, 306, 33, 21);
    
    self.lblCurrStep.alpha = 0.5f;
    self.lblCurrDistance.alpha = 0.5f;
    self.lblCurrDate.alpha = 0.5f;
    self.lblCurrCalories.alpha = 0.5f;
    self.lblCurrActTime.alpha = 0.5f;
    
    [UIView commitAnimations];      
} 

-(void)handleSwipeUpStart:(CAAnimation *)anim

{
    
    NSLog(@"animation is start ...");
    
}


-(void)handleSwipeUpStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(![[referenceDate addDays:-1] inSameMonth:referenceDate])
        return;
    self.imgVDataBottom.image = [UIImage imageNamed:@"data_bottom_panel.png"];
    self.imgVDataBottom.frame = CGRectMake(0, 330, 320, 45);
    self.imgVDataBottom.alpha = 1.0f;        
    self.imgVBehindBottom.alpha = 0.0f;
    self.imgVBehindBottom.frame = CGRectMake(0, 292, 320, 45);
    
    self.lblPrevDate.frame = CGRectMake(44, 331, 48, 21);
    self.lblPrevStep.frame = CGRectMake(71, 348, 33, 21);
    self.lblPrevDistance.frame = CGRectMake(131, 348, 33, 21);
    self.lblPrevCalories.frame = CGRectMake(180, 348, 33, 21);
    self.lblPrevActTime.frame = CGRectMake(240, 348, 33, 21);
    
    self.lblCurrStep.alpha = 1.0f;
    self.lblCurrDistance.alpha = 1.0f;
    self.lblCurrDate.alpha = 1.0f;
    self.lblCurrCalories.alpha = 1.0f;
    self.lblCurrActTime.alpha = 1.0f;
    
    referenceDate = [referenceDate addDays:-1];
    dayPickerView.selectedRow=referenceDate.day-1;
    [self displayPedometerDetailByDate:referenceDate];
}

-(void)handleSwipeDownStart:(CAAnimation *)anim

{
    NSLog(@"animation is start ...");
}


-(void)handleSwipeDownStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(![[referenceDate addDays:1] inSameMonth:referenceDate])
        return;
    self.imgVDataTop.image = [UIImage imageNamed:@"data_top_panel.png"];
    self.imgVDataTop.frame = CGRectMake(0, 238, 320, 45);
    self.imgVDataTop.alpha = 1.0f;        
    self.imgVBehindTop.alpha = 0.0f;
    self.imgVBehindTop.frame = CGRectMake(0, 277, 320, 45);
    
    self.lblNextDate.frame = CGRectMake(44, 243, 48, 21);
    self.lblNextStep.frame = CGRectMake(71, 261, 33, 21);
    self.lblNextDistance.frame = CGRectMake(131, 261, 33, 21);
    self.lblNextCalories.frame = CGRectMake(180, 261, 33, 21);
    self.lblNextActTime.frame = CGRectMake(240, 261, 33, 21);
    
    self.lblCurrStep.alpha = 1.0f;
    self.lblCurrDistance.alpha = 1.0f;
    self.lblCurrDate.alpha = 1.0f;
    self.lblCurrCalories.alpha = 1.0f;
    self.lblCurrActTime.alpha = 1.0f;
    
    referenceDate = [referenceDate addDays:1];
    dayPickerView.selectedRow=referenceDate.day-1;
    [self displayPedometerDetailByDate:referenceDate];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLable];
    
    //daysData = [[NSArray alloc] initWithObjects:@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday", nil];
    
    dayPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(0.0, 238.0, 320.0, 140)];
    dayPickerView.dataSource = self;
    dayPickerView.delegate = self;
    //[dayPickerView reloadData];
    [self.view addSubview:dayPickerView];
    
    
    /*
    UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];  
    doubleRecognizer.numberOfTapsRequired = 2; // 双击  
    
    [self.imgVDataMiddle addGestureRecognizer:doubleRecognizer];  
    */
     /*
    UISwipeGestureRecognizer *upRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];   
    [upRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];   
    [self.imgVDataMiddle addGestureRecognizer:upRecognizer];
    
    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];   
    [downRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];   
    [self.imgVDataMiddle addGestureRecognizer:downRecognizer];
    */
    [self initMonthSelectorWithX:0 Height:188.f];
    
    [self initDataByDate:referenceDate];
	
    // Do any additional setup after loading the view, typically from a nib.
    
    //    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 410)];
    //    bgImage.image = [UIImage imageNamed:@"data.bmp"] ;
    //    [self.view addSubview:bgImage]; 
    //    
}

- (void)viewDidUnload
{
    [self setImgVDataTop:nil];
    [self setImgVDataMiddle:nil];
    [self setImgVDataMiddle:nil];
    [self setImgVDataBottom:nil];
    [self setLblDate:nil];
    [self setLblStep:nil];
    [self setLblDistance:nil];
    [self setLblCalories:nil];
    [self setLblActivityTime:nil];
    [self setLblLastUpdate:nil];
    [self setLblUserName:nil];
    [self setLblNextDate:nil];
    [self setLblNextStep:nil];
    [self setLblNextDistance:nil];
    [self setLblNextCalories:nil];
    [self setLblNextActTime:nil];
    [self setLblCurrDate:nil];
    [self setLblCurrStep:nil];
    [self setLblCurrDistance:nil];
    [self setLblCurrCalories:nil];
    [self setLblCurrActTime:nil];
    [self setLblPrevDate:nil];
    [self setLblPrevStep:nil];
    [self setLblPrevDistance:nil];
    [self setLblPrevCalories:nil];
    [self setLblPrevActTime:nil];
    [self setImgVBehindTop:nil];
    [self setImgVBehindBottom:nil];
    [self setDayPickerView:nil];
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
    [[PEDAppDelegate getInstance] setCustomerTabBarControllerBackground:[UIImage imageNamed:@"data_bg.png"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [[PEDAppDelegate getInstance] setCustomerTabBarControllerBackground:[UIImage imageNamed:@"pedo_bg.png"]];
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

//- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
//	return [monthArray count];
//}
//
//#pragma mark - HorizontalPickerView Delegate Methods
//- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
//	return [monthArray objectAtIndex:index];
//}
//
//- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
//	CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
//	NSString *text = [monthArray objectAtIndex:index];
//    CGFloat fontSize = picker.currentSelectedIndex==index?14.0f:11.0f;
//	CGSize textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:fontSize]
//					   constrainedToSize:constrainedSize
//						   lineBreakMode:UILineBreakModeWordWrap];
//	return textSize.width + 20.0f; // 20px padding on each side
//}
//
//- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
//}


- (IBAction)btnPrevDataClick:(id)sender {
    [self handleSwipeUp:nil];
}

- (IBAction)btnNextDataClick:(id)sender {
    [self handleSwipeDown:nil];
}

-(NSArray *) getPedoDataResourcesWithTargetId:(NSString*) targetId referedDate:(NSDate *) referDate{
    NSDate *dateFrom = [referDate addDays:-1];
    NSDate *dateTo = [referDate addDays:1];
    NSArray *pedoDataArray = [[BO_PEDPedometerData getInstance] queryListFromDateNeedEmptySorted:dateFrom toDate:dateTo withTargetId:targetId];
    return pedoDataArray;
}

-(NSArray *) getPedoDataResourcesByMonthWithTargetId:(NSString*) targetId referedDate:(NSDate *) referDate{
    NSDate *dateFrom =  [referDate firstMonthDate];
    NSDate *dateTo=[[dateFrom addMonths:1] addDays:-1];
    NSDate *dateNow = [NSDate date];
    if([[UtilHelper formateDate:dateNow withFormat:@"MMM yyyy"] isEqualToString:[UtilHelper formateDate:dateTo withFormat:@"MMM yyyy"]]){
        dateTo = dateNow;
    }
    NSArray *pedoDataArray = [[BO_PEDPedometerData getInstance] queryListFromDateNeedEmptySorted:dateFrom toDate:dateTo withTargetId:targetId];
    return pedoDataArray;
}

- (void) initData
{
    NSDate *lastUploadDate = [[BO_PEDPedometerData getInstance] getLastUploadDate:[AppConfig getInstance].settings.target.targetId];
    [self initDataByDate:lastUploadDate];
}
- (void) initDataByDate:(NSDate *) date{
    NSDate *orginDate=[referenceDate copy];
    if(date){
        referenceDate=date;
    }
    else{
        referenceDate=[NSDate date];
    }
    PEDUserInfo *userInfo = [AppConfig getInstance].settings.userInfo;
    NSString* targetId = [AppConfig getInstance].settings.target.targetId;
    self.lblUserName.text = userInfo.userName;
    self.lblLastUpdate.text = [UtilHelper formateDate:[[BO_PEDPedometerData getInstance] getLastUpdateDate:[AppConfig getInstance].settings.target.targetId] withFormat:@"dd/MM/yy"];    
    if(daysData==nil || ![date inSameMonth:orginDate]){
        daysData=[self getPedoDataResourcesByMonthWithTargetId:targetId referedDate:date];
        [dayPickerView reloadData];
    }
    [self reloadPickerToMidOfDate:referenceDate];
    dayPickerView.selectedRow=referenceDate.day-1;
    for (UIView *view in [dayPickerView visibleViews]) {
        view.hidden=YES;
    }
    [self displayPedometerDetailByDate:referenceDate];
}
-(void)displayPedometerDetailByDate:(NSDate *)date
{
    NSMutableArray *pedoMeterDataArray=[[NSMutableArray alloc] initWithCapacity:3];
    
    PEDUserInfo *userInfo = [AppConfig getInstance].settings.userInfo;
    if(daysData!=nil){
        NSInteger currentRow=[date day]-1;
        PEDPedometerData *pedoData;
        for (int i = currentRow-1; i<=currentRow+1; i++) {
            if(daysData.count>i){
                pedoData = [daysData objectAtIndex:i];
            }
            else{
                pedoData=[[PEDPedometerData alloc] init];            
            }
            [pedoMeterDataArray addObject: pedoData];
        }        
    }
    if(pedoMeterDataArray != nil){
        NSLog(@"%d", pedoMeterDataArray.count);
        PEDPedometerData *pedoMeterData = [pedoMeterDataArray objectAtIndex:2];
        if(pedoMeterData && pedoMeterData.optDate != nil){
            lblPrevDate.text = [UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"];
            lblPrevStep.text = [PEDPedometerDataHelper integerToString: pedoMeterData.step];
            lblPrevDistance.text = [NSString stringWithFormat:@"%.1f%@", pedoMeterData.distance, [PEDPedometerCalcHelper getDistanceUnit:userInfo.measureFormat withWordFormat:YES]];
            lblPrevCalories.text = [NSString stringWithFormat:@"%.1fKcal", pedoMeterData.calorie];
            lblPrevActTime.text = [PEDPedometerDataHelper integerToTimeString:(int)pedoMeterData.activeTime];
        }
        else{           
            self.lblPrevDate.text = @"";
            self.lblPrevStep.text = @"";
            self.lblPrevDistance.text = @"";
            self.lblPrevCalories.text = @"";
            self.lblPrevActTime.text = @"";
        }
        pedoMeterData = [pedoMeterDataArray objectAtIndex:1];
        if(pedoMeterData && pedoMeterData.optDate != nil){
            lblCurrDate.text = [UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"];
            lblCurrStep.text = [PEDPedometerDataHelper integerToString: pedoMeterData.step];
            lblCurrDistance.text = [NSString stringWithFormat:@"%.1f%@", pedoMeterData.distance, [PEDPedometerCalcHelper getDistanceUnit:userInfo.measureFormat withWordFormat:YES]];
            lblCurrCalories.text = [NSString stringWithFormat:@"%.1fKcal", pedoMeterData.calorie];
            lblCurrActTime.text = [PEDPedometerDataHelper integerToTimeString:(int)pedoMeterData.activeTime];
            lblDate.text = [UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"];
            lblStep.text = [PEDPedometerDataHelper integerToString: pedoMeterData.step];
            lblDistance.text = [NSString stringWithFormat:@"%.1f%@", pedoMeterData.distance, [PEDPedometerCalcHelper getDistanceUnit:userInfo.measureFormat withWordFormat:YES]];
            lblCalories.text = [NSString stringWithFormat:@"%.1fKcal", pedoMeterData.calorie];
            lblActivityTime.text = [PEDPedometerDataHelper integerToTimeString:(int)pedoMeterData.activeTime];
        }
        else{
            self.lblCurrDate.text = @"";
            self.lblCurrStep.text = @"";
            self.lblCurrDistance.text = @"";
            self.lblCurrCalories.text = @"";
            self.lblCurrActTime.text = @"";
        }
        pedoMeterData = [pedoMeterDataArray objectAtIndex:0];
        if(pedoMeterData && pedoMeterData.optDate != nil){
            lblNextDate.text = [UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"];
            lblNextStep.text = [PEDPedometerDataHelper integerToString: pedoMeterData.step];
            lblNextDistance.text = [NSString stringWithFormat:@"%.1f%@", pedoMeterData.distance, [PEDPedometerCalcHelper getDistanceUnit:userInfo.measureFormat withWordFormat:YES]];
            lblNextCalories.text = [NSString stringWithFormat:@"%.1fKcal", pedoMeterData.calorie];
            lblNextActTime.text = [PEDPedometerDataHelper integerToTimeString:(int)pedoMeterData.activeTime];
        }
        else{
            self.lblNextDate.text = @"";
            self.lblNextStep.text = @"";
            self.lblNextDistance.text = @"";
            self.lblNextCalories.text = @"";
            self.lblNextActTime.text = @"";
        }            
    }
    [self setDatePickerLabelHidden:NO];
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
    PEDPedometerData *data = [daysData objectAtIndex:rowIndex];
    PEDPedoDataRowView *view=(PEDPedoDataRowView *)cellView;
    [view bindByPedometerData:data];
}

#pragma mark - AFPickerViewDelegate

- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row
{
    PEDPedometerData *data= (PEDPedometerData *)[daysData objectAtIndex:row];
    [self displayPedometerDetailByDate:data.optDate];
    for (UIView *view in [pickerView visibleViews]) {
        view.hidden=YES;
    }
}

- (CGFloat)pickerView:(AFPickerView *)pickerView heightForRowAtIndexPath:(NSInteger)rowIndex
{
    return 45.0;
}

-(UIView *)pickerView:(AFPickerView *)pickerView cellForRowAtIndexPath:(NSInteger)rowIndex
{
    return [PEDPedoDataRowView instanceView:(PEDPedometerData *)[daysData objectAtIndex:rowIndex]];
}

- (void)pickerViewDidStartScroll:(AFPickerView *)pickerView
{
    for (UIView *view in [pickerView visibleViews]) {
        view.hidden=NO;
    }
    [self setDatePickerLabelHidden:YES];
}

-(void)setDatePickerLabelHidden:(BOOL)yes
{
    NSArray *array = [[NSArray alloc] initWithObjects:lblNextDate,lblNextStep,lblNextDistance,lblNextCalories,lblNextCalories,lblNextActTime,lblCurrDate,lblCurrStep,lblCurrDistance,lblCurrCalories,lblCurrActTime,lblPrevDate,lblPrevStep,lblPrevDistance,lblPrevCalories,lblPrevActTime,nil];
    for (UIView *view in array) {
        view.hidden=yes;
    }
}

-(void)pickerView:(AFPickerView *)pickerView didTapCenter:(UITapGestureRecognizer *)recognizer
{
    [self doubleTap:recognizer];
}

@end
