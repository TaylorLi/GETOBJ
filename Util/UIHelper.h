//
//  UIHelper.h
//  Marry
//
//  Created by EagleDu on 12/2/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "AlertView.h"

@interface UIHelper : NSObject
+(void) showAlert:(NSString*) title message:(NSString*)msg func:(void(^)(AlertView* a, NSInteger i))block;
+ (void)setTextFieldErrorCss:(UITextField*)txtField isError:(BOOL)error;
+ (BOOL)validateTextFieldErrorCss:(UITextField*)txtField;
+(BOOL) alternateTextField:(NSArray *)views;
+(void) resignResponser:(NSArray *)views;
+(BOOL) validateTextFields:(NSArray *)views;
@end
