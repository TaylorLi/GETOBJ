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
#import "PEDPedometerCalcHelper.h"
#import "UtilHelper.h"
#import "UIHelper.h"

@interface PEDUserSettingViewController (){
    UITapGestureRecognizer *tapRecognizer;
    NSMutableDictionary *inchFeetDataDictionary;
    NSInteger currRow4Inch;
    NSInteger baseInch4English;
    NSInteger baseFeet4English;
}
-(void)bindUserInfo:(PEDUserInfo *)userInfo;
-(void)bindByUserInfoSetting;
-(void)segUnitChangeToUnit:(MeasureUnit)unit;
-(void)dataConversion:(MeasureUnit)unit;
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
@synthesize pvInchFeet;

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
    lblHeightUnit.text = [NSString stringWithFormat:@"Height (%@)",[PEDPedometerCalcHelper getHeightUnit:unit withWordFormat:false]];
    lblWeightUnit.text = [NSString stringWithFormat:@"Weight (%@)",[PEDPedometerCalcHelper getWeightUnit:unit withWordFormat:false]];
    lblStrideUnit.text = [NSString stringWithFormat:@"Stride (%@)", [PEDPedometerCalcHelper getStrideUnit:unit withWordFormat:false]];
}

-(void) limitTextField :(UITextField*) textField withKey:(NSString*)key withMinValue:(NSInteger) minValue withMaxValue:(NSInteger) maxValue{
    int value = [textField.text intValue];
    if(value < minValue || value > maxValue){
        if(value < minValue){
            textField.text = [NSString stringWithFormat:@"%d", minValue];
        }else{
            textField.text = [NSString stringWithFormat:@"%d", maxValue];
        }
        [UIHelper showAlert:@"Warning" message:[NSString stringWithFormat:@"The range of %@ is %d to %d",key, minValue, maxValue] func:^(AlertView *a, NSInteger i) {
            
        }];
    }
}

-(void)segUnitChange:(id)sender{ 
    UISegmentedControl* segControl = (UISegmentedControl*)sender;
    MeasureUnit unit=segControl.selectedSegmentIndex==0?MEASURE_UNIT_METRIC:MEASURE_UNIT_ENGLISH;
    [self segUnitChangeToUnit:unit];
    
    //    PEDUserInfo *userInfo=[AppConfig getInstance].settings.userInfo;
    [self dataConversion:unit];
    //[userInfo convertUnit:unit];
    if(unit == MEASURE_UNIT_METRIC){
        [self bindUserInfo:cacheUserInfo4Metric];
    }else{
        [self bindUserInfo:cacheUserInfo4English];
    }
    
} 

