//
//  PEDImportDataDetail.m
//  Pedometer
//
//  Created by JILI Du on 13/2/27.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "PEDImportDataDetailController.h"
#import "PEDImportDataViewController.h"
#import "UIHelper.h"
#import "BleServiceInfo.h"
#import "PEDUserInfo.h"
#import "BleDefinition.h"
#import "PEDPedometerData.h"
#import "PEDSleepData.h"
#import "BleExchangeDataContainer.h"
#import "BO_PEDSleepData.h"
#import "BO_PEDPedometerData.h"
#import "BO_PEDTarget.h"

@interface PEDImportDataDetailController ()

-(void)sendSettingDataWithType:(DataHeaderType)headerType;
- (void)sendDataToPeriperial:(void *)data ofLength:(int)length;
-(PEDTarget *)convertDataToTarget:(NSData *)data;
-(PEDPedometerData *)convertDataToPedoData:(NSData *)data;
-(PEDSleepData *)convertDataToSleepData:(NSData *)data;
-(void)saveExchangeDataToDatabase;
-(void)testExchangeDataEnd;
-(void) exchangeTimeout:(NSTimer *)timer;
-(void)cancelExchangeTimer;

@end

@implementation PEDImportDataDetailController
@synthesize txtActInfo;

@synthesize rssi_container;
@synthesize sensor;
@synthesize peripheral,indActive,parentController,exchangeContainer,exchangeTimer;


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
    self.title = @"Import Data";
    self.sensor.delegate = self;    
    [self.navigationController.navigationItem.leftBarButtonItem setAction:@selector(backToPeriperialList)];
    [indActive startAnimating];
    self.txtActInfo.text=[NSString stringWithFormat:@"Connecting to %@ ...",peripheral.name];
    [sensor connect:sensor.activePeripheral];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTxtActInfo:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Peripheral Deleagte

-(void)beginExchangeDataWithDevice
{
    self.exchangeContainer=[[BleExchangeDataContainer alloc] init];
    [self sendSettingDataWithType:DATA_HEADER_PEDO_SETTING_RQ];
}
-(void)sensorReadyToExchangeData
{
    [indActive stopAnimating];
    indActive.hidden=YES;
    txtActInfo.text=@"Ready to import data.";   
    [self beginExchangeDataWithDevice];
    //BleServiceInfo *svcInfo = [sensor getActivePeripheralInfo];
    //send settingData to pedometer
    
}
- (void)sendDataToPeriperial:(void *)data ofLength:(int)length
 {
    static unsigned char networkPacket[kMaxPacketSize];	
    // copy data in after the header
    memcpy( &networkPacket[0], data, length ); 
    NSData *packet = [NSData dataWithBytes: networkPacket length:length];
    [sensor write:sensor.activePeripheral data:packet];
    NSLog(@"Send Data:%@",packet);
}

-(void)sendSettingDataWithType:(DataHeaderType)headerType
{
    if(exchangeTimer){
        [exchangeTimer invalidate];
    }
    PEDUserInfo *userInfo=[[AppConfig getInstance].settings.userInfo copy];
    if(userInfo.measureFormat==MEASURE_UNIT_ENGLISH){
        [userInfo convertUnit:MEASURE_UNIT_METRIC];
    }
    packetPedoSetting setting;
    setting.age=(unsigned char)userInfo.age;
    setting.format=userInfo.measureFormat==MEASURE_UNIT_METRIC?0:1;
    setting.gender=userInfo.gender?0:1;
    setting.height=userInfo.height;
    setting.stride=userInfo.stride;
    setting.weight=userInfo.weight;
    setting.header=headerType;
    [self sendDataToPeriperial:&setting ofLength:sizeof(packetPedoSetting)];
     exchangeTimer = [NSTimer scheduledTimerWithTimeInterval:BLE_DATA_TRANSFER_TIMEOUT target:self selector:@selector(exchangeTimeout:) userInfo:nil repeats:NO];
}

-(void)cancelExchangeTimer
{
    if(exchangeTimer){
        [exchangeTimer invalidate];
    }
}
-(void) exchangeTimeout:(NSTimer *)timer
{
    [self failToExchangeData:@"Fail to receive response."];
}
-(PEDTarget *)convertDataToTarget:(NSData *)data
{
    unsigned char *incomingPacket = (unsigned char *)[data bytes];
    packetTargetData *packet = (packetTargetData *)&incomingPacket[0];	
    PEDTarget *target=[[PEDTarget alloc] init];
    target.targetStep=packet->targetStep[0]+packet->targetStep[0]*16*16+packet->targetStep[0]*16*16*16*16;
    target.remainStep=packet->remainStep[0]+packet->remainStep[0]*16*16+packet->remainStep[0]*16*16*16*16;
    target.remainDistance=(packet->remainDistance[0]+packet->remainDistance[0]*16*16+packet->remainDistance[0]*16*16*16*16)/100;
    target.remainCalorie=packet->remainCalorie[0]+packet->remainCalorie[0]*16*16+packet->remainCalorie[0]*16*16*16*16;
    target.pedoDataCount = packet->pedoMemoryNo;
    target.sleepDataCount=packet->pedoSleepMemNo;
    //checking
    return target;
}

