//
//  SerialGATT.m
//  SerialGATT
//
//  Created by BTSmartShield on 6/29/12.
//  Copyright (c) 2012 BTSmartShield.com. All rights reserved.
//

#import "BleDefinition.h"
#import "SerialGATT.h"
#import "BleServiceInfo.h"

@interface SerialGATT () 

-(void)connectionTimeout:(NSTimer *)timer;

@end
@implementation SerialGATT

@synthesize delegate;
@synthesize peripherals;
@synthesize manager;
@synthesize activePeripheral;

@synthesize serialHeartRateService;
@synthesize dataSettingWriteCharacteristic;
@synthesize dataNotifyCharacteristic;


@synthesize characteristicWriteUUID;
@synthesize characteristicNotifyUUID,serviceHeartRateDataUUID;
@synthesize scanTimer;
@synthesize connectingTimer;


/*
 * (void) setup
 * enable CoreBluetooth CentralManager and set the delegate for SerialGATT
 *
 */

-(void) setup
{
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    // initialize the Service UUID interested
    serviceHeartRateDataUUID=[CBUUID UUIDWithString:SERIAL_PERIPHERAL_HEART_RATE_SERVICE_UUID];
    characteristicWriteUUID = [CBUUID UUIDWithString:SERIAL_PERIPHERAL_CHARACTERISTIC_PEDOMETER_SETTING_UUID];
    characteristicNotifyUUID = [CBUUID UUIDWithString:SERIAL_PERIPHERAL_CHARACTERISTIC_SLEEP_PEDO_DATA_UUID];
}

/*
 * -(int) findBTSmartPeripherals:(int)timeout
 *
 * search for the BTSmartPeripherals and stop in timeout
 */

-(int) findBTSmartPeripherals:(int)timeout
{
    if ([manager state] != CBCentralManagerStatePoweredOn) {
        printf("CoreBluetooth is not correctly initialized !\n");
        return -1;
    }
    scanTimer = [NSTimer scheduledTimerWithTimeInterval:(float)timeout target:self selector:@selector(scanTimer:) userInfo:delegate repeats:NO];
    // start Scanning
    //[manager scanForPeripheralsWithServices:[[NSArray alloc] initWithObjects:[CBUUID UUIDWithString:@"deadf154-0000-0000-0000-0000deadf154"],nil] options:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:NO],CBCentralManagerScanOptionAllowDuplicatesKey,nil]];
    [manager scanForPeripheralsWithServices:nil options:[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:NO],CBCentralManagerScanOptionAllowDuplicatesKey,nil]];
    NSLog(@"scanForPeripheralsWithServices begin,with UUID:%@",serviceHeartRateDataUUID);
    //[manager scanForPeripheralsWithServices:nil options:nil];
    
    return 0;
}

/*
 * scanTimer
 * when findBTSmartPeripherals is timeout, this function will be called
 *
 */
-(void) scanTimer:(NSTimer *)timer
{
    id<BTSmartSensorDelegate> dlg= [timer userInfo];
    [manager stopScan];
    if(dlg){
        [dlg searchPeripheralTimeout];
    }
}

/*
 * connect
 * connect to a given peripheral
 *
 */
-(void) connect:(CBPeripheral *)peripheral
{
    if (![peripheral isConnected]) {
        [manager connectPeripheral:peripheral options:nil];
        connectingTimer = [NSTimer scheduledTimerWithTimeInterval:(float)BLE_CONNECTION_TIMEOUT target:self selector:@selector(connectionTimeout:) userInfo:delegate repeats:NO];
    }
}

-(void)connectionTimeout:(NSTimer *)timer
{
    [delegate failToExchangeData:@"Fail to connect this server."];
}

/*
 * disconnect
 * disconnect to a given peripheral
 *
 */
-(void) disconnect:(CBPeripheral *)peripheral
{
    [manager cancelPeripheralConnection:peripheral];
}

