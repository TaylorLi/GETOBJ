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
    return ceil(cm/2.54);
}
+(NSTimeInterval) convertKgToLbs:(NSTimeInterval) kg
{
    return ceil(2.2*kg);
}
+(NSTimeInterval) convertKmToMile:(NSTimeInterval) km
{
    return ceil(km*0.62);
}
+(NSTimeInterval) convertInchToFeet:(NSTimeInterval) inch
{
    return floor(inch/12);
}

+(NSString*) getFeetInfo:(NSTimeInterval) inch{
    float feet = inch/12;
    float feetRemain = (feet - (int)feet) * 12;
    return [NSString stringWithFormat:@"%.0f'%.0f\"", floor(feet), ceil(feetRemain)];
}

+(NSTimeInterval) convertInchToCm:(NSTimeInterval) inch
{
    return ceil(inch*2.54);
}
+(NSTimeInterval) convertLbsToKg:(NSTimeInterval) lbs
{
    return ceil(lbs/2.2);
}
+(NSTimeInterval) convertMileToKm:(NSTimeInterval) mile
{
    return ceil(mile/0.62);
}
+(NSTimeInterval) convertFeetToInch:(NSTimeInterval) feet
{
    return floor(feet*12);
}
@end
