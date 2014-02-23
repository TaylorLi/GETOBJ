//
//  PEDSecondViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDGraphsViewController.h"
#import "PEDPedometerDataHelper.h"
#import "BO_PEDPedometerData.h"
#import "PEDPedometerData.h"

@implementation PEDGraphsViewController

@synthesize dataForPlot;
@synthesize cptGraphHostingView;
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
            [tempControlPool removeObject:control];
        }
    }
    if(barIdArray != nil && barIdArray.count > 0){
        NSMutableArray *imageArray = [[NSMutableArray alloc]init];
        /**刻度比例图标*/
        int barWidth = 244;
        int startX = 36;
        int imgTotalWidth = 0;
        for (int i=0; i<barIdArray.count; i++) {
            UIImage *image = [PEDPedometerDataHelper getBarRemarkImageWithStatisticsType:[barIdArray objectAtIndex:i]];
            [imageArray addObject:image];
            imgTotalWidth += image.size.width;
        }
        for (int i=0; i<barIdArray.count; i++) {
            UIImage *image = [imageArray objectAtIndex:i];
            UIImageView *barColorView = [[UIImageView alloc] initWithImage:image];
            barColorView.frame = CGRectMake(startX, 108, image.size.width, image.size.height);
            if(barIdArray.count > 1)
            {
                startX += image.size.width + (barWidth - imgTotalWidth) / (barIdArray.count<3?2:barIdArray.count - 1);
            }
            
            [tempControlPool addObject:barColorView];
            //                [tempControlPool addObject:barRemarkLable];
            [self.view addSubview:barColorView];
            //                [self.view addSubview:barRemarkLable];
        }
         /*
        for (int i=0; i<barIdArray.count; i++) {
            UIImageView *barColorView = [[UIImageView alloc]initWithFrame:CGRectMake(46 + i * 100, 62, 30, 5)];
            //barColorView.backgroundColor = [PEDPedometerDataHelper getColorWithStatisticsType:[barIdArray objectAtIndex:i]];
            [barColorView setImage:[PEDPedometerDataHelper getBarRemarkImageWithStatisticsType:[barIdArray objectAtIndex:i]]];
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
        */
    }
}

-(void)DoubleTap:(UITapGestureRecognizer*)recognizer  
{  
    if(!isLargeView){
        CGRect rect= [[UIScreen mainScreen] applicationFrame];
        self.cptGraphHostingView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-45.0f);
        //self.graphicHostView.backgroundColor = [UIColor whiteColor];
        isLargeView = true;
    }else{
        self.cptGraphHostingView.frame = CGRectMake(29, 130, 251, 236);
        //self.graphicHostView.backgroundColor = [UIColor clearColor];
        isLargeView = false;
    }
    [self genCurvechart];
    [self.view bringSubviewToFront:self.cptGraphHostingView];
} 

-(void)handleSwipeRight:(UITapGestureRecognizer*)recognizer  
{  
    dayRemark--;
    dayArray = [PEDPedometerDataHelper getDaysQueue:[AppConfig getInstance].settings.showDateCount withDaySpacing:dayRemark withDateFormat:@"dd/MM" referedDate:referenceDate];
    statisticsData = [PEDPedometerDataHelper getStatisticsData:[AppConfig getInstance].settings.showDateCount withDaySpacing:dayRemark withTagetId:[AppConfig getInstance].settings.target.targetId withMeasureUnit:[AppConfig getInstance].settings.userInfo.measureFormat referedDate:referenceDate];
    [self genCurvechart];
} 

-(void)handleSwipeLeft:(UITapGestureRecognizer*)recognizer  
{  
    if(dayRemark < 0){
        dayRemark++;
        dayArray = [PEDPedometerDataHelper getDaysQueue:[AppConfig getInstance].settings.showDateCount withDaySpacing:dayRemark withDateFormat:@"dd/MM" referedDate:referenceDate];
        statisticsData = [PEDPedometerDataHelper getStatisticsData:[AppConfig getInstance].settings.showDateCount withDaySpacing:dayRemark withTagetId:[AppConfig getInstance].settings.target.targetId withMeasureUnit:[AppConfig getInstance].settings.userInfo.measureFormat referedDate:referenceDate];
        [self genCurvechart];
    }
} 

