//
//  NSString+MD5Addition.h
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(MD5Addition)

- (NSString *) stringFromMD5;
- (NSString *)stringByReplacingOccurrencesOfStringIngoreNil:(NSString *)target withString:(NSString *)replacement NS_AVAILABLE(10_5, 2_0);

@end
