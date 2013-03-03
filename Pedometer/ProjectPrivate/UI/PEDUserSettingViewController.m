//
//  PEDSecondViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDUserSettingViewController.h"
#import "PEDAppDelegate.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "UIHelper.h"
#import "PEDUserInfo.h"
#import "AppConfig.h"
#import "BO_PEDUserInfo.h"

@interface PEDUserSettingViewController ()
-(void)bindUserInfo:(PEDUserInfo *)userInfo;
-(void)segUnitChangeToUnit:(MeasureUnit)unit;
@end

@implementation PEDUserSettingViewController
@synthesize lblStrideUnit;
@synthesize lblWeightUnit;
@synthesize lblHeightUnit;
@synthesize txbUserName;
@synthesize txbStride;
@synthesize txbHeight;
@synthesize txbWeight;
@synthesize txbAge;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if(!self.navigationController.navigationBarHidden){
            self.navigationController.navigationBar.hidden = YES;
        } 
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)segUnitChangeToUnit:(MeasureUnit)unit
{
    switch (unit) {  
        case MEASURE_UNIT_METRIC:  
            [segUnit setImage:[UIImage imageNamed:@"segment_sel_left"] forSegmentAtIndex:0];
            [segUnit setImage:[UIImage imageNamed:@"segment_normal"] forSegmentAtIndex:1];  
            unitSegTitleLeft.hidden = NO;
            unitSegTitleRight.hidden = YES;
//            lblHeightUnit.text = @"cm";
//            lblStrideUnit.text = @"Stride(cm)";
//            lblWeightUnit.text = @"kg";
            break;  
        case MEASURE_UNIT_ENGLISH:  
            [segUnit setImage:[UIImage imageNamed:@"segment_normal"] forSegmentAtIndex:0];
            [segUnit setImage:[UIImage imageNamed:@"segment_sel_left"] forSegmentAtIndex:1];  
            unitSegTitleLeft.hidden = YES;
            unitSegTitleRight.hidden = NO;
            break;  
        default:  
            break;  
    }  
    lblHeightUnit.text = [PEDPedometerCalcHelper getHeightUnit:unit withWordFormat:false];
    lblWeightUnit.text = [PEDPedometerCalcHelper getWeightUnit:unit withWordFormat:false];
    lblStrideUnit.text = [NSString stringWithFormat:@"Stride(%@)", [PEDPedometerCalcHelper getStrideUnit:unit withWordFormat:false]];
}
-(void)segUnitChange:(id)sender{ 
    UISegmentedControl* segControl = (UISegmentedControl*)sender;
    MeasureUnit unit=segControl.selectedSegmentIndex==0?MEASURE_UNIT_METRIC:MEASURE_UNIT_ENGLISH;
    [self segUnitChangeToUnit:unit];
    
    PEDUserInfo *userInfo=[AppConfig getInstance].settings.userInfo;
    userInfo.height = [self.txbHeight.text floatValue];//m
    userInfo.weight = [self.txbWeight.text floatValue];//kg
    userInfo.stride = [self.txbStride.text floatValue];//cm
    if(userInfo){
        [userInfo convertUnit:unit];
        [self bindUserInfo:userInfo];
    }        

} 

-(void)segGenderChange:(id)sender{  
    UISegmentedControl* segControl = (UISegmentedControl*)sender;  
    switch (segControl.selectedSegmentIndex) {  
        case 0:  
            [segControl setImage:[UIImage imageNamed:@"segment_sel_left"] forSegmentAtIndex:0];
            [segControl setImage:[UIImage imageNamed:@"segment_normal"] forSegmentAtIndex:1];  
            genderSegTitleLeft.hidden = NO;
            genderSegTitleRight.hidden = YES;
            break;  
        case 1:  
            [segControl setImage:[UIImage imageNamed:@"segment_normal"] forSegmentAtIndex:0];
            [segControl setImage:[UIImage imageNamed:@"segment_sel_left"] forSegmentAtIndex:1];  
            genderSegTitleLeft.hidden = YES;
            genderSegTitleRight.hidden = NO;
            break;  
        default:  
            break;  
    }  
} 

- (void)viewDidLoad
{
    [super viewDidLoad];    
    ((UIScrollView *)self.view).delegate=self;
    //self.view.frame = CGRectMake(0, 20, 320, 460);
    //  UIColor *myTint = [[ UIColor alloc]initWithRed:0.66 green:1.0 blue:0.77 alpha:1.0];  
    segUnit = [[UISegmentedControl alloc]initWithFrame:CGRectMake(210, 126, 76, 18)];
    segUnit.segmentedControlStyle = UISegmentedControlStyleBar;
    //   segUnit.tintColor = myTint; 
    [segUnit insertSegmentWithImage:[UIImage imageNamed:@"segment_sel_left"] atIndex:0 animated:NO]; 
    [segUnit insertSegmentWithImage:[UIImage imageNamed:@"segment_normal"] atIndex:1 animated:NO]; 
    [segUnit setWidth:38 forSegmentAtIndex:0];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont fontWithName:@"Arial" size:8],UITextAttributeFont ,nil];      
