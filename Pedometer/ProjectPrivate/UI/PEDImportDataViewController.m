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
#import "PEDImportDataDetailController.h"

@interface PEDImportDataViewController ()

-(void)swithSchIndicator:(BOOL)loading;

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
    self.navigationController.title=@"Select Device";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backToPreviousTabView:)];  
    self.navigationItem.leftBarButtonItem = leftButton;  
    [self swithSchIndicator:YES];
    sensor = [[SerialGATT alloc] init];
    [sensor setup]; 
    sensor.delegate = self;  
    // Do any additional setup after loading the view from its nib.
}

-(void)swithSchIndicator:(BOOL)loading
{
    UIBarButtonItem *rightButton ;
    if(loading){
        if(!imgSchDeviceIndicator)
        imgSchDeviceIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        rightButton = [[UIBarButtonItem alloc] initWithCustomView:imgSchDeviceIndicator];
        
    }
    else{
       rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(scanBTSmartShields)];
    }   
    self.navigationItem.rightBarButtonItem = rightButton;
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
    [sensor cancelTimer];
    [self scanBTSmartShields];
}
- (void)scanBTSmartShields {
    peripheralArray=[[NSMutableArray alloc] init];
    [tbViewPeripheralList reloadData];
    [self swithSchIndicator:YES];
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
        
    [sensor findBTSmartPeripherals:BLE_DISCOVER_TIMEOUT];
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
    NSArray *info = [peripheralArray objectAtIndex:row];
    CBPeripheral *peripheral=[info objectAtIndex:0];
    //NSDictionary *advertiseData=[info objectAtIndex:1];
    NSLog(@"ConnectTo Device:%@",peripheral);
    if (sensor.activePeripheral && sensor.activePeripheral != peripheral) {
        [sensor disconnect:sensor.activePeripheral];
    }
    PEDImportDataDetailController *controller = [[PEDImportDataDetailController alloc] initWithNibName:@"PEDImportDataDetailController" bundle:nil];
    controller.peripheral = peripheral;
    controller.sensor = sensor;
    sensor.activePeripheral = peripheral;
    //[self addChildViewController:controller];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)backToPreviousTabView:(id)sender {
    [self cleanup];
    [sensor cancelTimer];
    sensor=nil;
    [[PEDAppDelegate getInstance] hideImportDataViewAndShowTabView];
}

-(void)restoreFromImportDetailView:(PEDImportDataDetailController *)detailController
{
    detailController=nil;
}

- (void)cleanup
{
    // Don't do anything if we're not connected
    if (!self.discoveredPeripheral || !self.discoveredPeripheral.isConnected) {
        return;
    }    
    // See if we are subscribed to a characteristic on the peripheral
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SERIAL_PERIPHERAL_CHARACTERISTIC_SLEEP_PEDO_DATA_UUID]]) {
                        if (characteristic.isNotifying) {
                            // It is notifying, so unsubscribe
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            
                            // And we're done.
                            return;
                        }
                    }
                }
            }
        }
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    [sensor.manager cancelPeripheralConnection:self.discoveredPeripheral];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"PeripheralRow";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PEDPeripheralInfoRow" owner:self options:nil] lastObject];
    }
    // Configure the cell
    NSUInteger row = [indexPath row];
    NSArray *info = [peripheralArray objectAtIndex:row];
    CBPeripheral *peripheral=[info objectAtIndex:0];
    NSDictionary *advertiseData=[info objectAtIndex:1];
    UILabel *textLable= (UILabel *)[cell viewWithTag:1];
    textLable.text = peripheral.name;
    UITextView *view=(UITextView *)[cell viewWithTag:2];
    NSMutableString *serviceInfo=[[NSMutableString alloc] init];
    NSString* uuidstr =[UtilHelper stringWithUUID];
    [serviceInfo appendFormat:@"UUID:%@\n",peripheral.UUID==nil?[NSString stringWithFormat:@"%@(Generate)",uuidstr]:[UtilHelper stringByUUID:peripheral.UUID]];
    [serviceInfo appendFormat:@"Local Name:%@\n",[advertiseData objectForKey:CBAdvertisementDataLocalNameKey]];
    NSArray *service=[advertiseData objectForKey:CBAdvertisementDataServiceUUIDsKey];
    for (NSString *servicUUID in service) {
        [serviceInfo appendFormat:@"Service:%@\n",servicUUID];
    }
    view.textColor=[UIColor grayColor];
    //view.font=[UIFont systemFontOfSize:12];
    view.text=serviceInfo;
    //cell.detailTextLabel.text = [NSString stringWithFormat:<#(NSString *), ...#>
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - BTSmartSensorDelegate
-(void)sensorPowerReady
{
    //TODO: it seems useless right now.
    [self scanBTSmartShields]; 
}

-(void) peripheralFound:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)data
{
    //kCBAdvDataLocalName = LightBlue;
    //kCBAdvDataServiceUUIDs 
    [peripheralArray addObject:[[NSArray alloc] initWithObjects:peripheral,data,nil]];
    [tbViewPeripheralList reloadData];
}

-(void) searchPeripheralTimeout
{
    [self swithSchIndicator:NO];
    if(peripheralArray.count==0){
        [UIHelper showAlert:@"Information" message:@"Can not find any available device." func:^(AlertView *a, NSInteger i) {
            ;
        }];
    }
}

@end
