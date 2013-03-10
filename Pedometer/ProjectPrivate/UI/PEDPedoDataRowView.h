//
//  PEDPedoDataRowView.h
//  Pedometer
//
//  Created by JILI Du on 13/3/10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PEDPedometerData;


@interface PEDPedoDataRowView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblNextDate;
@property (weak, nonatomic) IBOutlet UILabel *lblNextStep;
@property (weak, nonatomic) IBOutlet UILabel *lblNextDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblNextCalories;
@property (weak, nonatomic) IBOutlet UILabel *lblNextActTime;

+(PEDPedoDataRowView *)instanceView:(PEDPedometerData *) pedoMeterData;  

-(void) bindByPedometerData:(PEDPedometerData *) pedoMeterData;

@end
