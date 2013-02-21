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
//Device Information
#define SERIAL_PERIPHERAL_SERVICE_UUID @"5830180a-a6cf-46bc-812f-dfc71d70109b"

//Pipe (1)
//Serial Number String
#define SERIAL_PERIPHERAL_CHARACTERISTIC_SN_STRING_UUID @"58302a25-a6cf-46bc-812f-dfc71d70109b"

//Pipe (2)
//Manufacturer Name String
#define SERIAL_PERIPHERAL_CHARACTERISTIC_MANUFACTURER_NAME_STRING_UUID @"58302a29-a6cf-46bc-812f-dfc71d70109b"

//Pipe (3)
//System ID
#define SERIAL_PERIPHERAL_CHARACTERISTIC_SYSTEM_ID_STRING_UUID @"58302a23-a6cf-46bc-812f-dfc71d70109b"

//Pipe (4)
//Firmware Revision String
#define SERIAL_PERIPHERAL_CHARACTERISTIC_FIRMWARE_REVISION_STRING_UUID @"58302a26-a6cf-46bc-812f-dfc71d70109b"
//Pedometer
//#define SERIAL_PERIPHERAL_CHARACTERISTIC_SN_STRING_UUID @"5830 180d -a6cf-46bc-812f-dfc71d70109b"

//Pipe (5)
//SLEEP DATA Receive
#define SERIAL_PERIPHERAL_CHARACTERISTIC_SLEEP_DATA_UUID @"58302a37-a6cf-46bc-812f-dfc71d70109b"
//Pipe (6)
//Pedometer Data Receive
#define SERIAL_PERIPHERAL_CHARACTERISTIC_PEDOMETER_DATA_UUID @"58302a4a-a6cf-46bc-812f-dfc71d70109b"

#endif