-(PEDPedometerData *)convertDataToPedoData:(NSData *)data
{
    unsigned char *incomingPacket = (unsigned char *)[data bytes];
    packetPedoData *packet = (packetPedoData *)&incomingPacket[0];	
    PEDPedometerData *pedoData=[[PEDPedometerData alloc] init];
    pedoData.activeTime=packet->activityTimeHour*3600+packet->activityTimeMin*60;
    pedoData.calorie=packet->calorie[0]+packet->calorie[0]*16*16+packet->calorie[0]*16*16*16*16;
    pedoData.distance=(packet->distance[0]+packet->distance[0]*16*16+packet->distance[0]*16*16*16*16/100);
    pedoData.step=packet->step[0]+packet->step[0]*16*16+packet->step[0]*16*16*16*16;
    pedoData.optDate=[UtilHelper convertDate:[NSString stringWithFormat:@"20%2i-%2i-%2i",packet->year,packet->month,packet->day]];
    return pedoData;
}
-(PEDSleepData *)convertDataToSleepData:(NSData *)data
{
    unsigned char *incomingPacket = (unsigned char *)[data bytes];
    packetSleepData *packet = (packetSleepData *)&incomingPacket[0];	
    PEDSleepData *sleepData=[[PEDSleepData alloc] init];
    sleepData.optDate=[UtilHelper convertDate:[NSString stringWithFormat:@"20%2i-%2i-%2i",packet->year,packet->month,packet->day]];
    sleepData.timeToBed=packet->timeToBedHour*3600+packet->timeToBedMin*60;
    sleepData.timeToFallSleep=packet->timeToFallSleepHour*3600+packet->timeToFallSleepMin*60;
    sleepData.timeToWakeup=packet->timeToWakeupHour*3600+packet->timeToWakeupMin*60;
    sleepData.inBedTime=packet->inBedTimeHour*3600+packet->inBedTimeMin*60;
    sleepData.actualSleepTime=packet->actualSleepTimeHour*3600+packet->actualSleepTimeMin*60;
    sleepData.awakenTime=packet->awakenTime;
    return sleepData;
}

-(void) serialGATTCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    //NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    NSLog(@"Receive Notify:UUID:%@,data:%@",UUID,data);
    unsigned char *incomingPacket = (unsigned char *)[data bytes];
   DataHeaderType header = (DataHeaderType)incomingPacket[0];
    if (header == DATA_HEADER_PEDO_SETTING_TARGET_RS) {
        [self cancelExchangeTimer];
           PEDTarget *target= [self convertDataToTarget:data];
           if(target){
               exchangeContainer.target=target;
               if(target.pedoDataCount>0){
               exchangeContainer.exchageType=ExchangeTypePedoData;
                    exchangeContainer.pedoDataIndex++;
                   [self sendSettingDataWithType:DATA_HEADER_PEDO_DATA_1_RQ+exchangeContainer.pedoDataIndex];
               }    
               else if(target.sleepDataCount>0){
                   exchangeContainer.exchageType=ExchangeTypeSleepData;
                    exchangeContainer.sleepDataIndex++;
                   [self sendSettingDataWithType:DATA_HEADER_SLEEP_DATA_1_RQ+exchangeContainer.sleepDataIndex];
               }
               else{
                   exchangeContainer.isConnectingEnd=YES;
               }
           }
                else{
                    [self failToExchangeData:@"Invalid Data Format,connection will be terminated."];
                }        
    }
    else if(header>=DATA_HEADER_PEDO_DATA_1_RS&&header<=DATA_HEADER_PEDO_DATA_7_RS){
        [self cancelExchangeTimer];
        PEDPedometerData *pedoData=[self convertDataToPedoData:data];
        if(pedoData){
            [exchangeContainer.pedoData addObject:pedoData];
            exchangeContainer.pedoDataIndex++;
            if(header==DATA_HEADER_PEDO_DATA_1_RQ+exchangeContainer.target.pedoDataCount-1)
            {
                if(exchangeContainer.target.sleepDataCount>0){
                    exchangeContainer.sleepDataIndex++;
                    [self sendSettingDataWithType:DATA_HEADER_SLEEP_DATA_1_RQ+exchangeContainer.sleepDataIndex];
                }
                else{
                    exchangeContainer.isConnectingEnd=YES;
                }
            }
            else{
                [self sendSettingDataWithType:DATA_HEADER_PEDO_DATA_1_RQ+exchangeContainer.pedoDataIndex];
            }
        }
        else{
            [self failToExchangeData:@"Invalid Data Format,connection will be terminated."];
        }
    }
    else if(header>=DATA_HEADER_SLEEP_DATA_1_RS&&header<=DATA_HEADER_SLEEP_DATA_7_RS)
    {        
        [self cancelExchangeTimer];
        PEDSleepData *sleepData=[self convertDataToSleepData:data];
        if(sleepData){
            [exchangeContainer.sleepData addObject:sleepData];
            exchangeContainer.sleepDataIndex++;
            if(header==DATA_HEADER_SLEEP_DATA_1_RQ+exchangeContainer.target.sleepDataCount-1)
            {
                exchangeContainer.isConnectingEnd=YES;
            }
            else{
                [self sendSettingDataWithType:DATA_HEADER_SLEEP_DATA_1_RQ+exchangeContainer.sleepDataIndex];
            }
        }
        else{
            [self failToExchangeData:@"Invalid Data Format,connection will be terminated."];
        }
    }
    [self testExchangeDataEnd];
}

