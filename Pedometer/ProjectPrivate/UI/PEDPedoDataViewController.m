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
//@synthesize monthSelectView;
@synthesize dayRemark;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        UIImage *tabbarImage = [UIImage imageNamed:@"second.png"] ;
//        UITabBarItem *barItem = [[UITabBarItem alloc]initWithTitle:@"" image:tabbarImage tag:1];
//        self.tabBarItem = barItem;
      //  monthArray = [NSMutableArray arrayWithObjects:@"JUN,12", @"JUL,12", @"AUG,12", @"SEP,12", @"OCT,12", @"NOV,12", @"DEC,12", nil];
        dayRemark = 0;

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
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
    
    [UIView setAnimationDuration:2.0f];
    
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
    
    [UIView commitAnimations];    
} 

-(void)handleSwipeDown:(UITapGestureRecognizer*)recognizer  
{  
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationWillStartSelector:@selector(handleSwipeDownStart:)];
    
    [UIView setAnimationDidStopSelector:@selector(handleSwipeDownStop:finished:)];
    
    [UIView setAnimationDelay:0.0f];
    
    [UIView setAnimationDuration:2.0f];
    
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
    
    [UIView commitAnimations];      
} 

-(void)handleSwipeUpStart:(CAAnimation *)anim

{
    
    NSLog(@"animation is start ...");
    
}


-(void)handleSwipeUpStop:(CAAnimation *)anim finished:(BOOL)flag
{
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
    dayRemark -= 1;
    [self initData];
}

-(void)handleSwipeDownStart:(CAAnimation *)anim

{
    
    NSLog(@"animation is start ...");
    
}


-(void)handleSwipeDownStop:(CAAnimation *)anim finished:(BOOL)flag
{
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
    if(dayRemark < 0){
        dayRemark += 1;
        [self initData];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];  
    doubleRecognizer.numberOfTapsRequired = 2; // 双击  
    
    [self.imgVDataMiddle addGestureRecognizer:doubleRecognizer];  
    
    UISwipeGestureRecognizer *upRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];   
    [upRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];   
    [self.imgVDataMiddle addGestureRecognizer:upRecognizer];
    
    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];   
    [downRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];   
    [self.imgVDataMiddle addGestureRecognizer:downRecognizer];

    [self initData];
	// Do any additional setup after loading the view, typically from a nib.
    
//    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 410)];
//    bgImage.image = [UIImage imageNamed:@"data.bmp"] ;
//    [self.view addSubview:bgImage]; 
//    
    
//    CGFloat pickerHeight = 40.0f;
//    CGFloat width=[UIScreen mainScreen].bounds.size.width;
//	CGFloat x = 0;
//	CGFloat y = 331.0f;
//	CGRect tmpFrame = CGRectMake(x, y, width, pickerHeight);
//    
//	monthSelectView = [[V8HorizontalPickerView alloc] initWithFrame:tmpFrame];
//    monthSelectView.backgroundColor   = [UIColor clearColor];
//	monthSelectView.selectedTextColor = [UIColor whiteColor];
//	monthSelectView.textColor   = [UIColor grayColor];
//	monthSelectView.delegate    = self;
//	monthSelectView.dataSource  = self;
//	monthSelectView.elementFont = [UIFont boldSystemFontOfSize:11.0f];
//    monthSelectView.selectedElementFont=[UIFont boldSystemFontOfSize:14.0f];
//	monthSelectView.selectionPoint = CGPointMake(tmpFrame.size.width/2, 0);
//    [self.view addSubview:monthSelectView];
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

-(NSArray *) getPedoDataResources : (NSInteger) daySpacing withTargetId:(NSString*) targetId{
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSinceNow: (dayRemark - 1) * (24 * 60 * 60)];
    NSDate *dateTo = [NSDate dateWithTimeIntervalSinceNow: (dayRemark == 0 ? 0 : 1 + dayRemark) * (24 * 60 * 60)];
    NSArray *pedoDataArray = [[BO_PEDPedometerData getInstance] queryListFromDateNeedEmptySorted:dateFrom toDate:dateTo withTargetId:targetId];
    return pedoDataArray;
}

- (void) initData{
    PEDUserInfo *userInfo = [AppConfig getInstance].settings.userInfo;
    NSString* targetId = [AppConfig getInstance].settings.target.targetId;
    self.lblUserName.text = userInfo.userName;
    self.lblLastUpdate.text = [UtilHelper formateDate:[[BO_PEDPedometerData getInstance] getLastUploadDate:targetId] withFormat:@"dd/MM/yy"];
    pedoMeterDataArray = [self getPedoDataResources:dayRemark withTargetId:targetId];
    if(pedoMeterDataArray != nil){
        PEDPedometerData *pedoMeterData = [pedoMeterDataArray objectAtIndex:0];
        if(pedoMeterData.optDate != nil){
            lblPrevDate.text = [UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"];
            lblPrevStep.text = [PEDPedometerDataHelper integerToString: pedoMeterData.step];
            lblPrevDistance.text = [NSString stringWithFormat:@"%.1f%@", pedoMeterData.distance, [PEDPedometerCalcHelper getDistanceUnit:userInfo.measureFormat withWordFormat:YES]];
            lblPrevCalories.text = [NSString stringWithFormat:@"%.1fKcal", pedoMeterData.calorie];
            lblPrevActTime.text = [PEDPedometerDataHelper integerToTimeString:(int)pedoMeterData.activeTime];
        }
        pedoMeterData = [pedoMeterDataArray objectAtIndex:1];
        if(pedoMeterData.optDate != nil){
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
        if(pedoMeterDataArray.count > 2){
            pedoMeterData = [pedoMeterDataArray objectAtIndex:2];
            if(pedoMeterData.optDate != nil){
                lblNextDate.text = [UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"];
                lblNextStep.text = [PEDPedometerDataHelper integerToString: pedoMeterData.step];
                lblNextDistance.text = [NSString stringWithFormat:@"%.1f%@", pedoMeterData.distance, [PEDPedometerCalcHelper getDistanceUnit:userInfo.measureFormat withWordFormat:YES]];
                lblNextCalories.text = [NSString stringWithFormat:@"%.1fKcal", pedoMeterData.calorie];
                lblNextActTime.text = [PEDPedometerDataHelper integerToTimeString:(int)pedoMeterData.activeTime];
            }
            
        }
    }
}
@end
