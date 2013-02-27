//
//  PEDImportDataViewController.m
//  Pedometer
//
//  Created by Eagle Du on 13/2/24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDImportDataViewController.h"
#import "SerialGATT.h"
#import "BleDefinition.h"
#import "PEDAppDelegate.h"
#import "UIHelper.h"

@interface PEDImportDataViewController ()

@end

@implementation PEDImportDataViewController
@synthesize imgCustomer;
@synthesize imgSchDeviceIndicator;
@synthesize tbViewPeripheralList;

@synthesize sensor;
@synthesize peripheralArray;
@synthesize transferCharacteristic;
@synthesize discoveredPeripheral;
@synthesize btnSchPeripheral;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
    sensor = [[SerialGATT alloc] init];
    [sensor setup]; 
    sensor.delegate = self;  
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setImgCustomer:nil];
    [self setImgSchDeviceIndicator:nil];
    [self setTbViewPeripheralList:nil];
    [self setBtnSchPeripheral:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)clickToReloadPeripheral:(id)sender
{
    [self scanBTSmartShields];
}
- (void)scanBTSmartShields {
    peripheralArray=[[NSMutableArray alloc] init];
    [tbViewPeripheralList reloadData];
    btnSchPeripheral.hidden=YES;
    imgSchDeviceIndicator.hidden=NO;
    [imgSchDeviceIndicator startAnimating];
    if ([sensor activePeripheral]) {
        if ([sensor.activePeripheral isConnected]) {
            [sensor.manager cancelPeripheralConnection:sensor.activePeripheral];
            sensor.activePeripheral = nil;
        }
    }    
    if ([sensor peripherals]) {
        sensor.peripherals = nil;
        [tbViewPeripheralList reloadData];
    }
        
    [sensor findBTSmartPeripherals:BLE_CONNECTION_TIMEOUT];
}

#pragma mark -
#pragma mark UITableViewDataSource Method Implementations

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.peripheralArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = [indexPath row];
    CBPeripheral *peripheral = [peripheralArray objectAtIndex:row];
    NSLog(@"ConnectTo Device:%@",peripheral);
    if (sensor.activePeripheral && sensor.activePeripheral != peripheral) {
        [sensor disconnect:sensor.activePeripheral];
    }
    
    sensor.activePeripheral = peripheral;
    [sensor connect:sensor.activePeripheral];
    [self beginReadDataFromPeripheral:peripheral];
    //[self.navigationController pushViewController:controller animated:YES];
}

-(void)beginReadDataFromPeripheral:(CBPeripheral *)peripheral
{
    
}

