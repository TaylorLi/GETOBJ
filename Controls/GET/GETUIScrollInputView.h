//
//  GETUIScrollInputView.h
//  Pedometer
//
//  Created by JILI Du on 13/2/28.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GETUIScrollInputView : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>

#pragma mark – 
#pragma mark Scorll for keyboard
-(void) setCenterPoint:(CGFloat) y;
-(void)bindControlEventForScroll;

@end
