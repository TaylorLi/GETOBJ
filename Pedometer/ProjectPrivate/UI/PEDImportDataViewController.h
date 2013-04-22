//
//  PEDImportDataViewController.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"

@class PEDImportDataDetailController;
@class UILoadingBox;

@interface PEDImportDataViewController : UIViewController<BTSmartSensorDelegate,UITableViewDataSource>
{
    UILoadingBox *loadingBox;
}
@property (strong, nonatomic) IBOutlet UIButton *imgCustomer;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *imgSchDeviceIndicator;
@property (strong, nonatomic) IBOutlet UITableView *tbViewPeripheralList;
@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralArray;
@property (strong, nonatomic) CBCharacteristic   *transferCharacteristic;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) IBOutlet UIButton *btnSchPeripheral;
@property (strong, nonatomic) IBOutlet UILabel *lblTopTip;
@property (strong, nonatomic) IBOutlet UILabel *lblConnectDeviceName;
@property (strong, nonatomic) IBOutlet UILabel *lblConnectDeviceUUID;
@property (strong, nonatomic) IBOutlet UIButton *btnReSelectDevice;
@property (strong, nonatomic) IBOutlet UIButton *btnClearData;
@property (strong, nonatomic) IBOutlet UILabel *lblConnectDeviceNameTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblConnectDeviceUUIDTitle;
//只需找特定的UUID
@property (nonatomic,strong) NSString *onlyPeripheralUUID;

@property ( nonatomic) BOOL isDebugMode;

-(void)showLoading:(BOOL)show;
- (void)scanBTSmartShields;
- (IBAction)backToPreviousTabView:(id)sender;
- (IBAction)clickToReloadPeripheral:(id)sender;
-(void)searchPeripheralTimeout;

- (void)cleanup;
-(void)restoreFromImportDetailView:(PEDImportDataDetailController *)detailController;

@end
