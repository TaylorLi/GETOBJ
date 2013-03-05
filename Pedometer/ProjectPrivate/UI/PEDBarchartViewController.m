//
//  PEDFirstViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDBarchartViewController.h"
#import "BO_PEDPedometerData.h"
#import "PEDPedometerData.h"
#import "PEDPedometerCalcHelper.h"
#import "PEDPedometerDataHelper.h"

@interface PEDBarchartViewController ()
-(void) reloadPickerToMidOfDate:(NSDate *)date;
@end

@implementation PEDBarchartViewController

@synthesize graphicHostView;
@synthesize monthSelectView;
@synthesize timer;
@synthesize lblUserName;
@synthesize lblLastUpdate;
@synthesize btnActTime;
@synthesize btnStep;
@synthesize btnDistance;
@synthesize btnAvgSpeed;
@synthesize btnCalories;
@synthesize btnAvgPace;

-(void) initBarRemark{
    if(tempControlPool == nil){
        tempControlPool = [[NSMutableArray alloc]init];
    }else{
        for (int i=tempControlPool.count -1 ; i>=0; i--) {
            id control = [tempControlPool objectAtIndex:i];
            [control removeFromSuperview];
        }
    }
    if(barIdArray != nil && barIdArray.count > 0){
        for (int i=0; i<barIdArray.count; i++) {
            UIImageView *barColorView = [[UIImageView alloc]initWithFrame:CGRectMake(46 + i * 100, 62, 30, 5)];
            barColorView.backgroundColor = [PEDPedometerDataHelper getColorWithStatisticsType:[barIdArray objectAtIndex:i]];
            
            UILabel *barRemarkLable = [[UILabel alloc]initWithFrame:CGRectMake(30 + i * 100, 72, 62, 24)];
            barRemarkLable.text = [PEDPedometerDataHelper getBarRemarkTextWithStatisticsType:[barIdArray objectAtIndex:i] withMeasureUnit:[AppConfig getInstance].settings.userInfo.measureFormat];
            barRemarkLable.textAlignment = UITextAlignmentCenter;
            barRemarkLable.font = [UIFont systemFontOfSize:10];
            barRemarkLable.textColor = [UIColor whiteColor];
            barRemarkLable.numberOfLines = 2;
            barRemarkLable.backgroundColor = [UIColor clearColor];
            [tempControlPool addObject:barColorView];
            [tempControlPool addObject:barRemarkLable];
            [self.view addSubview:barColorView];
            [self.view addSubview:barRemarkLable];
        }
    }
}

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

-(void)DoubleTap:(UITapGestureRecognizer*)recognizer  
{  
    if(!isLargeView){
        self.graphicHostView.frame = CGRectMake(0, 0, 320, 423);
        //self.graphicHostView.backgroundColor = [UIColor whiteColor];
        isLargeView = true;
    }else{
        self.graphicHostView.frame = CGRectMake(26, 113, 271, 132);
        //self.graphicHostView.backgroundColor = [UIColor clearColor];
        isLargeView = false;
    }
    [self.view bringSubviewToFront:self.graphicHostView];
} 

-(void)handleSwipeRight:(UITapGestureRecognizer*)recognizer  
{  
    dayRemark--;
    dayArray = [PEDPedometerDataHelper getDaysQueue:[AppConfig getInstance].settings.showDateCount withDaySpacing:dayRemark withDateFormat:@"dd/MM"];
    statisticsData = [PEDPedometerDataHelper getStatisticsData:[AppConfig getInstance].settings.showDateCount withDaySpacing:dayRemark withTagetId:[AppConfig getInstance].settings.target.targetId withMeasureUnit:[AppConfig getInstance].settings.userInfo.measureFormat];
    [self timerFired];
} 

-(void)handleSwipeLeft:(UITapGestureRecognizer*)recognizer  
{  
    if(dayRemark < 0){
        dayRemark++;
        dayArray = [PEDPedometerDataHelper getDaysQueue:[AppConfig getInstance].settings.showDateCount withDaySpacing:dayRemark withDateFormat:@"dd/MM"];
        statisticsData = [PEDPedometerDataHelper getStatisticsData:[AppConfig getInstance].settings.showDateCount withDaySpacing:dayRemark withTagetId:[AppConfig getInstance].settings.target.targetId withMeasureUnit:[AppConfig getInstance].settings.userInfo.measureFormat];
        [self timerFired];
    }
} 

