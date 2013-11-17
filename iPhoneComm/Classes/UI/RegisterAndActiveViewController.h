//
//  RegisterAndActiveViewController.h
//  TKD Score
//
//  Created by Eagle Du on 13/1/2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "UATitledModalPanel.h"
#import "UIHelper.h"

#define kFormResultTypeSuccess 1
#define kFormResultTypeCancel 2

@interface RegisterAndActiveViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>
{
    ASIHTTPRequest *request;
}
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPwd;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UITextField *txtProductSN;
@property (nonatomic,unsafe_unretained) NSObject<FormBoxDelegate> *delegate;
- (IBAction)doneRegister:(id)sender;
- (IBAction)cancelRegister:(id)sender;
#pragma mark – 
#pragma mark Scorll for keyboard
-(void) setCenterPoint:(CGFloat) y;
-(void)bindControlEventForScroll;
@end