-(void)dataConversion:(MeasureUnit)unit{
    PEDUserInfo *userInfo=[AppConfig getInstance].settings.userInfo;
    if (!userInfo) {
        userInfo = [[PEDUserInfo alloc]init];
    }
    switch (unit) {
        case MEASURE_UNIT_ENGLISH:
            if(cacheUserInfo4Metric){
                if([self.txbHeight.text intValue] != (int)cacheUserInfo4Metric.height){
                    cacheUserInfo4Metric.height = [self.txbHeight.text floatValue];
                    cacheUserInfo4English.height = [PEDPedometerCalcHelper convertCmToInch:cacheUserInfo4Metric.height];
                    cacheHeight = cacheUserInfo4English.height;
                }
                if([self.txbWeight.text intValue] != (int)cacheUserInfo4Metric.weight){
                    cacheUserInfo4Metric.weight = [self.txbWeight.text floatValue];
                    cacheUserInfo4English.weight = [PEDPedometerCalcHelper convertKgToLbs:cacheUserInfo4Metric.weight];
                }
                if([self.txbStride.text intValue] != (int)cacheUserInfo4Metric.stride){
                    cacheUserInfo4Metric.stride = [self.txbStride.text floatValue];
                    cacheUserInfo4English.stride = [PEDPedometerCalcHelper convertCmToInch:cacheUserInfo4Metric.stride];
                }
                cacheUserInfo4English.age = [self.txbAge.text intValue];
                cacheUserInfo4Metric.age = [self.txbAge.text intValue];
                cacheUserInfo4English.userName = self.txbUserName.text;
                cacheUserInfo4Metric.userName = self.txbUserName.text;
                
                //userInfo = [cacheUserInfo4English copy];
                
            }else{
                cacheUserInfo4Metric = [[PEDUserInfo alloc] init];
                cacheUserInfo4Metric.userId = [UtilHelper stringWithUUID];
                cacheUserInfo4Metric.measureFormat = MEASURE_UNIT_METRIC;
                cacheUserInfo4Metric.height = [self.txbHeight.text floatValue];//m
                cacheUserInfo4Metric.weight = [self.txbWeight.text floatValue];//kg
                cacheUserInfo4Metric.stride = [self.txbStride.text floatValue];//cm
                cacheUserInfo4Metric.userName = self.txbUserName.text;
                cacheUserInfo4Metric.age = [self.txbAge.text intValue];
                userInfo = [cacheUserInfo4Metric copy];
                
                [userInfo convertUnit:MEASURE_UNIT_ENGLISH];
                
                cacheUserInfo4English = [userInfo copy];
                cacheHeight = cacheUserInfo4English.height;
                
            }
            break;
        case MEASURE_UNIT_METRIC:
            if(cacheUserInfo4English){
                if((int)cacheHeight != (int)cacheUserInfo4English.height){
                    cacheUserInfo4English.height = cacheHeight;
                    cacheUserInfo4Metric.height = [PEDPedometerCalcHelper convertInchToCm:cacheUserInfo4English.height];
                }
                if([self.txbWeight.text intValue] != (int)cacheUserInfo4English.weight){
                    cacheUserInfo4English.weight = [self.txbWeight.text floatValue];
                    cacheUserInfo4Metric.weight = [PEDPedometerCalcHelper convertLbsToKg:cacheUserInfo4English.weight];
                }
                if([self.txbStride.text intValue] != (int)cacheUserInfo4English.stride){
                    cacheUserInfo4English.stride = [self.txbStride.text floatValue];
                    cacheUserInfo4Metric.stride = [PEDPedometerCalcHelper convertInchToCm:cacheUserInfo4English.stride];
                }
                cacheUserInfo4English.age = [self.txbAge.text intValue];
                cacheUserInfo4Metric.age = [self.txbAge.text intValue];
                cacheUserInfo4English.userName = self.txbUserName.text;
                cacheUserInfo4Metric.userName = self.txbUserName.text;
                //userInfo = [cacheUserInfo4Metric copy];
            }else{
                cacheUserInfo4English = [[PEDUserInfo alloc] init];
                cacheUserInfo4English.userId = [UtilHelper stringWithUUID];
                cacheUserInfo4English.measureFormat = MEASURE_UNIT_ENGLISH;
                cacheUserInfo4English.height = [self.txbHeight.text floatValue];//m
                cacheUserInfo4English.weight = [self.txbWeight.text floatValue];//kg
                cacheUserInfo4English.stride = [self.txbStride.text floatValue];//cm
                cacheUserInfo4English.age = [self.txbAge.text intValue];
                cacheUserInfo4English.userName = self.txbUserName.text;
                cacheHeight = [self.txbHeight.text floatValue];
                
                userInfo = [cacheUserInfo4English copy];
                
                [userInfo convertUnit:MEASURE_UNIT_METRIC];
                
                cacheUserInfo4Metric = [userInfo copy];
            }
            break;
        default:
            break;
    }
    //    if(cacheUserInfo4Meter){
    //        //        [userInfo convertUnit:unit];
    //        switch (unit) {
    //            case MEASURE_UNIT_ENGLISH:
    //                if([self.txbHeight.text intValue] != (int)cacheUserInfo4Meter.height){
    //                    cacheUserInfo4Meter.height = [self.txbHeight.text floatValue];
    //                }
    //                if([self.txbWeight.text intValue] != (int)cacheUserInfo4Metric.weight){
    //                    cacheUserInfo4Metric.weight = [self.txbWeight.text floatValue];
    //                }
    //                if([self.txbStride.text intValue] != (int)cacheUserInfo4Metric.stride){
    //                    cacheUserInfo4Metric.stride = [self.txbStride.text floatValue];
    //                }
    //                break;
    //            case MEASURE_UNIT_METRIC:
    //                if([self.txbHeight.text intValue] != (int)[PEDPedometerCalcHelper convertInchToFeet:[PEDPedometerCalcHelper convertCmToInch:cacheUserInfo4Metric.height]]){
    //                    cacheUserInfo4Metric.height = [PEDPedometerCalcHelper convertInchToCm:[PEDPedometerCalcHelper convertFeetToInch:[self.txbHeight.text floatValue]]];
    //                }
    //                if([self.txbWeight.text intValue] != (int)[PEDPedometerCalcHelper convertKgToLbs:cacheUserInfo4Metric.weight]){
    //                    cacheUserInfo4Metric.weight = [PEDPedometerCalcHelper convertLbsToKg:[self.txbWeight.text floatValue]];
    //                }
    //                if([self.txbStride.text intValue] != (int)[PEDPedometerCalcHelper convertCmToInch:cacheUserInfo4Metric.stride]){
    //                    cacheUserInfo4Metric.stride = [PEDPedometerCalcHelper convertInchToCm:[self.txbStride.text floatValue]];
    //                }
    //                break;
    //            default:
    //                break;
    //        }
    //        //        cacheUserInfo.measureFormat = unit;
    //        
    //    }else{
    //        cacheUserInfo4Meter = [[PEDUserInfo alloc] init];
    //        cacheUserInfo4Meter.userId = [UtilHelper stringWithUUID];
    //        cacheUserInfo4Meter.measureFormat = MEASURE_UNIT_METRIC;
    //        cacheUserInfo4Meter.height = [self.txbHeight.text floatValue];//m
    //        cacheUserInfo4Meter.weight = [self.txbWeight.text floatValue];//kg
    //        cacheUserInfo4Meter.stride = [self.txbStride.text floatValue];//cm
    //    } 
    //    userInfo = [cacheUserInfo4Meter copy];
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
    /*点击保存时再存到对象
     PEDUserInfo *userInfo=[AppConfig getInstance].settings.userInfo;
     if(userInfo){
     userInfo.gender = segControl.selectedSegmentIndex;
     }
     */
    if(cacheUserInfo4Metric){
        cacheUserInfo4Metric.gender = segControl.selectedSegmentIndex;
    }
    if(cacheUserInfo4English){
        cacheUserInfo4English.gender = segControl.selectedSegmentIndex;
    }
} 

