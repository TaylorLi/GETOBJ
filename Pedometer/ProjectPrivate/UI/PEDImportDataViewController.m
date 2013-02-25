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
    
    sensor.delegate = self;
    
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
-(void)sensorReady
{
    //TODO: it seems useless right now.
    [self scanBTSmartShields]; 
}

-(void) peripheralFound:(CBPeripheral *)peripheral
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
