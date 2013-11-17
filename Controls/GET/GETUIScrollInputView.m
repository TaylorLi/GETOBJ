//
//  GETUIScrollInputView.m
//  Pedometer
//
//  Created by JILI Du on 13/2/28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "GETUIScrollInputView.h"
#import "UIHelper.h"

@implementation GETUIScrollInputView

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self bindControlEventForScroll];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark – 
#pragma mark Scorll for keyboard

- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;                
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];                
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;                
    float height = self.view.frame.size.height;        
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);                
        self.view.frame = rect;        
    }        
    [UIView commitAnimations];   
    /*
    float height= textField.center.y> self.view.frame.size.height/2-textField.frame.size.height*3?(self.view.frame.size.height/2-textField.frame.size.height*3): self.view.frame.size.height/2;
    [self setCenterPoint:height];
     */
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
    [self setCenterPoint:0];
    /*
    if(![UIHelper alternateTextField:self.view.subviews])
    {
        [self setCenterPoint:0];
    }
    */
    return YES;
}

-(void) setCenterPoint:(CGFloat) y
{
    y=y==0?(self.view.frame.size.height + 40)/2:y;
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
    scrollView.showsVerticalScrollIndicator = NO;
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