-(void) initData{
    lblUserName.text = [AppConfig getInstance].settings.userInfo.userName;
    NSDate *lastOptDate=[[BO_PEDPedometerData getInstance] getLastUploadDate:[AppConfig getInstance].settings.target.targetId];
    lblLastUpdate.text = [UtilHelper formateDate:lastOptDate withFormat:@"dd/MM/yy"];
    isLargeView = false;
    dayRemark =0;
    dayArray = [PEDPedometerDataHelper getDaysQueue:[AppConfig getInstance].settings.showDateCount withDaySpacing:dayRemark withDateFormat:@"dd/MM"];
    statisticsData = [PEDPedometerDataHelper getStatisticsData:[AppConfig getInstance].settings.showDateCount withDaySpacing:dayRemark withTagetId:[AppConfig getInstance].settings.target.targetId withMeasureUnit:[AppConfig getInstance].settings.userInfo.measureFormat];
    barIdArray = [[NSMutableArray alloc] initWithObjects:[PEDPedometerDataHelper integerToString:STATISTICS_DISTANCE], [PEDPedometerDataHelper integerToString:STATISTICS_AVG_SPEED],[PEDPedometerDataHelper integerToString:STATISTICS_AVG_PACE], nil];
    [self initBarRemark];
    
    UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTap:)];  
    doubleRecognizer.numberOfTapsRequired = 2; // 双击  
    //关键语句，给self.view添加一个手势监测；  
    [self.graphicHostView addGestureRecognizer:doubleRecognizer];  
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];   
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];   
    [self.graphicHostView addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];   
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];   
    [self.graphicHostView addGestureRecognizer:leftRecognizer];
    
    [self reloadPickerToMidOfDate:lastOptDate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    [self initData];
	// Do any additional setup after loading the view, typically from a nib.
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [self timerFired];
#ifdef MEMORY_TEST
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
//                                                selector:@selector(timerFired) userInfo:nil repeats:YES];
#endif
    [monthSelectView scrollToElement:0 animated:NO];
}

- (void)drawRect:(CGRect)rect
{
    
}

