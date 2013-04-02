//
//  PEDPedometerDataHelper.m
//  Pedometer
//
//  Created by Yuheng Li on 13-3-2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDPedometerDataHelper.h"
#import "PEDPedometerData.h"
#import "BO_PEDPedometerData.h"
#import "CorePlot-CocoaTouch.h"
@implementation PEDPedometerDataHelper

+(NSString*) integerToTimeString:(NSInteger) intValue{
    int h, m, s;
    h = intValue / 3600;
    m = intValue % 3600 / 60;
    s = intValue % 3600 % 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02d", h, m, s];
}

+(NSString*) integerToString: (NSInteger) intValue{
    return [NSString stringWithFormat:@"%d", intValue];
}

+(NSMutableArray*) getDaysQueue :(NSInteger) dayCount withDaySpacing: (NSInteger) daySpacing withDateFormat: (NSString*) dateFormat referedDate:(NSDate *) referDate{
    NSMutableArray *daysArray = [[NSMutableArray alloc]initWithCapacity:dayCount];
    
    for (int i=dayCount - daySpacing - 1; i>=-daySpacing; i--) {

        NSDate *date = [referDate addDays:-i];

        [daysArray addObject:[UtilHelper formateDate:date withFormat:dateFormat]];
    }
    return daysArray;
}

+(NSMutableDictionary*) getStatisticsData :(NSInteger) dayCount withDaySpacing: (NSInteger) daySpacing withTagetId: (NSString*) targetId withMeasureUnit:(MeasureUnit) measureUnit referedDate:(NSDate *) referDate{
    NSMutableDictionary * statisticsDatas = [[NSMutableDictionary alloc]init];
    [statisticsDatas setObject:[[NSMutableArray alloc] initWithCapacity:dayCount] forKey:[self integerToString:STATISTICS_STEP]];
    [statisticsDatas setObject:[[NSMutableArray alloc] initWithCapacity:dayCount] forKey:[self integerToString:STATISTICS_ACTIVITY_TIME]];
    [statisticsDatas setObject:[[NSMutableArray alloc] initWithCapacity:dayCount] forKey:[self integerToString:STATISTICS_CALORIES]];
    [statisticsDatas setObject:[[NSMutableArray alloc] initWithCapacity:dayCount] forKey:[self integerToString:STATISTICS_DISTANCE]];
    [statisticsDatas setObject:[[NSMutableArray alloc] initWithCapacity:dayCount] forKey:[self integerToString:STATISTICS_AVG_SPEED]];
    [statisticsDatas setObject:[[NSMutableArray alloc] initWithCapacity:dayCount] forKey:[self integerToString:STATISTICS_AVG_PACE]];

    NSDate *dateFrom = [referDate addDays: - (dayCount - daySpacing - 1)];
    dateFrom = [UtilHelper convertDate: [UtilHelper formateDate:dateFrom]];
    NSDate *dateTo = [referDate addDays: - (- daySpacing - 1)];
    dateTo = [UtilHelper convertDate: [UtilHelper formateDate:dateTo]];

    NSArray *meterDataArray = [[BO_PEDPedometerData getInstance] queryListFromDateNeedEmptySorted:dateFrom toDate:dateTo withTargetId:targetId];
    for (PEDPedometerData *meterData in meterDataArray) {
        if(meterData == nil){
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_STEP]] addObject:[NSNumber numberWithFloat:0.0f]];
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_ACTIVITY_TIME]] addObject:[NSNumber numberWithFloat:0.0f]];
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_CALORIES]] addObject:[NSNumber numberWithFloat:0.0f]];
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_DISTANCE]] addObject:[NSNumber numberWithFloat:0.0f]];
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_AVG_SPEED]] addObject:[NSNumber numberWithFloat:0.0f]];
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_AVG_PACE]] addObject:[NSNumber numberWithFloat:0.0f]];
        }else{
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_STEP]] addObject: [NSNumber numberWithFloat:meterData.step / 1000.0f]];
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_ACTIVITY_TIME]] addObject:[NSNumber numberWithFloat:meterData.activeTime/60/10]];
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_CALORIES]] addObject:[NSNumber numberWithFloat:meterData.calorie / 1000]];
            NSTimeInterval distance = [AppConfig getInstance].settings.userInfo.measureFormat == MEASURE_UNIT_METRIC ? meterData.distance : [PEDPedometerCalcHelper convertKmToMile:meterData.distance];
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_DISTANCE]] addObject:[NSNumber numberWithFloat:distance]];
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_AVG_SPEED]] addObject:[NSNumber numberWithFloat: [PEDPedometerCalcHelper calAvgSpeedByDistance:meterData.distance inTime:meterData.activeTime withMeasureUnit:measureUnit]]];
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_AVG_PACE]] addObject:[NSNumber numberWithFloat:[PEDPedometerCalcHelper calAvgPaceByDistance:meterData.distance inTime:meterData.activeTime withMeasureUnit:measureUnit]]];
        }
    }
    return statisticsDatas;
}


