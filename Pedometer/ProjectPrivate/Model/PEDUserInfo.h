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
@property (nonatomic) NSTimeInterval stride;
@property (nonatomic)  NSTimeInterval height;
@property (nonatomic) NSTimeInterval weight;
@property (nonatomic) BOOL gender;//0=Male, 1=Female
@property (nonatomic) NSInteger age;
@property (nonatomic,strong) NSDate *updateDate;
@end
