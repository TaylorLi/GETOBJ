//
//  PEDPedometerCalcHelper.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/19.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEDPedometerCalcHelper : NSObject
//计算卡路里
+(NSTimeInterval) calCalorieByStep:(NSInteger)step stride:(NSTimeInterval)stride weight:(NSTimeInterval)weight; 
//min/km
+(NSTimeInterval) calDistanceByStep:(NSInteger)step stride:(NSTimeInterval)stride;
+(NSTimeInterval) calAvgPaceByDistance:(NSTimeInterval) km inTime:(NSTimeInterval) sencond;
+(NSTimeInterval) calAvgSpeedByDistance:(NSTimeInterval) km inTime:(NSTimeInterval) sencond;
//km

+(NSTimeInterval) convertCmToInch:(NSTimeInterval) cm;
+(NSTimeInterval) convertKgToLbs:(NSTimeInterval) kg;
+(NSTimeInterval) convertKmToMile:(NSTimeInterval) km;
+(NSTimeInterval) convertInchToFeet:(NSTimeInterval) inch;

+(NSTimeInterval) convertInchToCm:(NSTimeInterval) inch;
+(NSTimeInterval) convertLbsToKg:(NSTimeInterval) lbs;
+(NSTimeInterval) convertMileToKm:(NSTimeInterval) mile;
+(NSTimeInterval) convertFeetToInch:(NSTimeInterval) feet;

@end
