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
#define BLE_DISCOVER_TIMEOUT 30
#define BLE_CONNECTION_TIMEOUT 5
#define BLE_DATA_TRANSFER_TIMEOUT 5

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
#define SERIAL_PERIPHERAL_DEVICE_SERVICE_UUID @"5830180A-A6CF-46BC-812F-DFC71D70109B"
//CHARACTERISTIC Pipe (1) Read
//Serial Number String
#define SERIAL_PERIPHERAL_CHARACTERISTIC_SN_STRING_UUID @"58302A25-A6CF-46BC-812F-DFC71D70109B"

//CHARACTERISTIC Pipe (2) Read
//Manufacturer Name String
#define SERIAL_PERIPHERAL_CHARACTERISTIC_MANUFACTURER_NAME_STRING_UUID @"58302A29-A6CF-46BC-812F-DFC71D70109B"

//CHARACTERISTIC Pipe (3) Read
//System ID
#define SERIAL_PERIPHERAL_CHARACTERISTIC_SYSTEM_ID_STRING_UUID @"58302A23-A6CF-46BC-812F-DFC71D70109B"

//CHARACTERISTIC Pipe (4) Read
//Firmware Revision String
#define SERIAL_PERIPHERAL_CHARACTERISTIC_FIRMWARE_REVISION_STRING_UUID @"58302A26-A6CF-46BC-812F-DFC71D70109B"

#pragma mark -
#pragma mark Service 3:Heart Rate

#define SERIAL_PERIPHERAL_HEART_RATE_SERVICE_UUID @"5830180D-A6CF-46BC-812F-DFC71D70109B"

//Pipe (5)
//SLEEP DATA OR PEDOMETER DATA Receive NOTIFY
#define SERIAL_PERIPHERAL_CHARACTERISTIC_SLEEP_PEDO_DATA_UUID @"58302A37-A6CF-46BC-812F-DFC71D70109B"
//Pipe (6)
//Pedometer Setting Parameter Send To Device  WriteWithoutResponse
#define SERIAL_PERIPHERAL_CHARACTERISTIC_PEDOMETER_SETTING_UUID @"2A4A"


typedef enum {
    DATA_HEADER_PEDO_SETTING_RQ=  0x01,
    DATA_HEADER_PEDO_SETTING_TARGET_RS = 0x02,
    DATA_HEADER_PEDO_CURRENT_DATA_RQ  =0x82,
    DATA_HEADER_PEDO_CURRENT_DATA_RS =0x03,
    
    DATA_HEADER_PEDO_DATA_1_RQ  =0x83,
    DATA_HEADER_PEDO_DATA_1_RS =0x04,
    DATA_HEADER_PEDO_DATA_7_RQ= 0x89,
    DATA_HEADER_PEDO_DATA_7_RS =0x0A,
    DATA_HEADER_SLEEP_DATA_1_RQ= 0x8A,
    DATA_HEADER_SLEEP_DATA_1_RS= 0x0B,
    DATA_HEADER_SLEEP_DATA_7_RQ= 0x8F,
    DATA_HEADER_SLEEP_DATA_7_RS =0x11,
    DATA_HEADER_END_CONNECT_RQ= 0x91,
} DataHeaderType;

typedef struct {
    u_char header;
    u_char stride;
	u_char height;
	u_char weight;
	u_char gender;	
	u_char age;
	u_char format;
} packetPedoSetting;

typedef struct {
    u_char header;
} packetPedoHeader;    

typedef struct {
    u_char header;  //1 byte
    //targetStep 3 byte,10000 Step = 002710 (Hex), 1st byte = 0x10, 2nd byte = 0x27, 3rd byte = 0x00
    u_char targetStep[3];
    //remainStep 3 byte
    u_char remainStep[3]; 
    //remainDistance 3 byte
	u_char remainDistance[3]; 
    //remainCalorie 3 bytes
	u_char remainCalorie[3];
	u_char pedoMemoryNo; //1 byte
	u_char pedoSleepMemNo; //1 byte
} packetTargetData;

typedef struct {
    u_char header;  //1 byte
    //targetStep 3 byte,10000 Step = 002710 (Hex), 1st byte = 0x10, 2nd byte = 0x27, 3rd byte = 0x00
    u_char day;
    u_char month;
    u_char year;
    //Step1 3 byte
    u_char step[3]; 
    //Distance1 3 byte
	u_char distance[3]; //km
    //remainCalorie 3 bytes
	u_char calorie[3];
	u_char activityTimeMin; //min
	u_char activityTimeHour; //Hour
} packetPedoData;

typedef struct {
    u_char header;  //1 byte
    //targetStep 3 byte,10000 Step = 002710 (Hex), 1st byte = 0x10, 2nd byte = 0x27, 3rd byte = 0x00
    u_char day;
    u_char month;
    u_char year;
    //Step1 2 byte
    u_char timeToBedMin;
    u_char timeToBedHour;
	u_char timeToWakeupMin; 
    u_char timeToWakeupHour; 
    //Distance1 3 byte
	u_char timeToFallSleepMin; //km
    u_char timeToFallSleepHour; 
    u_char awakenTime; 
    //remainCalorie 3 bytes
    u_char inBedTimeMin;
	u_char inBedTimeHour;
    u_char actualSleepTimeMin;
    u_char actualSleepTimeHour;
} packetSleepData;

#endif
