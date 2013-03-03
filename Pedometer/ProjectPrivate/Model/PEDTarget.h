//
//  PEDTarget.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEDTarget : NSObjectSerialization<SqliteORMDelegate>

@property (nonatomic,strong) NSString *targetId;
@property (nonatomic) NSInteger targetStep;
@property (nonatomic) NSInteger remainStep;
@property (nonatomic) NSTimeInterval targetDistance;
@property (nonatomic) NSTimeInterval remainDistance;
@property (nonatomic) NSTimeInterval targetCalorie;
@property (nonatomic) NSTimeInterval remainCalorie;
@property (nonatomic,strong) NSDate *updateDate;
@property (nonatomic,strong) NSString *userId;
@property NSInteger sleepDataCount;
@property NSInteger pedoDataCount;

-(id) initWithUserInfo:(PEDUserInfo*)user;

@end
