//
//  d.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/22.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "UtilHelper.h"
#import "Reflection.h"

@implementation UtilHelper
+(NSString *)formateTime:(NSDate *)date;
{
    return [UtilHelper formateDate:date withFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
}
+(NSString *)formateDate:(NSDate *)date
{
    return [UtilHelper formateDate:date withFormat:@"yyyy-MM-dd"];
}
+(NSString *)formateDateWithTime:(NSDate *)date
{
    return [UtilHelper formateDate:date withFormat:@"yyyy-MM-dd HH:mm:ss"];
}
+(NSString *)formateDate:(NSDate *)date withFormat:(NSString *)format
{
    return [self formateDate:date withFormat:format multiLanuage:@"en_US"];
}
+(NSString *)formateDate:(NSDate *)date withFormat:(NSString *)format multiLanuage:(NSString *) lang
{
    if(date==nil)
        return @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:format];
    if (lang) {
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:lang]];
    }    
    NSString *d= [dateFormatter stringFromDate:date];
    if(d==nil){
        NSLog(@"date object type:%@",[date class]);
        NSLog(@"   Normal Date = %@", date);
        NSLog(@"Formatted Date = %@", d);
        return @"";
    }    
    return d;
}

+(NSDate *) convertDate:(NSString *)dateString
{
    return [UtilHelper convertDate:dateString withFormat:@"yyyy-MM-dd"];
}
+(NSDate *) convertDate:(NSString *)dateString withFormat:(NSString *)format
{
    return [self convertDate:dateString withFormat:format multiLanuage:@"en_US"];
}
+(NSDate *) convertDate:(NSString *)dateString withFormat:(NSString *)format multiLanuage:(NSString *) lang
{
    if(dateString==nil||[dateString isEqualToString:@""])
        return nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:format];
    if(lang){
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:lang]];
    }
    NSDate *d= [dateFormatter dateFromString:dateString];
if(d==nil)
{
    NSLog(@"date object type:%@",[dateString class]);
    NSLog(@"   Normal Date = %@", dateString);
    NSLog(@"   Date Format= %@", format);
    NSLog(@"Formatted Date = %@", d);
}
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
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    //每个应用程序只有一个Documents目录  
    //NSString *documentsDirectory = [paths objectAtIndex:0];  
    //创建文件名  
    return [PATH_OF_CACHE stringByAppendingPathComponent:fileName];  
}  
+(BOOL)isFileExist:(NSString *)fileName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[UtilHelper dataFilePath:fileName]];
}

+ (NSString*) stringWithUUID {
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
    //return [[uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
}

+ (NSString*) stringByUUID:(CFUUIDRef)uuidObj {
    //get the string representation of the UUID
    NSString    *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    return uuidString;
    //return [[uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
}

+(void)copyAttributesFromObject:(id)from ToObject:(id)to
{
    NSDictionary *propetiesTo=[Reflection getPropertiesNameAndType:[to class]];
    NSDictionary *propetiesFrom=[Reflection getPropertiesNameAndType:[from class]];
    for (NSString *propertyNameTo in propetiesTo.allKeys)
    {
        NSString *propertyTypeTo=[propetiesTo valueForKey:propertyNameTo];
        if([propetiesFrom containKey:propertyNameTo]&&[(NSString *)[propetiesFrom objectForKey:propertyTypeTo] isEqualToString:propertyTypeTo])
            
        {
            [to setValue:[from valueForKey:propertyNameTo] forKey:propertyNameTo];
        }
    }
}

+(NSString *)ArrayToString:(NSArray *)array
{
  if(array==nil)
      return @"";
    else{
        NSMutableString *sb=[[NSMutableString alloc] init];
        for (NSString *str in array) {
            [sb appendFormat:@"%@,",str];
        }
        return [sb substringToIndex:sb.length-1];
    }
}

+(NSString *)stringWithInt:(int) v
{
    return [NSString stringWithFormat:@"%i",v];
}

+(BOOL) isValidEmail:(NSString*)email
{
    NSString *emailRegEx = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";  
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];  
    
    return [regExPredicate evaluateWithObject:email];  
}

+(NSString *) toJson:(id)obj
{
    @try {
        SBJsonWriter *wr=[[SBJsonWriter alloc] init];
        return  [wr stringWithObject:obj];
    }
    @catch (NSException *exception) {
        return exception.reason;
    }
    @finally {
        
    }
    
}
+(id)fromJson:(NSString *)jsonString
{
    @try {
        SBJsonParser *parse=[[SBJsonParser alloc] init];
       return [parse objectWithString:jsonString];
    }
    @catch (NSException *exception) {
       return @"proxyForJson protocal no impleted.";
    }
    @finally {
        
    }
}
+(NSString *)deviceName
{
    return [[UIDevice currentDevice] name];
}
+(NSString *)hexDescriptionForNSData:(NSData *)data
{
    Byte *bytes = (Byte *)[data bytes];    
    NSString *hexStr=@"";    
    for(int i=0;i<[data length];i++)        
    {        
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else 
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    
    return [NSString stringWithFormat:@"16 Hex Of bytes is %@",hexStr];
}    
+(void)sendEmail:(NSString *)to andSubject:(NSString*) subject andBody:(NSString*) body{
    
    NSString *email = [NSString stringWithFormat:@"mailto://%@?subject=%@&body=%@", to, subject, body];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}
+(BOOL) isSameDate:(NSDate*) oneDate withAnotherDate:(NSDate*) anotherDate{
    return [[self formateDate:oneDate withFormat:@"yyyyMMdd"] isEqualToString:[self formateDate:anotherDate withFormat:@"yyyyMMdd"]];
}
@end
