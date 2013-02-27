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

@implementation PEDUserSettingViewController
@synthesize btnSetting;
@synthesize btnContactUs;
@synthesize btnHomePage;
@synthesize btnConfirm;
@synthesize heightUnit;
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

-(void)segUnitChange:(id)sender{  
    UISegmentedControl* segControl = (UISegmentedControl*)sender;  
    switch (segControl.selectedSegmentIndex) {  
        case 0:  
            [segControl setImage:[UIImage imageNamed:@"segment_sel_left"] forSegmentAtIndex:0];
            [segControl setImage:[UIImage imageNamed:@"segment_normal"] forSegmentAtIndex:1];  
            unitSegTitleLeft.hidden = NO;
            unitSegTitleRight.hidden = YES;
            heightUnit.text = @"cm";
            break;  
        case 1:  
            [segControl setImage:[UIImage imageNamed:@"segment_normal"] forSegmentAtIndex:0];
            [segControl setImage:[UIImage imageNamed:@"segment_sel_left"] forSegmentAtIndex:1];  
            unitSegTitleLeft.hidden = YES;
            unitSegTitleRight.hidden = NO;
            heightUnit.text = @"inch";
            break;  
        default:  
            break;  
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
    self.view.frame = CGRectMake(0, 20, 320, 460);
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
    segUnit.selectedSegmentIndex = 0;
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
    segGender.selectedSegmentIndex = 0;
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
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setBtnSetting:nil];
    [self setBtnContactUs:nil];
    [self setBtnHomePage:nil];
    [self setBtnConfirm:nil];
    [self setHeightUnit:nil];
    [self setTxbUserName:nil];
    [self setTxbStride:nil];
    [self setTxbHeight:nil];
    [self setTxbWeight:nil];
    [self setTxbAge:nil];
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
        PEDUserInfo *curr = [[PEDUserInfo alloc]init];
        curr.userId = [UtilHelper stringWithUUID];
        curr.userName = self.txbUserName.text;
        curr.age = [self.txbAge.text intValue];
        curr.measureFormat = segUnit.selectedSegmentIndex;
        curr.gender = segGender.selectedSegmentIndex;
        curr.height = [self.txbHeight.text floatValue];//m
        curr.weight = [self.txbWeight.text floatValue];//kg
        curr.stride = [self.txbWeight.text floatValue];//cm
        curr.updateDate=[NSDate date];
        curr.isCurrentUser=YES;
        [[AppConfig getInstance] saveAppSetting: curr];
        [[PEDAppDelegate getInstance]showTabView];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{        
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.        
    NSTimeInterval animationDuration = 0.30f;        
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];        
    [UIView setAnimationDuration:animationDuration];        
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);        
    self.view.frame = rect;        
    [UIView commitAnimations];        
    [textField resignFirstResponder];
    return YES;        
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{        
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;                
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];                
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;                
    float height = self.view.frame.size.height;        
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);                
        self.view.frame = rect;        
    }        
    [UIView commitAnimations];                
}

@end