-(void) txbHeightEditBegin{
    //    if(segUnit.selectedSegmentIndex == MEASURE_UNIT_ENGLISH){
    //        txbHeight.text = [NSString stringWithFormat:@"%.0f", cacheHeight];
    //    }    
}

-(void) txbHeightEditEnd:(id) sender{
    //    if(segUnit.selectedSegmentIndex == MEASURE_UNIT_ENGLISH){
    //        [self limitTextField:(UITextField *)sender withKey:@"height" withMinValue:32 withMaxValue:98];
    //        cacheHeight = [txbHeight.text floatValue];
    //        txbHeight.text = [PEDPedometerCalcHelper getFeetInfo:cacheHeight];
    //    }else{
    [self limitTextField:(UITextField *)sender withKey:@"height" withMinValue:80 withMaxValue:250];
    //    }
}

-(void) txbWeightEditEnd:(id) sender{
    if(segUnit.selectedSegmentIndex == MEASURE_UNIT_ENGLISH){
        [self limitTextField:(UITextField *)sender withKey:@"weight" withMinValue:33 withMaxValue:286];
    }else{
        [self limitTextField:(UITextField *)sender withKey:@"weight" withMinValue:15 withMaxValue:130];
    }
}

-(void) txbStrideEditEnd:(id) sender{
    if(segUnit.selectedSegmentIndex == MEASURE_UNIT_ENGLISH){
        [self limitTextField:(UITextField *)sender withKey:@"stride" withMinValue:12 withMaxValue:59];
    }else{
        [self limitTextField:(UITextField *)sender withKey:@"stride" withMinValue:30 withMaxValue:150];
    }
}

-(void) txbAgeEditEnd:(id) sender{
    [self limitTextField:(UITextField *)sender withKey:@"age" withMinValue:5 withMaxValue:99];
}

-(void)txtChanged:(UITextField *)sender{
    if([sender.text hasSuffix:@"."]){
        sender.text = [sender.text substringToIndex:sender.text.length-1];
    }
}

