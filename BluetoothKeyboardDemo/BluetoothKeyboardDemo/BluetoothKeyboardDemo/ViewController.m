//
//  ViewController.m
//  BluetoothKeyboardDemo
//
//  Created by Eagle Du on 12/10/10.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "ViewController.h"
#import "Definition.h"

@implementation ViewController
@synthesize imgCursor;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setImgCursor:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   }

- (void)viewDidAppear:(BOOL)animated
{    
    [super viewDidAppear:animated];
    UIDevice *device = [UIDevice currentDevice];
    
    BOOL backgroundSupported = NO;
    
    if ( [device respondsToSelector:@selector(isMultitaskingSupported)] )
        
    {
        
        backgroundSupported = device.multitaskingSupported;
        
    }
    
    if ( backgroundSupported == YES )
        
    {
        
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        //注意这里，告诉系统已经准备好了
        
        [self becomeFirstResponder];
        
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
	[super viewWillDisappear:animated];    
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)bluetoothKeyboardPressed:(KeyBoradEventInfo *)keyboardArgv
{
    UIImage *imgStyle1=[UIImage imageNamed:@"cursor1.png"];
    UIImage *imgStyle2=[UIImage imageNamed:@"cursor2.png"];
    float moveStep=20;
    switch (keyboardArgv.keyCode) {
        case GSEVENTKEY_KEYCODE_ALP_A:
            imgCursor.image=imgStyle1;
            break;
        case GSEVENTKEY_KEYCODE_ALP_B:
            imgCursor.image=imgStyle2;
            ;
            break;
        case GSEVENTKEY_KEYCODE_ARROW_LEFT:
            if(imgCursor.frame.origin.x-moveStep>0)
                imgCursor.frame=CGRectMake(imgCursor.frame.origin.x-moveStep, imgCursor.frame.origin.y, imgCursor.frame.size.width, imgCursor.frame.size.height);
            break;
        case GSEVENTKEY_KEYCODE_ARROW_RIGHT:
            if(imgCursor.frame.origin.x+moveStep<[UIScreen mainScreen].bounds.size.width)
                imgCursor.frame=CGRectMake(imgCursor.frame.origin.x+moveStep, imgCursor.frame.origin.y, imgCursor.frame.size.width, imgCursor.frame.size.height);
            break;
        case GSEVENTKEY_KEYCODE_ARROW_UP:
            if(imgCursor.frame.origin.y-moveStep>0)
                imgCursor.frame=CGRectMake(imgCursor.frame.origin.x, imgCursor.frame.origin.y-moveStep, imgCursor.frame.size.width, imgCursor.frame.size.height);
            break;
        case GSEVENTKEY_KEYCODE_ARROW_DOWN:
            //NSLog(@"%f,%f",imgCursor.frame.origin.y,[UIScreen mainScreen].bounds.size.height);
            if(imgCursor.frame.origin.y+moveStep<[UIScreen mainScreen].bounds.size.height)
                imgCursor.frame=CGRectMake(imgCursor.frame.origin.x, imgCursor.frame.origin.y+moveStep, imgCursor.frame.size.width, imgCursor.frame.size.height);
            break;
        default:
            break;
    }
}



- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {                   
            case UIEventSubtypeRemoteControlTogglePlayPause:
                NSLog(@"Play Pause Press");               
                break;                
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"Previous Press");
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"Next Press");
                break;
            default:
                break;
                
        }
    }
}


- (BOOL)canBecomeFirstResponder{
    return YES;
}



@end
