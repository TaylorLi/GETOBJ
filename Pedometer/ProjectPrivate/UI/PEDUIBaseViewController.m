//
//  PEDUIBaseViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDUIBaseViewController.h"
#import "PEDAppDelegate.h"
#import "SwitchViewController.h"

@interface PEDUIBaseViewController ()


@end

@implementation PEDUIBaseViewController

@synthesize monthSelectView,controlContainer;

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
    @try {
        if(index!=3){
            NSDate *date =  [UtilHelper convertDate:[NSString stringWithFormat:@"01 %@", [monthArray objectAtIndex:index]] withFormat:@"dd MMM yyyy"];
            [self reloadPickerToMidOfDate:date];
        }   
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
}

-(void) reloadPickerToMidOfDate:(NSDate *)date
{
    @try {
        monthArray=[[NSMutableArray alloc] initWithCapacity:7];
        NSString *nowDateString = [UtilHelper formateDate:[NSDate date] withFormat:@"MMM yyyy"];
        NSDate *selectedDate=date;
        if(date){
            selectedDate=date;
        }
        else{
            selectedDate=[NSDate date];
        }
        NSDate *fromDate=[selectedDate addMonths:-3];
        for (int i=0; i<7; i++) {
            
            NSString *dateString = [UtilHelper formateDate:[fromDate addMonths:i] withFormat:@"MMM yyyy"];
            [monthArray addObject:dateString];
            if([dateString isEqualToString:nowDateString]){
                break;
            }
            
        }    
        [monthSelectView reloadData];
        [monthSelectView scrollToElement:3 animated:NO]; 
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
}

- (IBAction)swithToPedoView:(id)sender
{
    [controlContainer switchViews:YES];
}
-(IBAction)swithToSleepView:(id)sender{
    [controlContainer switchViews:NO];
}

@end
