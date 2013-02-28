//
//  PEDFirstViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDBarchartViewController.h"

@implementation PEDBarchartViewController

@synthesize graphicHostView;
@synthesize monthSelectView;
@synthesize timer;

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        UIImage *tabbarImage = [UIImage imageNamed:@"second.png"] ;
//        UITabBarItem *barItem = [[UITabBarItem alloc]initWithTitle:@"" image:tabbarImage tag:4];
//        self.tabBarItem = barItem;
        monthArray = [NSMutableArray arrayWithObjects:@"All", @"Today", @"Thursday",
                       @"Wednesday", @"Tuesday", @"Monday", nil];
    }
    return self;
}


#pragma mark -
#pragma mark Initialization and teardown

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

-(void)viewDidAppear:(BOOL)animated
{
    [self timerFired];
#ifdef MEMORY_TEST
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
                                                selector:@selector(timerFired) userInfo:nil repeats:YES];
#endif
    [monthSelectView scrollToElement:0 animated:NO];
}

- (void)drawRect:(CGRect)rect
{
    
}

-(void)timerFired
{
#ifdef MEMORY_TEST
    static NSUInteger counter = 0;
    
    NSLog(@"\n----------------------------\ntimerFired: %lu", counter++);
#endif
    barChart=nil;
    //[barChart release];
    
    // Create barChart from theme
    barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [barChart applyTheme:theme];
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.graphicHostView;
    hostingView.hostedGraph = barChart;
    
    // Border
    barChart.plotAreaFrame.borderLineStyle = nil;
    barChart.plotAreaFrame.cornerRadius    = 0.0f;
    
    // Paddings
    barChart.paddingLeft   = 0.0f;
    barChart.paddingRight  = 0.0f;
    barChart.paddingTop    = 0.0f;
    barChart.paddingBottom = 0.0f;
    
    barChart.plotAreaFrame.paddingLeft   = 35.0f;
    barChart.plotAreaFrame.paddingTop    = 20.0f;
    barChart.plotAreaFrame.paddingRight  = 20.0f;
    barChart.plotAreaFrame.paddingBottom = 30.0f;
    
    // Graph title
    /*
    barChart.title = @"Graph Title\nLine 2";
    CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
    textStyle.color                   = [CPTColor grayColor];
    textStyle.fontSize                = 16.0f;
    textStyle.textAlignment           = CPTTextAlignmentCenter;
    barChart.titleTextStyle           = textStyle;
    barChart.titleDisplacement        = CGPointMake(0.0f, -20.0f);
    barChart.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    */
    // Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(15.0f)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(7.0f)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    CPTMutableLineStyle *lineStyle= [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 5.0f;
    lineStyle.lineColor         = [CPTColor darkGrayColor];    
    x.axisLineStyle               = lineStyle;
    lineStyle= [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 1.0f;
    lineStyle.lineColor         = [CPTColor grayColor]; 
    x.majorTickLineStyle          = lineStyle;
    x.majorGridLineStyle=lineStyle;
    lineStyle= [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 5.0f;
    lineStyle.lineColor         = [CPTColor colorWithComponentRed:1 green:0 blue:0 alpha:1]; 
    x.minorTickLineStyle          = lineStyle;
    NSArray *customMajorTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithFloat:8.0f], nil];
    x.majorTickLocations=[NSSet setWithArray:customMajorTickLocations];
    x.majorIntervalLength         = CPTDecimalFromString(@"8");
    
    NSArray *customMinjorTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithFloat:1.0f],[NSDecimalNumber numberWithFloat:2.0f],[NSDecimalNumber numberWithFloat:3.0f],[NSDecimalNumber numberWithFloat:4.0f],[NSDecimalNumber numberWithFloat:5.0f],[NSDecimalNumber numberWithFloat:6.0f],[NSDecimalNumber numberWithFloat:7.0f], nil];
    x.minorTickLocations=[NSSet setWithArray:customMinjorTickLocations];
    
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"-0.05");
    /*
    x.title                       = @"X Axis";
    x.titleLocation               = CPTDecimalFromFloat(7.5f);
    x.titleOffset                 = 55.0f;
    */
    // Define some custom labels for the data elements
    //x.labelRotation  = M_PI / 4;
    x.labelingPolicy = CPTAxisLabelingPolicyNone; 
     
    NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithFloat:1], [NSDecimalNumber numberWithFloat:2], [NSDecimalNumber numberWithFloat:3], [NSDecimalNumber numberWithFloat:6], [NSDecimalNumber numberWithFloat:7], [NSDecimalNumber numberWithFloat:8], [NSDecimalNumber numberWithFloat:9], nil];
  
    NSArray *xAxisLabels         = [NSArray arrayWithObjects:@"29/9", @"28/9", @"27/9", @"26/9", @"25/9",@"24/9",@"23/9", nil];
    NSUInteger labelLocation     = 0;
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
    for ( NSNumber *tickLocation in customTickLocations ) {
        CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
        textStyle.fontSize=11.0f;
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[xAxisLabels objectAtIndex:labelLocation++] textStyle:textStyle];
        newLabel.tickLocation = [tickLocation decimalValue];
        newLabel.offset       = x.labelOffset + x.majorTickLength;
        //M_PI / 4;
        newLabel.rotation     = 0;
        [customLabels addObject:newLabel];
        //newLabel=nil;
        //[newLabel release];
    }
    
    x.axisLabels = [NSSet setWithArray:customLabels];
    
    CPTXYAxis *y = axisSet.yAxis;
    lineStyle= [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 1.0f;
    lineStyle.lineColor         = [CPTColor darkGrayColor];
    y.axisLineStyle               = lineStyle;
    y.majorTickLineStyle          = nil;
    y.minorTickLineStyle          = nil;
    y.majorIntervalLength         = CPTDecimalFromString(@"1");
    y.majorGridLineStyle=lineStyle;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    /*
    y.title                       = @"Y Axis";
    y.titleOffset                 = 45.0f;
    y.titleLocation               = CPTDecimalFromFloat(150.0f);
    */
    // First bar plot
    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor orangeColor] horizontalBars:NO];
    barPlot.baseValue  = CPTDecimalFromString(@"0");
    barPlot.barWidth= CPTDecimalFromFloat(0.2f);
    barPlot.dataSource = self;
    barPlot.barOffset  = CPTDecimalFromFloat(0.2f);
    barPlot.barCornerRadius = 5.0f;
    barPlot.identifier = @"Bar Plot 1";
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    
    // Second bar plot
    barPlot                 = [CPTBarPlot tubularBarPlotWithColor:[CPTColor purpleColor] horizontalBars:NO];
    barPlot.dataSource      = self;
    barPlot.baseValue       = CPTDecimalFromString(@"0");
    barPlot.barWidth= CPTDecimalFromFloat(0.2f);
    barPlot.barOffset       = CPTDecimalFromFloat(0.5f);
    barPlot.barCornerRadius = 5.0f;
    barPlot.identifier      = @"Bar Plot 2";
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    // third bar plot
    barPlot                 = [CPTBarPlot tubularBarPlotWithColor:[CPTColor greenColor] horizontalBars:NO];
    barPlot.dataSource      = self;
    barPlot.baseValue       = CPTDecimalFromString(@"0");
    barPlot.barWidth= CPTDecimalFromFloat(0.2f);
    barPlot.barOffset       = CPTDecimalFromFloat(0.8f);
    barPlot.barCornerRadius = 5.0f;
    barPlot.identifier      = @"Bar Plot 3";
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 7;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDecimalNumber *num = nil;
    
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        switch ( fieldEnum ) {
            case CPTBarPlotFieldBarLocation:
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithFloat:index+index*0.1];
                break;
                
            case CPTBarPlotFieldBarTip:
                if ( [plot.identifier isEqual:@"Bar Plot 1"] ) {
                    num =  (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:(index + 1)];
                }
                else if ( [plot.identifier isEqual:@"Bar Plot 2"] ) {
                    num =  (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:(index + 2)+index*1];
                }
                
                else if ( [plot.identifier isEqual:@"Bar Plot 3"] ) {
                    num =  (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:(index + 3)];
                }
                else
                {
                    num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:(index)];
                }
                break;
        }
    }
    
    return num;
}

#pragma mark - HorizontalPickerView DataSource Methods
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
	
}


- (void)viewDidUnload {
    [self setGraphicHostView:nil];
    [self setMonthSelectView:nil];
    [super viewDidUnload];
}
@end
