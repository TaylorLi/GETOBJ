//
//  UILoadingBox.m
//  Marry
//
//  Created by EagleDu on 12/2/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIPasswordBox.h"

@implementation UIPasswordBox
-(id) initWithLoading:(NSString *)message onComplete:(FuncResultBlock)onCompletedFunc
{
    self = [super initWithTitle:nil
                        message: message
                       delegate: self
              cancelButtonTitle: nil
              otherButtonTitles: nil];    
    
    if (self) {        
        
        passwordField = [[[UITextField alloc] init] autorelease];             
        passwordField.text=@"";      
        passwordField.delegate=self;
        passwordField.borderStyle= UITextBorderStyleRoundedRect;
        passwordField.font=[UIFont fontWithName:@"Helvetica" size:25.0f];
        passwordField.secureTextEntry = YES;
        [self addSubview:passwordField];       
        [passwordField becomeFirstResponder];
        completedFunc=[onCompletedFunc copy];
        [self show];
        passwordField.frame = CGRectMake((self.bounds.size.width-200.0f)/2, 50.0f, 200.0f, 36.0f);
    }
    return self;
}

-(void)dealloc
{
    passwordField=nil;
    completedFunc=nil;
}

-(void) resetPassword
{
    passwordField.text=@"";
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    completedFunc(textField.text);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];    
    return YES;
}
@end
