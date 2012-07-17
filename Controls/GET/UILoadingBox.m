//
//  UILoadingBox.m
//  Marry
//
//  Created by EagleDu on 12/2/25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UILoadingBox.h"

@implementation UILoadingBox
-(id) initWithLoading:(NSString *)message showCloseImage:(BOOL) showClose onClosed:(FuncBlock) onCompleted
{
    self = [super initWithTitle:nil
                        message: message
                       delegate: self
              cancelButtonTitle: nil
              otherButtonTitles: nil];    
    
    if (self) {
        
        activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];        
        activityView.frame = CGRectMake(120.f, 48.0f, 36.0f, 36.0f);
        [self addSubview:activityView];  
        if(showClose)
        {
            completedFunc=onCompleted;        
            UIImage *closeImage=[UIImage imageNamed:@"close.png"];
            closeView = [[[UIImageView alloc] initWithImage:closeImage] autorelease];
            closeView.frame = CGRectMake(250.0f, 5.0f, 24.0f, 24.0f);
            [closeView setUserInteractionEnabled:YES];
            [self addSubview:closeView];
        }
    }
    return self;
}
-(void) showLoading{
    [activityView startAnimating];
    [self show];
}
-(void) hideLoading{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [[event allTouches] anyObject];
    if([touch view]==closeView){
        [self dismissWithClickedButtonIndex:0 animated:YES];
        if(completedFunc!=NULL)
            completedFunc(); 
    }
}
-(void)dealloc
{
    activityView=nil;
    closeView=nil;
}
@end
