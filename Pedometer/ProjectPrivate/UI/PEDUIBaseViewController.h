//
//  PEDUIBaseViewController.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/25.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"
#import "V8HorizontalPickerViewProtocol.h"
@class SwitchViewController;

#define month_font_size 8.0f

@interface PEDUIBaseViewController : UIViewController<V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>
{
    NSMutableArray *monthArray;
}

@property (strong, nonatomic) IBOutlet V8HorizontalPickerView *monthSelectView;
@property(assign,nonatomic)SwitchViewController *controlContainer;

-(void) initMonthSelectorWithX:(CGFloat)originX Height:(CGFloat)originY;
- (IBAction)clickToConnectDevice:(id)sender;
- (IBAction)clickToSettingView:(id)sender;
-(void) reloadPickerToMidOfDate:(NSDate *)date;
- (IBAction)swithToPedoView:(id)sender;
-(IBAction)swithToSleepView:(id)sender;
@end
