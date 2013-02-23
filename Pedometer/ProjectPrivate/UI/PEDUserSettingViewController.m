//
//  PEDSecondViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDUserSettingViewController.h"
#import "PEDAppDelegate.h"

@implementation PEDUserSettingViewController
@synthesize btnSetting;
@synthesize btnContactUs;
@synthesize btnHomePage;
@synthesize btnConfirm;

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
            break;  
        case 1:  
            [segControl setImage:[UIImage imageNamed:@"segment_normal"] forSegmentAtIndex:0];
            [segControl setImage:[UIImage imageNamed:@"segment_sel_left"] forSegmentAtIndex:1];  
            unitSegTitleLeft.hidden = YES;
            unitSegTitleRight.hidden = NO;
            break;  
        default:  
            break;  
    }  
} 

- (void)viewDidLoad
{
    [super viewDidLoad];
    txtUserName = [[UITextField alloc]initWithFrame:CGRectMake(170, 93, 116, 18)];
    txtUserName.backgroundColor = [UIColor clearColor];
    txtUserName.borderStyle = UITextBorderStyleNone;
    txtUserName.background = [UIImage imageNamed:@"setting_tb.png"];
    txtUserName.font = [UIFont fontWithName:@"Arial" size:13.0f];
    txtUserName.textColor = [UIColor whiteColor];
   // txtUserName.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtUserName.textAlignment = UITextAlignmentCenter;
    txtUserName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtUserName.delegate =self;
    [self.view addSubview:txtUserName];
    
    txtStride = [[UITextField alloc]initWithFrame:CGRectMake(248, 178, 38, 18)];
    txtStride.backgroundColor = [UIColor clearColor];
    txtStride.borderStyle = UITextBorderStyleNone;
    txtStride.background = [UIImage imageNamed:@"setting_textbox.png"];
    txtStride.font = [UIFont fontWithName:@"Arial" size:13.0f];
    txtStride.textColor = [UIColor whiteColor];
    txtStride.textAlignment = UITextAlignmentCenter;
    txtStride.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtStride.delegate =self;
    [self.view addSubview:txtStride];
    
    txtHeight = [[UITextField alloc]initWithFrame:CGRectMake(248, 212, 38, 18)];
    txtHeight.backgroundColor = [UIColor clearColor];
    txtHeight.borderStyle = UITextBorderStyleNone;
    txtHeight.background = [UIImage imageNamed:@"setting_textbox.png"];
    txtHeight.font = [UIFont fontWithName:@"Arial" size:13.0f];
    txtHeight.textColor = [UIColor whiteColor];
    txtHeight.textAlignment = UITextAlignmentCenter;
    txtHeight.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtHeight.delegate =self;
    [self.view addSubview:txtHeight];
    
    txtWeight = [[UITextField alloc]initWithFrame:CGRectMake(248, 245, 38, 18)];
    txtWeight.backgroundColor = [UIColor clearColor];
    txtWeight.borderStyle = UITextBorderStyleNone;
    txtWeight.background = [UIImage imageNamed:@"setting_textbox.png"];
    txtWeight.font = [UIFont fontWithName:@"Arial" size:13.0f];
    txtWeight.textColor = [UIColor whiteColor];
    txtWeight.textAlignment = UITextAlignmentCenter;
    txtWeight.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtWeight.delegate =self;
    [self.view addSubview:txtWeight];
    
    txtAge = [[UITextField alloc]initWithFrame:CGRectMake(248, 340, 38, 18)];
    txtAge.backgroundColor = [UIColor clearColor];
    txtAge.borderStyle = UITextBorderStyleNone;
    txtAge.background = [UIImage imageNamed:@"setting_textbox.png"];
    txtAge.font = [UIFont fontWithName:@"Arial" size:13.0f];
    txtAge.textColor = [UIColor whiteColor];
    txtAge.textAlignment = UITextAlignmentCenter;
    txtAge.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txtAge.delegate =self;
    [self.view addSubview:txtAge];
    
    //  UIColor *myTint = [[ UIColor alloc]initWithRed:0.66 green:1.0 blue:0.77 alpha:1.0];  
    segUnit = [[UISegmentedControl alloc]initWithFrame:CGRectMake(210, 146, 76, 18)];
    segUnit.segmentedControlStyle = UISegmentedControlStyleBar;
    //   segUnit.tintColor = myTint; 
    [segUnit insertSegmentWithTitle:@"Metric" atIndex:0 animated:YES]; 
    [segUnit insertSegmentWithTitle:@"English" atIndex:1 animated:YES]; 
    [segUnit setImage:[UIImage imageNamed:@"segment_sel_left"] forSegmentAtIndex:0];
    [segUnit setImage:[UIImage imageNamed:@"segment_normal"] forSegmentAtIndex:1];
    [segUnit setWidth:38 forSegmentAtIndex:0];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[UIFont fontWithName:@"Arial" size:8],UITextAttributeFont ,nil];      
