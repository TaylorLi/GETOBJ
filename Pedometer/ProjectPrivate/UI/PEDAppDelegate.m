//
//  PEDAppDelegate.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDAppDelegate.h"
#import "PEDDatabase.h"
#import "PEDUserInfo.h"
#import "BO_PEDUserInfo.h"
#import "PEDPedometerData.h"
#import "BO_PEDPedometerData.h"
#import "PEDMainViewController.h"
#import "PEDUserSettingViewController.h"
#import "PEDPedoViewController.h"
#import "PEDPedoDataViewController.h"
#import "PEDBarchartViewController.h"
#import "PEDBacktoMainViewController.h"
#import "PEDTargetViewController.h"
#import "PEDGraphsViewController.h"
#import "CustomerTabBarController.h"
#import "PEDImportDataViewController.h"
#import "UncaughtExceptionHandler.h"
#import "SwitchViewController.h"
#import "PEDPedo4SleepViewController.h"
#import "PEDPedoData4SleepViewController.h"
#import "PEDBarchart4SleepViewController.h"
#import "PEDGraphs4SleepViewController.h"

@implementation PEDAppDelegate

@synthesize window = _window;
@synthesize pedBacktoMainViewController,pedBarchartViewController,pedGraphsViewController,pedMainViewController,pedPedoViewController,pedUserSettingViewController,pedTargetViewController,pedPedoDataViewController,pedImportDataViewController,pedAvailPerialViewController,importDataViewController;

@synthesize sleepTargetViewController,sleepPedoViewController,sleepGraphsViewController,sleepBarchatViewController,sleepPedoDataViewController;

@synthesize customerTabBarController,sleepCustomerTabBarController,isShowSleepTab;

static PEDAppDelegate* _instance;

+ (PEDAppDelegate*)getInstance {
    return _instance;
}

-(void) setCustomerTabBarControllerBackground: (UIImage *) bgImage{
    if(isShowSleepTab){
        if(sleepCustomerTabBarController){
            UIImageView *tabBarBgView = (UIImageView*)[sleepCustomerTabBarController.view.subviews objectAtIndex:0];
            tabBarBgView.image = bgImage;
        }
    }else{
        if(customerTabBarController){
            UIImageView *tabBarBgView = (UIImageView*)[customerTabBarController.view.subviews objectAtIndex:0];
            tabBarBgView.image = bgImage;
        }
    }
}

-(void) swithView:(UIView *) view{
    for (UIView *subView in self.window.subviews) {
        if(subView.superview!=nil){
            [subView removeFromSuperview];
        }
    }
    [self.window insertSubview:view atIndex:0];
}

-(void) showUserSettingView{
    if(!pedUserSettingViewController){
        pedUserSettingViewController = [[PEDUserSettingViewController alloc]init];
    }
    [self swithView : pedUserSettingViewController.view];
}

