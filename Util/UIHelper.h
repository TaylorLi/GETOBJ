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

@protocol FormBoxDelegate
@optional
- (void)actionByView:(id)controller eventType:(NSInteger) type eventArgs:(NSDictionary *)args;
@end

@interface UIHelper : NSObject
+(void) showAlert:(NSString*) title message:(NSString*)msg func:(void(^)(AlertView* a, NSInteger i))block;
+(void) showConfirm:(NSString*) title message:(NSString*)msg doneText:(NSString *)doneText doneFunc:(void(^)(AlertView* a, NSInteger i))doneBlock cancelText:(NSString *)cancelText cancelfunc:(void(^)(AlertView* a, NSInteger i))block;
+ (void)setTextFieldErrorCss:(UITextField*)txtField isError:(BOOL)error;
+ (BOOL)validateTextFieldErrorCss:(UITextField*)txtField;
+(BOOL) alternateTextField:(NSArray *)views;
+(void) resignResponser:(NSArray *)views;
+(BOOL) validateTextFields:(NSArray *)views;
+(UIView *)findFirstResponder:(UIView *)parentView;
@end
