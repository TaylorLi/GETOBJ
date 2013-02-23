//
//  PEDSecondViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDGraphsViewController.h"

@implementation PEDGraphsViewController

@synthesize dataForPlot;
@synthesize cptGraphHostingView;

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        UIImage *tabbarImage = [UIImage imageNamed:@"second.png"] ;
//        UITabBarItem *barItem = [[UITabBarItem alloc]initWithTitle:@"" image:tabbarImage tag:3];
//        self.tabBarItem = barItem;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    
}

#pragma mark -
#pragma mark Initialization and teardown


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create graph from theme
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)cptGraphHostingView;
    hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    hostingView.hostedGraph     = graph;
    
    // Border
    graph.plotAreaFrame.borderLineStyle = nil;
    graph.plotAreaFrame.cornerRadius    = 0.0f;
    
    // Paddings
    graph.paddingLeft   = 0.0f;
    graph.paddingRight  = 0.0f;
    graph.paddingTop    = 0.0f;
    graph.paddingBottom = 0.0f;
    
    graph.plotAreaFrame.paddingLeft   = 50.0f;
    graph.plotAreaFrame.paddingTop    = 20.0f;
    graph.plotAreaFrame.paddingRight  = 20.0f;
    graph.plotAreaFrame.paddingBottom = 40.0f;
    
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
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(15.0f)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(8.0f)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    CPTMutableLineStyle *lineStyle= [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 4.0f;
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
    
    // Create a blue plot area
    CPTScatterPlot *boundLinePlot  = [[CPTScatterPlot alloc] init];
    lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 4.0f;
    lineStyle.lineColor         = [CPTColor orangeColor];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = @"Orange Plot";
    boundLinePlot.dataSource    = self;
    [graph addPlot:boundLinePlot];
    /*
    // Do a blue gradient
    CPTColor *areaColor1       = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    CPTGradient *areaGradient1 = [CPTGradient gradientWithBeginningColor:areaColor1 endingColor:[CPTColor clearColor]];
    areaGradient1.angle = -90.0f;
    CPTFill *areaGradientFill = [CPTFill fillWithGradient:areaGradient1];
    boundLinePlot.areaFill      = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
    */
    // Add plot symbols 圆形坐标点
    /*
    CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
    symbolLineStyle.lineColor = [CPTColor blackColor];
    
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill          = [CPTFill fillWithColor:[CPTColor blueColor]];
    plotSymbol.lineStyle     = symbolLineStyle;
    plotSymbol.size          = CGSizeMake(10.0, 10.0);
    boundLinePlot.plotSymbol = plotSymbol;
    */
    
    boundLinePlot  = [[CPTScatterPlot alloc] init];
    lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 4.0f;
    lineStyle.lineColor         = [CPTColor purpleColor];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = @"Purple Plot";
    boundLinePlot.dataSource    = self;
    [graph addPlot:boundLinePlot];
    
    /*
    // Do a blue gradient
    areaColor1       = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
    areaGradient1 = [CPTGradient gradientWithBeginningColor:areaColor1 endingColor:[CPTColor clearColor]];
    areaGradient1.angle = -90.0f;
    areaGradientFill = [CPTFill fillWithGradient:areaGradient1];
    boundLinePlot.areaFill      = areaGradientFill;
    boundLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
    */
    
    boundLinePlot  = [[CPTScatterPlot alloc] init];
    lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 4.0f;
    lineStyle.lineColor         = [CPTColor greenColor];
    boundLinePlot.dataLineStyle = lineStyle;
    boundLinePlot.identifier    = @"Green Plot";
    boundLinePlot.dataSource    = self;
    [graph addPlot:boundLinePlot];
    /*
    // Put an area gradient under the plot above
    CPTColor *areaColor       = [CPTColor colorWithComponentRed:0.3 green:1.0 blue:0.3 alpha:0.8];
    CPTGradient *areaGradient = [CPTGradient gradientWithBeginningColor:areaColor endingColor:[CPTColor clearColor]];
    areaGradient.angle               = -90.0f;
    areaGradientFill                 = [CPTFill fillWithGradient:areaGradient];
    dataSourceLinePlot.areaFill      = areaGradientFill;
    dataSourceLinePlot.areaBaseValue = CPTDecimalFromString(@"1.75");
    */
    
    // Add some initial data
    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:100];
    NSUInteger i;
    for ( i = 0; i < 8; i++ ) {
        id x = [NSNumber numberWithFloat:i * 0.8];
        id y = [NSNumber numberWithFloat:16 * rand() / (float)RAND_MAX + 0.8*i];
        [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
    }
    self.dataForPlot = contentArray;
    
#ifdef PERFORMANCE_TEST
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changePlotRange) userInfo:nil repeats:YES];
#endif
	// Do any additional setup after loading the view, typically from a nib.
    
    //UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 410)];
    //bgImage.image = [UIImage imageNamed:@"graphs.bmp"] ;
    //[self.view addSubview:bgImage];
}

