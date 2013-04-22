//
//  LogHelper.h
//  Pedometer
//
//  Created by JILI Du on 13/4/21.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Log4Cocoa.h"


@interface LogHelper : NSObject

+(void)setInitialLogger;
+(void)setInitialLoggerByConfigFile:(NSString *)fileName;

+(void)info:(NSString *)message;
+(void)error:(NSString *)message exception:(NSException *)ex;
+(void)debug:(NSString *)message;
+(void)warmning:(NSString *)message exception:(NSException *)ex;
+(void)debug:(NSString *)message exception:(NSException *)ex;
+(void)errorAndShowAlert:(NSString *)message exception:(NSException *)ex;

@end
