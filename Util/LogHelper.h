//
//  LogHelper.h
//  Pedometer
//
//  Created by JILI Du on 13/4/21.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Log4Cocoa.h"

#ifdef DEBUG  
# define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);  
#else  
# define DLog(...);  
#endif  

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
