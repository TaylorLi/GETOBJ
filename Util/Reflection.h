//
//  Reflection.h
//  TKD Score
//
//  Created by Eagle Du on 12/8/26.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reflection : NSObject

+(NSDictionary *)getPropertiesNameAndType:(Class)classType;

@end