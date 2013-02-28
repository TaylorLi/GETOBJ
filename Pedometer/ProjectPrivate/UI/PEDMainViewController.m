//
//  PEDSecondViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDMainViewController.h"
#import "PEDAppDelegate.h"
#import "AppConfig.h"

@implementation PEDMainViewController
@synthesize btnFitPlus;
@synthesize btnHealthPlus;
@synthesize btnSportPlus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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

    //[self setWantsFullScreenLayout:YES];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setBtnFitPlus:nil];
    [self setBtnHealthPlus:nil];
    [self setBtnSportPlus:nil];
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
    [UtilHelper sendEmail:@"114600001@qq.com" andSubject:nil andBody:nil];
}

- (IBAction)homePageClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.kingtech-hk.com"]];
}

- (IBAction)fitPlusClick:(id)sender {
    [AppConfig getInstance].settings.plusType = PLUS_FIT;
    if([AppConfig getInstance].settings.userInfo){
        [[PEDAppDelegate getInstance] showTabView];
    }else{
        [[PEDAppDelegate getInstance] showUserSettingView];
    }
}

- (IBAction)healthPlusClick:(id)sender {
    [AppConfig getInstance].settings.plusType = PLUS_HEALTH;
}

- (IBAction)sportPlusClick:(id)sender {
    [AppConfig getInstance].settings.plusType = PLUS_SPORT;
}

- (IBAction)settingClick:(id)sender {
    [[PEDAppDelegate getInstance] showUserSettingView];
}
@end
