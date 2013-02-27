//
//  BleDefinition.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/19.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#ifndef Pedometer_BleDefinition_h
#define Pedometer_BleDefinition_h

#pragma mark -
#pragma mark service uuid

#define BLE_OPERATE_TIMEOUT 30
#define BLE_CONNECTION_TIMEOUT 30

#pragma mark -
#pragma mark Service 1:Generic Access(0x1800)
#define SERIAL_PERIPHERAL_GENERIC_ACCESS_SERVICE_UUID @"1800"

//Characteristic 1 :DeviceName Read
#define SERIAL_PERIPHERAL_CHARACTERISTIC_DEVICENAME @"2A00"
//Characteristic 2 :Apperance Read
#define SERIAL_PERIPHERAL_CHARACTERISTIC_APPERANCE @"2A01"
//Characteristic 3 :SlavePreferredConnectionParameters Read
#define SERIAL_PERIPHERAL_CHARACTERISTIC_SLAVE_CONNECTION_PARAMETER @"2A04"

#pragma mark -
#pragma mark Service 2:Device Information
#define SERIAL_PERIPHERAL_DEVICE_SERVICE_UUID @"180A"
//CHARACTERISTIC Pipe (1) Read
//Serial Number String
#define SERIAL_PERIPHERAL_CHARACTERISTIC_SN_STRING_UUID @"58302a25-a6cf-46bc-812f-dfc71d70109b"

//CHARACTERISTIC Pipe (2) Read
//Manufacturer Name String
#define SERIAL_PERIPHERAL_CHARACTERISTIC_MANUFACTURER_NAME_STRING_UUID @"58302a29-a6cf-46bc-812f-dfc71d70109b"

//CHARACTERISTIC Pipe (3) Read
//System ID
#define SERIAL_PERIPHERAL_CHARACTERISTIC_SYSTEM_ID_STRING_UUID @"58302a23-a6cf-46bc-812f-dfc71d70109b"

//CHARACTERISTIC Pipe (4) Read
//Firmware Revision String
#define SERIAL_PERIPHERAL_CHARACTERISTIC_FIRMWARE_REVISION_STRING_UUID @"58302a26-a6cf-46bc-812f-dfc71d70109b"

#pragma mark -
#pragma mark Service 3:Heart Rate

#define SERIAL_PERIPHERAL_HEART_RATE_SERVICE_UUID @"180D"

//Pipe (5)
//SLEEP DATA OR PEDOMETER DATA Receive NOTIFY
#define SERIAL_PERIPHERAL_CHARACTERISTIC_SLEEP_PEDO_DATA_UUID @"58302a37-a6cf-46bc-812f-dfc71d70109b"
//Pipe (6)
//Pedometer Setting Parameter Send To Device  WriteWithoutResponse
#define SERIAL_PERIPHERAL_CHARACTERISTIC_PEDOMETER_SETTING_UUID @"2a4a"


#define DATA_HEADER_PEDO_SETTING_RQ  0x01
#define DATA_HEADER_TEDO_SETTING_RS  0x02
#define DATA_HEADER_TARGER_DATA_RQ  0x82
#define DATA_HEADER_TARGER_DATA_RS 0x03
#define DATA_HEADER_PEDO_DATA_1 0x83
#endif
