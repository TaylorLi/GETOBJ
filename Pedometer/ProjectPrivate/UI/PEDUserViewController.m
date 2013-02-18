//
//  PEDSecondViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDUserViewController.h"
#import "PEDAppDelegate.h"

@implementation PEDUserViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    bgImage.image = [UIImage imageNamed:@"user.bmp"] ;
    [self.view addSubview:bgImage]; 
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnBack.frame = CGRectMake(30, 380, 80, 25);
    btnBack.backgroundColor = [UIColor clearColor];
    [btnBack setTitle:@"Back" forState:UIControlStateNormal];
    [btnBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backToMainView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnBack];
    
    
    UIButton *btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(190, 381, 94, 25)];
    btnConfirm.backgroundColor = [UIColor clearColor];
    [btnConfirm addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnConfirm];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) backToMainView{
    [[PEDAppDelegate getInstance]showMainView];
}

-(void) confirmClick{
    [[PEDAppDelegate getInstance]showTabView];
}

- (void)viewDidUnload
{
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

@end
