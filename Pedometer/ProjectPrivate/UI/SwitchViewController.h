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
    PEDUIBaseViewController *sleepViewController;
    PEDUIBaseViewController *pedoViewController;
}
@property (retain, nonatomic) PEDUIBaseViewController *sleepViewController;
@property (retain, nonatomic) PEDUIBaseViewController *pedoViewController;

- (IBAction)switchViews:(BOOL)showPedoView;
-(id) initWithPedoViewController:(PEDUIBaseViewController *)pedoController sleepViewController:(PEDUIBaseViewController *)sleepConbroller;
@end
