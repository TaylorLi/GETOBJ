//
//  PEDPedoDataRowView4Sleep.h
//  Pedometer
//
//  Created by Yuheng Li on 13-5-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PEDSleepData;

@interface PEDPedoDataRowView4Sleep : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblHour4ActualSleepTime;
@property (weak, nonatomic) IBOutlet UILabel *lblMinute4ActualSleepTime;
@property (weak, nonatomic) IBOutlet UILabel *lblRemark4TimeToBed;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeToBed;
@property (weak, nonatomic) IBOutlet UILabel *lblRemark4TimeToFallSleep;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeToFallSleep;
@property (weak, nonatomic) IBOutlet UILabel *lblTimesAwaken;


+(PEDPedoDataRowView4Sleep *)instanceView:(PEDSleepData *) pedoMeterData;  

-(void) bindByPedometerData:(PEDSleepData *) pedoMeterData;
@end
