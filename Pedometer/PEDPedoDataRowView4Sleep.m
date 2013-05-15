//
//  PEDPedoDataRowView4Sleep.m
//  Pedometer
//
//  Created by Yuheng Li on 13-5-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDPedoDataRowView4Sleep.h"
#import "PEDSleepData.h"
#import "UtilHelper.h"
#import "PEDPedometerDataHelper.h"

@implementation PEDPedoDataRowView4Sleep

@synthesize lblDate;
@synthesize lblHour4ActualSleepTime;
@synthesize lblMinute4ActualSleepTime;
@synthesize lblRemark4TimeToBed;
@synthesize lblTimeToBed;
@synthesize lblRemark4TimeToFallSleep;
@synthesize lblTimeToFallSleep;
@synthesize lblTimesAwaken;


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

+(PEDPedoDataRowView4Sleep *)instanceView:(PEDSleepData *) pedoMeterData  
{  
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PEDPedoDataRowView4Sleep" owner:nil options:nil];  
    PEDPedoDataRowView4Sleep *view = (PEDPedoDataRowView4Sleep *)[nibView objectAtIndex:0];  
    if(view){
        [view bindByPedometerData:pedoMeterData];
    }
    return view;
}  

-(void) bindByPedometerData:(PEDSleepData *) pedoMeterData
{
    if(pedoMeterData && pedoMeterData.optDate){
        int h,m,s;
        h = (int)pedoMeterData.actualSleepTime / 3600;
        m = (int)pedoMeterData.actualSleepTime % 3600 / 60;
        s = (int)pedoMeterData.actualSleepTime % 3600 % 60;
        m = m + round(s/60);
        lblDate.text = [UtilHelper formateDate:pedoMeterData.optDate withFormat:@"dd/MM/yy"];
        lblHour4ActualSleepTime.text = [NSString stringWithFormat:@"%d", h];
        lblMinute4ActualSleepTime.text = [NSString stringWithFormat:@"%02d", m];
        lblRemark4TimeToBed.text = [PEDPedometerDataHelper getSleepTimeRemark:pedoMeterData.timeToBed];
        lblTimeToBed.text = [PEDPedometerDataHelper getSleepTimeString:pedoMeterData.timeToBed];
        lblRemark4TimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeRemark:pedoMeterData.timeToFallSleep];
        lblTimeToFallSleep.text = [PEDPedometerDataHelper getSleepTimeString:pedoMeterData.timeToFallSleep];
        lblTimesAwaken.text = [NSString stringWithFormat:@"%.0f", pedoMeterData.awakenTime];
    }
}
@end