-(void) bindByUserInfoSetting
{
    PEDUserInfo *userInfo=[AppConfig getInstance].settings.userInfo;
    if(userInfo){
        switch (userInfo.measureFormat) {
            case MEASURE_UNIT_METRIC:
                if(!cacheUserInfo4Metric){
                    cacheUserInfo4Metric = [userInfo copy];
                }
                [cacheUserInfo4Metric convertUnit:MEASURE_UNIT_ENGLISH];
                if(!cacheUserInfo4English){
                    cacheUserInfo4English = [cacheUserInfo4Metric copy];
                }
                cacheUserInfo4Metric = [userInfo copy];
                [self bindUserInfo:cacheUserInfo4Metric];
                break;
            case MEASURE_UNIT_ENGLISH:
                userInfo.measureFormat = MEASURE_UNIT_METRIC;
                if(!cacheUserInfo4Metric){
                    cacheUserInfo4Metric = [userInfo copy];
                }
                [cacheUserInfo4Metric convertUnit:MEASURE_UNIT_ENGLISH];
                if(!cacheUserInfo4English){
                    cacheUserInfo4English = [cacheUserInfo4Metric copy];
                }
                cacheUserInfo4Metric = [userInfo copy];
                userInfo.measureFormat = MEASURE_UNIT_ENGLISH;
                [self bindUserInfo:cacheUserInfo4English];
                //userInfo = [cacheUserInfo4English copy];
                break;
            default:
                break;
        }
        cacheHeight = cacheUserInfo4English.height;
        //        MeasureUnit originUnit = userInfo.measureFormat;
        //        if(originUnit == MEASURE_UNIT_ENGLISH){
        //            [userInfo convertUnit:MEASURE_UNIT_METRIC];
        //        }
        //        if(!cacheUserInfo4Meter){
        //            cacheUserInfo4Meter = [userInfo copy];
        //        }
        //        if(originUnit == MEASURE_UNIT_ENGLISH){
        //            [userInfo convertUnit:MEASURE_UNIT_ENGLISH];
        //        }
        // [self bindUserInfo:userInfo];
    }
}

-(void) keyboardWillShow:(NSNotification *) note {
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:tapRecognizer];
}

-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
                [self setCenterPoint:0];
            }
        }
    }
}