//    [segGender setTitleTextAttributes:dic forState:UIControlStateNormal];
    // segUnit.momentary = YES; 
    segUnit.selectedSegmentIndex = 0;
    [segUnit addTarget:self action:@selector(segUnitChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segUnit];
    
    unitSegTitleLeft = [[UILabel alloc] initWithFrame:CGRectMake(215, 146, 33, 18)];
    unitSegTitleLeft.text = @"Metric";
    unitSegTitleLeft.textColor = [UIColor whiteColor];
    unitSegTitleLeft.backgroundColor = [UIColor clearColor];
    unitSegTitleLeft.font = [UIFont fontWithName:@"Arial" size:10];
    [self.view addSubview:unitSegTitleLeft];
    
    unitSegTitleRight = [[UILabel alloc] initWithFrame:CGRectMake(251, 146, 35, 18)];
    unitSegTitleRight.text = @"English";
    unitSegTitleRight.textColor = [UIColor whiteColor];
    unitSegTitleRight.backgroundColor = [UIColor clearColor];
    unitSegTitleRight.font = [UIFont fontWithName:@"Arial" size:10];
    unitSegTitleRight.hidden = YES;
    [self.view addSubview:unitSegTitleRight];
    
    segGender = [[UISegmentedControl alloc]initWithFrame:CGRectMake(210, 290, 76, 18)];
    segGender.segmentedControlStyle = UISegmentedControlStyleBar;
    //   segGender.tintColor = myTint; 
    [segGender insertSegmentWithImage:[UIImage imageNamed:@"segment_sel_left.png"]  atIndex:0 animated:YES]; 
    [segGender insertSegmentWithImage:[UIImage imageNamed:@"segment_normal.png"]  atIndex:1 animated:YES]; 
    [segGender setTitle:@"F" forSegmentAtIndex:0];
    [segGender setTitle:@"M" forSegmentAtIndex:1];
    [segGender setWidth:38 forSegmentAtIndex:0];

    // segGender.momentary = YES; 
    [self.view addSubview:segGender];
    
//    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
//    bgImage.image = [UIImage imageNamed:@"user.bmp"] ;
//    [self.view addSubview:bgImage]; 
//    
//    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btnBack.frame = CGRectMake(30, 380, 80, 25);
//    btnBack.backgroundColor = [UIColor clearColor];
//    [btnBack setTitle:@"Back" forState:UIControlStateNormal];
//    [btnBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btnBack addTarget:self action:@selector(backToMainView) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:btnBack];
//    
//    
//    UIButton *btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(190, 381, 94, 25)];
//    btnConfirm.backgroundColor = [UIColor clearColor];
//    [btnConfirm addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:btnConfirm];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

//-(void) backToMainView{
//    [[PEDAppDelegate getInstance]showMainView];
//}
//
//-(void) confirmClick{
//    [[PEDAppDelegate getInstance]showTabView];
//}

- (void)viewDidUnload
{
    [self setBtnSetting:nil];
    [self setBtnContactUs:nil];
    [self setBtnHomePage:nil];
    [self setBtnConfirm:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
}

- (IBAction)homePageClick:(id)sender {
}

- (IBAction)settingClick:(id)sender {
    [[PEDAppDelegate getInstance] showMainView];
}
- (IBAction)confirmClick:(id)sender {
    [[PEDAppDelegate getInstance]showTabView];
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