//    [segGender setTitleTextAttributes:dic forState:UIControlStateNormal];
    // segUnit.momentary = YES; 
    segUnit.selectedSegmentIndex =0;
    [segUnit addTarget:self action:@selector(segUnitChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segUnit];
    
    unitSegTitleLeft = [[UILabel alloc] initWithFrame:CGRectMake(215, 126, 33, 18)];
    unitSegTitleLeft.text = @"Metric";
    unitSegTitleLeft.textColor = [UIColor whiteColor];
    unitSegTitleLeft.backgroundColor = [UIColor clearColor];
    unitSegTitleLeft.font = [UIFont fontWithName:@"Arial" size:10];
    [self.view addSubview:unitSegTitleLeft];
    
    unitSegTitleRight = [[UILabel alloc] initWithFrame:CGRectMake(251, 126, 35, 18)];
    unitSegTitleRight.text = @"English";
    unitSegTitleRight.textColor = [UIColor whiteColor];
    unitSegTitleRight.backgroundColor = [UIColor clearColor];
    unitSegTitleRight.font = [UIFont fontWithName:@"Arial" size:10];
    unitSegTitleRight.hidden = YES;
    [self.view addSubview:unitSegTitleRight];
    
    segGender = [[UISegmentedControl alloc]initWithFrame:CGRectMake(210, 270, 76, 18)];
    segGender.segmentedControlStyle = UISegmentedControlStyleBar;
    //   segGender.tintColor = myTint; 
    [segGender insertSegmentWithImage:[UIImage imageNamed:@"segment_sel_left.png"]  atIndex:0 animated:NO]; 
    [segGender insertSegmentWithImage:[UIImage imageNamed:@"segment_normal.png"]  atIndex:1 animated:NO]; 
    [segGender setWidth:38 forSegmentAtIndex:0];
    segGender.selectedSegmentIndex =0;
    [segGender addTarget:self action:@selector(segGenderChange:) forControlEvents:UIControlEventValueChanged];
    // segGender.momentary = YES; 
    [self.view addSubview:segGender];
    
    genderSegTitleLeft = [[UILabel alloc] initWithFrame:CGRectMake(225, 270, 23, 18)];
    genderSegTitleLeft.text = @"M";
    genderSegTitleLeft.textColor = [UIColor whiteColor];
    genderSegTitleLeft.backgroundColor = [UIColor clearColor];
    genderSegTitleLeft.font = [UIFont fontWithName:@"Arial" size:10];
    [self.view addSubview:genderSegTitleLeft];
    
    genderSegTitleRight = [[UILabel alloc] initWithFrame:CGRectMake(261, 270, 25, 18)];
    genderSegTitleRight.text = @"F";
    genderSegTitleRight.textColor = [UIColor whiteColor];
    genderSegTitleRight.backgroundColor = [UIColor clearColor];
    genderSegTitleRight.font = [UIFont fontWithName:@"Arial" size:10];
    genderSegTitleRight.hidden = YES;
    [self.view addSubview:genderSegTitleRight];
    PEDUserInfo *userInfo=[AppConfig getInstance].settings.userInfo;
    if(userInfo){
        [self bindUserInfo:userInfo];
    }
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)bindUserInfo:(PEDUserInfo *)userInfo
{
    if(userInfo){
        [userInfo convertUnit:userInfo.measureFormat];
        txbUserName.text=userInfo.userName;
        txbAge.text=[NSString stringWithFormat:@"%i", userInfo.age];
        txbHeight.text=[NSString stringWithFormat:@"%.2f", userInfo.height];
        txbWeight.text=[NSString stringWithFormat:@"%.2f", userInfo.weight];
        txbStride.text=[NSString stringWithFormat:@"%.2f", userInfo.stride];
        segGender.selectedSegmentIndex =userInfo.gender? 0:1;
        segUnit.selectedSegmentIndex =userInfo.measureFormat==MEASURE_UNIT_METRIC?0:1;
        [self segUnitChangeToUnit:userInfo.measureFormat];
        [self segGenderChange:nil];
    }    
}

- (void)viewDidUnload
{
    [self setLblHeightUnit:nil];
    [self setTxbUserName:nil];
    [self setTxbStride:nil];
    [self setTxbHeight:nil];
    [self setTxbWeight:nil];
    [self setTxbAge:nil];
    [self setLblStrideUnit:nil];
    [self setLblWeightUnit:nil];
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

- (IBAction)contactUsClick:(id)sender {
    [UtilHelper sendEmail:@"114600001@qq.com" andSubject:nil andBody:nil];
 //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://114600001@qq.com"]];
}

- (IBAction)homePageClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.kingtech-hk.com"]];
}

- (IBAction)settingClick:(id)sender {
    [[PEDAppDelegate getInstance] showMainView];
}
- (IBAction)confirmClick:(id)sender {
    if([UIHelper validateTextFields: [[NSArray alloc] initWithObjects:txbUserName, txbStride, txbHeight, txbWeight, txbAge, nil]]){
        PEDUserInfo *curr=[AppConfig getInstance].settings.userInfo;
        if(!curr){
            curr = [[PEDUserInfo alloc]init];
            curr.userId = [UtilHelper stringWithUUID];
        }
        curr.userName = self.txbUserName.text;
        curr.age = [self.txbAge.text intValue];
        curr.height = [self.txbHeight.text floatValue];//m
        curr.weight = [self.txbWeight.text floatValue];//kg
        curr.stride = [self.txbStride.text floatValue];//cm
        curr.updateDate=[NSDate date];
        curr.isCurrentUser=YES;
        [curr convertUnit:MEASURE_UNIT_METRIC];
        curr.measureFormat = segUnit.selectedSegmentIndex;
        curr.gender = segGender.selectedSegmentIndex;
        [[AppConfig getInstance] saveUserInfo:curr];    
        [[PEDAppDelegate getInstance] restoreControllerData];
        [[PEDAppDelegate getInstance] showTabView];
    }
}
@end
