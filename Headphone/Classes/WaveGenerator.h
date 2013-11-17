//
//  WaveGenerator.h
//  Headphone
//
//  Created by JILI Du on 13/3/24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayWaveDefintion.h"

@interface WaveGenerator : NSObject

+(NSData *)generatorCmdBytesByOriginCmdByte:(Byte *)bytes withLength:(int)byteLength;   
+(NSArray *)genWaveEdageArray;
+(NSArray *)genPlautArray;
+(NSData *)cmdReadUserInfo;
@end
