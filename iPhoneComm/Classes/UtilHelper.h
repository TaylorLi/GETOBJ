//
//  Util.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/22.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Definition.h"

@interface UtilHelper : NSObject
+(NSString *)formateTime:(NSDate *)date;
+(id)deserializeFromFile:(NSString *)fileName dataKey:(NSString *) dataKey;
+(void)serializeObjectToFile:(NSString *)fileName withObject:(id)obj dataKey:(NSString*) dataKey;
+(NSString *)dataFilePath:(NSString *)fileName;
+(BOOL)isFileExist:(NSString *)fileName;
+(NSString *)getKeyCodeDesc:(short)keyCode;
+(NSString *)getWinTypeDesc:(WinType)type;
+ (NSString*) stringWithUUID;
@end
