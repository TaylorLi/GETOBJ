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
+(NSString *)getKeyCodeDesc:(short)keyCode
{
    if(keyCode>=GSEVENTKEY_KEYCODE_ALP_A&&keyCode<=GSEVENTKEY_KEYCODE_ALP_Z)
    {
        short c=(short)'A';
        c=keyCode-GSEVENTKEY_KEYCODE_ALP_A+c;
        return [NSString stringWithFormat:@"Alpha %c",(char)c];
    }
    else if(keyCode==GSEVENTKEY_KEYCODE_NUM_0)
    {
        return @"Num 0";
    }
    else if(keyCode>=GSEVENTKEY_KEYCODE_NUM_1&&keyCode<=GSEVENTKEY_KEYCODE_NUM_9)
    {
        short c=(short)'1';
        c=keyCode-GSEVENTKEY_KEYCODE_NUM_1+c;
        return [NSString stringWithFormat:@"Num %c",(char)c];
    }
    else
    {
        NSDictionary *codeDesc=[[NSDictionary alloc] initWithObjectsAndKeys:
                                @"~",@"53",
                                @"-",@"45",
                                @"+",@"46",
                                @"\\",@"49",
                                @"[",@"47",
                                @"]",@"48",
                                @";",@"51",
                                @"'",@"52",
                                @",",@"54",
                                @".",@"55",
                                @"/",@"56",
                                @"ARROW RIGHT",@"79",
                                @"ARROW LEFT",@"80",
                                @"ARROW DOWN",@"81",
                                @"ARROW UP",@"82",
                                nil];
        if([codeDesc containKey:[NSString stringWithFormat:@"%i",keyCode]])
        {
            return [codeDesc objectForKey:[NSString stringWithFormat:@"Char %i",keyCode]];
        }
        else
            return [NSString stringWithFormat:@"Unmatch code %i",keyCode];
    }
}
+(NSString *)getWinTypeDesc:(WinType)type{
    switch (type) {
        case kWinByPoint:            
            return @"Win By Point";
        case kWinByPointGap:
            return @"Win By Point Gap";
        case  kWinByByWarning:
            return @"Win By Warning";
        default:
            return @"";
    }
}

+ (NSString*) stringWithUUID {
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
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

@end