#pragma mark - basic operations for SerialGATT service
-(void) write:(CBPeripheral *)peripheral data:(NSData *)data
{
    if (!serialHeartRateService || !dataSettingWriteCharacteristic) {
        return;
    }
    
    [peripheral writeValue:data forCharacteristic:dataSettingWriteCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

-(void) read:(CBPeripheral *)peripheral
{
    if (!serialHeartRateService || !dataSettingWriteCharacteristic) {
        return;
    }
    
    [peripheral readValueForCharacteristic:dataSettingWriteCharacteristic];
}

-(void) notify: (CBPeripheral *)peripheral on:(BOOL)on
{
    if (!serialHeartRateService || !dataNotifyCharacteristic) {
        return;
    }
    [peripheral setNotifyValue:on forCharacteristic:dataNotifyCharacteristic];
}

#pragma mark - Finding CBServices and CBCharacteristics
-(CBService *) findServiceFromUUIDString:(NSString *)UUID p:(CBPeripheral *)peripheral
{
    return [self findServiceFromUUID:[CBUUID UUIDWithString:UUID] p:peripheral];
}

-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)peripheral
{
    printf("the services count is %d\n", peripheral.services.count);
    for (CBService *s in peripheral.services) {
        // compare s with UUID
        if ([[s.UUID data] isEqualToData:[UUID data]]) {
            return s;
        }
    }
    return  nil;
}

-(CBCharacteristic *) findCharacteristicFromUUIDString:(NSString *)UUID p:(CBPeripheral *)peripheral service:(CBService *)service
{
    return [self findCharacteristicFromUUID:[CBUUID UUIDWithString:UUID] p:peripheral service:service];
}

-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID p:(CBPeripheral *)peripheral service:(CBService *)service
{
    for (CBCharacteristic *c in service.characteristics) {
        printf("characteristic <%s> is found!\n", [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy]);
        if ([[c.UUID data] isEqualToData:[UUID data]]) {
            return c;
        }
    }
    return nil;
}


#pragma mark - CBCentralManager Delegates

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CoreBluetooth BLE hardware is resetting");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CoreBluetooth BLE state is unauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CoreBluetooth BLE state is unknown");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
            break;
        default:
            break;
    }
    
    //TODO: to handle the state updates
    if (central.state != CBCentralManagerStatePoweredOn) {
        // In a real app, you'd deal with all the states correctly
        return;
    }
    
    // The state must be CBCentralManagerStatePoweredOn...
    
    // ... so start scanning
    [self.delegate sensorPowerReady];
}
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"didDiscoverPeripheral:%@",peripheral);
    if (!peripherals) {
        peripherals = [[NSMutableArray alloc] initWithObjects:peripheral, nil];
        [delegate peripheralFound:peripheral advertisementData:advertisementData];
    } 
    else {
        // Add the new peripheral to the peripherals array
        for (int i = 0; i < [peripherals count]; i++) {
            CBPeripheral *p = [peripherals objectAtIndex:i];
            if(p.UUID!=nil&&peripheral.UUID!=nil)
            {
                CFUUIDBytes b1 = CFUUIDGetUUIDBytes(p.UUID);
                CFUUIDBytes b2 = CFUUIDGetUUIDBytes(peripheral.UUID);
                if (memcmp(&b1, &b2, 16) == 0) {
                    // these are the same, and replace the old peripheral information
                    [peripherals replaceObjectAtIndex:i withObject:peripheral];
                    printf("Duplicated peripheral is found...\n");
                    [delegate peripheralFound: peripheral advertisementData:advertisementData];
                    return;
                }
            }
        }
        printf("New peripheral is found...\n");
        [peripheral discoverServices:nil];
        [peripherals addObject:peripheral];
        [delegate peripheralFound:peripheral advertisementData:advertisementData];
    }
    printf("%s\n", __FUNCTION__);
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [connectingTimer invalidate];
    activePeripheral = peripheral;
    activePeripheral.delegate = self;
    
    [activePeripheral discoverServices:nil];
    
    printf("connected to the active peripheral\n");
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    activePeripheral = nil;
    printf("disconnected to the active peripheral\n");
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSString *logDetail=[NSString stringWithFormat:@"failed to connect to peripheral %@: %@", [peripheral name], [error localizedDescription]];
    NSLog(@"%@",logDetail);
    [delegate failToExchangeData:logDetail];
}
-(BleServiceInfo *)getActivePeripheralInfo
{
    BleServiceInfo *deviceInfo=[[BleServiceInfo alloc] init];
    CBService *serialService = [self findServiceFromUUIDString:SERIAL_PERIPHERAL_GENERIC_ACCESS_SERVICE_UUID p:activePeripheral];
    if(serialService){
        CBCharacteristic * dataCharacteristic = [self findCharacteristicFromUUIDString:SERIAL_PERIPHERAL_CHARACTERISTIC_DEVICENAME p:activePeripheral service:serialService];
        NSString *characterValue = [[NSString alloc] initWithData:dataCharacteristic.value encoding:NSUTF8StringEncoding];
        deviceInfo.deviceName=characterValue;
        
        CBCharacteristic * dataCharacteristic2 = [self findCharacteristicFromUUIDString:SERIAL_PERIPHERAL_CHARACTERISTIC_APPERANCE p:activePeripheral service:serialService];
        NSString *characterValue2 = [[NSString alloc] initWithData:dataCharacteristic2.value encoding:NSUTF8StringEncoding];    
        deviceInfo.appearance=characterValue2;
    }
    
    CBService *serialService2 = [self findServiceFromUUIDString:SERIAL_PERIPHERAL_DEVICE_SERVICE_UUID p:activePeripheral];
    if(serialService){
        CBCharacteristic * dataCharacteristic = [self findCharacteristicFromUUIDString:SERIAL_PERIPHERAL_CHARACTERISTIC_SN_STRING_UUID p:activePeripheral service:serialService2];
        NSString *characterValue = [[NSString alloc] initWithData:dataCharacteristic.value encoding:NSUTF8StringEncoding];
        deviceInfo.serialNumber=characterValue;
        
        CBCharacteristic * dataCharacteristic2 = [self findCharacteristicFromUUIDString:SERIAL_PERIPHERAL_CHARACTERISTIC_MANUFACTURER_NAME_STRING_UUID p:activePeripheral service:serialService2];
        NSString *characterValue2 = [[NSString alloc] initWithData:dataCharacteristic2.value encoding:NSUTF8StringEncoding];    
        deviceInfo.manufacture=characterValue2;
        
        CBCharacteristic * dataCharacteristic3 = [self findCharacteristicFromUUIDString:SERIAL_PERIPHERAL_CHARACTERISTIC_SYSTEM_ID_STRING_UUID p:activePeripheral service:serialService2];
        NSString *characterValue3 = [[NSString alloc] initWithData:dataCharacteristic3.value encoding:NSUTF8StringEncoding];
        deviceInfo.systemID=characterValue3;
        
        CBCharacteristic * dataCharacteristic4 = [self findCharacteristicFromUUIDString:SERIAL_PERIPHERAL_CHARACTERISTIC_FIRMWARE_REVISION_STRING_UUID p:activePeripheral service:serialService2];
        NSString *characterValue4 = [[NSString alloc] initWithData:dataCharacteristic4.value encoding:NSUTF8StringEncoding];    
        deviceInfo.firewareRevision=characterValue4;
    }
    return deviceInfo;
}

