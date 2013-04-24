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
#import "PEDTarget.h"
#import "UIHelper.h"
#import "PEDImportDataDetailController.h"
#import "BO_PEDTarget.h"
#import "UILoadingBox.h"

@interface PEDImportDataViewController ()

-(void)swithSchIndicator:(BOOL)loading;
-(void)bindViewWithUserInfo;
-(void)connectToPeripheral:(CBPeripheral *)peripheral;

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
@synthesize lblTopTip;
@synthesize lblConnectDeviceName;
@synthesize lblConnectDeviceUUID;
@synthesize btnReSelectDevice;
@synthesize btnClearData;
@synthesize lblConnectDeviceNameTitle;
@synthesize lblConnectDeviceUUIDTitle;
@synthesize onlyPeripheralUUID,isDebugMode;


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
    [self bindViewWithUserInfo];
    sensor = [[SerialGATT alloc] init];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backToPreviousTabView:)];  
    self.navigationItem.leftBarButtonItem = leftButton;  
    self.title=@"Sync Devices";
    [self swithSchIndicator:YES];    
    [sensor setup]; 
    sensor.delegate = self;  
    isDebugMode=NO;
    // Do any additional setup after loading the view from its nib.
}

-(void)bindViewWithUserInfo
{
    PEDTarget *target =  [AppConfig getInstance].settings.target;
    if(target!=nil&&target.relatedDeviceUUID!=nil){
        onlyPeripheralUUID=target.relatedDeviceUUID;
        lblTopTip.text=@"Binding Device";
        lblConnectDeviceName.text=target.relatedDeviceName;
        lblConnectDeviceUUID.text=target.relatedDeviceUUID;
        lblConnectDeviceNameTitle.hidden=NO;
        lblConnectDeviceUUIDTitle.hidden=NO;
        lblConnectDeviceName.hidden=NO;
        lblConnectDeviceUUID.hidden=NO;
        tbViewPeripheralList.hidden=YES;
        btnClearData.hidden=NO;
        btnReSelectDevice.hidden=NO;
    }
    else{
        lblTopTip.text=@"Select device to sync data";
        onlyPeripheralUUID=nil;
        lblConnectDeviceNameTitle.hidden=YES;
        lblConnectDeviceUUIDTitle.hidden=YES;
        lblConnectDeviceName.hidden=YES;
        lblConnectDeviceUUID.hidden=YES;
        tbViewPeripheralList.hidden=NO;
        btnClearData.hidden=YES;
        btnReSelectDevice.hidden=YES;
    }
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
        rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Sync" style:UIBarButtonItemStylePlain target:self action:@selector(scanBTSmartShields)];
    }   
    self.navigationItem.rightBarButtonItem = rightButton;
}
- (void)viewDidUnload
{
    [self setImgCustomer:nil];
    [self setImgSchDeviceIndicator:nil];
    [self setTbViewPeripheralList:nil];
    [self setBtnSchPeripheral:nil];
    [self setLblTopTip:nil];
    [self setLblConnectDeviceName:nil];
    [self setLblConnectDeviceUUID:nil];
    [self setBtnReSelectDevice:nil];
    [self setBtnClearData:nil];
    [self setLblConnectDeviceNameTitle:nil];
    [self setLblConnectDeviceUUID:nil];
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
    @try {
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
    @catch (NSException *exception) {
        [LogHelper errorAndShowAlert:@"Failed to search devices,please retry." exception:exception];
    }
    @finally {
        
    }
    
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
    [self connectToPeripheral:peripheral];
}

-(void)connectToPeripheral:(CBPeripheral *)peripheral
{
    @try {
        //NSDictionary *advertiseData=[info objectAtIndex:1];
        log4Info(@"ConnectTo Device:%@",peripheral);
        if (sensor.activePeripheral && sensor.activePeripheral != peripheral) {
            [sensor disconnect:sensor.activePeripheral];
        }
        PEDImportDataDetailController *controller = [[PEDImportDataDetailController alloc] initWithNibName:@"PEDImportDataDetailController" bundle:nil];
        controller.isDebugMode=isDebugMode;
        controller.parentController=self;
        controller.peripheral = peripheral;
        controller.sensor = sensor;
        sensor.activePeripheral = peripheral;
        //[self addChildViewController:controller];
        if(isDebugMode)
            [self.navigationController pushViewController:controller animated:YES];
        else{
            [self showLoading:YES];
            [controller startToCommunicate];
            [self addChildViewController:controller];
        }
    }
    @catch (NSException *exception) {
        [LogHelper errorAndShowAlert:@"Failed to conneted to device,please retry." exception:exception];
    }
    @finally {
        
    }
}
-(void)showLoading:(BOOL)show{
    if(show){
        if(!loadingBox){
            loadingBox=[[UILoadingBox alloc] initWithLoading:@"Transfering data ..." showCloseImage:YES onClosed:^{
                [self backToPreviousTabView:nil];
            }];
        }
        [loadingBox showLoading];
    }
    else{
        if(loadingBox){
            [loadingBox hideLoading];
            loadingBox=nil;
            
        }
    }
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
    @try {
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
    @catch (NSException *exception) {
        [LogHelper error:@"Fail to search devices,please retry." exception:exception];
    }
    @finally {
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
    
    UILabel *textLable= (UILabel *)[cell viewWithTag:1];
    textLable.text = peripheral.name;
    UITextView *view=(UITextView *)[cell viewWithTag:2];
    NSMutableString *serviceInfo=[[NSMutableString alloc] init];
    NSString* uuidstr =[UtilHelper stringWithUUID];
    [serviceInfo appendFormat:@"UUID:%@\n",peripheral.UUID==nil?[NSString stringWithFormat:@"%@(Generate)",uuidstr]:[UtilHelper stringByUUID:peripheral.UUID]];
    /*
     NSDictionary *advertiseData=[info objectAtIndex:1];  
     [serviceInfo appendFormat:@"Local Name:%@\n",[advertiseData objectForKey:CBAdvertisementDataLocalNameKey]];
     NSArray *service=[advertiseData objectForKey:CBAdvertisementDataServiceUUIDsKey];
     
     for (NSString *servicUUID in service) {
     [serviceInfo appendFormat:@"Service:%@\n",servicUUID];
     }
     */
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
    @try {
        //kCBAdvDataLocalName = LightBlue;
        //kCBAdvDataServiceUUIDs 
        if(onlyPeripheralUUID){
            
            if([[UtilHelper stringByUUID:peripheral.UUID] isEqualToString:onlyPeripheralUUID]){
                [peripheralArray addObject:[[NSArray alloc] initWithObjects:peripheral,data,nil]];
                [sensor.manager stopScan];
                [self searchPeripheralTimeout];
                //start to exhchange data
                [self connectToPeripheral:peripheral];
            }
        }
        else{
            [peripheralArray addObject:[[NSArray alloc] initWithObjects:peripheral,data,nil]];
            [tbViewPeripheralList reloadData];
        }   
    }
    @catch (NSException *exception) {
        [LogHelper error:@"Fail to regconize device." exception:exception];
    }
    @finally {
        
    }
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
- (IBAction)ReBindDevice:(id)sender {
    @try {
        [UIHelper showConfirm:@"Information" message:@"Continue to clear data and rebind to other device?" doneText:@"Yes" doneFunc:^(AlertView *a, NSInteger i) {
            [sensor.manager stopScan];
            PEDTarget *target =  [AppConfig getInstance].settings.target;
            [[BO_PEDTarget getInstance] clearBindingDevice:target];
            [AppConfig getInstance].settings.target=target;
            onlyPeripheralUUID=nil;
            [self bindViewWithUserInfo];
            [self scanBTSmartShields];
            [UIHelper showAlert:@"Information" message:@"Success to clear data,you can reselect binding device." func:nil];
        } cancelText:@"No" cancelfunc:nil];
    }
    @catch (NSException *exception) {
        [LogHelper errorAndShowAlert:@"Error occured." exception:exception];
    }
    @finally {
        
    }
}

- (IBAction)ClearCurrentDeviceData:(id)sender {
    @try {
        [UIHelper showConfirm:@"Information" message:@"Continue to clear data?" doneText:@"Yes" doneFunc:^(AlertView *a, NSInteger i) {
            PEDTarget *target =  [AppConfig getInstance].settings.target;
            [[BO_PEDTarget getInstance] clearTargetData:target.targetId];
            [sensor.manager stopScan];
            [self swithSchIndicator:NO];
            [UIHelper showAlert:@"Information" message:@"Success to clear data." func:^(AlertView *a, NSInteger i) {
                [self backToPreviousTabView:nil];
            }];
        } cancelText:@"No" cancelfunc:nil];
    }
    @catch (NSException *exception) {
        [LogHelper errorAndShowAlert:@"Error occured." exception:exception];
    }
    @finally {
        
    }
}

@end
