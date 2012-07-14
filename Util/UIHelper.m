//
//  UIHelper.m
//  Marry
//
//  Created by EagleDu on 12/2/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIHelper.h"

@implementation UIHelper

+(void) showAlert:(NSString*) title message:(NSString*)msg delegate:(id)func{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:func 
                                              cancelButtonTitle:@"确认" 
                                              otherButtonTitles:nil];
    [alertView show];
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
            if(field!=nil &&![field isHidden]&& field.text.length==0)
            {
                success=[UIHelper validateTextFieldErrorCss:field] && success;                          
            }            
        }
    }
    return success;
}
@end
