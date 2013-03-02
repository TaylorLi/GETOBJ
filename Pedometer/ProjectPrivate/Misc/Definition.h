//
//  Definition.h
//  
//
//  Created by Eagle Du on 12/7/16.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATABASE_NAME @"Pedometer"

typedef enum {
	MEASURE_UNIT_METRIC = 0,					// no packet
    MEASURE_UNIT_ENGLISH = 1
} MeasureUnit;

typedef enum{
   GENDER_MALE=0,
    GENDER_FEMALE
}GenderType;

typedef enum{
    PLUS_NONE = -1,
    PLUS_FIT = 0,
    PLUS_HEALTH,
    PLUS_SPORT
}PlusType;

typedef enum{
    STATISTICS_STEP = 0,
    STATISTICS_ACTIVITY_TIME, 
    STATISTICS_CALORIES, 
    STATISTICS_DISTANCE, 
    STATISTICS_AVG_SPEED, 
    STATISTICS_AVG_PACE
}StatisticsType;

@interface Definition : NSObject


@end
