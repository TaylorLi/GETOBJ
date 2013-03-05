//
//  BO_MatchInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_PEDSleepData.h"
#import "PEDSleepData.h"

static BO_PEDSleepData* instance;

@implementation BO_PEDSleepData

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[PEDSleepData class] primaryKey:@"dataId"];
    if(self){
        
    }
    return self;
}

+ (BO_PEDSleepData*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_PEDSleepData alloc] init];
    }
    return instance;
}

-(PEDSleepData *)getWithTarget :(NSString*) targetId withDate:(NSDate *)date
{
    return [self queryObjectBySql:@"select * from PEDSleepData where targetId = ? and optDate=?" parameters:[[NSArray alloc] initWithObjects:targetId,date, nil]];
}

@end
