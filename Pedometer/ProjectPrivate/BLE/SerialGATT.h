//
//  SerialGATT.h
//  SerialGATT
//
//  Created by BTSmartShield on 6/29/12.
//  Copyright (c) 2012 BTSmartShield.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@protocol BTSmartSensorDelegate

@optional
- (void) peripheralFound:(CBPeripheral *)peripheral;
- (void) serialGATTCharValueUpdated: (NSString *)UUID value: (NSData *)data;
-(void) sensorReady;
-(void) searchPeripheralTimeout;
@end

@interface SerialGATT : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate> {
    
}

@property (nonatomic, assign) id <BTSmartSensorDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *peripherals;
@property (strong, nonatomic) CBCentralManager *manager;
@property (strong, nonatomic) CBPeripheral *activePeripheral;
@property (strong, nonatomic) CBService *serialHeartRateService; // for SERIAL_PERIPHERAL_HEART_RATE_SERVICE_UUID
@property (strong, nonatomic) CBCharacteristic *dataSettingWriteCharacteristic; // for SERIAL_PERIPHERAL_CHARACTERISTIC_PEDOMETER_SETTING_UUID
@property (strong, nonatomic) CBCharacteristic *dataNotifyCharacteristic; // for SERIAL_PERIPHERAL_CHARACTERISTIC_SLEEP_PEDO_DATA_UUID

@property (strong, nonatomic) CBUUID *characteristicWriteUUID;
@property (strong, nonatomic) CBUUID *characteristicNotifyUUID;
@property (strong,nonatomic) CBUUID *serviceHeartRateDataUUID;

#pragma mark - Methods for controlling the Bluetooth Smart Sensor
-(void) setup; //controller setup

-(int) findBTSmartPeripherals:(int)timeout;
-(void) scanTimer: (NSTimer *)timer;

-(void) connect: (CBPeripheral *)peripheral;
-(void) disconnect: (CBPeripheral *)peripheral;

-(void) write:(CBPeripheral *)peripheral data:(NSData *)data;
-(void) read:(CBPeripheral *)peripheral;
-(void) notify:(CBPeripheral *)peripheral on:(BOOL)on;

-(CBService *) findServiceFromUUID: (CBUUID *)UUID p:(CBPeripheral *)peripheral;
-(CBCharacteristic *) findCharacteristicFromUUID: (CBUUID *)UUID p:(CBPeripheral *)peripheral service: (CBService *)service;



@end
