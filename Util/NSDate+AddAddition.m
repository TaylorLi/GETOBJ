//
//  NSDate+AddAddition.m
//  Pedometer
//
//  Created by JILI Du on 13/3/4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+AddAddition.h"

@implementation  NSDate (AddAddition)

-(NSDate *)addByFormat:(DateInteval) format withInteval:(NSInteger)num
{
    NSDateComponents* dateComponents = [[NSDateComponents alloc] init];
    switch (format) {
        case DateIntevalDay:
            [dateComponents setDay:num];
            break;
        case DateIntevalMonth:
            [dateComponents setMonth:num];
            break;            
        case DateIntevalYear:
            [dateComponents setYear:num];
            break;
        case DateIntevalHour:
            [dateComponents setHour:num];
            break;
        case DateIntevalMinute:
            [dateComponents setMinute:num];
            break;
        case DateIntevalSecond:
            [dateComponents setSecond:num];
            break;
        default:
            break;
    }
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

-(NSDate *) firstMonthDate
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *components=[calendar components:unitFlags fromDate:self];
    [components setDay:1];
    return [calendar dateFromComponents:components];
}
-(NSDate *) lastMonthDate
{
   return [[[self firstMonthDate] addMonths:1] addSeconds:-1];
}
-(NSDate *) addDays:(NSInteger)num
{
   return [self addByFormat:DateIntevalDay withInteval:num];
}

-(NSDate *) addMonths:(NSInteger)num
{
    return [self addByFormat:DateIntevalMonth withInteval:num];
}

-(NSDate *) addYears:(NSInteger)num
{
    return [self addByFormat:DateIntevalYear withInteval:num];
}

-(NSDate *) addHours:(NSInteger)num
{
    return [self addByFormat:DateIntevalHour withInteval:num];
}

-(NSDate *) addMinutes:(NSInteger)num
{
    return [self addByFormat:DateIntevalMinute withInteval:num];
}

-(NSDate *) addSeconds:(NSInteger)num
{
    return [self addByFormat:DateIntevalSecond withInteval:num];
}
-(BOOL) inSameMonth:(NSDate *)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *componentsSelf=[calendar components:unitFlags fromDate:self];
    NSDateComponents *componentsTo=[calendar components:unitFlags fromDate:date];
    return componentsSelf.year==componentsTo.year && componentsSelf.month == componentsTo.month;
}

-(NSDateComponents *) components
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit |NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *componentsSelf=[calendar components:unitFlags fromDate:self];
    return componentsSelf;
}

-(NSInteger) year
{
    return [self components].year;
}

-(NSInteger) month
{
   return [self components].month; 
}

-(NSInteger) day
{
    return [self components].day;
}

-(NSInteger) hour
{
    return [self components].hour;
}

-(NSInteger) minute
{
    return [self components].minute;
}

-(NSInteger) second
{
    return [self components].second;
}
@end
