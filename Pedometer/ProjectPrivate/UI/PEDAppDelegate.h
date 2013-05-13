//
//  PEDAppDelegate.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PEDMainViewController,PEDBarchartViewController,PEDBacktoMainViewController,PEDPedoDataViewController,PEDPedoViewController,PEDTargetViewController,PEDUserSettingViewController,PEDGraphsViewController, CustomerTabBarController,PEDImportDataViewController,PEDAvailPerialViewController,
PEDPedoData4SleepViewController,PEDPedo4SleepViewController,PEDBarchart4SleepViewController,PEDGraphs4SleepViewController;

@interface PEDAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet PEDMainViewController *pedMainViewController;
@property (strong, nonatomic) PEDBarchartViewController *pedBarchartViewController;
@property (strong, nonatomic) PEDBacktoMainViewController *pedBacktoMainViewController;
@property (strong, nonatomic) PEDPedoDataViewController *pedPedoDataViewController;
@property (strong, nonatomic) PEDPedoViewController *pedPedoViewController;
@property (strong, nonatomic) PEDTargetViewController *pedTargetViewController;
@property (strong, nonatomic) PEDUserSettingViewController *pedUserSettingViewController;
@property (strong, nonatomic) PEDGraphsViewController *pedGraphsViewController;
@property (strong, nonatomic) CustomerTabBarController *customerTabBarController;
@property (strong,nonatomic) PEDImportDataViewController *pedImportDataViewController;
@property (strong,nonatomic) PEDAvailPerialViewController *pedAvailPerialViewController;
@property (strong,nonatomic) UINavigationController *importDataViewController;

@property (strong, nonatomic) PEDTargetViewController *sleepTargetViewController;
@property (strong, nonatomic) PEDBarchart4SleepViewController *sleepBarchatViewController;
@property (strong, nonatomic) PEDPedo4SleepViewController *sleepPedoViewController;
@property (strong, nonatomic) PEDPedoData4SleepViewController *sleepPedoDataViewController;
@property (strong, nonatomic) PEDGraphs4SleepViewController *sleepGraphsViewController;

+ (PEDAppDelegate*)getInstance;
-(void) showUserSettingView;
-(void) showMainView;
-(void) showTabView;
-(void) setCustomerTabBarControllerBackground: (UIImage *) bgImage;
-(void)showImportDataView;
-(void)hideImportDataViewAndShowTabView:(NSDate *)currentDate;
-(void)restoreControllerData:(NSDate *)currentDate;
@end
