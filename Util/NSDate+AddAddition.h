//
//  NSDate+AddAddition.h
//  Pedometer
//
//  Created by JILI Du on 13/3/4.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DateIntevalDay,
     DateIntevalMonth,
     DateIntevalYear,
     DateIntevalHour,
     DateIntevalMinute,
     DateIntevalSecond,
}DateInteval;

@interface NSDate (AddAddition)

-(NSDate *) addDays:(NSInteger)num;
-(NSDate *) addMonths:(NSInteger)num;
-(NSDate *) addYears:(NSInteger)num;
-(NSDate *) addHours:(NSInteger)num;
-(NSDate *) addMinutes:(NSInteger)num;
-(NSDate *) addSeconds:(NSInteger)num;
-(NSDate *)addByFormat:(DateInteval) format withInteval:(NSInteger)num; 
@end
