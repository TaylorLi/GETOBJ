//
//  PEDImportDataViewController.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"

@interface PEDImportDataViewController : UIViewController<BTSmartSensorDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *imgCustomer;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *imgSchDeviceIndicator;
@property (strong, nonatomic) IBOutlet UITableView *tbViewPeripheralList;
@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralArray;
@property (strong, nonatomic) CBCharacteristic   *transferCharacteristic;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) IBOutlet UIButton *btnSchPeripheral;


- (void)scanBTSmartShields;
-(void)beginReadDataFromPeripheral:(CBPeripheral *)peripheral;
- (IBAction)backToPreviousTabView:(id)sender;
- (IBAction)clickToReloadPeripheral:(id)sender;
-(void)searchPeripheralTimeout;

- (void)cleanup;

@end
