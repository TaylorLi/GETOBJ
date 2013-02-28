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

@interface PEDPedoViewController : UIViewController<V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>{
    NSMutableArray *monthArray;
}
@property (strong, nonatomic) IBOutlet V8HorizontalPickerView *monthSelectView;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrDay;
@property (weak, nonatomic) IBOutlet UILabel *lblStepAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblDistanceUnit;
@property (weak, nonatomic) IBOutlet UILabel *lblCaloriesAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblActivityTime;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeedAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblSpeedUnit;
@property (weak, nonatomic) IBOutlet UILabel *lblPaceAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblPaceUnit;

- (void) initData;
@end
