//
//  PEDUIBaseViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDUIBaseViewController.h"
#import "PEDAppDelegate.h"

@interface PEDUIBaseViewController ()


@end

@implementation PEDUIBaseViewController

@synthesize monthSelectView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) initMonthSelectorWithX:(CGFloat)originX Height:(CGFloat)originY
{
    CGFloat pickerHeight = 40.0f;
    CGFloat width=[UIScreen mainScreen].bounds.size.width;
	CGFloat x = originX;
	CGFloat y = originY;
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)clickToConnectDevice:(id)sender {
    [[PEDAppDelegate getInstance] showImportDataView];
}


#pragma mark - HorizontalPickerView Delegate Methods

- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
	return [monthArray count];
}

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
    if(index!=3){
        NSDate *date =  [UtilHelper convertDate:[NSString stringWithFormat:@"01 %@", [monthArray objectAtIndex:index]] withFormat:@"dd MMM yyyy"];
        [self reloadPickerToMidOfDate:date];
    }   
}

-(void) reloadPickerToMidOfDate:(NSDate *)date
{
    monthArray=[[NSMutableArray alloc] initWithCapacity:7];
    NSDate *selectedData=date;
    if(date){
        selectedData=date;
    }
    else{
        selectedData=[NSDate date];
    }
    NSDate *fromDate=[selectedData addMonths:-3];
    for (int i=0; i<7; i++) {
        [monthArray addObject:[UtilHelper formateDate:[fromDate addMonths:i] withFormat:@"MMM yyyy"]];
        
    }    
    [monthSelectView reloadData];
    [monthSelectView scrollToElement:3 animated:NO]; 
}

@end