-(void) initGesture
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(dismissKeyboard)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    ((UIScrollView *)self.view).delegate=self;
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
    
    [self.txbHeight addTarget:self action:@selector(txbHeightEditBegin) forControlEvents:UIControlEventEditingDidBegin];
    
    [self.txbHeight addTarget:self action:@selector(txbHeightEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self.txbWeight addTarget:self action:@selector(txbWeightEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self.txbStride addTarget:self action:@selector(txbStrideEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self.txbAge addTarget:self action:@selector(txbAgeEditEnd:) forControlEvents:UIControlEventEditingDidEnd];
    
    [self.txbAge addTarget:self action:@selector(txtChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.txbHeight addTarget:self action:@selector(txtChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.txbWeight addTarget:self action:@selector(txtChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.txbStride addTarget:self action:@selector(txtChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self initGesture];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)bindUserInfo:(PEDUserInfo *)userInfo
{
    @try {
        if(userInfo){
            //[userInfo convertUnit:userInfo.measureFormat];
            txbUserName.text=userInfo.userName;
            txbAge.text=[NSString stringWithFormat:@"%i", userInfo.age];
            if(userInfo.measureFormat == MEASURE_UNIT_METRIC){
                pvInchFeet.hidden = YES;
                txbHeight.text=[NSString stringWithFormat:@"%.0f", userInfo.height];
                txbHeight.hidden = NO;
            }else{
                //txbHeight.text = [PEDPedometerCalcHelper getFeetInfo:userInfo.height];
                float inch = userInfo.height/12;
                float feet = (inch - (int)inch) * 12;
                txbHeight.hidden = YES;
                baseInch4English = floor(inch);
                baseFeet4English = floor(feet);
                [pvInchFeet reloadData];
                pvInchFeet.hidden = NO;
            }
            txbWeight.text=[NSString stringWithFormat:@"%.0f", userInfo.weight];
            txbStride.text=[NSString stringWithFormat:@"%.0f", userInfo.stride];
            segGender.selectedSegmentIndex =userInfo.gender? 1:0;
            segUnit.selectedSegmentIndex =userInfo.measureFormat==MEASURE_UNIT_METRIC?0:1;
            [self segUnitChangeToUnit:userInfo.measureFormat];
            [self segGenderChange:segGender];
        }   
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
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
    [self setPvInchFeet:nil];
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
    [self bindByUserInfoSetting];
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
    [UtilHelper sendEmail:@"" andSubject:nil andBody:nil];
    //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://114600001@qq.com"]];
}

- (IBAction)homePageClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.kingtech-hk.com"]];
}

- (IBAction)settingClick:(id)sender {
    [[PEDAppDelegate getInstance] showMainView];
}
- (IBAction)confirmClick:(id)sender {
    @try {
        if([UIHelper validateTextFields: [[NSArray alloc] initWithObjects:txbUserName, txbStride, txbHeight, txbWeight, txbAge, nil]]){
            PEDUserInfo *curr=[AppConfig getInstance].settings.userInfo;
            if(!curr){
                curr=[[PEDUserInfo alloc] initWithDefault];
            }
            if(cacheUserInfo4Metric){
                if(segUnit.selectedSegmentIndex == MEASURE_UNIT_ENGLISH){
                    [self dataConversion:MEASURE_UNIT_METRIC];
                }else{
                    [self dataConversion:MEASURE_UNIT_ENGLISH];
                }
                curr = [cacheUserInfo4Metric copy];
            }else{
                curr.height = [self.txbHeight.text floatValue];//m
                curr.weight = [self.txbWeight.text floatValue];//kg
                curr.stride = [self.txbStride.text floatValue];//cm
                if(segUnit.selectedSegmentIndex == MEASURE_UNIT_ENGLISH){
                    [curr convertUnit:MEASURE_UNIT_METRIC];
                }
            }
            //curr = [cacheUserInfo copy];
            //        if(!curr){
            //            curr = [[PEDUserInfo alloc]init];
            //            curr.userId = [UtilHelper stringWithUUID];
            //        }
            curr.userName = self.txbUserName.text;
            curr.age = [self.txbAge.text intValue];
            
            
            curr.updateDate=[NSDate date];
            curr.isCurrentUser=YES;
            //[curr convertUnit:MEASURE_UNIT_METRIC];
            curr.measureFormat = segUnit.selectedSegmentIndex;
            curr.gender = segGender.selectedSegmentIndex;
            [[AppConfig getInstance] saveUserInfo:curr];    
            [[PEDAppDelegate getInstance] restoreControllerData];
            [[PEDAppDelegate getInstance] showTabView];
        }
    }
    @catch (NSException *exception) {
        [LogHelper errorAndShowAlert:@"Failed to save setting,please retry." exception:exception];
    }
    @finally {
        
    }
}

-(void) initInchFeetData{
    if(!inchFeetDataDictionary){
        inchFeetDataDictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
        NSMutableArray *inchs = [[NSMutableArray alloc]initWithCapacity:7];
        for (int i=2; i<9; i++) {
            [inchs addObject:[NSNumber numberWithInt:i]];
        }
        [inchFeetDataDictionary setObject:inchs forKey:[NSNumber numberWithInt:0]];
        NSMutableArray *feets = [[NSMutableArray alloc]initWithCapacity:3];
        for (int i=8; i<12; i++) {
            [feets addObject:[NSNumber numberWithInt:i]];
        }
        [inchFeetDataDictionary setObject:feets forKey:[NSNumber numberWithInt:1]];
        currRow4Inch = 0;
        baseInch4English = 2;
        baseFeet4English = 8;
    }
}

-(NSInteger) getIndexOfInchFeetDataWithKey:(id)key andValue:(NSInteger) value{
    NSInteger index = 0;
    NSMutableArray *inchFeets = [inchFeetDataDictionary objectForKey:key];
    for (int i=0; i<inchFeets.count; i++) {
        if(value == [[inchFeets objectAtIndex:i] intValue]){
            index = i;
            break;
        }
    }
    return index;
}

-(void) reloadInchFeetDataWithRowIndex :(NSInteger) rowIndex{
    
    NSMutableArray *feets = nil;
    switch (rowIndex) {
        case 0:
            feets = [[NSMutableArray alloc]initWithCapacity:4];
            for (int i=8; i<12; i++) {
                [feets addObject:[NSNumber numberWithInt:i]];
            }
            break;
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            feets = [[NSMutableArray alloc]initWithCapacity:12];
            for (int i=0; i<12; i++) {
                [feets addObject:[NSNumber numberWithInt:i]];
            }
            break;
        case 6:
            feets = [[NSMutableArray alloc]initWithCapacity:3];
            for (int i=0; i<3; i++) {
                [feets addObject:[NSNumber numberWithInt:i]];
            }
            break;
        default:
            break;
    }
    [inchFeetDataDictionary setObject:feets forKey:[NSNumber numberWithInt:1]];
}

#pragma mark -
#pragma mark Picker extend view Delege and Data Source Methods

- (NSString *)pickerView:(PickerExtendView *)pickerView titleForRow:(NSInteger)rowIndex forComponent:(NSInteger)componentIndex{
    NSString *title = @"";
    switch (componentIndex) {
        case 0:
            title = [NSString stringWithFormat:@"%i '", [[[inchFeetDataDictionary objectForKey:[NSNumber numberWithInt: componentIndex]] objectAtIndex:rowIndex]intValue]];
            break;
        case 1:
            title = [NSString stringWithFormat:@"%i \"", [[[inchFeetDataDictionary objectForKey:[NSNumber numberWithInt:componentIndex]] objectAtIndex:rowIndex] intValue]];
        default:
            break;
    }
    return title;
}

- (NSInteger)numberOfComponentsInPickerView:(PickerExtendView *)pickerView{
    [self initInchFeetData];
    return [inchFeetDataDictionary count];
}

- (NSInteger)numberOfRowsToShowForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex{
    return 1;
}

- (NSInteger)maxNumberOfRowsForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex{
    return [[inchFeetDataDictionary objectForKey:[NSNumber numberWithInt:componentIndex]] count] ;
}

- (CGSize)sizeForRowInPickerView:(PickerExtendView *) pickerView{
    return CGSizeMake(35.0f, 15.0f);
}

- (CGFloat)paddingForComponents:(PickerExtendView *) pickerView{
    return 2.0f;
}

- (UIImage *)backgroundImageForPickerView:(PickerExtendView *) pickerView{
    return [UIImage imageNamed:@"pickerBG.png"];
}

-(CGSize) sizeForPickerView :(PickerExtendView *) pickerView{
    return CGSizeMake(79.0f, 20.0f);
}

-(void) pickerViewDidChangeValue:(PickerExtendView *)pickerView seletedRowIndex:(NSInteger)rowIndex atComponentIndex:(NSInteger)componentIndex{
    if(componentIndex == 0){
        baseInch4English = [[[inchFeetDataDictionary objectForKey:[NSNumber numberWithInt:0]] objectAtIndex: [pvInchFeet selectRowIndexWithComponent:0]] intValue];
        if(currRow4Inch != rowIndex){
            [self reloadInchFeetDataWithRowIndex:rowIndex];
            [pickerView reloadData];
            currRow4Inch = rowIndex;
        }
    }else{
        baseFeet4English = [[[inchFeetDataDictionary objectForKey:[NSNumber numberWithInt:1]] objectAtIndex: [pvInchFeet selectRowIndexWithComponent:1]] intValue];
    }
}

- (void)pickerViewDidChangeValue:(PickerExtendView*)pickerView{
    baseInch4English = [[[inchFeetDataDictionary objectForKey:[NSNumber numberWithInt:0]] objectAtIndex: [pvInchFeet selectRowIndexWithComponent:0]] intValue];
    baseFeet4English = [[[inchFeetDataDictionary objectForKey:[NSNumber numberWithInt:1]] objectAtIndex: [pvInchFeet selectRowIndexWithComponent:1]] intValue];
    
    cacheHeight = baseInch4English * 12 + baseFeet4English;
    UIScrollView *scv = (UIScrollView*)self.view;
    scv.scrollEnabled = YES;
}

- (NSInteger)defaultSeletRowForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex{
    NSInteger rowIndex = 0;
    switch (componentIndex) {
        case 0:
            rowIndex = [self getIndexOfInchFeetDataWithKey:[NSNumber numberWithInt:0] andValue:baseInch4English];
            [self reloadInchFeetDataWithRowIndex : rowIndex];
            break;
        case 1:
            rowIndex = [self getIndexOfInchFeetDataWithKey:[NSNumber numberWithInt:1] andValue:baseFeet4English];
        default:
            break;
    }
    return rowIndex;
}

- (UITextAlignment)textAlignmentForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex{
    return UITextAlignmentCenter;
}

- (UIColor *)textColorForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex{
    return [UIColor whiteColor];
}
@end
