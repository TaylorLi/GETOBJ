//
//  d.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/22.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "UtilHelper.h"

@implementation UtilHelper
+(NSString *)formateTime:(NSDate *)date;
{
    if(date==nil)
        return @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //[dateFormatter setDateFormat:@"hh:mm:ss"]
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *d= [dateFormatter stringFromDate:[NSDate date]];
    return d;
}
//从文件中反序列化反序列化
+(id)deserializeFromFile:(NSString *)fileName dataKey:(NSString *) dataKey;
{
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[UtilHelper dataFilePath:fileName]];  
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];  
    
    id obj = [unarchiver decodeObjectForKey:dataKey];  
    [unarchiver finishDecoding];  
    return obj;
}
//序列化到文件中，对象必须实现<NSCoding, NSCopying>协议
+(void)serializeObjectToFile:(NSString *)fileName withObject:(id)obj dataKey:(NSString*) dataKey
{
    NSMutableData *data = [[NSMutableData alloc] init];//用于存储编码的数据  
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];  
    
    [archiver encodeObject:obj forKey:dataKey];  
    [archiver finishEncoding];  
    [data writeToFile:[UtilHelper dataFilePath:fileName] atomically:YES];  
}
//数据文件的完整路径  
+(NSString *)dataFilePath:(NSString *)fileName {  
    //检索Documents目录路径。第二个参数表示将搜索限制在我们的应用程序沙盒中  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    //每个应用程序只有一个Documents目录  
    NSString *documentsDirectory = [paths objectAtIndex:0];  
    //创建文件名  
    return [documentsDirectory stringByAppendingPathComponent:fileName];  
}  
+(BOOL)isFileExist:(NSString *)fileName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[UtilHelper dataFilePath:fileName]];
}
@end