#pragma mark - CBPeripheral delegates

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        printf("updateValueForCharacteristic failed\n");
        return;
    }
    
    // Compare the characteristic with SERIAL_PERIPHERAL_CHAR_RECV_UUID and SERIAL_PERIPHERAL_CHAR_NOTIFY_UUID
    if ([[characteristic.UUID data] isEqualToData:[characteristicNotifyUUID data]]) {
        // TODO: read the data from SERIAL_PERIPHERAL_CHAR_NOTIFY_UUID
        [delegate serialGATTCharValueUpdated:SERIAL_PERIPHERAL_HEART_RATE_SERVICE_UUID value:characteristic.value];
    }
    else if ([[characteristic.UUID data] isEqualToData:[characteristicWriteUUID data]]) {
        // TODO: read the data from SERIAL_PERIPHERAL_CHAR_RECV_UUID, which can be used to write and read data
        [delegate serialGATTCharValueUpdated:SERIAL_PERIPHERAL_CHARACTERISTIC_PEDOMETER_SETTING_UUID value:characteristic.value];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (!error) {
        printf("The services are found\n");
        serialHeartRateService = [self findServiceFromUUID:serviceHeartRateDataUUID p:peripheral];
        if (!serialHeartRateService) {
            printf("The desired service is not found!\n");
            [delegate failToExchangeData:@"The desired service is not found!"];
            return;
        } else {
            for (CBService *svc in peripheral.services) {
                if(svc!=serialHeartRateService)
                    [peripheral discoverCharacteristics:nil forService:svc];
            }
            [peripheral discoverCharacteristics:nil forService:serialHeartRateService];              
        }        
    }
    else {
        printf("discoverservices is uncesessful!\n");
        [delegate failToExchangeData:@"Discover services is uncesessful!"];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (!error) {        
        printf("The characteristics are found for the service!\n");
        if(service==serialHeartRateService){
            dataSettingWriteCharacteristic = [self findCharacteristicFromUUID:characteristicWriteUUID p:peripheral service:serialHeartRateService];
            dataNotifyCharacteristic = [self findCharacteristicFromUUID:characteristicNotifyUUID p:peripheral service:serialHeartRateService];        
            if (!dataNotifyCharacteristic || !dataSettingWriteCharacteristic) {
                printf("The desired characteristics can't be found!\n");
                [delegate failToExchangeData:@"The desired characteristics can't be found!"];
                return;
            }    
            else {            
                [self notify:peripheral on:YES];
                //all require service ready
                [delegate sensorReadyToExchangeData];
                
            }
        } 
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (!error) {
        printf("setting notification\n");
    } else {
        printf("failed\n");
    }
}

-(void) cancelTimer
{
    if(scanTimer){
        [scanTimer invalidate];
    }
    if(connectingTimer){
        [connectingTimer invalidate];
    }
}

@end
