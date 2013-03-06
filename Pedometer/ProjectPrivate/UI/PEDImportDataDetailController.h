//
//  PEDImportDataDetail.h
//  Pedometer
//
//  Created by JILI Du on 13/2/27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"

#define RSSI_THRESHOLD -60
#define kMaxPacketSize 128

@class CBPeripheral;
@class SerialGATT;
@class PEDImportDataViewController,PEDUserInfo,PEDTarget,BleExchangeDataContainer;

@interface PEDImportDataDetailController : UIViewController<BTSmartSensorDelegate>
{
    NSMutableString *exchangeDebuglog;
}

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) SerialGATT *sensor;

@property (strong, nonatomic) NSMutableArray *rssi_container; // used for contain the indexers of the lower rssi value 
@property (strong,nonatomic) IBOutlet UITextView *txtActInfo;
@property (strong,nonatomic) IBOutlet UIActivityIndicatorView *indActive;
@property (strong,nonatomic) PEDImportDataViewController *parentController;
@property (strong,nonatomic) BleExchangeDataContainer *exchangeContainer;
@property (strong,nonatomic) NSTimer *exchangeTimer;
@property (strong, nonatomic) IBOutlet UITextView *txtExchangeLog;



-(void) serialGATTCharValueUpdated:(NSString *)UUID value:(NSData *)data;

-(void)backToPeriperialList;
-(void)beginExchangeDataWithDevice;

@end
