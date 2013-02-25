//
//  PEDAvailPerialViewController.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAModalPanel.h"
#import "DialogBoxContainer.h"
#import "SerialGATT.h"

@interface PEDAvailPerialViewController : UIViewController<BTSmartSensorDelegate,UITableViewDataSource,CBPeripheralManagerDelegate,CBCentralManagerDelegate, CBPeripheralDelegate>
{
    
}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *schActivator;
@property (nonatomic,unsafe_unretained) NSObject<FormBoxDelegate> *delegate;

@property(strong,nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBCentralManager      *centralManager;

@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralArray;
@property (strong, nonatomic) IBOutlet UITableView *btSmartShieldsTableView;
@property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;

- (void)scanBTSmartShields;
- (void)setup;
-(void)beginReadDataFromPeripheral:(CBPeripheral *)peripheral;
- (void)scan;
- (void)cleanup;

@end

