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
+(NSMutableArray*) getDaysQueue :(NSInteger) dayCount withDaySpacing: (NSInteger) daySpacing withDateFormat: (NSString*) dateFormat;
+(NSMutableDictionary*) getStatisticsData :(NSInteger) dayCount withDaySpacing: (NSInteger) daySpacing withTagetId: (NSString*) targetId withMeasureUnit:(MeasureUnit) measureUnit;
+(CPTColor*) getCPTColorWithStatisticsType:(NSString*) statisticsTypeString;
+(NSString*) getBarRemarkTextWithStatisticsType:(NSString*) statisticsTypeString withMeasureUnit:(MeasureUnit) measureUnit;
+(UIColor*) getColorWithStatisticsType:(NSString*) statisticsTypeString;
+(UIImage*) getBtnBGImageWithStatisticsType:(NSString*) statisticsTypeString;
@end
