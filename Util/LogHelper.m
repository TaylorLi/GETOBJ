//
//  LogHelper.m
//  Pedometer
//
//  Created by JILI Du on 13/4/21.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "LogHelper.h"
#import "UIHelper.h"

@implementation LogHelper

+(void)setInitialLogger
{
    [[L4Logger rootLogger] setLevel:[L4Level all]];
    [[L4Logger rootLogger] addAppender: [[L4ConsoleAppender alloc] initTarget:YES withLayout: [L4Layout simpleLayout]]];
    
    [[L4Logger rootLogger] addAppender: [[L4FileAppender alloc] initWithLayout:[L4Layout simpleLayout] fileName:@"Logger.txt" append:YES]];
    L4Logger *theLogger = [L4Logger loggerForClass:[L4FunctionLogger class]];
    [theLogger setLevel:[L4Level info]];
    log4CDebug(@"The logging system has been initialized.");
}

+(void)setInitialLoggerByConfigFile:(NSString *)fileName
{
    NSArray *array= [fileName componentsSeparatedByString:@"."];
     NSString *configPath=[[NSBundle mainBundle] pathForResource:[array objectAtIndex:0] ofType:[array objectAtIndex:1]];    
    L4PropertyConfigurator *config =
    [L4PropertyConfigurator propertyConfiguratorWithFileName:configPath];
    
    [config configure];
    log4CInfo(@"Log4Cocoa is ready to go!");
}

+(void)info:(NSString *)message{
    log4CInfo(message);
}

+(void)error:(NSString *)message exception:(NSException *)ex{
    log4CErrorWithException(message,ex);
}

+(void)debug:(NSString *)message{
    log4CDebug(message);
}

+(void)warmning:(NSString *)message exception:(NSException *)ex{
    log4CWarnWithException(message, ex);
}

+(void)debug:(NSString *)message exception:(NSException *)ex{
    log4CDebugWithException(message,ex);
}

+(void)errorAndShowAlert:(NSString *)message exception:(NSException *)ex{
    log4ErrorWithException(message,ex);
    [UIHelper showAlert:@"Warmning" message:message func:nil];
}
@end
