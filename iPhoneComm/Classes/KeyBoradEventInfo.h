//
//  KeyBoradEventInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/9/6.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyBoradEventInfo : NSObject

@property short keyCode;
@property (nonatomic,strong) NSString *keyDesc;
@property BOOL command;
@property BOOL option;
@property BOOL control;
@property BOOL shift;
@end
