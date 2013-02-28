//
//  PEDSecondViewController.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"
#import "V8HorizontalPickerViewProtocol.h"
#import "UAModalPanel.h"
#import "DialogBoxContainer.h"
#import "PEDUIBaseViewController.h"

@class  DialogBoxContainer;

@interface PEDPedoDataViewController : PEDUIBaseViewController<UAModalPanelDelegate,DialogBoxDelegate>
{
    DialogBoxContainer *regPannel;
}



//<V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>{
//    NSMutableArray *monthArray;
//}
//@property (strong, nonatomic) IBOutlet V8HorizontalPickerView *monthSelectView;
- (IBAction)showMonthView:(id)sender;


- (void) initData;

@end
