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
#import "AFPickerView.h"

@class  DialogBoxContainer;

@interface PEDPedoDataViewController : PEDUIBaseViewController<UAModalPanelDelegate,DialogBoxDelegate,AFPickerViewDataSource, AFPickerViewDelegate>
{
    DialogBoxContainer *regPannel;    
    NSArray *daysData;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgVDataTop;
//@property (weak, nonatomic) IBOutlet UIImageView *imgVDataMiddle;
//@property (weak, nonatomic) IBOutlet UIImageView *imgVDataBottom;
//@property (weak, nonatomic) IBOutlet UIImageView *imgVBehindTop;
//@property (weak, nonatomic) IBOutlet UIImageView *imgVBehindBottom;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblCalories;
@property (weak, nonatomic) IBOutlet UILabel *lblActivityTime;
@property (weak, nonatomic) IBOutlet UILabel *lblStep;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

@property (weak, nonatomic) IBOutlet UILabel *lblNextDate;
@property (weak, nonatomic) IBOutlet UILabel *lblNextStep;
@property (weak, nonatomic) IBOutlet UILabel *lblNextDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblNextCalories;
@property (weak, nonatomic) IBOutlet UILabel *lblNextActTime;

@property (weak, nonatomic) IBOutlet UILabel *lblCurrDate;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrStep;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrCalories;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrActTime;

@property (weak, nonatomic) IBOutlet UILabel *lblPrevDate;
@property (weak, nonatomic) IBOutlet UILabel *lblPrevStep;
@property (weak, nonatomic) IBOutlet UILabel *lblPrevDistance;
@property (weak, nonatomic) IBOutlet UILabel *lblPrevCalories;
@property (weak, nonatomic) IBOutlet UILabel *lblPrevActTime;
@property (nonatomic,strong) NSDate *referenceDate;
@property (strong, nonatomic) IBOutlet AFPickerView *dayPickerView;


//<V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>{
//    NSMutableArray *monthArray;
//}
//@property (strong, nonatomic) IBOutlet V8HorizontalPickerView *monthSelectView;
- (IBAction)btnPrevDataClick:(id)sender;
- (IBAction)btnNextDataClick:(id)sender;

- (void) initData;
- (void) initDataByDate:(NSDate *) date;

@end