- (void) initData
{
    NSDate *lastUploadDate = [[BO_PEDPedometerData getInstance] getLastUploadDate:[AppConfig getInstance].settings.target.targetId];
    [self initDataByDate:lastUploadDate];
}
- (void) initDataByDate:(NSDate *) date{
    @try {
        [self initBarRemark];
        if(isLargeView){
            [self DoubleTap:nil];
        }
        lblUserName.text = [AppConfig getInstance].settings.userInfo.userName;
        if(date==nil){
            if(referenceDate==nil)
                referenceDate=[NSDate date];
        }
        else
            referenceDate=date;
        lblLastUpdate.text = [UtilHelper formateDate:[[BO_PEDPedometerData getInstance] getLastUpdateDate:[AppConfig getInstance].settings.target.targetId] withFormat:@"dd/MM/yy"];
        isLargeView = false;
        dayRemark =0;
        isFirstLoad = YES;
        dayArray = [PEDPedometerDataHelper getDaysQueue:[AppConfig getInstance].settings.showDateCount withDaySpacing:dayRemark withDateFormat:@"dd/MM" referedDate:referenceDate];
        statisticsData = [PEDPedometerDataHelper getStatisticsData:[AppConfig getInstance].settings.showDateCount withDaySpacing:dayRemark withTagetId:[AppConfig getInstance].settings.target.targetId withMeasureUnit:[AppConfig getInstance].settings.userInfo.measureFormat referedDate:referenceDate];    
        
        [self.view bringSubviewToFront:self.cptGraphHostingView];
        
        UITapGestureRecognizer* doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTap:)];  
        doubleRecognizer.numberOfTapsRequired = 2; // 双击  
        
        [self.cptGraphHostingView addGestureRecognizer:doubleRecognizer];  
        
        UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];   
        [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];   
        [self.cptGraphHostingView addGestureRecognizer:rightRecognizer];
        
        UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];   
        [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];   
        [self.cptGraphHostingView addGestureRecognizer:leftRecognizer];
        [self reloadPickerToMidOfDate:referenceDate];
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
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
    [self initMonthSelectorWithX:56.f Height:66.f isForPedo:YES];
    barIdArray = [[NSMutableArray alloc] initWithObjects:[PEDPedometerDataHelper integerToString:STATISTICS_DISTANCE], [PEDPedometerDataHelper integerToString:STATISTICS_AVG_SPEED],[PEDPedometerDataHelper integerToString:STATISTICS_AVG_PACE], nil];
    [self initBarRemark];
    [self initData];
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        [self setEdgesForExtendedLayout:UIRectEdgeNone];
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
    return [AppConfig getInstance].settings.showDateCount;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    //    NSString *key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    //    NSNumber *num = [[dataForPlot objectAtIndex:index] valueForKey:key];
    //    
    //    // Green plot gets shifted above the blue
    //    if ( [(NSString *)plot.identifier isEqualToString:@"Green Plot"] ) {
    //        if ( fieldEnum == CPTScatterPlotFieldY ) {
    //            num = [NSNumber numberWithDouble:[num doubleValue] + 1.2];
    //        }
    //    }
    //    else if ( [(NSString *)plot.identifier isEqualToString:@"Orange Plot"] ) {
    //        if ( fieldEnum == CPTScatterPlotFieldY ) {
    //            num = [NSNumber numberWithDouble:[num doubleValue] + 0.5];
    //        }
    //    }
    //    return num;
    NSDecimalNumber *num = nil;
    
    if ( [plot isKindOfClass:[CPTScatterPlot class]] ) {
        switch ( fieldEnum ) {
            case CPTScatterPlotFieldX:
                num = (NSDecimalNumber *)[NSDecimalNumber numberWithFloat:index + 1];
                break;
                
            case CPTScatterPlotFieldY:
                num =  (NSDecimalNumber *)[NSDecimalNumber numberWithFloat:[(NSNumber *)[[statisticsData objectForKey:plot.identifier] objectAtIndex:index] floatValue]];
                break;
        }
    }
    
    return num;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index{
    if([(NSNumber *)[[statisticsData objectForKey:plot.identifier] objectAtIndex:index] floatValue] == 0){
        return nil;
    }
    CPTMutableTextStyle *textLineStyle=[CPTMutableTextStyle textStyle];
    textLineStyle.fontSize=isLargeView ? 7.0f : 6.0f;
    textLineStyle.color = [CPTColor whiteColor];
    NSString *plotIndentifier=(NSString *)plot.identifier;
    NSString *numberFormat;
    int digitCount;
    NSNumber *plotValue;
    digitCount=[plotIndentifier isEqualToString:[PEDPedometerDataHelper integerToString:STATISTICS_DISTANCE]] || [plotIndentifier isEqualToString:[PEDPedometerDataHelper integerToString:STATISTICS_AVG_SPEED]]? 2: 1;
    numberFormat=[NSString stringWithFormat:@"%%.%if",digitCount];
    plotValue=(NSNumber *)[[statisticsData objectForKey:plot.identifier] objectAtIndex:index] ;
    float plotValueDisplay=[PEDPedometerCalcHelper round:[plotValue floatValue] digit:digitCount];
    CPTTextLayer *label=[[CPTTextLayer alloc] initWithText: [NSString stringWithFormat:numberFormat,plotValueDisplay] style:textLineStyle];
    return label;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self genCurvechart];
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

