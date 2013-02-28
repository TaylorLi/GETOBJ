//
//  PEDPedometerCalcHelper.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/19.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDPedometerCalcHelper.h"

@implementation PEDPedometerCalcHelper

//卡路里公式=1.036 × 行走距离(km) × 体重(kg)
+(NSTimeInterval) calCalorieByStep:(NSInteger)step stride:(NSTimeInterval)stride weight:(NSTimeInterval)weight
{
    return 1.036*step*stride/100/1000*weight;
}

+(NSTimeInterval) calDistanceByStep:(NSInteger)step stride:(NSTimeInterval)stride 
{
    return 1.036*step*stride/100/1000;
}
//km/h
+(NSTimeInterval) calAvgPaceByDistance:(NSTimeInterval) km inTime:(NSTimeInterval) sencond
{
    return sencond/60/km;
}
//min/km
+(NSTimeInterval) calAvgSpeedByDistance:(NSTimeInterval) km inTime:(NSTimeInterval) sencond
{
    return km*3600/sencond;
}


/*
 
 Metric: Stride = cm, Height = m, Weight = kg, distance = km
 English: Stride = inch, height = feet-inch, Weight = Lbs, distance = mile
 1 kg = 2.2 lbs, 1 inch = 2.54 cm, 1 feet = 12 inch, 1 km = 0.62 mile
 
 */
+(NSTimeInterval) convertCmToInch:(NSTimeInterval) cm
{
    return cm/2.54;
}
+(NSTimeInterval) convertKgToLbs:(NSTimeInterval) kg
{
    return 2.2*kg;
}
+(NSTimeInterval) convertKmToMile:(NSTimeInterval) km
{
    return km*0.62;
}
+(NSTimeInterval) convertInchToFeet:(NSTimeInterval) inch
{
    return inch/12;
}

+(NSTimeInterval) convertInchToCm:(NSTimeInterval) inch
{
    return inch*2.54;
}
+(NSTimeInterval) convertLbsToKg:(NSTimeInterval) lbs
{
    return lbs/2.2;
}
+(NSTimeInterval) convertMileToKm:(NSTimeInterval) mile
{
    return mile/0.62;
}
+(NSTimeInterval) convertFeetToInch:(NSTimeInterval) feet
{
    return feet*12;
}
@end
