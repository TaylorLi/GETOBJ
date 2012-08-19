//
//  Util.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/22.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h> 

@interface UtilHelper : NSObject
+(NSString *)formateTime:(NSDate *)date;
+(void)playSoundWithPath:(NSString *)resourcePath ofType:(NSString *)fileType;
@end