-(void) btnClick:(id)sender withStatisticsType:(StatisticsType) statisticsType{
    @try {
        NSString *statisticsTypeStr = [PEDPedometerDataHelper integerToString:statisticsType];
        if(barIdArray != nil){
            UIButton * btn = (UIButton*) sender;
            BOOL isChange = NO;
            if([barIdArray containsObject:statisticsTypeStr]){
                [barIdArray removeObject:statisticsTypeStr];
                [btn setBackgroundImage:[PEDPedometerDataHelper getBtnBGImageWithStatisticsType:statisticsTypeStr withStatus:false] forState:UIControlStateNormal];
                /*
                [btn setBackgroundImage:nil forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                */
                 isChange = YES;
            }else{
                if(barIdArray.count < 3){
                    [barIdArray addObject:statisticsTypeStr];
                    [btn setBackgroundImage:[PEDPedometerDataHelper getBtnBGImageWithStatisticsType:statisticsTypeStr withStatus:true] forState:UIControlStateNormal];
                    //[btn setTitleColor:[PEDPedometerDataHelper getColorWithStatisticsType: statisticsTypeStr] forState:UIControlStateNormal];
                    isChange = YES;
                }
            }
            if(isChange){
                [self initBarRemark];
                [self genCurvechart];
            }
        }
    }
    @catch (NSException *exception) {
        [LogHelper errorAndShowAlert:@"Failed to change statistics type." exception:exception];
    }
    @finally {
        
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

-(void)genCurvechart
{
    @try {
        float yRangeLength = 9.0f;
        float ymajorIntervalLength = yRangeLength/([AppConfig getInstance].settings.chartIntervalLength+1);
        
        if(barIdArray !=nil && barIdArray.count>0){
            float maxValue = 0.0f;
            for (int i=0; i<barIdArray.count; i++) {
                NSArray *daysData = [statisticsData objectForKey:[barIdArray objectAtIndex:i]];
                for (int j=0; j<daysData.count; j++) {
                    float tempFloat = [(NSNumber *)[daysData objectAtIndex:j] floatValue];
                    if(maxValue < tempFloat){
                        maxValue = tempFloat;
                    }
                }
            }
            if(maxValue > FLOAT_EQUAL_STANDARD){
                int maxIntValue = (int)maxValue;
                yRangeLength = maxValue;
                ymajorIntervalLength = ceil(maxValue / [AppConfig getInstance].settings.chartIntervalLength);
                if(maxIntValue % [AppConfig getInstance].settings.chartIntervalLength != 0 || maxValue - maxIntValue > FLOAT_EQUAL_STANDARD){
                    yRangeLength = maxIntValue + [AppConfig getInstance].settings.chartIntervalLength - maxIntValue % [AppConfig getInstance].settings.chartIntervalLength + ymajorIntervalLength;
                }
            }
        }
        
        graph = nil;
        // Create graph from theme
        graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
        //    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
        //    [graph applyTheme:theme];
        CPTGraphHostingView *hostingView = (CPTGraphHostingView *)cptGraphHostingView;
        hostingView.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
        hostingView.backgroundColor = isLargeView ? [UIColor colorWithPatternImage:[UIImage imageNamed:@"chart_large_bg.png"]] : [UIColor clearColor];
//        if(isLargeView){
//            CPTTheme *theme = [CPTTheme themeNamed:kCPTSlateTheme];
//            [graph applyTheme:theme];
//        }
        hostingView.hostedGraph     = graph;
        
        // Border
        graph.plotAreaFrame.borderLineStyle = nil;
        graph.plotAreaFrame.cornerRadius    = 0.0f;
        
        // Paddings
        graph.paddingLeft   = 0.0f;
        graph.paddingRight  = 0.0f;
        graph.paddingTop    = 0.0f;
        graph.paddingBottom = 0.0f;
        
        graph.plotAreaFrame.paddingLeft   = 25.0f;
        graph.plotAreaFrame.paddingTop    = 10.0f;
        graph.plotAreaFrame.paddingRight  = 0.0f;
        graph.plotAreaFrame.paddingBottom = isLargeView?55.0f : 36.0f;
        
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
        plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(yRangeLength)];
        plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(8.0f)];
        
        CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
        CPTXYAxis *x          = axisSet.xAxis;
        CPTMutableLineStyle *lineStyle= [CPTMutableLineStyle lineStyle];
        lineStyle.miterLimit        = 1.0f;
        lineStyle.lineWidth         = 0.0f;
        lineStyle.lineColor         = [CPTColor darkGrayColor];    
        x.axisLineStyle               = lineStyle;
        lineStyle= [CPTMutableLineStyle lineStyle];
        lineStyle.miterLimit        = 1.0f;
        lineStyle.lineWidth         = 0.0f;
        lineStyle.lineColor         = [CPTColor grayColor]; 
        x.majorTickLineStyle          = lineStyle;
        x.majorGridLineStyle=lineStyle;
        lineStyle= [CPTMutableLineStyle lineStyle];
        lineStyle.miterLimit        = 1.0f;
        lineStyle.lineWidth         = 0.0f;
        lineStyle.lineColor         = [CPTColor grayColor]; 
        x.minorTickLineStyle          = lineStyle;
        NSArray *customMajorTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithFloat:8.0f], nil];
        x.majorTickLocations=[NSSet setWithArray:customMajorTickLocations];
        x.majorIntervalLength         = CPTDecimalFromString(@"1");
        
        NSArray *customMinjorTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithFloat:1.0f],[NSDecimalNumber numberWithFloat:2.0f],[NSDecimalNumber numberWithFloat:3.0f],[NSDecimalNumber numberWithFloat:4.0f],[NSDecimalNumber numberWithFloat:5.0f],[NSDecimalNumber numberWithFloat:6.0f],[NSDecimalNumber numberWithFloat:7.0f], nil];
        x.minorTickLocations=[NSSet setWithArray:customMinjorTickLocations];
        x.orthogonalCoordinateDecimal =CPTDecimalFromFloat(isLargeView? -ymajorIntervalLength*0.3: -ymajorIntervalLength*0.5);//x轴偏移直角坐标
        /*
         x.title                       = @"X Axis";
         x.titleLocation               = CPTDecimalFromFloat(7.5f);
         x.titleOffset                 = 55.0f;
         */
        // Define some custom labels for the data elements
        //x.labelRotation  = M_PI / 4;
        x.labelingPolicy = CPTAxisLabelingPolicyNone; 
        
        NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithFloat:1.0f], [NSDecimalNumber numberWithFloat:2.0f], [NSDecimalNumber numberWithFloat:3.0f], [NSDecimalNumber numberWithFloat:4.0f], [NSDecimalNumber numberWithFloat:5.0f], [NSDecimalNumber numberWithFloat:6.0f], [NSDecimalNumber numberWithFloat:7.0f], nil];
        
        NSArray *xAxisLabels         = [dayArray copy];
        NSUInteger labelLocation     = 0;
        NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
        for ( NSNumber *tickLocation in customTickLocations ) {
            CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
            textStyle.color = [CPTColor whiteColor];
            textStyle.fontSize=isLargeView?11.0f : 9.0f;
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
        lineStyle.lineWidth         = 0.0f;
        lineStyle.lineColor         = [CPTColor darkGrayColor];
        y.axisLineStyle               = lineStyle;
        y.majorTickLineStyle          = nil;
        y.minorTickLineStyle          = nil;
        y.majorIntervalLength         = CPTDecimalFromFloat(ymajorIntervalLength);
        y.majorGridLineStyle=lineStyle;
        y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0.3");
        CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
        textStyle.color = [CPTColor whiteColor];
        textStyle.fontSize = isLargeView? 11.0f : 9.0f;
        y.labelTextStyle  = textStyle;
        /*
         y.title                       = @"Y Axis";
         y.titleOffset                 = 45.0f;
         y.titleLocation               = CPTDecimalFromFloat(150.0f);
         */
        
        // Create a blue plot area
        
        if(barIdArray !=nil && barIdArray.count>0){
            CPTScatterPlot *boundLinePlot = nil;
            for (int i=0; i<barIdArray.count; i++) {
                boundLinePlot  = [[CPTScatterPlot alloc] init];
                lineStyle = [CPTMutableLineStyle lineStyle];
                lineStyle.miterLimit        = 1.0f;
                lineStyle.lineWidth         = 2.0f;
                lineStyle.lineColor         = [PEDPedometerDataHelper getCPTColorWithStatisticsType:[barIdArray objectAtIndex:i]];
                boundLinePlot.dataLineStyle = lineStyle;
                boundLinePlot.identifier    = [barIdArray objectAtIndex:i];
                boundLinePlot.dataSource    = self;
                [graph addPlot:boundLinePlot];
            }
        }
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
        
        //    boundLinePlot  = [[CPTScatterPlot alloc] init];
        //    lineStyle = [CPTMutableLineStyle lineStyle];
        //    lineStyle.miterLimit        = 1.0f;
        //    lineStyle.lineWidth         = 4.0f;
        //    lineStyle.lineColor         = [CPTColor purpleColor];
        //    boundLinePlot.dataLineStyle = lineStyle;
        //    boundLinePlot.identifier    = @"Purple Plot";
        //    boundLinePlot.dataSource    = self;
        //    [graph addPlot:boundLinePlot];
        
        /*
         // Do a blue gradient
         areaColor1       = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
         areaGradient1 = [CPTGradient gradientWithBeginningColor:areaColor1 endingColor:[CPTColor clearColor]];
         areaGradient1.angle = -90.0f;
         areaGradientFill = [CPTFill fillWithGradient:areaGradient1];
         boundLinePlot.areaFill      = areaGradientFill;
         boundLinePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
         */
        
        //    boundLinePlot  = [[CPTScatterPlot alloc] init];
        //    lineStyle = [CPTMutableLineStyle lineStyle];
        //    lineStyle.miterLimit        = 1.0f;
        //    lineStyle.lineWidth         = 4.0f;
        //    lineStyle.lineColor         = [CPTColor greenColor];
        //    boundLinePlot.dataLineStyle = lineStyle;
        //    boundLinePlot.identifier    = @"Green Plot";
        //    boundLinePlot.dataSource    = self;
        //    [graph addPlot:boundLinePlot];
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
        //    NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:100];
        //    NSUInteger i;
        //    for ( i = 0; i < 8; i++ ) {
        //        id x = [NSNumber numberWithFloat:i * 0.8];
        //        id y = [NSNumber numberWithFloat:16 * rand() / (float)RAND_MAX + 0.8*i];
        //        [contentArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x", y, @"y", nil]];
        //    }
        //    self.dataForPlot = contentArray;
        
#ifdef PERFORMANCE_TEST
        //    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changePlotRange) userInfo:nil repeats:YES];
#endif
        // Do any additional setup after loading the view, typically from a nib.
        
        //UIImageView *bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 410)];
        //bgImage.image = [UIImage imageNamed:@"graphs.bmp"] ;
        //[self.view addSubview:bgImage];
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
    
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    @try {
        if(!isFirstLoad){
            NSDate *date =  [UtilHelper convertDate:[NSString stringWithFormat:@"01 %@", [monthArray objectAtIndex:index]] withFormat:@"dd MMM yyyy"];
            if(index!=3){        
                [self reloadPickerToMidOfDate:date];
            }
            NSDate *dateTo=[date addMonths:1];
            NSDate *selectDate=[[BO_PEDPedometerData getInstance] getLastDateWithTarget:[AppConfig getInstance].settings.target.targetId between:date to:dateTo];
            //selectDate = !selectDate ? date : selectDate;
            if(selectDate){
                dayRemark = - [referenceDate timeIntervalSinceDate:selectDate]/60/60/24; 
            }else{
                if([referenceDate timeIntervalSinceDate:date]<0){
                    dayRemark = - [referenceDate timeIntervalSinceDate:date]/60/60/24 + [AppConfig getInstance].settings.showDateCount; 
                }
                else{
                    dayRemark = - [referenceDate timeIntervalSinceDate:date]/60/60/24 + [AppConfig getInstance].settings.showDateCount - 1; 
                }
            }
            dayArray = [PEDPedometerDataHelper getDaysQueue:[AppConfig getInstance].settings.showDateCount withDaySpacing:dayRemark withDateFormat:@"dd/MM" referedDate:referenceDate];
            statisticsData = [PEDPedometerDataHelper getStatisticsData:[AppConfig getInstance].settings.showDateCount withDaySpacing:dayRemark withTagetId:[AppConfig getInstance].settings.target.targetId withMeasureUnit:[AppConfig getInstance].settings.userInfo.measureFormat referedDate:referenceDate];
            [self genCurvechart];
        }
        isFirstLoad = NO;
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
    
}

- (void)viewDidUnload {
    [self setCptGraphHostingView:nil];
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