+(CPTColor*) getCPTColorWithStatisticsType:(NSString*) statisticsTypeString{
    CPTColor *cptColor = nil;
    switch ([statisticsTypeString integerValue]) {
        case STATISTICS_STEP:
            cptColor = [CPTColor colorWithComponentRed:41/255.0f green:218/255.0f blue:179/255.0f alpha:1];
            break;
        case STATISTICS_ACTIVITY_TIME:
            cptColor = [CPTColor colorWithComponentRed:215/255.0f green:218/255.0f blue:33/255.0f alpha:1];
            break;
        case STATISTICS_CALORIES:
            cptColor = [CPTColor colorWithComponentRed:246/255.0f green:18/255.0f blue:99/255.0f alpha:1];
            break;
        case STATISTICS_DISTANCE:
            cptColor = [CPTColor colorWithComponentRed:215/255.0f green:106/255.0f blue:69/255.0f alpha:1];
            break;
        case STATISTICS_AVG_SPEED:
            cptColor = [CPTColor colorWithComponentRed:123/255.0f green:91/255.0f blue:184/255.0f alpha:1];
            break;
        case STATISTICS_AVG_PACE:
            cptColor = [CPTColor colorWithComponentRed:139/255.0f green:215/255.0f blue:83/255.0f alpha:1];
            break;
        default:
            break;
    }
    return cptColor;
}

+(NSString*) getBarRemarkTextWithStatisticsType:(NSString*) statisticsTypeString withMeasureUnit:(MeasureUnit) measureUnit{
    NSString *lableText = nil;
    switch ([statisticsTypeString integerValue]) {
        case STATISTICS_STEP:
            lableText = @"Step 1=1000";
            break;
        case STATISTICS_ACTIVITY_TIME:
            lableText = @"Activity Time 1=10Min";
            break;
        case STATISTICS_CALORIES:
            lableText = @"Calories 1=1000Kcal";
            break;
        case STATISTICS_DISTANCE:
            lableText = [NSString stringWithFormat:@"Distance 1=1%@", [PEDPedometerCalcHelper getDistanceUnit:measureUnit withWordFormat:YES]];
            break;
        case STATISTICS_AVG_SPEED:
            lableText = [NSString stringWithFormat:@"Avg Speed 1=1%@/hr", [PEDPedometerCalcHelper getDistanceUnit:measureUnit withWordFormat:YES]];
            break;
        case STATISTICS_AVG_PACE:
            lableText = [NSString stringWithFormat:@"Avg Pace 1=1Min/%@", [PEDPedometerCalcHelper getDistanceUnit:measureUnit withWordFormat:YES]];
            break;
        default:
            break;
    }
    return lableText;    
}

+(UIColor*) getColorWithStatisticsType:(NSString*) statisticsTypeString{
    UIColor *uiColor = nil;
    switch ([statisticsTypeString integerValue]) {
        case STATISTICS_STEP:
            uiColor = [UIColor colorWithRed:78/255.0f green:142/255.0f blue:173/255.0f alpha:1];
            break;
        case STATISTICS_ACTIVITY_TIME:
            uiColor = [UIColor colorWithRed:151/255.0f green:127/255.0f blue:29/255.0f alpha:1];
            break;
        case STATISTICS_CALORIES:
            uiColor = [UIColor colorWithRed:124/255.0f green:29/255.0f blue:67/255.0f alpha:1];
            break;
        case STATISTICS_DISTANCE:
            uiColor = [UIColor colorWithRed:117/255.0f green:60/255.0f blue:47/255.0f alpha:1];
            break;
        case STATISTICS_AVG_SPEED:
            uiColor = [UIColor colorWithRed:74/255.0f green:63/255.0f blue:93/255.0f alpha:1];
            break;
        case STATISTICS_AVG_PACE:
            uiColor = [UIColor colorWithRed:77/255.0f green:115/255.0f blue:62/255.0f alpha:1];
            break;
        default:
            break;
    }
    return uiColor; 
}

+(UIImage*) getBtnBGImageWithStatisticsType:(NSString*) statisticsTypeString{
    UIImage *btnBGImage = nil;
    switch ([statisticsTypeString integerValue]) {
        case STATISTICS_STEP:
            btnBGImage = [UIImage imageNamed:@"step_button.png"];
            break;
        case STATISTICS_ACTIVITY_TIME:
            btnBGImage = [UIImage imageNamed:@"activity_time_button.png"];
            break;
        case STATISTICS_CALORIES:
            btnBGImage = [UIImage imageNamed:@"calories_button.png"];
            break;
        case STATISTICS_DISTANCE:
            btnBGImage = [UIImage imageNamed:@"distance_button.png"];
            break;
        case STATISTICS_AVG_SPEED:
            btnBGImage = [UIImage imageNamed:@"speed_button.png"];
            break;
        case STATISTICS_AVG_PACE:
            btnBGImage = [UIImage imageNamed:@"pace_button.png"];
            break;
        default:
            break;
    }
    return btnBGImage; 
}

+(NSString*) getTargetRemark :(NSTimeInterval) stepPercent withDistancePercent:(NSTimeInterval) distancePercent withCaloriesPercent:(NSTimeInterval) caloriesPercent{
    NSString *remark = nil;
    int avgPercent = (int)(stepPercent + distancePercent + caloriesPercent) * 100 / 3;
    if(avgPercent <= 5){
        remark = @"Activity Started !";
    }
    else if(avgPercent <= 59){
        remark = @"More To Go !";
    }
    else if(avgPercent <= 99){
        remark = @"Work hard ! Keep going !";
    }else{
        remark = @"Congratulations !";
    }
    return remark;
}
@end
