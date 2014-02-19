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
#import "PEDPedoDataRowView.h"

@class  DialogBoxContainer;

@interface PEDPedoDataViewController : PEDUIBaseViewController<UAModalPanelDelegate,DialogBoxDelegate,AFPickerViewDataSource, AFPickerViewDelegate>
{
    DialogBoxContainer *regPannel;    
    NSArray *daysData;
    int showDataRowsCount;
}

@property (nonatomic,strong) NSDate *referenceDate;
@property (strong, nonatomic) IBOutlet AFPickerView *dayPickerView;
@property (strong,nonatomic) NSMutableArray *showDataRows;

- (IBAction)btnPrevDataClick:(id)sender;
- (IBAction)btnNextDataClick:(id)sender;

- (void) initData;
- (void) initDataByDate:(NSDate *) date;
-(id)initWithRefrenceDate:(NSDate *)refDate;

@end
