//
//  RegisterAndActiveViewController.m
//  TKD Score
//
//  Created by Eagle Du on 13/1/2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "RegisterAndActiveViewController.h"
#import "UILoadingBox.h"
#import "UIHelper.h"
#import "RequestManager.h"
#import "AppConfig.h"
#import "AppSetting.h"

@implementation RegisterAndActiveViewController
@synthesize txtUsername;
@synthesize txtEmail;
@synthesize txtPwd;
@synthesize btnDone;
@synthesize txtProductSN;
@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    txtUsername.text=[AppConfig getInstance].settngs.registerUsername;
    txtEmail.text=[AppConfig getInstance].settngs.registerEmail;
    [self bindControlEventForScroll];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTxtUsername:nil];
    [self setTxtEmail:nil];
    [self setTxtPwd:nil];
    [self setBtnDone:nil];
    [self setTxtProductSN:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return [AppConfig shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}
-(NSUInteger)supportedInterfaceOrientations{
    return [AppConfig supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    return [AppConfig shouldAutorotate];
}

- (IBAction)doneRegister:(id)sender {   
    if(![UIHelper validateTextFields:self.view.subviews])
    {
        return;
    }
    if(![UtilHelper isValidEmail:txtEmail.text])
    {
        [UIHelper showAlert:@"Information" message:@"Invalid email." func:nil];
        [UIHelper setTextFieldErrorCss:txtEmail isError:YES];
        return;
    }
    else
    {
        [UIHelper setTextFieldErrorCss:txtEmail isError:NO];
    }
    UILoadingBox __block *msgBox=[[UILoadingBox alloc] initWithLoading:@"Register processing" showCloseImage:YES onClosed:^{
        if(request!=nil){
            [request cancel];
        }
    }];
    [msgBox showLoading];
   __block NSString *trimProductSN = [txtProductSN.text uppercaseString];
    request = [RequestManager registerAndActiveWithUserName:txtUsername.text andPwd:txtPwd.text andEmail:txtEmail.text andProductSN:trimProductSN funCompleted:^(RequestResult *result) {
        [msgBox hideLoading];
        if(result.success){
            NSString *encyptKey =result.extraData;
            BOOL validKey = [[AppConfig getInstance] testIfProductHasValidateWithSN:trimProductSN encryptSN:encyptKey];
            if(validKey)
            {
                AppSetting *setting=[AppConfig getInstance].settngs;
                setting.enctryProductSN=encyptKey;
                setting.registerEmail=txtEmail.text;
                setting.registerUsername=txtUsername.text;
                setting.productSN=trimProductSN;
                setting.lastProductSNValidateDate=[NSDate date];
                [AppConfig getInstance].hasValidActive=YES;
                [[AppConfig getInstance] saveAppSettingToFile];
                [UIHelper showAlert:@"Register success." message:@"Thank you for registeration.Enjoy your game with [Peripheral Device] now." func:^(AlertView *a, NSInteger i) {
                    if ([delegate respondsToSelector:@selector(actionByView:eventType:eventArgs:)]) {
                        [delegate actionByView:self eventType:kFormResultTypeSuccess eventArgs:nil];
                    } 
                }];
            }
            else{
                [UIHelper showAlert:@"Register failed." message:@"Invalid product key,please retry later." func:^(AlertView *a, NSInteger i) {
                    
                }];
            }
        }    
        else
        {
            [UIHelper showAlert:@"Register failed." message:result.errorMsg func:^(AlertView *a, NSInteger i) {
            }];
        }
    }];  
}
- (IBAction)cancelRegister:(id)sender
{
    if ([delegate respondsToSelector:@selector(actionByView:eventType:eventArgs:)]) {
        [delegate actionByView:self eventType:kFormResultTypeCancel eventArgs:nil];
    } 
}
#pragma mark – 
#pragma mark Scorll for keyboard

- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    float height= textField.center.y> self.view.frame.size.height/2-textField.frame.size.height*3?(self.view.frame.size.height/2-textField.frame.size.height*3): self.view.frame.size.height/2;
    [self setCenterPoint:height];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    //[UIHelper validateTextFieldErrorCss:textField];
    //[self setCenterPoint:0] ;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    if(![UIHelper alternateTextField:self.view.subviews])
    {
        [self setCenterPoint:0];
    }
    return YES;
}

-(void) setCenterPoint:(CGFloat) y
{
    y=y==0?self.view.frame.size.height/2:y;
    NSTimeInterval animationDuration=0.40f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width=self.view.frame.size.width;
    self.view.center=CGPointMake(width/2, y);
    [UIView commitAnimations];
}
-(void)bindControlEventForScroll
{
   UIScrollView *scrollView =  (UIScrollView *)self.view;
    scrollView.contentSize=CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height+5) ;
    scrollView.delegate=self;
    for(UIView *view in self.view.subviews)
    {
        if([view isMemberOfClass:[UITextField class]])
        {
            UITextField *txtBox=(UITextField *)view;
            txtBox.delegate=self;
        }
    }    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    //UITouch *touch = [[event allTouches] anyObject];
    for(UIView *view in self.view.subviews)
    {
        if([view isMemberOfClass:[UITextField class]])
        {
            [view resignFirstResponder];
        }
    }
    [self setCenterPoint:0];
}

#pragma mark – 
#pragma mark UIScrollViewDelegate Methods 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{ 
    for(UIView *view in self.view.subviews)
    {
        if([view isMemberOfClass:[UITextField class]])
        {
            [view resignFirstResponder];
        }
    }
    [self setCenterPoint:0];
} 

@end
