//
//  SwitchViewController.m
//  View Switcher
//
//  Created by Dave Mark on 12/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SwitchViewController.h"
#import "PEDUIBaseViewController.h"

@implementation SwitchViewController
@synthesize sleepViewController;
@synthesize pedoViewController;

-(id) initWithPedoViewController:(UIViewController *)pedoController sleepViewController:(UIViewController *)sleepConbroller{
    self=[super init];
    if(self)
    {
        pedoViewController=pedoController;
        sleepViewController=sleepConbroller;
        NSArray *viewController=[[NSArray alloc] initWithObjects:pedoViewController,sleepViewController,nil];
        for (UIViewController *control in viewController) {
            
            if([control isKindOfClass:[PEDUIBaseViewController class]]){
                PEDUIBaseViewController *baseController=(PEDUIBaseViewController *)control;
                baseController.controlContainer=self;
            }
            else{
                if([control isKindOfClass:[UINavigationController class]]){
                    UINavigationController *nav=(UINavigationController*)control;
                    for (id subController in nav.viewControllers) {
                        if([subController isKindOfClass:[PEDUIBaseViewController class]]){
                            PEDUIBaseViewController *tabController=(PEDUIBaseViewController *)subController;
                            tabController.controlContainer=self;
                        }
                    }
                }
            }
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [self.view insertSubview:pedoViewController.view atIndex:0];
    [super viewDidLoad];
}

- (IBAction)switchViews:(BOOL)showPedoView
{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	if(showPedoView){
        if (self.pedoViewController.view.superview == nil)
        {
            [UIView setAnimationTransition:
             UIViewAnimationTransitionFlipFromRight
                                   forView:self.view cache:YES];
            
            [sleepViewController viewWillAppear:YES];
            [pedoViewController viewWillDisappear:YES];
            
            [sleepViewController.view removeFromSuperview];
            [self.view insertSubview:pedoViewController.view atIndex:0];
            [pedoViewController viewDidDisappear:YES];
            [sleepViewController viewDidAppear:YES];
        }
    }
    else{
        if (self.sleepViewController.view.superview == nil)
        {
            [UIView setAnimationTransition:
             UIViewAnimationTransitionFlipFromLeft
                                   forView:self.view cache:YES];
            
            [pedoViewController viewWillAppear:YES];
            [sleepViewController viewWillDisappear:YES];
            
            [pedoViewController.view removeFromSuperview];
            [self.view insertSubview:sleepViewController.view atIndex:0];
            [sleepViewController viewDidDisappear:YES];
            [pedoViewController viewDidAppear:YES];
        }
    }
    
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
	if (self.pedoViewController.view.superview == nil)
        self.pedoViewController = nil;
    else
		self.sleepViewController = nil;	
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
