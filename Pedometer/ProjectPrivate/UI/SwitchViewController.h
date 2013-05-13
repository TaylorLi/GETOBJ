//
//  SwitchViewController.h
//  View Switcher
//
//  Created by Dave Mark on 12/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PEDUIBaseViewController;

@interface SwitchViewController : UIViewController {
    UIViewController *sleepViewController;
    UIViewController *pedoViewController;
}
@property (retain, nonatomic) UIViewController *sleepViewController;
@property (retain, nonatomic) UIViewController *pedoViewController;

- (IBAction)switchViews:(BOOL)showPedoView;
-(id) initWithPedoViewController:(UIViewController *)pedoController sleepViewController:(UIViewController *)sleepConbroller;
@end
