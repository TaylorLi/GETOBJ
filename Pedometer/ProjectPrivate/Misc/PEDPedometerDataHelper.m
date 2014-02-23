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
#import "BO_PEDSleepData.h"
#import "PEDSleepData.h"
#import "CorePlot-CocoaTouch.h"
@implementation PEDPedometerDataHelper

+(NSString*) integerToTimeString:(NSInteger) intValue{
    int h, m, s;
    h = intValue / 3600;
    m = intValue % 3600 / 60;
    s = intValue % 3600 % 60;
    m += round(s/60);
    return [NSString stringWithFormat:@"%02d:%02d", h, m];
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
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_AVG_PACE]] addObject:[NSNumber numberWithFloat:[PEDPedometerCalcHelper calAvgPaceByDistance:meterData.distance inTime:meterData.activeTime withMeasureUnit:measureUnit]/10]];
        }
    }
    return statisticsDatas;
}

+(NSMutableDictionary*) getStatisticsData4Sleep: (NSInteger) dayCount withDaySpacing: (NSInteger) daySpacing withTagetId: (NSString*) targetId referedDate:(NSDate *) referDate{
    NSMutableDictionary * statisticsDatas = [[NSMutableDictionary alloc]init];
    [statisticsDatas setObject:[[NSMutableArray alloc] initWithCapacity:dayCount] forKey:[self integerToString:STATISTICS_SLEEP_ACTUAL_SLEEP_TIME]];
    [statisticsDatas setObject:[[NSMutableArray alloc] initWithCapacity:dayCount] forKey:[self integerToString:STATISTICS_SLEEP_TIMES_AWAKEN]];
    [statisticsDatas setObject:[[NSMutableArray alloc] initWithCapacity:dayCount] forKey:[self integerToString:STATISTICS_SLEEP_IN_BED_TIME]];
    
    NSDate *dateFrom = [referDate addDays: - (dayCount - daySpacing - 1)];
    dateFrom = [UtilHelper convertDate: [UtilHelper formateDate:dateFrom]];
    NSDate *dateTo = [referDate addDays: - (- daySpacing - 1)];
    dateTo = [UtilHelper convertDate: [UtilHelper formateDate:dateTo]];
    
    NSArray *sleepDataArray = [[BO_PEDSleepData getInstance] queryListFromDateNeedEmptySorted:dateFrom toDate:dateTo withTargetId:targetId];
    for (PEDSleepData *sleepData in sleepDataArray) {
        if(sleepData == nil){
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_SLEEP_ACTUAL_SLEEP_TIME]] addObject:[NSNumber numberWithFloat:0.0f]];
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_SLEEP_TIMES_AWAKEN]] addObject:[NSNumber numberWithFloat:0.0f]];
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_SLEEP_IN_BED_TIME]] addObject:[NSNumber numberWithFloat:0.0f]];
        }else{
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_SLEEP_ACTUAL_SLEEP_TIME]] addObject: [NSNumber numberWithFloat:sleepData.actualSleepTime / 3600.0f]];
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_SLEEP_TIMES_AWAKEN]] addObject:[NSNumber numberWithFloat:sleepData.awakenTime]];
            [[statisticsDatas objectForKey:[self integerToString:STATISTICS_SLEEP_IN_BED_TIME]] addObject:[NSNumber numberWithFloat:sleepData.inBedTime / 3600.0f]];
        }
    }
    return statisticsDatas;
}


