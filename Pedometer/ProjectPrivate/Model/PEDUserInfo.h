//
//  PEDUserInfo.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEDUserInfo : NSObjectSerialization<SqliteORMDelegate>
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic) MeasureUnit measureFormat;
@property (nonatomic) NSTimeInterval stride;//cm
@property (nonatomic)  NSTimeInterval height;//cm
@property (nonatomic) NSTimeInterval weight;//kg
@property (nonatomic) BOOL gender;//0=Male, 1=Female
@property (nonatomic) NSInteger age;
@property (nonatomic,strong) NSDate *updateDate;
@property (nonatomic) BOOL isCurrentUser;

#pragma mark -
#pragma mark 无需保存到数据库的属性


@property (nonatomic,strong) NSString *strideUnit;
@property (nonatomic,strong) NSString *heightUnit;
@property (nonatomic,strong) NSString *weightUnit;
@property (nonatomic,strong) NSString *distanceUnit;

-(id)initWithDefault;

-(void)convertUnit:(MeasureUnit) dstUnit;

@end
