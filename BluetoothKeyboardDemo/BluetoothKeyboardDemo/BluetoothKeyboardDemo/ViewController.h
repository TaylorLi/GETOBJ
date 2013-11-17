//
//  ViewController.h
//  BluetoothKeyboardDemo
//
//  Created by Eagle Du on 12/10/10.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyBoradEventInfo.h"

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgCursor;

-(void)bluetoothKeyboardPressed:(KeyBoradEventInfo *)keyboardArgv;

@end
