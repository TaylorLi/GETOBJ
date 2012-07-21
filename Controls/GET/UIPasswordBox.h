//
//  UILoadingBox.h
//  Marry
//
//  Created by EagleDu on 12/2/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*usage
UILoadingBox *loading=[[UILoadingBox alloc] initWithLoading:@"Loading..." showCloseImage:YES completed:^{[self loginButtonPressed:self];}];
[loading showLoading];
*/
#import <Foundation/Foundation.h>

@interface UIPasswordBox : UIAlertView<UIAlertViewDelegate,UITextFieldDelegate>
{
    UITextField *passwordField;  
    FuncResultBlock completedFunc;
}

-(id) initWithLoading:(NSString *)message onComplete:(FuncResultBlock)completedFunc;
-(void) resetPassword;
@end
