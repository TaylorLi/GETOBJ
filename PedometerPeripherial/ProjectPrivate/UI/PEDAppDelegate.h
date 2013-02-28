//
//  PEDAppDelegate.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PEDAvailPerialViewController;

@interface PEDAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) IBOutlet PEDAvailPerialViewController *pedAvailPerialViewController;

+ (PEDAppDelegate*)getInstance;
@end