-(void) btnClick:(id)sender withStatisticsType:(StatisticsType) statisticsType{
    NSString *statisticsTypeStr = [PEDPedometerDataHelper integerToString:statisticsType];
    if(barIdArray != nil){
        UIButton * btn = (UIButton*) sender;
        BOOL isChange = NO;
        if([barIdArray containsObject:statisticsTypeStr]){
            [barIdArray removeObject:statisticsTypeStr];
            [btn setBackgroundImage:nil forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            isChange = YES;
        }else{
            if(barIdArray.count < 3){
                [barIdArray addObject:statisticsTypeStr];
                [btn setBackgroundImage:[PEDPedometerDataHelper getBtnBGImageWithStatisticsType:statisticsTypeStr] forState:UIControlStateNormal];
                [btn setTitleColor:[PEDPedometerDataHelper getColorWithStatisticsType: statisticsTypeStr] forState:UIControlStateNormal];
                isChange = YES;
            }
        }
        if(isChange){
            [self initBarRemark];
            [self timerFired];
        }
    }
}

- (IBAction)btnSetpClick:(id)sender {
    [self btnClick:sender withStatisticsType:STATISTICS_STEP];
}

- (IBAction)btnActTimeClick:(id)sender {
    [self btnClick:sender withStatisticsType:STATISTICS_ACTIVITY_TIME];
}

- (IBAction)btnDistanceClick:(id)sender {
    [self btnClick:sender withStatisticsType:STATISTICS_DISTANCE];
}

- (IBAction)btnCaloriesClick:(id)sender {
    [self btnClick:sender withStatisticsType:STATISTICS_CALORIES];
}

- (IBAction)btnAvgSpeedClick:(id)sender {
    [self btnClick:sender withStatisticsType:STATISTICS_AVG_SPEED];
}

- (IBAction)btnAvgPaceClick:(id)sender {
    [self btnClick:sender withStatisticsType:STATISTICS_AVG_PACE];
}

-(void)timerFired
{
    barChart=nil;
    //[barChart release];
    
    // Create barChart from theme
    barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
//    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
//    [barChart applyTheme:theme];
    CPTGraphHostingView *hostingView = (CPTGraphHostingView *)self.graphicHostView;

    hostingView.hostedGraph = barChart;
    hostingView.backgroundColor = [UIColor whiteColor];
    
    // Border
    barChart.plotAreaFrame.borderLineStyle = nil;
    barChart.plotAreaFrame.cornerRadius    = 0.0f;
    
    // Paddings
    barChart.paddingLeft   = 0.0f;
    barChart.paddingRight  = 0.0f;
    barChart.paddingTop    = 0.0f;
    barChart.paddingBottom = 0.0f;
    
    barChart.plotAreaFrame.paddingLeft   = 30.0f;
    barChart.plotAreaFrame.paddingTop    = 20.0f;
    barChart.plotAreaFrame.paddingRight  = 20.0f;
    barChart.plotAreaFrame.paddingBottom = 25.0f;
    
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
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(8.0f)];
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x          = axisSet.xAxis;
    CPTMutableLineStyle *lineStyle= [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 1.0f;
    lineStyle.lineColor         = [CPTColor darkGrayColor];    
    x.axisLineStyle               = lineStyle;  //线型设置
    lineStyle= [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 1.0f;
    lineStyle.lineColor         = [CPTColor grayColor]; 
    x.majorTickLineStyle          = lineStyle;  //大刻度线
    x.majorGridLineStyle=lineStyle; //指定大刻度线上的网格线线段样式
    lineStyle= [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit        = 1.0f;
    lineStyle.lineWidth         = 1.0f;
    lineStyle.lineColor         = [CPTColor colorWithComponentRed:0 green:0 blue:0 alpha:1]; 
    x.minorTickLineStyle          = lineStyle;  //小刻度线
    NSArray *customMajorTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithFloat:8.0f], nil];
    x.majorTickLocations=[NSSet setWithArray:customMajorTickLocations];
    x.majorIntervalLength         = CPTDecimalFromString(@"1"); // 大刻度线间距
    
    NSArray *customMinjorTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithFloat:1.0f],[NSDecimalNumber numberWithFloat:2.0f],[NSDecimalNumber numberWithFloat:3.0f],[NSDecimalNumber numberWithFloat:4.0f],[NSDecimalNumber numberWithFloat:5.0f],[NSDecimalNumber numberWithFloat:6.0f],[NSDecimalNumber numberWithFloat:7.0f], nil];
    x.minorTickLocations=[NSSet setWithArray:customMinjorTickLocations];
    
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"-0.05"); //直角坐标
    /*
    x.title                       = @"X Axis";
    x.titleLocation               = CPTDecimalFromFloat(7.5f);
    x.titleOffset                 = 55.0f;
    */
    // Define some custom labels for the data elements
    //x.labelRotation  = M_PI / 4;
    x.labelingPolicy = CPTAxisLabelingPolicyNone; 
     
    NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithFloat:1.0f],[NSDecimalNumber numberWithFloat:2.0f],[NSDecimalNumber numberWithFloat:3.0f],[NSDecimalNumber numberWithFloat:4.0f],[NSDecimalNumber numberWithFloat:5.0f],[NSDecimalNumber numberWithFloat:6.0f],[NSDecimalNumber numberWithFloat:7.0f], nil];
  
    NSArray *xAxisLabels         = [dayArray copy];//[NSArray arrayWithObjects:@"29/9", @"28/9", @"27/9", @"26/9", @"25/9",@"24/9",@"23/9", nil];
    NSUInteger labelLocation     = 0;
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
    for ( NSNumber *tickLocation in customTickLocations ) {
        CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
        textStyle.fontSize=9.0f;
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
    y.majorIntervalLength         = CPTDecimalFromString(@"3");
    y.majorGridLineStyle=lineStyle;
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontSize = 9.0f;
    y.labelTextStyle  = textStyle;
    /*
    y.title                       = @"Y Axis";
    y.titleOffset                 = 45.0f;
    y.titleLocation               = CPTDecimalFromFloat(150.0f);
    */
    // First bar plot
    
    if(barIdArray !=nil && barIdArray.count>0){
        float baseBarOffset = 0.5f;
        if(barIdArray.count > 1){
            baseBarOffset -= barIdArray.count * 0.1f;
        }
        CPTBarPlot *barPlot = nil;
        for (int i=0; i<barIdArray.count; i++) {
            barPlot = [CPTBarPlot tubularBarPlotWithColor:[PEDPedometerDataHelper getCPTColorWithStatisticsType:[barIdArray objectAtIndex:i]] horizontalBars:NO];
            barPlot.baseValue  = CPTDecimalFromString(@"0");
            barPlot.barWidth= CPTDecimalFromFloat(0.2f);
            barPlot.dataSource = self;
            barPlot.barOffset  = CPTDecimalFromFloat(baseBarOffset * (i + 1) + i * 0.1);
            barPlot.barCornerRadius = 5.0f;
            barPlot.identifier = [barIdArray objectAtIndex:i];
            [barChart addPlot:barPlot toPlotSpace:plotSpace];
        }
    }
//    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor orangeColor] horizontalBars:NO];
//    barPlot.baseValue  = CPTDecimalFromString(@"0");
//    barPlot.barWidth= CPTDecimalFromFloat(0.2f);
//    barPlot.dataSource = self;
//    barPlot.barOffset  = CPTDecimalFromFloat(0.2f);
//    barPlot.barCornerRadius = 5.0f;
//    barPlot.identifier = @"Bar Plot 1";
//    [barChart addPlot:barPlot toPlotSpace:plotSpace];
//    
//    // Second bar plot
//    barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor purpleColor] horizontalBars:NO];
//    barPlot.dataSource      = self;
//    barPlot.baseValue       = CPTDecimalFromString(@"0");
//    barPlot.barWidth= CPTDecimalFromFloat(0.2f);
//    barPlot.barOffset       = CPTDecimalFromFloat(0.5f);
//    barPlot.barCornerRadius = 5.0f;
//    barPlot.identifier      = @"Bar Plot 2";
//    [barChart addPlot:barPlot toPlotSpace:plotSpace];
//    // third bar plot
//    barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor greenColor] horizontalBars:NO];
//    barPlot.dataSource      = self;
//    barPlot.baseValue       = CPTDecimalFromString(@"0");
//    barPlot.barWidth= CPTDecimalFromFloat(0.2f);
//    barPlot.barOffset       = CPTDecimalFromFloat(0.8f);
//    barPlot.barCornerRadius = 5.0f;
//    barPlot.identifier      = @"Bar Plot 3";
//    [barChart addPlot:barPlot toPlotSpace:plotSpace];
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
    return [AppConfig getInstance].settings.showDateCount;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDecimalNumber *num = nil;
    
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        switch ( fieldEnum ) {
            case CPTBarPlotFieldBarLocation:
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithFloat:index + 0.5];
                break;
                
            case CPTBarPlotFieldBarTip:
                num =  (NSDecimalNumber *)[NSDecimalNumber numberWithFloat:[(NSNumber *)[[statisticsData objectForKey:plot.identifier] objectAtIndex:index] floatValue]];
                break;
        }
    }
    
    return num;
}

// 在柱子上面显示对应的值
-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index{
    if([(NSNumber *)[[statisticsData objectForKey:plot.identifier] objectAtIndex:index] intValue] == 0){
        return nil;
    }
    CPTMutableTextStyle *textLineStyle=[CPTMutableTextStyle textStyle];
    textLineStyle.fontSize=8.0f;
    textLineStyle.color=[CPTColor blackColor];

    CPTTextLayer *label=[[CPTTextLayer alloc] initWithText: [NSString stringWithFormat:@"%.1f",[(NSNumber *)[[statisticsData objectForKey:plot.identifier] objectAtIndex:index] floatValue]] style:textLineStyle];
    return label;
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

- (void)viewDidUnload {
    [self setGraphicHostView:nil];
    [self setMonthSelectView:nil];
    [self setLblUserName:nil];
    [self setLblLastUpdate:nil];
    [self setBtnActTime:nil];
    [self setBtnStep:nil];
    [self setBtnDistance:nil];
    [self setBtnAvgSpeed:nil];
    [self setBtnCalories:nil];
    [self setBtnAvgPace:nil];
    [super viewDidUnload];
}
@end
