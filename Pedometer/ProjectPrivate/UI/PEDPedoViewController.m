//
//  PEDSecondViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDPedoViewController.h"

@implementation PEDPedoViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 410)];
    bgImage.image = [UIImage imageNamed:@"pedo.bmp"] ;
    [self.view addSubview:bgImage]; 
    
    UIButton *btnDayStatistics = [[UIButton alloc] initWithFrame:CGRectMake(131, 302, 58, 29)];
    btnDayStatistics.backgroundColor = [UIColor clearColor];
    [btnDayStatistics addTarget:self action:@selector(dayStatisticsClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnDayStatistics];
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

-(void) dayStatisticsClick{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