- (IBAction)backToPreviousTabView:(id)sender {
    [[PEDAppDelegate getInstance] hideImportDataViewAndShowTabView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"peripheral";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    // Configure the cell
    NSUInteger row = [indexPath row];
    CBPeripheral *peripheral = [peripheralArray objectAtIndex:row];
    cell.textLabel.text = peripheral.name;
    //cell.detailTextLabel.text = [NSString stringWithFormat:<#(NSString *), ...#>
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

#pragma mark - BTSmartSensorDelegate
-(void)sensorPowerReady
{
    //TODO: it seems useless right now.
    [self scanBTSmartShields]; 
}
/*
 1, 	iPhone ------------------------------------------------------------------------> Pedometer unit
 Request Connection
 2, 	iPhone <------------------------------------------------------------------------ Pedometer unit
 Connection Accepted
 3, 	iPhone ------------------------------------------------------------------------> Pedometer unit
 Service Discovery
 4, 	iPhone <------------------------------------------------------------------------ Pedometer unit
 Services information
 5, 	iPhone ------------------------------------------------------------------------> Pedometer unit
 Enable Services
 6, 	iPhone --------------------- Pipe #6 ---------------------------------------> Pedometer unit
 0x01, 0x39, 0x70, 0x62, 0x00, 0x25,0x00 
 (Stride = 57cm, Height = 1.12m, Weight = 98kg, Male, Age = 37, Metric)
 
 7,	iPhone <-------------------- Pipe #5 -------------------------------------- Pedometer unit
 0x02, 0x10, 0x27, 0x00, 0x10, 0x27, 0x00, 0x3A, 0x02, 0x00, 0x43, 0x02, 0x00, 0x07, 0x02
 Target Step:		0x002710 = 10000 steps
 Remaining Step:		0x002710 = 10000 steps
 Remaining Distance:	0x00023A = 5.70 km
 Remaining Calorie:	0x000243 = 579 kcal
 Pedometer data:		7
 Sleep Monitor data:	2
 
 8, 	iPhone --------------------- Pipe #6 ---------------------------------------> Pedometer unit
 0x82  Acknowledge Target data with 0x82
 
 9,	iPhone <-------------------- Pipe #5 -------------------------------------- Pedometer unit
 0x03, 0x27, 0x12, 0x12, 0xD7, 0x11, 0x00, 0x12, 0x01, 0x00, 0x38, 0x01, 0x00, 0x34, 0x02
 Date:			27 Dec 2012
 Step:			0011D7 = 4567 steps
 Distance:		0x000112 = 2.74 km
 Calorie:		0x000138 = 312 kcal
 Activity Time:	02:34
 
 10, 	iPhone --------------------- Pipe #6 ---------------------------------------> Pedometer unit
 0x83  Acknowledge Target data with 0x83
 
 

 11,	iPhone <-------------------- Pipe #5 -------------------------------------- Pedometer unit
 0x04, 0x28, 0x12, 12, 0x59, 0x01, 0x00, 0x14, 0x00, 0x00, 0x23, 0x00, 0x00, 0x27, 0x00
 Date:			28 Dec 2012
 Step:			000159 = 345 steps
 Distance:		0x000014 = 0.20 km
 Calorie:		0x000023 = 35 kcal
 Activity Time:	00:27
 
 12, 	iPhone --------------------- Pipe #6 ---------------------------------------> Pedometer unit
 0x84  Acknowledge Target data with 0x84
 
 13,	iPhone <-------------------- Pipe #5 -------------------------------------- Pedometer unit
 0x05, 0x29, 0x12, 0x12, 0x9F, 0x86, 0x01, 0x70, 0x17, 0x00, 0xAE, 0x1E, 0x00, 0x18, 0x05
 Date:			29 Dec 2012
 Step:			01869F = 99999 steps
 Distance:		0x001770 = 60.00 km
 Calorie:		0x001EAE = 7854 kcal
 Activity Time:	05:18
 
 14, 	iPhone --------------------- Pipe #6 ---------------------------------------> Pedometer unit
 0x85  Acknowledge Target data with 0x85
 
 15,	iPhone <-------------------- Pipe #5 -------------------------------------- Pedometer unit
 0x06, 0x30, 0x12, 0x12, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x02, 0x00
 Date:			30 Dec 2012
 Step:			000002 = 2 steps
 Distance:		0x000000 = 0.00 km
 Calorie:		0x000001 = 1 kcal
 Activity Time:	00:02
 
 16, 	iPhone --------------------- Pipe #6 ---------------------------------------> Pedometer unit
 0x86  Acknowledge Target data with 0x86

 17,	iPhone <-------------------- Pipe #5 -------------------------------------- Pedometer unit
 0x07, 0x31, 0x12, 0x12, 0xD2, 0x1E, 0x00, 0xD9, 0x01, 0x00, 0xF4, 0x01, 0x00, 0x48, 0x04
 Date:			31 Dec 2012
 Step:			001ED2 = 7890 steps
 Distance:		0x0001D9 = 4.73 km
 Calorie:		0x0001F4 = 500 kcal
 Activity Time:	04:48
 
 18, 	iPhone --------------------- Pipe #6 ---------------------------------------> Pedometer unit
 0x87  Acknowledge Target data with 0x87
 
 19,	iPhone <-------------------- Pipe #5 -------------------------------------- Pedometer unit
 0x08, 0x01, 0x01, 0x13, 0x7B, 0x00, 0x00, 0x49, 0x00, 0x00, 0x4E, 0x00, 0x00, 0x09, 0x01
 Date:			01 Jan 2013
 Step:			00007B = 123 steps
 Distance:		0x000049 = 0.73 km
 Calorie:		0x00004E = 78 kcal
 Activity Time:	01:09
 
 20, 	iPhone --------------------- Pipe #6 ---------------------------------------> Pedometer unit
 0x88  Acknowledge Target data with 0x88
 
 21,	iPhone <-------------------- Pipe #5 -------------------------------------- Pedometer unit
 0x09, 0x02, 0x01, 0x13, 0x58, 0x1B, 0x00, 0xA4, 0x01, 0x00, 0x2C, 0x01, 0x00, 0x58, 0x03
 Date:			02 Jan 2013
 Step:			001B58 = 7000 steps
 Distance:		0x0001A4 = 4.20 km
 Calorie:		0x00012C = 300 kcal
 Activity Time:	03:58
 
 22, 	iPhone --------------------- Pipe #6 ---------------------------------------> Pedometer unit
 0x89  Acknowledge Target data with 0x89
 

 23,	iPhone <-------------------- Pipe #5 -------------------------------------- Pedometer unit
 0x0A, 0x27, 0x12, 0x12, 0x35, 0x22, 0x15, 0x07, 0x50, 0x22, 0x03, 0x40, 0x08, 0x25, 0x08
 Date:				27 Dec 2012
 To Bed Time:		22:35
 Wakeup Time:		07:15
 Fall Sleep Time:		22:50
 Awaken Time:		3
 In Bed Time:		08:40
 Actual Sleep Time:	08:25
 
 12, 	iPhone --------------------- Pipe #6 ---------------------------------------> Pedometer unit
 0x8A  Acknowledge Target data with 0x8A
 
 13,	iPhone <-------------------- Pipe #5 -------------------------------------- Pedometer unit
 0x0B, 0x28, 0x12, 0x12, 0x15, 0x21, 0x40, 0x06, 0xFF, 0xFF, 0x00, 0x25, 0x09, 0x00, 0x00
 Date:				28 Dec 2012
 To Bed Time:		21:15
 Wakeup Time:		06:40
 Fall Sleep Time:		None
 Awaken Time:		0
 In Bed Time:		09:25
 Actual Sleep Time:	00:00
 
 14, 	iPhone --------------------- Pipe #6 ---------------------------------------> Pedometer unit
 0x8B  Acknowledge Target data with 0x8B
 
 15, 	iPhone <------------------------------------------------------------------------ Pedometer unit
 Terminate Connection

 */
-(void)sensorReadyToExchangeData
{
    //Pedometer setting data
    Byte byte[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23};
    NSData *settingData=[[NSData alloc] initWithBytes:byte length:7];
    [sensor write:sensor.activePeripheral data:settingData];
}

-(void) serialGATTCharValueUpdated: (NSString *)UUID value: (NSData *)data{
  Byte *bytes = (Byte *)[data bytes];
    switch (bytes[0]) {
        case 0x02:
            ;
            break;
            
        default:
            break;
    }
}

-(void) peripheralFound:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)data
{
    [peripheralArray addObject:peripheral];
    [tbViewPeripheralList reloadData];
}

-(void) searchPeripheralTimeout
{
    btnSchPeripheral.hidden=NO;
    [imgSchDeviceIndicator stopAnimating];
    imgSchDeviceIndicator.hidden=YES;
    
    if(peripheralArray.count==0){
        [UIHelper showAlert:@"Information" message:@"Can not find any available device." func:^(AlertView *a, NSInteger i) {
            ;
        }];
    }
}

@end
