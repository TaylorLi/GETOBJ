//
//  PEDAppDelegate.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDAppDelegate.h"
#import "PEDMainViewController.h"
#import "PEDUserViewController.h"
#import "PEDPedoViewController.h"
#import "PEDPedoDataViewController.h"
#import "PEDBarchartViewController.h"
#import "PEDBacktoMainViewController.h"
#import "PEDTargetViewController.h"
#import "PEDGraphsViewController.h"

@implementation PEDAppDelegate

@synthesize window = _window;
@synthesize pedBacktoMainViewController,pedBarchartViewController,pedGraphsViewController,pedMainViewController,pedPedoViewController,pedUserViewController,pedTargetViewController,pedPedoDataViewController;
@synthesize tabBarController;

static PEDAppDelegate* _instance;

+ (PEDAppDelegate*)getInstance {
    return _instance;
}

-(void) swithView:(UIView *) view{
    for (UIView *subView in self.window.subviews) {
        if(subView.superview!=nil){
            [subView removeFromSuperview];
        }
    }
    [self.window insertSubview:view atIndex:0];
}

-(void) showUserView{
    if(!pedUserViewController){
        pedUserViewController = [[PEDUserViewController alloc]init];
    }
    [self swithView : pedUserViewController.view];
}

-(void) showMainView{
    if(!pedMainViewController){
        pedMainViewController = [[PEDMainViewController alloc]init];
    }
    [self swithView : pedMainViewController.view];
}

-(void) showTabView{
    if(!tabBarController){
        tabBarController = [[UITabBarController alloc]init];
        pedBacktoMainViewController = [[PEDBacktoMainViewController alloc]init];
        pedPedoDataViewController = [[PEDPedoDataViewController alloc]init];
        pedTargetViewController = [[PEDTargetViewController alloc]init];
        pedGraphsViewController = [[PEDGraphsViewController alloc]init];
        pedBarchartViewController = [[PEDBarchartViewController alloc]init];
        UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:pedPedoDataViewController];
        
        tabBarController.viewControllers = [[NSArray alloc]initWithObjects:pedBacktoMainViewController,
        nav1,pedTargetViewController,pedBarchartViewController,pedGraphsViewController, nil];
    }
    tabBarController.selectedIndex = 1;
    [self swithView : tabBarController.view];
}

//-(void) applicationDidFinishLaunching:(UIApplication *)application{
//
//    _instance = self;
//    
//    // Override point for customization after app launch
//    [self.window addSubview:pedMainViewController.view];   
//    [self.window makeKeyAndVisible];
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
//    v.backgroundColor = [UIColor whiteColor];
//    [self.window addSubview:v];
    
    _instance = self;
    pedMainViewController = [[PEDMainViewController alloc]init];
    [self.window addSubview:pedMainViewController.view];   
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