-(void) showMainView{
    @try {        
        if(!pedMainViewController){
            pedMainViewController = [[PEDMainViewController alloc]init];
        }
        if([AppConfig getInstance].settings.plusType != PLUS_NONE){
            [pedMainViewController.btnFitPlus setBackgroundImage:[UIImage imageNamed:@"front_button_normal.png"] forState:UIControlStateNormal];
            [pedMainViewController.btnHealthPlus setBackgroundImage:[UIImage imageNamed:@"front_button_normal.png"] forState:UIControlStateNormal];
            [pedMainViewController.btnSportPlus setBackgroundImage:[UIImage imageNamed:@"front_button_normal.png"] forState:UIControlStateNormal];
            switch ([AppConfig getInstance].settings.plusType) {
                case PLUS_FIT:
                    [pedMainViewController.btnFitPlus setBackgroundImage:[UIImage imageNamed:@"front_button_highlight.png"] forState:UIControlStateNormal];
                    break;
                case PLUS_HEALTH:
                    [pedMainViewController.btnHealthPlus setBackgroundImage:[UIImage imageNamed:@"front_button_highlight.png"] forState:UIControlStateNormal];
                    break;
                case PLUS_SPORT:
                    [pedMainViewController.btnSportPlus setBackgroundImage:[UIImage imageNamed:@"front_button_highlight.png"] forState:UIControlStateNormal];
                    break; 
                default:
                    break;
            }
        }
        [self swithView : pedMainViewController.view];
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
}

-(void)showImportDataView{
    @try{
        if(pedImportDataViewController){
            [pedImportDataViewController cleanup];
        }
        pedImportDataViewController =[[PEDImportDataViewController alloc] init];
        importDataViewController=[[UINavigationController alloc] initWithRootViewController:pedImportDataViewController];
        importDataViewController.title=@"Sync Device";
        [self swithView:importDataViewController.view];
        
        //pedAvailPerialViewController = [[PEDAvailPerialViewController alloc] init];
        //[self swithView:pedAvailPerialViewController.view];
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
}

-(void)hideImportDataViewAndShowTabView:(NSDate *)currentDate
{
    [self restoreControllerData:currentDate];
    importDataViewController = nil;
    pedImportDataViewController = nil;
    [self showTabView];
}

-(void) showTabView{
    @try {        
        
        if(!customerTabBarController || !sleepCustomerTabBarController){
            NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
            [imgDic setObject:[UIImage imageNamed:@"back_normal.png"] forKey:@"Default"];
            [imgDic setObject:[UIImage imageNamed:@"back_normal.png"] forKey:@"Highlighted"];
            [imgDic setObject:[UIImage imageNamed:@"back_normal.png"] forKey:@"Seleted"];
            NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
            [imgDic2 setObject:[UIImage imageNamed:@"pedo_normal.png"] forKey:@"Default"];
            [imgDic2 setObject:[UIImage imageNamed:@"pedo_highlight.png"] forKey:@"Highlighted"];
            [imgDic2 setObject:[UIImage imageNamed:@"pedo_highlight.png"] forKey:@"Seleted"];
            NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
            [imgDic3 setObject:[UIImage imageNamed:@"target_normal.png"] forKey:@"Default"];
            [imgDic3 setObject:[UIImage imageNamed:@"target_highlight.png"] forKey:@"Highlighted"];
            [imgDic3 setObject:[UIImage imageNamed:@"target_highlight.png"] forKey:@"Seleted"];
            NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
            [imgDic4 setObject:[UIImage imageNamed:@"bar_normal.png"] forKey:@"Default"];
            [imgDic4 setObject:[UIImage imageNamed:@"bar_highlight.png"] forKey:@"Highlighted"];
            [imgDic4 setObject:[UIImage imageNamed:@"bar_highlight.png"] forKey:@"Seleted"];
            NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
            [imgDic5 setObject:[UIImage imageNamed:@"graphic_normal.png"] forKey:@"Default"];
            [imgDic5 setObject:[UIImage imageNamed:@"graphic_highlight.png"] forKey:@"Highlighted"];
            [imgDic5 setObject:[UIImage imageNamed:@"graphic_highlight.png"] forKey:@"Seleted"];
            
            //        UIImageView *tabBarBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 320, 460)];
            //        tabBarBg.image = [UIImage imageNamed:@"pedo_bg.png"];
            //        tabBarController = [[UITabBarController alloc]init];
            //        [tabBarController.view insertSubview:tabBarBg atIndex:0];
            //        tabBarController.tabBar.frame = CGRectMake(0, self.window.frame.size.height-36, 320, 36);
            //        // [tabBarController.tabBar setBounds:CGRectMake(0, self.window.frame.size.height-36, 320, 36)];
            //        tabBarController.tabBar.backgroundColor = [UIColor clearColor];
            //        tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"footer.png"];
            if(!pedBacktoMainViewController)
                pedBacktoMainViewController = [[PEDBacktoMainViewController alloc]init];
            if(!customerTabBarController){
                pedPedoViewController = [[PEDPedoViewController alloc]init];        
                //pedPedoDataViewController = [[PEDPedoDataViewController alloc]init];
                pedTargetViewController = [[PEDTargetViewController alloc]init];           
                pedGraphsViewController = [[PEDGraphsViewController alloc]init];                        
                pedBarchartViewController = [[PEDBarchartViewController alloc]init];
                UINavigationController *navPedo = [[UINavigationController alloc] initWithRootViewController:pedPedoViewController];
                navPedo.navigationBarHidden=YES;
                NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic2,imgDic3,imgDic4, imgDic5,nil];
                customerTabBarController = [[CustomerTabBarController alloc] initWithViewControllers:[[NSArray alloc]initWithObjects:pedBacktoMainViewController,navPedo,pedTargetViewController,pedBarchartViewController,pedGraphsViewController, nil] imageArray:imgArr frames:CGRectMake(0, 0, 320, 480)];
                
                UIImageView *tabBarBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
                tabBarBg.image = [UIImage imageNamed:@"pedo_bg.png"];
                tabBarBg.backgroundColor = [UIColor clearColor];
                [customerTabBarController.view insertSubview:tabBarBg atIndex:0];
                [customerTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"footer.png"]];
                customerTabBarController.selectedIndex = 1;
            }
            
            if(!sleepCustomerTabBarController){
                sleepGraphsViewController=[[PEDGraphs4SleepViewController alloc] init];
                sleepPedoViewController=[[PEDPedo4SleepViewController alloc] init];   
                sleepBarchatViewController=[[PEDBarchart4SleepViewController alloc] init];            
                UINavigationController *navSleep = [[UINavigationController alloc] initWithRootViewController:sleepPedoViewController];
                navSleep.navigationBarHidden=YES;
                 NSArray *imgArr = [NSArray arrayWithObjects:imgDic,imgDic2,imgDic4, imgDic5,nil];
                sleepCustomerTabBarController = [[CustomerTabBarController alloc] initWithViewControllers:[[NSArray alloc]initWithObjects:pedBacktoMainViewController,navSleep,sleepBarchatViewController,sleepGraphsViewController, nil] imageArray:imgArr frames:CGRectMake(0, 0, 320, 480)];
                
                UIImageView *tabBarBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
                tabBarBg.image = [UIImage imageNamed:@"pedo_bg.png"];
                tabBarBg.backgroundColor = [UIColor clearColor];
                [sleepCustomerTabBarController.view insertSubview:tabBarBg atIndex:0];
                [sleepCustomerTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"footer.png"]];
                sleepCustomerTabBarController.selectedIndex = 1;
            }
            //        tabBarController.viewControllers = [[NSArray alloc]initWithObjects:pedBacktoMainViewController,
            //        nav1,pedTargetViewController,pedBarchartViewController,pedGraphsViewController, nil];
            
            
            //[customerTabBarController setTabBarTransparent:YES];
            
        }
        //    tabBarController.selectedIndex = 1;
        if(isShowSleepTab)
        {         
            sleepCustomerTabBarController.selectedIndex = sleepCustomerTabBarController.preSelectedIndex==0?1:sleepCustomerTabBarController.preSelectedIndex;
            [self swithView : sleepCustomerTabBarController.view];
        }
        else{           
            customerTabBarController.selectedIndex=customerTabBarController.preSelectedIndex==0?1:customerTabBarController.preSelectedIndex;
            [self swithView : customerTabBarController.view];
        }
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
}