-(void)testExchangeDataEnd
{
    if(exchangeContainer.isConnectingEnd){
        [self sendSettingDataWithType:DATA_HEADER_END_CONNECT_RQ];
        //test data
        [self saveExchangeDataToDatabase];
    }
}
         
-(void)saveExchangeDataToDatabase
{
    BOOL success=YES;
    PEDUserInfo *user =[AppConfig getInstance].settings.userInfo;
    if(exchangeContainer.target){
      PEDTarget *target =  [[BO_PEDTarget getInstance] queryTargetByUserId:user.userId];
        if(target){
            target.targetStep=exchangeContainer.target.targetStep;
            target.remainStep=exchangeContainer.target.remainStep;
            target.remainDistance=exchangeContainer.target.remainDistance;
            target.remainCalorie=exchangeContainer.target.remainCalorie;
            target.pedoDataCount = exchangeContainer.target.pedoDataCount;
            target.sleepDataCount=exchangeContainer.target.sleepDataCount;
            target.updateDate=exchangeContainer.target.updateDate;
            exchangeContainer.target=target;
        }
        else{
            exchangeContainer.target.userId=user.userId;
            target=exchangeContainer.target;
        }
        [[BO_PEDTarget getInstance] saveObject:target];
    }
    for (PEDPedometerData *data in exchangeContainer.pedoData) {
        PEDPedometerData *pedoData=[[BO_PEDPedometerData getInstance] getWithTarget:exchangeContainer.target.targetId withDate:data.optDate];
        if(pedoData){
            pedoData.activeTime=data.activeTime;
            pedoData.calorie=data.calorie;
            pedoData.distance=data.distance;
            pedoData.step=data.step;
            pedoData.optDate=data.optDate;
            pedoData.updateDate=data.updateDate;
        }
        else{
            data.targetId=exchangeContainer.target.targetId;
            pedoData=data;            
        }
        [[BO_PEDPedometerData getInstance] saveObject:pedoData];
    }
    for(PEDSleepData *data in exchangeContainer.sleepData){
        PEDSleepData *sleepData=[[BO_PEDSleepData getInstance] getWithTarget:exchangeContainer.target.targetId withDate:data.optDate];;
        if(sleepData){
            sleepData.optDate=data.optDate;
            sleepData.timeToBed=data.timeToBed;
            sleepData.timeToWakeup=data.timeToWakeup;
            sleepData.inBedTime=data.inBedTime;
            sleepData.actualSleepTime=data.actualSleepTime;
            sleepData.awakenTime=data.awakenTime;
            sleepData.updateDate=data.updateDate;
        }
        else{
            data.targetId=sleepData.targetId;
            sleepData=data;
        }
    }
    if(success){
        [self failToExchangeData:@"Success to import data."];
    }
    else{
        [self failToExchangeData:@"Fail to import data to database."];
    }
}

-(void)backToPeriperialList
{
    [sensor cancelTimer];
    [sensor disconnect:sensor.activePeripheral];
    sensor.activePeripheral=nil;
    sensor.delegate=parentController;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) failToExchangeData:(NSString *)reason
{
    [indActive stopAnimating];
    [UIHelper showAlert:@"Information" message:reason func:^(AlertView *a, NSInteger i) {
        [self backToPeriperialList];
    }];
}
-(void) sensorStatusChange:(NSString *)description
{
    txtActInfo.text = description;
}

@end


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
