//
//  PEDSecondViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDTargetViewController.h"
#import "BO_PEDPedometerData.h"
#import "PEDPedometerCalcHelper.h"
#import "PEDPedometerDataHelper.h"

@implementation PEDTargetViewController
@synthesize lblUserName;
@synthesize lblLastUpdate;
@synthesize lblStepTarget;
@synthesize lblStepAmount;
@synthesize lblStepRemain;
@synthesize imgVStep;
@synthesize lblDistanceTarget;
@synthesize lblDistanceAmount;
@synthesize lblDistanceRemain;
@synthesize imgVDistance;
@synthesize lblCaloriesTarget;
@synthesize lblCaloriesAmount;
@synthesize lblCaloriesRemain;
@synthesize imgVCalories;
@synthesize lblMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        UIImage *tabbarImage = [UIImage imageNamed:@"second.png"] ;
        //        UITabBarItem *barItem = [[UITabBarItem alloc]initWithTitle:@"" image:tabbarImage tag:2];
        //        self.tabBarItem = barItem;
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
    [self initData];
	// Do any additional setup after loading the view, typically from a nib.
}

- (CGFloat)percentOfTarget:(CGFloat) target withRemain:(CGFloat) remain{
    if(target == remain) return 0;
    return (target - remain) * 219 / target;
}

- (void)viewDidUnload
{
    [self setLblUserName:nil];
    [self setLblLastUpdate:nil];
    [self setLblStepTarget:nil];
    [self setLblStepAmount:nil];
    [self setLblStepRemain:nil];
    [self setImgVStep:nil];
    [self setLblDistanceTarget:nil];
    [self setLblDistanceAmount:nil];
    [self setLblDistanceRemain:nil];
    [self setImgVDistance:nil];
    [self setLblCaloriesTarget:nil];
    [self setLblCaloriesAmount:nil];
    [self setLblCaloriesRemain:nil];
    [self setImgVCalories:nil];
    [self setLblMessage:nil];
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

- (void) initData{
    @try {
        PEDUserInfo *userInfo = [AppConfig getInstance].settings.userInfo;
        PEDTarget *target = [AppConfig getInstance].settings.target;
        lblLastUpdate.text = [UtilHelper formateDate:target.updateDate withFormat:@"dd/MM/yy"];
        lblUserName.text = userInfo.userName;
        lblStepTarget.text = [NSString stringWithFormat:@"%i", target.targetStep];
        lblStepRemain.text = [NSString stringWithFormat:@"%i", target.remainStep];
        lblStepAmount.text = [NSString stringWithFormat:@"%i", target.targetStep - target.remainStep];
        NSString *distanceUnit = [PEDPedometerCalcHelper getDistanceUnit:userInfo.measureFormat withWordFormat:YES];
        NSTimeInterval targetDistance = userInfo.measureFormat == MEASURE_UNIT_METRIC ? target.targetDistance : [PEDPedometerCalcHelper convertKmToMile:target.targetDistance];
        NSTimeInterval remainDistance = userInfo.measureFormat == MEASURE_UNIT_METRIC ? target.remainDistance : [PEDPedometerCalcHelper convertKmToMile:target.remainDistance];
        lblDistanceTarget.text = [NSString stringWithFormat:@"%.2f%@", targetDistance, distanceUnit];
        lblDistanceRemain.text = [NSString stringWithFormat:@"%.2f", remainDistance];
        lblDistanceAmount.text = [NSString stringWithFormat:@"%.2f", targetDistance - remainDistance];
        lblCaloriesTarget.text = [NSString stringWithFormat:@"%.1f", target.targetCalorie];
        lblCaloriesRemain.text = [NSString stringWithFormat:@"%.1f", target.remainCalorie];
        lblCaloriesAmount.text = [NSString stringWithFormat:@"%.1f", target.targetCalorie - target.remainCalorie];
        UIImage *stepImage = [[UIImage imageNamed:@"target_step_bar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,45,0,45)];
        UIImage *caloriesImage = [[UIImage imageNamed:@"target_calories_bar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,58,0,58)];
        UIImage *distanceImage = [[UIImage imageNamed:@"target_distance_bar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,58,0,58)];
        imgVStep.frame = CGRectMake(69, 119, [self percentOfTarget:target.targetStep withRemain:target.remainStep], 15);
        imgVStep.image = stepImage;
        imgVCalories.frame = CGRectMake(69, 300, [self percentOfTarget:target.targetCalorie withRemain:target.remainCalorie], 15);
        imgVCalories.image = caloriesImage;
        imgVDistance.frame = CGRectMake(69, 210, [self percentOfTarget:targetDistance withRemain:remainDistance], 15);
        imgVDistance.image = distanceImage;
        int lblStepRemainX = imgVStep.frame.size.width - lblStepRemain.frame.size.width;
        int lblCaloriesRemainX = imgVCalories.frame.size.width - lblCaloriesRemain.frame.size.width;
        int lblDistanceRemainX = imgVDistance.frame.size.width - lblDistanceRemain.frame.size.width;
        lblStepRemain.frame = CGRectMake( imgVStep.frame.origin.x + (lblStepRemainX <= 10 ? 0 : lblStepRemainX - 10), 116, 42, 21) ; 
        lblCaloriesRemain.frame = CGRectMake(imgVCalories.frame.origin.x + (lblCaloriesRemainX <= 10 ? 0 : lblCaloriesRemainX - 10), 297, 42, 21) ; 
        lblDistanceRemain.frame = CGRectMake(imgVDistance.frame.origin.x + (lblDistanceRemainX <= 10 ? 0 : lblDistanceRemainX - 10), 207, 37, 21) ; 
        
        lblMessage.text = [PEDPedometerDataHelper getTargetRemark:(target.targetStep - target.remainStep)*1.0/target.targetStep withDistancePercent:(target.targetDistance - target.remainDistance)/target.targetDistance withCaloriesPercent:(target.targetCalorie - target.remainCalorie)/target.targetCalorie];
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
    
}

@end