+(CPTColor*) getCPTColorWithStatisticsType:(NSString*) statisticsTypeString{
    CPTColor *cptColor = nil;
    switch ([statisticsTypeString integerValue]) {
        case STATISTICS_STEP:
            cptColor = [CPTColor colorWithComponentRed:204/255.0f green:153/255.0f blue:204/255.0f alpha:1];
            break;
        case STATISTICS_ACTIVITY_TIME:
            cptColor = [CPTColor colorWithComponentRed:0/255.0f green:204/255.0f blue:255/255.0f alpha:1];
            break;
        case STATISTICS_CALORIES:
            cptColor = [CPTColor colorWithComponentRed:235/255.0f green:102/255.0f blue:41/255.0f alpha:1];
            break;
        case STATISTICS_DISTANCE:
            cptColor = [CPTColor colorWithComponentRed:137/255.0f green:194/255.0f blue:52/255.0f alpha:1];
            break;
        case STATISTICS_AVG_SPEED:
            cptColor = [CPTColor colorWithComponentRed:243/255.0f green:214/255.0f blue:220/255.0f alpha:1];
            break;
        case STATISTICS_AVG_PACE:
            cptColor = [CPTColor colorWithComponentRed:248/255.0f green:204/255.0f blue:107/255.0f alpha:1];
            break;
        case STATISTICS_SLEEP_ACTUAL_SLEEP_TIME:
            cptColor = [CPTColor colorWithComponentRed:236/255.0f green:183/255.0f blue:195/255.0f alpha:1];
            break;
        case STATISTICS_SLEEP_TIMES_AWAKEN:
            cptColor = [CPTColor colorWithComponentRed:151/255.0f green:209/255.0f blue:233/255.0f alpha:1];
            break;
        case STATISTICS_SLEEP_IN_BED_TIME:
            cptColor = [CPTColor colorWithComponentRed:217/255.0f green:207/255.0f blue:181/255.0f alpha:1];
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
        case STATISTICS_SLEEP_ACTUAL_SLEEP_TIME:
            lableText = @"Actual sleep time\n 1=1HOUR";
            break;
        case STATISTICS_SLEEP_TIMES_AWAKEN:
            lableText = @"Times awaken\n 1=1TIMES";
            break;
        case STATISTICS_SLEEP_IN_BED_TIME:
            lableText = @"In bed time\n 1=1HOUR";
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
        case STATISTICS_SLEEP_ACTUAL_SLEEP_TIME:
            uiColor = [UIColor colorWithRed:124/255.0f green:94/255.0f blue:98/255.0f alpha:1];
            break;
        case STATISTICS_SLEEP_TIMES_AWAKEN:
            uiColor = [UIColor colorWithRed:81/255.0f green:120/255.0f blue:135/255.0f alpha:1];
            break;
        case STATISTICS_SLEEP_IN_BED_TIME:
            uiColor = [UIColor colorWithRed:106/255.0f green:101/255.0f blue:84/255.0f alpha:1];
            break;
        default:
            break;
    }
    return uiColor; 
}
/*图表上面选中类型比例标示*/
+(UIImage*) getBarRemarkImageWithStatisticsType:(NSString*) statisticsTypeString{
    UIImage *barBRImage = nil;
    BOOL useMetric = [AppConfig getInstance].settings.userInfo.measureFormat ==MEASURE_UNIT_METRIC;
    switch ([statisticsTypeString integerValue]) {
        case STATISTICS_STEP:
            barBRImage = [UIImage imageNamed:@"Barchart_hear_bar_step.png"];
            break;
        case STATISTICS_ACTIVITY_TIME:
            barBRImage = [UIImage imageNamed:@"Barchart_hear_bar_acttime.png"];
            break;
        case STATISTICS_CALORIES:
            barBRImage = [UIImage imageNamed:@"Barchart_hear_bar_calories.png"];
            break;
        case STATISTICS_DISTANCE:
            barBRImage = [UIImage imageNamed:useMetric?@"Barchart_hear_bar_distance_metric":@"Barchart_hear_bar_distance_enghlish.png"];
            break;
        case STATISTICS_AVG_SPEED:
            barBRImage = [UIImage imageNamed:useMetric?@"Barchart_hear_bar_speed_metric.png":@"Barchart_hear_bar_speed_enghlish.png"];
            break;
        case STATISTICS_AVG_PACE:
            barBRImage = [UIImage imageNamed:useMetric?@"Barchart_hear_bar_pace_metric.png": @"Barchart_hear_bar_pace_enghlish.png"];
            break;
        case STATISTICS_SLEEP_ACTUAL_SLEEP_TIME:
            barBRImage = [UIImage imageNamed:@"sleep_chart_remark_ast.png"];
            break;
        case STATISTICS_SLEEP_TIMES_AWAKEN:
            barBRImage = [UIImage imageNamed:@"sleep_chart_remark_ta.png"];
            break;
        case STATISTICS_SLEEP_IN_BED_TIME:
            barBRImage = [UIImage imageNamed:@"sleep_chart_remark_ibt.png"];
            break;
        default:
            break;
    }
    return barBRImage;
}
/*图标按钮背景图片*/
+(UIImage*) getBtnBGImageWithStatisticsType:(NSString*) statisticsTypeString withStatus:(BOOL) isEnable{
    UIImage *btnBGImage = nil;
    switch ([statisticsTypeString integerValue]) {
        case STATISTICS_STEP:
            btnBGImage = isEnable ?[UIImage imageNamed:(@"pedo_btn_panel_step_first.png")]:nil;
            break;
        case STATISTICS_ACTIVITY_TIME:
            btnBGImage = isEnable ?[UIImage imageNamed:(@"pedo_btn_panel_acttime_first.png")]:nil;
            break;
        case STATISTICS_CALORIES:
            btnBGImage = isEnable ?[UIImage imageNamed:(@"pedo_btn_panel_calories_first.png")]:nil;
            break;
        case STATISTICS_DISTANCE:
            btnBGImage = isEnable ?[UIImage imageNamed:(@"pedo_btn_panel_distance_first.png")]:nil;
            break;
        case STATISTICS_AVG_SPEED:
            btnBGImage = isEnable ?[UIImage imageNamed:(@"pedo_btn_panel_avg_speed_second.png")]:nil;
            break;
        case STATISTICS_AVG_PACE:
            btnBGImage = isEnable ? [UIImage imageNamed:(@"pedo_btn_panel_avg_pace_second.png")]:nil;
            break;
        case STATISTICS_SLEEP_ACTUAL_SLEEP_TIME:
            btnBGImage = [UIImage imageNamed:(isEnable ? @"sleep_chart_btn_ast_on.png" : @"sleep_chart_btn_ast_off.png")];
            break;
        case STATISTICS_SLEEP_TIMES_AWAKEN:
            btnBGImage = [UIImage imageNamed:(isEnable ? @"sleep_chart_btn_ta_on.png" : @"sleep_chart_btn_ta_off.png")];
            break;
        case STATISTICS_SLEEP_IN_BED_TIME:
            btnBGImage = [UIImage imageNamed:(isEnable ? @"sleep_chart_btn_ibt_on.png" : @"sleep_chart_btn_ibt_off.png")];
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

+(NSString*) getSleepTimeString :(NSTimeInterval) time{
    return [self getSleepTimeString:time withFormat:@"%d:%02d"];
}

+(NSString*) getSleepTimeString :(NSTimeInterval) time withFormat: (NSString*) format{
    NSString *ret = @"-:--";
    if(time != TIME_INVALID_FLAG){
        int h, m, s;
        h = (int)time / 3600;
        m = (int)time % 3600 / 60;
        s = (int)time % 3600 % 60;
        m = m + round(s/60);
        if(h >= 12){
            h -= 12;
        }
        ret = [NSString stringWithFormat:format, h, m];
    }
    return ret;
}

+(NSString*) getSleepTimeRemark :(NSTimeInterval) time{
    NSString *remark = @"";
    if(time != TIME_INVALID_FLAG){
        int h;
        h = (int)time / 3600;
        if(h >= 12){
            remark = @"P";
        }else{
            remark = @"A";
        }
    }
    return remark;
}
@end
