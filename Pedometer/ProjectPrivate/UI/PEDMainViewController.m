//
//  PEDSecondViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDMainViewController.h"
#import "PEDAppDelegate.h"

@implementation PEDMainViewController
@synthesize btnFitPlus;
@synthesize btnHealthPlus;
@synthesize btnSportPlus;
@synthesize btnSetting;
@synthesize btnContactUs;
@synthesize btnHomePage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
//        bgImage.image = [UIImage imageNamed:@"main.bmp"] ;
//        [self.view addSubview:bgImage]; 
//        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(35, 286, 254, 28)];
//        button.backgroundColor = [UIColor clearColor];
//        [button addTarget:self action:@selector(fitPlusClick) forControlEvents:UIControlEventTouchDown];
//        [self.view addSubview:button];
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
    [self setBtnSetting:nil];
    [self setBtnContactUs:nil];
    [self setBtnHomePage:nil];
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

- (IBAction)fitPlusClick:(id)sender {
    [[PEDAppDelegate getInstance] showUserSettingView];
}

- (IBAction)healthPlusClick:(id)sender {
}

- (IBAction)sportPlusClick:(id)sender {
}

- (IBAction)settingClick:(id)sender {
    [[PEDAppDelegate getInstance] showUserSettingView];
}
@end