-(void)changePlotRange
{
    // Setup plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(5.0 + 2.0 * rand() / RAND_MAX)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat(13.0 + 2.0 * rand() / RAND_MAX)];
}


#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [dataForPlot count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    NSNumber *num = [[dataForPlot objectAtIndex:index] valueForKey:key];
    
    // Green plot gets shifted above the blue
    if ( [(NSString *)plot.identifier isEqualToString:@"Green Plot"] ) {
        if ( fieldEnum == CPTScatterPlotFieldY ) {
            num = [NSNumber numberWithDouble:[num doubleValue] + 1.2];
        }
    }
    else if ( [(NSString *)plot.identifier isEqualToString:@"Orange Plot"] ) {
        if ( fieldEnum == CPTScatterPlotFieldY ) {
            num = [NSNumber numberWithDouble:[num doubleValue] + 0.5];
        }
    }
    return num;
}

#pragma mark -
#pragma mark Axis Delegate Methods

-(BOOL)axis:(CPTAxis *)axis shouldUpdateAxisLabelsAtLocations:(NSSet *)locations
{
    static CPTTextStyle *positiveStyle = nil;
    static CPTTextStyle *negativeStyle = nil;
    
    NSNumberFormatter *formatter = axis.labelFormatter;
    CGFloat labelOffset          = axis.labelOffset;
    NSDecimalNumber *zero        = [NSDecimalNumber zero];
    
    NSMutableSet *newLabels = [NSMutableSet set];
    
    for ( NSDecimalNumber *tickLocation in locations ) {
        CPTTextStyle *theLabelTextStyle;
        
        if ( [tickLocation isGreaterThanOrEqualTo:zero] ) {
            if ( !positiveStyle ) {
                CPTMutableTextStyle *newStyle = [axis.labelTextStyle mutableCopy];
                newStyle.color = [CPTColor greenColor];
                positiveStyle  = newStyle;
            }
            theLabelTextStyle = positiveStyle;
        }
        else {
            if ( !negativeStyle ) {
                CPTMutableTextStyle *newStyle = [axis.labelTextStyle mutableCopy];
                newStyle.color = [CPTColor redColor];
                negativeStyle  = newStyle;
            }
            theLabelTextStyle = negativeStyle;
        }
        
        NSString *labelString       = [formatter stringForObjectValue:tickLocation];
        CPTTextLayer *newLabelLayer = [[CPTTextLayer alloc] initWithText:labelString style:theLabelTextStyle];
        
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithContentLayer:newLabelLayer];
        newLabel.tickLocation = tickLocation.decimalValue;
        newLabel.offset       = labelOffset;
        
        [newLabels addObject:newLabel];
        
        //[newLabel release];
        //[newLabelLayer release];
    }
    
    axis.axisLabels = newLabels;
    
    return NO;
}

- (void)viewDidUnload {
    [self setCptGraphHostingView:nil];
    [super viewDidUnload];
}
@end
