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
#import "PEDUIBaseViewController.h"

@interface PEDPedoViewController : PEDUIBaseViewController<V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>{
    NSMutableArray *monthArray;
}
@property (strong, nonatomic) IBOutlet V8HorizontalPickerView *monthSelectView;
@end
