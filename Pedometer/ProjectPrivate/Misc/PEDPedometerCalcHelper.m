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
//km
+(NSTimeInterval) calDistanceByStep:(NSInteger)step stride:(NSTimeInterval)stride 
{
    return step*stride/100/1000;
}
//km/h
+(NSTimeInterval) calAvgPaceByDistance:(NSTimeInterval) km inTime:(NSTimeInterval) sencond withMeasureUnit:(MeasureUnit) measureUnit
{
    if (km==0) {
        return 0;
    }
    return sencond/60/(measureUnit==MEASURE_UNIT_METRIC ? km : [self convertKmToMile:km]);
}
//min/km
+(NSTimeInterval) calAvgSpeedByDistance:(NSTimeInterval) km inTime:(NSTimeInterval) sencond withMeasureUnit:(MeasureUnit) measureUnit
{
    if(sencond==0)
        return 0;
    else
        return (measureUnit==MEASURE_UNIT_METRIC ? km : [self convertKmToMile:km])*3600/sencond;
}

+(NSString*) getStrideUnit :(MeasureUnit) measureUnit withWordFormat:(Boolean) isUpper{
    NSString *strideUnit = nil;
    switch (measureUnit) {
        case MEASURE_UNIT_METRIC:
            if (isUpper) {
                strideUnit = @"CM";
            }else{
                strideUnit = @"cm";
            }
            break;
        case MEASURE_UNIT_ENGLISH:
            if (isUpper) {
                strideUnit = @"Inch";
            }else{
                strideUnit = @"inch";
            }
            break;
        default:
            break;
    }
    return strideUnit;
}

+(NSString*) getHeightUnit :(MeasureUnit) measureUnit withWordFormat:(Boolean) isUpper{
    NSString *heightUnit = nil;
    switch (measureUnit) {
        case MEASURE_UNIT_METRIC:
            if (isUpper) {
                heightUnit = @"CM";
            }else{
                heightUnit = @"cm";
            }
            break;
        case MEASURE_UNIT_ENGLISH:
            if (isUpper) {
                heightUnit = @"Feet-Inch";
            }else{
                heightUnit = @"feet-inch";
            }
            break;
        default:
            break;
    }
    return heightUnit;
}

+(NSString*) getWeightUnit :(MeasureUnit) measureUnit withWordFormat:(Boolean) isUpper{
    NSString *weightUnit = nil;
    switch (measureUnit) {
        case MEASURE_UNIT_METRIC:
            if (isUpper) {
                weightUnit = @"KG";
            }else{
                weightUnit = @"kg";
            }
            break;
        case MEASURE_UNIT_ENGLISH:
            if (isUpper) {
                weightUnit = @"Lbs";
            }else{
                weightUnit = @"lbs";
            }
            break;
        default:
            break;
    }
    return weightUnit;
}

+(NSString*) getDistanceUnit :(MeasureUnit) measureUnit withWordFormat:(Boolean) isUpper{
    NSString *distanceUnit = nil;
    switch (measureUnit) {
        case MEASURE_UNIT_METRIC:
            if (isUpper) {
                distanceUnit = @"KM";
            }else{
                distanceUnit = @"km";
            }
            break;
        case MEASURE_UNIT_ENGLISH:
            if (isUpper) {
                distanceUnit = @"Mile";
            }else{
                distanceUnit = @"mile";
            }
            break;
        default:
            break;
    }
    return distanceUnit;
}

/*
 
 Metric: Stride = cm, Height = m, Weight = kg, distance = km
 English: Stride = inch, height = feet-inch, Weight = Lbs, distance = mile
 1 kg = 2.2 lbs, 1 inch = 2.54 cm, 1 feet = 12 inch, 1 km = 0.62 mile
 
 */
+(NSTimeInterval) convertCmToInch:(NSTimeInterval) cm
{
    //return floor(cm/2.54);
    NSTimeInterval inch = cm/2.54;
    inch = [self round:inch digit:2];
    inch = [self round:inch digit:1];
    return inch;
    
}
+(NSTimeInterval) convertKgToLbs:(NSTimeInterval) kg
{
    return [self round:(2.2*kg) digit:0];
}
+(NSTimeInterval) convertKmToMile:(NSTimeInterval) km
{
    return round(km / 1.602 *100) / 100;
}
+(NSTimeInterval) convertInchToFeet:(NSTimeInterval) inch
{
    return [self round:(inch/12) digit:0];
}

+(NSString*) getFeetInfo:(NSTimeInterval) inch{
    float feet = inch/12;
    float feetRemain = (feet - (int)feet) * 12;
    return [NSString stringWithFormat:@"%.0f'%.0f\"", [self round:(feet) digit:0], [self round:(feetRemain) digit:0]];
}

+(NSTimeInterval) convertInchToCm:(NSTimeInterval) inch
{
    //return floor(inch*2.54);
    NSTimeInterval cm = inch*2.54;
    cm = [self round:cm digit:1];
    cm = [self round:cm digit:0];
    return cm;
}
+(NSTimeInterval) convertLbsToKg:(NSTimeInterval) lbs
{
    return [self round:(lbs/2.2) digit:0];
}
+(NSTimeInterval) convertMileToKm:(NSTimeInterval) mile
{
    return [self round:(mile/0.62) digit:0];
}
+(NSTimeInterval) convertFeetToInch:(NSTimeInterval) feet
{
    return [self round:(feet*12) digit:0];
}

+(NSTimeInterval) round:(NSTimeInterval) num digit:(NSInteger)decimals
{
    return round(num *pow(10, decimals)) / pow(10, decimals);
}
@end
