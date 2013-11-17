//
//  BO_MatchInfo.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "BO_PEDTarget.h"
#import "PEDTarget.h"

static BO_PEDTarget* instance;

@implementation BO_PEDTarget

-(id)init{
    self=[super initWithModelTypeAndPrimaryKey:[PEDTarget class] primaryKey:@"targetId"];
    if(self){
        
    }
    return self;
}

+ (BO_PEDTarget*) getInstance {
    if ( instance == nil ) {
        instance = [[BO_PEDTarget alloc] init];
    }
    return instance;
}

-(PEDTarget *)queryTargetByUserId:(NSString *)userId
{
    return [self queryObjectBySql:@"select * from PEDTarget where userId=?" parameters:[[NSArray alloc] initWithObjects:userId, nil]];
}

-(void)clearTargetData:(NSString *)targetId
{
     [self executeNoQuery:@"delete from PEDSleepdata where targetId=?" parameters:[[NSArray alloc] initWithObjects:targetId, nil]];
    [self executeNoQuery:@"delete from PEDPedometerData where targetId=?" parameters:[[NSArray alloc] initWithObjects:targetId, nil]];
}

-(PEDTarget *)clearBindingDevice:(PEDTarget *)target
{
    [self clearTargetData:target.targetId];
    target.relatedDeviceName=nil;
    target.relatedDeviceUUID=nil;
    [self updateObject:target];
    return target;
}

@end
