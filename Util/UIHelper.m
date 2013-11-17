//
//  UIHelper.m
//  Marry
//
//  Created by EagleDu on 12/2/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIHelper.h"


@implementation UIHelper

+(void) showAlert:(NSString*) title message:(NSString*)msg func:(void(^)(AlertView* a, NSInteger i))block{
    
    AlertView *confirmview = [[AlertView alloc] initWithTitle:title message:msg];
    [confirmview addButtonWithTitle:NSLocalizedString(@"OK", @"") block:[block copy]];
     [confirmview show];
}
+(void) showConfirm:(NSString*) title message:(NSString*)msg doneText:(NSString *)doneText doneFunc:(void(^)(AlertView* a, NSInteger i))doneBlock cancelText:(NSString *)cancelText cancelfunc:(void(^)(AlertView* a, NSInteger i))cancelBlock
{
    AlertView *confirmview = [[AlertView alloc] initWithTitle:title message:msg];
    [confirmview addButtonWithTitle:NSLocalizedString(doneText, doneText) block:[doneBlock copy]];
    [confirmview addButtonWithTitle:NSLocalizedString(cancelText, cancelText) block:[cancelBlock copy]];
    [confirmview show];
}

+ (void)setTextFieldErrorCss:(UITextField*)txtField isError:(BOOL)error
{
    if(error)
    {
        txtField.layer.masksToBounds = YES;
        txtField.layer.borderWidth = 2.0;
        txtField.layer.cornerRadius = 5.0;
        txtField.clipsToBounds = YES;
        txtField.layer.borderColor=[[UIColor redColor] CGColor];
    }
    else
    {
        txtField.layer.borderWidth=0;
    }
}
+ (BOOL)validateTextFieldErrorCss:(UITextField*)txtField
{
    if(txtField.text.length==0){
        [self setTextFieldErrorCss:txtField isError: YES];
        return NO;
    }
    else
    {
        [self setTextFieldErrorCss:txtField isError:NO];
        return YES;
    }
}

+(BOOL) alternateTextField:(NSArray *)views
{
    BOOL hasEmptyFieldFill=NO;
    BOOL hasSetFirstResponse=NO;
    for(UIView *view in [views sortedArrayUsingComparator:^(id obj1,id obj2){
        return ((UIView*)obj1).tag>((UIView*)obj2).tag;
    }])
    {       
        if([view isMemberOfClass:[UITextField class]])
        {            
            UITextField *field=(id)view;
            if(field!=nil && field.text.length==0)
            {
                hasEmptyFieldFill=YES;
                if(!hasSetFirstResponse&&[field canBecomeFirstResponder])
                {
                    hasSetFirstResponse=YES;
                    [field becomeFirstResponder];
                }               
            }            
        }
    }
    return hasEmptyFieldFill;
}
+(void) resignResponser:(NSArray *)views
{
    for(UIView *view in views)
    {
        if([view isFirstResponder])
        {
            [view resignFirstResponder];
            break;
        }
    }
}
+(BOOL) validateTextFields:(NSArray *)views
{
    BOOL success=YES;
    for(UIView *view in views)
    {
        if([view isMemberOfClass:[UITextField class]])
        {            
            UITextField *field=(id)view;
            if(field!=nil &&![field isHidden])
            {
                success=[UIHelper validateTextFieldErrorCss:field] && success;                          
            }            
        }
    }
    return success;
}

+ (UIView *)findFirstResponder:(UIView *)parentView
{
    if (parentView.isFirstResponder) {        
        return parentView;     
    }
    
    for (UIView *subView in parentView.subviews) {
        UIView *firstResponder = [UIHelper findFirstResponder:subView];
        
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}

+ (void) setColorOfButtons:(NSArray*)buttons red:(float)red green:(float)green blue:(float)blue alpha:(float)alpha {
    
    if (buttons.count == 0) {
        return;
    }
    
    // get the first button
    NSEnumerator* buttonEnum = [buttons objectEnumerator];
    UIButton* button = (UIButton*)[buttonEnum nextObject];
    
    // set the button's highlight color
    [button setTintColor:[UIColor colorWithRed:red/255.9999f green:green/255.9999f blue:blue/255.9999f alpha:alpha]];
    
    // clear any existing background image
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    
    // place the button into highlighted state with no title
    BOOL wasHighlighted = button.highlighted;
    NSString* savedTitle = [button titleForState:UIControlStateNormal];
    [button setTitle:nil forState:UIControlStateNormal];
    [button setHighlighted:YES];
    
    // render the highlighted state of the button into an image
    UIGraphicsBeginImageContext(button.layer.frame.size);
    CGContextRef graphicsContext = UIGraphicsGetCurrentContext();
    [button.layer renderInContext:graphicsContext];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIImage* stretchableImage = [image stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    UIGraphicsEndImageContext();
    
    // restore the button's state and title
    [button setHighlighted:wasHighlighted];
    [button setTitle:savedTitle forState:UIControlStateNormal];
    
    // set background image of all buttons
    do {
        [button setBackgroundImage:stretchableImage forState:UIControlStateNormal];
    } while (button = (UIButton*)[buttonEnum  nextObject]);    
}
@end