//-(void) applicationDidFinishLaunching:(UIApplication *)application{
//
//    _instance = self;
//    
//    // Override point for customization after app launch
//    [self.window addSubview:pedMainViewController.view];   
//    [self.window makeKeyAndVisible];
//}

-(void)restoreControllerData:(NSDate *)currentDate{
    @try {        
        if(pedPedoViewController){
            [pedPedoViewController initDataByDate:currentDate];
        }
        if(pedTargetViewController){
            [pedTargetViewController initData];
        }        
        if(pedBarchartViewController){
            [pedBarchartViewController initDataByDate:currentDate];
        }
        if(pedGraphsViewController){
            [pedGraphsViewController initDataByDate:currentDate];
        }
        if(pedPedoDataViewController){
            [pedPedoDataViewController initDataByDate:currentDate];
        }
        if(sleepTargetViewController){
            [sleepTargetViewController initData];
        }
        if(sleepPedoViewController){
            [sleepPedoViewController initDataByDate:currentDate];
        }
        if(sleepPedoDataViewController){
            [sleepPedoDataViewController initDataByDate:currentDate];
        }
        if(sleepGraphsViewController){
            [sleepGraphsViewController initDataByDate:currentDate];
        }
        if(sleepBarchatViewController){
            [sleepBarchatViewController initDataByDate:currentDate];
        }
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    isShowSleepTab = NO;
    @try {
        [LogHelper setInitialLoggerByConfigFile:@"log4cocoa.properties"];
        //    self.window.frame = CGRectMake(0, 20, 320, 460);
        [[PEDDatabase getInstance] setupServerDatabase];
        [AppConfig getInstance];    
        _instance = self;
        pedMainViewController = [[PEDMainViewController alloc] initWithNibName:@"PEDMainViewController" bundle:nil];
        //[self.window addSubview:pedMainViewController.view];
        self.window.rootViewController = pedMainViewController;
        [self.window makeKeyAndVisible];
        // Override point for customization after application launch.        
        [self performSelector:@selector(installUncaughtExceptionHandler) withObject:nil afterDelay:0];
        //[self performSelector:@selector(string) withObject:nil afterDelay:4.0];
        return YES;
    }
    @catch (NSException *exception) {
        [LogHelper error:@"error occured" exception:exception];
    }
    @finally {
        
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //	if ([viewController isKindOfClass:[SecondViewController class]])
    //	{
    //        [CustomerTabBarController hidesTabBar:NO animated:YES]; 
    //	}
    
    if (viewController.hidesBottomBarWhenPushed)
    {
        [customerTabBarController hidesTabBar:YES animated:YES]; 
    }
    else
    {
        [customerTabBarController hidesTabBar:NO animated:YES]; 
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [[AppConfig getInstance] saveAppConfig];
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
    [[AppConfig getInstance] restoreAppConfig];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)installUncaughtExceptionHandler
{
	InstallUncaughtExceptionHandler();
}

@end
