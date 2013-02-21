//
//  PEDUserInfo.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDUserInfo.h"

@implementation PEDUserInfo

@synthesize userId,userName,age,measureFormat,gender,height,stride,weight,updateDate,isCurrentUser,heightUnit,strideUnit,weightUnit,distanceUnit;

-(id) initWithDefault
{
    self=[super init];
    if(self)
    {
        userId = [UtilHelper stringWithUUID];   
        userName=[UtilHelper deviceName];
        age=26;
        measureFormat=UNIT_METRIC;
        gender=GENDER_MALE;
        height=1.6;//m
        weight=60;//kg
        stride=60;//cm
        updateDate=[NSDate date];
        isCurrentUser=YES;
        [self convertUnit:UNIT_METRIC];
    }
    return self;
}

/*
 
 Metric: Stride = cm, Height = m, Weight = kg, distance = km
 English: Stride = inch, height = feet-inch, Weight = Lbs, distance = mile
 1 kg = 2.2 lbs, 1 inch = 2.54 cm, 1 feet = 12 inch, 1 km = 0.62 mile
 
 */
-(void)convertUnit:(MeasureUnit) dstUnit;
{
    if(dstUnit==UNIT_METRIC){
        heightUnit=@"m";
        strideUnit=@"cm";
        weightUnit=@"kg";
        distanceUnit=@"km";
        if (measureFormat==UNIT_ENGLISH) {
           
        }
    }
    else{
        heightUnit=@"feet-inch";
        strideUnit=@"inch";
        weightUnit=@"Lbs";
        distanceUnit=@"mile";
        if(measureFormat==UNIT_METRIC){
            height=[PEDPedometerCalcHelper convertInchToFeet:[PEDPedometerCalcHelper convertCmToInch:height*100]];
            stride=[PEDPedometerCalcHelper convertCmToInch:stride];
            weight=[PEDPedometerCalcHelper convertKgToLbs:weight];
        }
    }
}

@end
