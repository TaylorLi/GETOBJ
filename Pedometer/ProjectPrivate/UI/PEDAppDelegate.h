//
//  PEDAppDelegate.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PEDMainViewController,PEDBarchartViewController,PEDBacktoMainViewController,PEDPedoDataViewController,PEDPedoViewController,PEDTargetViewController,PEDUserSettingViewController,PEDGraphsViewController, CustomerTabBarController;

@interface PEDAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PEDMainViewController *pedMainViewController;
@property (strong, nonatomic) PEDBarchartViewController *pedBarchartViewController;
@property (strong, nonatomic) PEDBacktoMainViewController *pedBacktoMainViewController;
@property (strong, nonatomic) PEDPedoDataViewController *pedPedoDataViewController;
@property (strong, nonatomic) PEDPedoViewController *pedPedoViewController;
@property (strong, nonatomic) PEDTargetViewController *pedTargetViewController;
@property (strong, nonatomic) PEDUserSettingViewController *pedUserSettingViewController;
@property (strong, nonatomic) PEDGraphsViewController *pedGraphsViewController;
@property (strong, nonatomic) CustomerTabBarController *customerTabBarController;
+ (PEDAppDelegate*)getInstance;
-(void) showUserSettingView;
-(void) showMainView;
-(void) showTabView;
-(void) setCustomerTabBarControllerBackground: (UIImage *) bgImage;
@end
