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

-(void) initMonthSelectorWithX:(CGFloat)originX Height:(CGFloat)originY isForPedo:(BOOL) isPedo
{    
    CGFloat pickerHeight = 23.0f;
    CGFloat width=220.f;
	CGFloat x = originX;
	CGFloat y = originY;
	CGRect tmpFrame = CGRectMake(x, y, width, pickerHeight);
    
	monthSelectView = [[V8HorizontalPickerView alloc] initWithFrame:tmpFrame];
    monthSelectView.backgroundColor   = [UIColor clearColor];
    
    if(isPedo){
        monthSelectView.textColor   = [UIColor colorWithRed:251/255.0 green:103/255.0 blue:7/255.0 alpha:1];
        monthSelectView.selectedTextColor = [UIColor colorWithRed:251/255.0 green:103/255.0 blue:7/255.0 alpha:1];
    }else{
        monthSelectView.textColor   = [UIColor whiteColor];
        monthSelectView.selectedTextColor = [UIColor whiteColor];
	}
    monthSelectView.delegate    = self;
	monthSelectView.dataSource  = self;
	//monthSelectView.elementFont = [UIFont boldSystemFontOfSize:month_font_size];
    //monthSelectView.selectedElementFont=[UIFont boldSystemFontOfSize:month_font_size];
	monthSelectView.elementFont = [UIFont fontWithName:USE_DEFAULT_FONT size:month_font_size];
    monthSelectView.selectedElementFont=[UIFont fontWithName:USE_DEFAULT_FONT size:month_font_size];
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
    NSMutableString *text = [[monthArray objectAtIndex:index] mutableCopy];
    [text replaceCharactersInRange:NSMakeRange(3, 1) withString:@","];
	return text;
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
	CGSize constrainedSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
	NSString *text = [monthArray objectAtIndex:index];
    CGFloat fontSize = picker.currentSelectedIndex==index?month_font_size:month_font_size;
	CGSize textSize = [text sizeWithFont:[UIFont boldSystemFontOfSize:fontSize]
					   constrainedToSize:constrainedSize
						   lineBreakMode:UILineBreakModeWordWrap];
	return textSize.width + 3.5f; // 20px padding on each side
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
    int initCount=7;
    @try {
        monthArray=[[NSMutableArray alloc] initWithCapacity:initCount];
        NSString *nowDateString = [[UtilHelper formateDate:[NSDate date] withFormat:@"MMM yyyy"] uppercaseString];
        NSDate *selectedDate=date;
        if(date){
            selectedDate=date;
        }
        else{
            selectedDate=[NSDate date];
        }
        NSDate *fromDate=[selectedDate addMonths:-(initCount/2)];
        for (int i=0; i<initCount; i++) {
            
            NSString *dateString = [[UtilHelper formateDate:[fromDate addMonths:i] withFormat:@"MMM yyyy"] uppercaseString];
            [monthArray addObject:dateString];
            if([dateString isEqualToString:nowDateString]){
                break;
            }
            
        }    
        [monthSelectView reloadData];
        [monthSelectView scrollToElement:initCount/2 animated:NO];
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
}

- (IBAction)swithToPedoView:(id)sender
{
    [PEDAppDelegate getInstance].isShowSleepTab=NO;
    [[PEDAppDelegate getInstance] showTabView];
    //[controlContainer switchViews:YES];
}
-(IBAction)swithToSleepView:(id)sender{
    [PEDAppDelegate getInstance].isShowSleepTab=YES;
    [[PEDAppDelegate getInstance] showTabView];
    //[controlContainer switchViews:NO];
}
- (IBAction)clickToSettingView:(id)sender{
    [[PEDAppDelegate getInstance] showUserSettingView];
}

-(void)genNumberImage:(NSString *)imagePrefix withNumber:(NSInteger) number withCoordinate:(CGPoint) coordinate withZeroFill:(BOOL) isFill
{
    int count = 0;
    do {
        int unit = number % 10;
        UIImage *image = [UIImage imageNamed:[imagePrefix stringByAppendingFormat:@"%d", unit]];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake(coordinate.x, coordinate.y, image.size.width, image.size.height);
        
        number = number / 10;
        count++;
    } while (number != 0);
    
    if(count==1 && isFill){
        UIImage *imageFill = [UIImage imageNamed:[imagePrefix stringByAppendingString:@"0"]];
        UIImageView *imageViewFill = [[UIImageView alloc]initWithImage:imageFill];
        imageViewFill.frame = CGRectMake(coordinate.x - imageFill.size.width, coordinate.y, imageFill.size.width, imageFill.size.height);
    }
}

@end
