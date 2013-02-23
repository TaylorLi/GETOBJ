//
//  PEDSecondViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDPedoViewController.h"
#import "PEDPedoDataViewController.h"

@implementation PEDPedoViewController
@synthesize monthSelectView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        monthArray = [NSMutableArray arrayWithObjects:@"JUN,12", @"JUL,12", @"AUG,12", @"SEP,12", @"OCT,12", @"NOV,12", @"DEC,12", nil];
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
	// Do any additional setup after loading the view, typically from a nib.
    
//    UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 410)];
//    bgImage.image = [UIImage imageNamed:@"pedo.bmp"] ;
//    [self.view addSubview:bgImage]; 
//    
//    UIButton *btnDayStatistics = [[UIButton alloc] initWithFrame:CGRectMake(131, 302, 58, 29)];
//    btnDayStatistics.backgroundColor = [UIColor clearColor];
//    [btnDayStatistics addTarget:self action:@selector(dayStatisticsClick) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:btnDayStatistics];
    
    CGFloat pickerHeight = 40.0f;
    CGFloat width=[UIScreen mainScreen].bounds.size.width;
	CGFloat x = 0;
	CGFloat y = 331.0f;
	CGRect tmpFrame = CGRectMake(x, y, width, pickerHeight);
    
	monthSelectView = [[V8HorizontalPickerView alloc] initWithFrame:tmpFrame];
    monthSelectView.backgroundColor   = [UIColor clearColor];
	monthSelectView.selectedTextColor = [UIColor whiteColor];
	monthSelectView.textColor   = [UIColor grayColor];
	monthSelectView.delegate    = self;
	monthSelectView.dataSource  = self;
	monthSelectView.elementFont = [UIFont boldSystemFontOfSize:11.0f];
    monthSelectView.selectedElementFont=[UIFont boldSystemFontOfSize:14.0f];
	monthSelectView.selectionPoint = CGPointMake(tmpFrame.size.width/2, 0);
    [self.view addSubview:monthSelectView];
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

//-(void) dayStatisticsClick{
//    PEDPedoDataViewController *pedPedoDataViewController = [[PEDPedoDataViewController alloc]init];
//    [self.navigationController pushViewController:pedPedoDataViewController animated:YES];
//    //[self.view insertSubview:pedPedoDataViewController.view atIndex:0];
//    //    [self.navigationController presentModalViewController:pedPedoDataViewController animated:YES];
//    //   [self presentModalViewController:pedPedoDataViewController animated:NO]; 
//}

- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
	return [monthArray count];
}

#pragma mark - HorizontalPickerView Delegate Methods
- (NSString *)horizontalPickerView:(V8HorizontalPickerView *)picker titleForElementAtIndex:(NSInteger)index {
	return [monthArray objectAtIndex:index];
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
	CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
	NSString *text = [monthArray objectAtIndex:index];
    CGFloat fontSize = picker.currentSelectedIndex==index?14.0f:11.0f;
	CGSize textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:fontSize]
					   constrainedToSize:constrainedSize
						   lineBreakMode:UILineBreakModeWordWrap];
	return textSize.width + 20.0f; // 20px padding on each side
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    PEDPedoDataViewController *pedPedoDataViewController = [[PEDPedoDataViewController alloc]init];
    [self.navigationController pushViewController:pedPedoDataViewController animated:YES];
}
@end
