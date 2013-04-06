//
//  PEDPedoDataRowView.m
//  Pedometer
//
//  Created by JILI Du on 13/3/10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDPedoDataRowView.h"
#import "PEDPedometerData.h"
#import "UtilHelper.h"
#import "PEDPedometerDataHelper.h"

@implementation PEDPedoDataRowView

@synthesize lblNextDate;
@synthesize lblNextStep;
@synthesize lblNextDistance;
@synthesize lblNextCalories;
@synthesize lblNextActTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+(PEDPedoDataRowView *)instanceView:(PEDPedometerData *) pedoMeterData  
{  
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PEDPedoDataRowView" owner:nil options:nil];  
   PEDPedoDataRowView *view = (PEDPedoDataRowView *)[nibView objectAtIndex:0];  
   if(view){
       [view bindByPedometerData:pedoMeterData];
   }
   return view;
}  

-(void) bindByPedometerData:(PEDPedometerData *) pedoMeterData
{
    if(pedoMeterData.optDate){
        lblNextDate.text = [UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"];
        NSLog(@"%@",[UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"]);
        lblNextStep.text = [PEDPedometerDataHelper integerToString: pedoMeterData.step];
        NSTimeInterval distance = [AppConfig getInstance].settings.userInfo.measureFormat == MEASURE_UNIT_METRIC ? pedoMeterData.distance : [PEDPedometerCalcHelper convertKmToMile:pedoMeterData.distance];
        lblNextDistance.text = [NSString stringWithFormat:@"%.2f%@", distance, [PEDPedometerCalcHelper getDistanceUnit:[AppConfig getInstance].settings.userInfo.measureFormat withWordFormat:YES]];
        lblNextCalories.text = [NSString stringWithFormat:@"%.1fKcal", pedoMeterData.calorie];
        lblNextActTime.text = [PEDPedometerDataHelper integerToTimeString:(int)pedoMeterData.activeTime];
    }
}
@end
