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


@interface PEDPedoDataViewController  ()
{
    
}

-(NSArray *) getPedoDataResourcesWithTargetId:(NSString*) targetId referedDate:(NSDate *) referDate;

-(void)displayPedometerDetailByDate:(NSDate *)date;
-(void)setDatePickerLabelHidden:(BOOL)yes;
@end

@implementation PEDPedoDataViewController


@synthesize referenceDate;
@synthesize dayPickerView;
@synthesize showDataRows;

//@synthesize monthSelectView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        showDataRowsCount=5;
    }
    return self;
}

-(id)initWithRefrenceDate:(NSDate *)refDate
{
    self = [super init];
    if(self){
        self.referenceDate=refDate;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void) initLable{
    
}

-(void)doubleTap:(UITapGestureRecognizer*)recognizer
{
    [[PEDAppDelegate getInstance].pedPedoViewController initDataByDate: referenceDate];
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
    
    referenceDate = [referenceDate addDays:-1];
    dayPickerView.selectedRow=referenceDate.day-1;
    //[self displayPedometerDetailByDate:referenceDate];
}

-(void)handleSwipeDownStart:(CAAnimation *)anim

{
    log4Info(@"animation is start ...");
}


-(void)handleSwipeDownStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if(![[referenceDate addDays:1] inSameMonth:referenceDate])
        return;
    
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
    
    
    
    dayPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(56.0, 97.0, 220.0, 390)];
    //dayPickerView.backgroundColor=[UIColor colorWithRed:143/255.0f green:100/255.0f blue:120/255.0f alpha:1];
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
    [self initMonthSelectorWithX:56.f Height:66.f isForPedo:YES];
	
    // Do any additional setup after loading the view, typically from a nib.
    
    //    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 410)];
    //    bgImage.image = [UIImage imageNamed:@"data.bmp"] ;
    //    [self.view addSubview:bgImage];
    //
    [self initDataByDate:referenceDate];
}

- (void)viewDidUnload
{
    //    [self setImgVBehindTop:nil];
    //    [self setImgVBehindBottom:nil];
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
    //[[PEDAppDelegate getInstance] setCustomerTabBarControllerBackground:[UIImage imageNamed:@"data_bg.png"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    //[[PEDAppDelegate getInstance] setCustomerTabBarControllerBackground:[UIImage imageNamed:@"pedo_bg.png"]];
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
    @try {
        NSDate *orginDate=[referenceDate copy];
        if(date==nil){
            if(referenceDate==nil)
                referenceDate=[NSDate date];
        }
        else
            referenceDate=date;
        // PEDUserInfo *userInfo = [AppConfig getInstance].settings.userInfo;
        NSString* targetId = [AppConfig getInstance].settings.target.targetId;
        //self.lblUserName.text = userInfo.userName;
        //self.lblLastUpdate.text = [UtilHelper formateDate:[[BO_PEDPedometerData getInstance] getLastUpdateDate:[AppConfig getInstance].settings.target.targetId] withFormat:@"dd/MM/yy"];
        if(daysData==nil || ![date inSameMonth:orginDate]){
            daysData=[self getPedoDataResourcesByMonthWithTargetId:targetId referedDate:referenceDate];
            [dayPickerView reloadData];
        }
        [self reloadPickerToMidOfDate:referenceDate];
        dayPickerView.selectedRow=referenceDate.day-1;
//        for (UIView *view in [dayPickerView visibleViews]) {
//            view.hidden=YES;
//        }
//        [self displayPedometerDetailByDate:referenceDate];
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
}
-(void)displayPedometerDetailByDate:(NSDate *)date
{
    @try {
        NSMutableArray *pedoMeterDataArray=[[NSMutableArray alloc] initWithCapacity:showDataRowsCount];
        
        //PEDUserInfo *userInfo = [AppConfig getInstance].settings.userInfo;
        
        if(daysData!=nil){
            NSInteger currentRow=[date day]-1;
            PEDPedometerData *pedoData;
            for (int i = currentRow-showDataRowsCount/2; i<=currentRow+showDataRowsCount/2; i++) {
                if(i>0 && daysData.count>i){
                    pedoData = [daysData objectAtIndex:i];
                }
                else{
                    pedoData=[[PEDPedometerData alloc] init];
                }
                [pedoMeterDataArray addObject: pedoData];
            }
        }
        if(showDataRows==nil){
            showDataRows =[[NSMutableArray alloc] initWithCapacity:showDataRowsCount];
            for(int i=0;i<showDataRowsCount;i++){
                PEDPedoDataRowView *row =  [PEDPedoDataRowView instanceView:nil];
                row.frame = CGRectMake(56,97*(i+1),214.0f,80.0f);
                [self.view addSubview:row];
                [showDataRows addObject:row];
            }
        }
        if(pedoMeterDataArray != nil){
            log4Info(@"%d", pedoMeterDataArray.count);
            for (int i=0; i<pedoMeterDataArray.count; i++) {
                PEDPedoDataRowView *row =  [showDataRows objectAtIndex:i];
                [row bindByPedometerData:[pedoMeterDataArray objectAtIndex:i]];
            }
            
        }
        [self setDatePickerLabelHidden:NO];
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
    /*
     [self displayPedometerDetailByDate:data.optDate];
     */
    referenceDate=data.optDate;
    /*
     for (UIView *view in [pickerView visibleViews]) {
     view.hidden=YES;
     }
     */
}

- (CGFloat)pickerView:(AFPickerView *)pickerView heightForRowAtIndexPath:(NSInteger)rowIndex
{
    return 80.0;
}
- (float)pickerViewRowHeight:(AFPickerView *)pickerView
{
    return 80.0;
}

-(UIView *)pickerView:(AFPickerView *)pickerView cellForRowAtIndexPath:(NSInteger)rowIndex
{
    return [PEDPedoDataRowView instanceView:(PEDPedometerData *)[daysData objectAtIndex:rowIndex]];
}

- (void)pickerViewDidStartScroll:(AFPickerView *)pickerView
{
//    for (UIView *view in [pickerView visibleViews]) {
//        view.hidden=NO;
//    }
//    [self setDatePickerLabelHidden:YES];
}

-(void)setDatePickerLabelHidden:(BOOL)yes
{
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
    [[PEDAppDelegate getInstance].pedPedoViewController initDataByDate: seletedDate];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
