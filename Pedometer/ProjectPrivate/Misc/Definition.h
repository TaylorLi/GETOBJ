//
//  Definition.h
//  
//
//  Created by Eagle Du on 12/7/16.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATABASE_NAME @"Pedometer"

#define CONTACT_EMAIL @"mkt@mail.kingtech-hk.com"
#define CONTACT_EMAIL_SAMPLE_SUBJECT @""
#define CONTACT_EMAIL_SAMPLE_BODY @""
/*无效时间表示方式*/
#define TIME_INVALID_FLAG -1

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
    STATISTICS_ACTIVITY_TIME=3, 
    STATISTICS_CALORIES=2, 
    STATISTICS_DISTANCE=1, 
    STATISTICS_AVG_SPEED=4, 
    STATISTICS_AVG_PACE=5,
    STATISTICS_SLEEP_ACTUAL_SLEEP_TIME=6,
    STATISTICS_SLEEP_TIMES_AWAKEN=7,
    STATISTICS_SLEEP_IN_BED_TIME=8
}StatisticsType;

@interface Definition : NSObject


@end
