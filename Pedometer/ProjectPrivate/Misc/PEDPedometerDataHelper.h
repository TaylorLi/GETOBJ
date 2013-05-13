//
//  PEDPedometerDataHelper.h
//  Pedometer
//
//  Created by Yuheng Li on 13-3-2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
@interface PEDPedometerDataHelper : NSObject
+(NSString*) integerToString: (NSInteger) intValue;
+(NSMutableArray*) getDaysQueue :(NSInteger) dayCount withDaySpacing: (NSInteger) daySpacing withDateFormat: (NSString*) dateFormat referedDate:(NSDate *) referDate;
+(NSMutableDictionary*) getStatisticsData :(NSInteger) dayCount withDaySpacing: (NSInteger) daySpacing withTagetId: (NSString*) targetId withMeasureUnit:(MeasureUnit) measureUnit referedDate:(NSDate *) referDate;
+(NSMutableDictionary*) getStatisticsData4Sleep: (NSInteger) dayCount withDaySpacing: (NSInteger) daySpacing withTagetId: (NSString*) targetId referedDate:(NSDate *) referDate;
+(CPTColor*) getCPTColorWithStatisticsType:(NSString*) statisticsTypeString;
+(NSString*) getBarRemarkTextWithStatisticsType:(NSString*) statisticsTypeString withMeasureUnit:(MeasureUnit) measureUnit;
+(UIColor*) getColorWithStatisticsType:(NSString*) statisticsTypeString;
+(UIImage*) getBtnBGImageWithStatisticsType:(NSString*) statisticsTypeString;
+(NSString*) getTargetRemark :(NSTimeInterval) stepPercent withDistancePercent:(NSTimeInterval) distancePercent withCaloriesPercent:(NSTimeInterval) caloriesPercent;
+(NSString*) integerToTimeString:(NSInteger) intValue;
@end
