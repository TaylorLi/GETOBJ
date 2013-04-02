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
-(void) addExchangeLog:(NSString *) logDetail;
-(void)sendBeginExchangeData;
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
@synthesize txtExchangeLog;
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
    [self setTxtExchangeLog:nil];
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
    exchangeDebuglog=[[NSMutableString alloc] init];
    txtExchangeLog.text=exchangeDebuglog;
    self.exchangeContainer=[[BleExchangeDataContainer alloc] init];
    [self sendBeginExchangeData];
    //[self sendSettingDataWithType:DATA_HEADER_PEDO_SETTING_RQ];
}

-(void) addExchangeLog:(NSString *) logDetail{
    [exchangeDebuglog appendFormat:@"%@ %@\n",[UtilHelper formateTime:[NSDate date]],logDetail];
    txtExchangeLog.text=exchangeDebuglog;
}
-(void)sensorReadyToExchangeData
{
    //[indActive stopAnimating];
    //indActive.hidden=YES;
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
    NSLog(@"Send Data:%@",[packet hexRepresentationWithSpaces_AS:YES]);
    [self addExchangeLog:[NSString stringWithFormat:@"Send Data:%@",[packet hexRepresentationWithSpaces_AS:YES]]];
}
-(void)sendBeginExchangeData
{
    if(exchangeTimer){
        [exchangeTimer invalidate];
    }
    PEDUserInfo *userInfo=[[AppConfig getInstance].settings.userInfo copy];
    //userInfo始终存的是metric类型的数据
    /*
    if(userInfo.measureFormat==MEASURE_UNIT_ENGLISH){
        [userInfo convertUnit:MEASURE_UNIT_METRIC];
    }
    */
    packetPedoSetting setting;
    setting.age=(unsigned char)userInfo.age;
    setting.format=userInfo.measureFormat==MEASURE_UNIT_METRIC?0:1;
    setting.gender=userInfo.gender?1:0;
    setting.height=(unsigned short)userInfo.height;
    setting.stride=(unsigned short)userInfo.stride;
    setting.weight=(unsigned short)userInfo.weight;
    setting.header=DATA_HEADER_PEDO_SETTING_RQ;
    [self sendDataToPeriperial:&setting ofLength:sizeof(packetPedoSetting)];
    exchangeTimer = [NSTimer scheduledTimerWithTimeInterval:BLE_DATA_TRANSFER_TIMEOUT target:self selector:@selector(exchangeTimeout:) userInfo:nil repeats:NO];
}
-(void)sendSettingDataWithType:(DataHeaderType)headerType
{
    if(exchangeTimer){
        [exchangeTimer invalidate];
    }
    packetPedoHeader header;    
    header.header = headerType;
    [self sendDataToPeriperial:&header ofLength:sizeof(packetPedoHeader)];
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
    PEDUserInfo *userInfo=[AppConfig getInstance].settings.userInfo;
    unsigned char *incomingPacket = (unsigned char *)[data bytes];
    packetTargetData *packet = (packetTargetData *)&incomingPacket[0];	
    PEDTarget *target=[[PEDTarget alloc] init];
    /*
     5, TARGET 的目标距离是用STRIDE X 目标步数
     
     例如: STRIDE = 50CM, 目标步数是10000, 目标距离= 10000 X 50 / 100000 = 50KM
     
     6, TARGET 的目标卡路里可按目标步数和余下步数的比例,
     
     例如: 接收到余下卡路里=401, 目标步数是10000, 余下步数是3878, 目标卡路里= 10000/3878 X 401 = 1034
     */
    target.targetStep=packet->targetStep[0]+packet->targetStep[1]*16*16+packet->targetStep[2]*16*16*16*16;
    target.targetDistance=[PEDPedometerCalcHelper calDistanceByStep:target.targetStep stride:userInfo.stride];    
    target.remainStep=packet->remainStep[0]+packet->remainStep[1]*16*16+packet->remainStep[2]*16*16*16*16;
    target.remainDistance=(NSTimeInterval)((packet->remainDistance[0]+packet->remainDistance[1]*16*16+packet->remainDistance[2]*16*16*16*16))/100;
    target.remainCalorie=packet->remainCalorie[0]+packet->remainCalorie[1]*16*16+packet->remainCalorie[2]*16*16*16*16;
    target.targetCalorie=target.targetStep / target.remainStep * target.remainCalorie;
    target.pedoDataCount = packet->pedoMemoryNo;
    target.sleepDataCount=packet->pedoSleepMemNo;
    target.updateDate=[NSDate date];
    //checking
    return target;
}

-(PEDPedometerData *)convertDataToPedoData:(NSData *)data
{
    unsigned char *incomingPacket = (unsigned char *)[data bytes];
    packetPedoData *packet = (packetPedoData *)&incomingPacket[0];	
    PEDPedometerData *pedoData=[[PEDPedometerData alloc] init];
    pedoData.activeTime=[[NSString stringWithFormat:@"%2x",packet->activityTimeHour] intValue]*3600+[[NSString stringWithFormat:@"%2x",packet->activityTimeMin] intValue]*60;
    pedoData.calorie=packet->calorie[0]+packet->calorie[1]*16*16+packet->calorie[2]*16*16*16*16;
    pedoData.distance=(NSTimeInterval)(packet->distance[0]+packet->distance[1]*16*16+packet->distance[2]*16*16*16*16)/100;
    pedoData.step=packet->step[0]+packet->step[1]*16*16+packet->step[2]*16*16*16*16;
    pedoData.optDate=[UtilHelper convertDate:[NSString stringWithFormat:@"20%2x-%2x-%2x",packet->year,packet->month,packet->day]];
    return pedoData;
}
-(PEDSleepData *)convertDataToSleepData:(NSData *)data
{
    unsigned char *incomingPacket = (unsigned char *)[data bytes];
    packetSleepData *packet = (packetSleepData *)&incomingPacket[0];	
    PEDSleepData *sleepData=[[PEDSleepData alloc] init];
    sleepData.optDate=[UtilHelper convertDate:[NSString stringWithFormat:@"20%2x-%2x-%2x",packet->year,packet->month,packet->day]];
    sleepData.timeToBed=[[NSString stringWithFormat:@"%2x",packet->timeToBedHour] intValue]*3600+[[NSString stringWithFormat:@"%2x",packet->timeToBedMin] intValue]*60;
    sleepData.timeToFallSleep=[[NSString stringWithFormat:@"%2x",packet->timeToFallSleepHour] intValue]*3600+[[NSString stringWithFormat:@"%2x",packet->timeToFallSleepMin] intValue]*60;
    sleepData.timeToWakeup=[[NSString stringWithFormat:@"%2x",packet->timeToWakeupHour] intValue]*3600+[[NSString stringWithFormat:@"%2x",packet->timeToWakeupMin] intValue]*60;
    sleepData.inBedTime=[[NSString stringWithFormat:@"%2x",packet->inBedTimeHour] intValue]*3600+[[NSString stringWithFormat:@"%2x",packet->inBedTimeMin] intValue]*60;
    sleepData.actualSleepTime=[[NSString stringWithFormat:@"%2x",packet->actualSleepTimeHour] intValue]*3600+[[NSString stringWithFormat:@"%2x",packet->actualSleepTimeMin] intValue]*60;
    sleepData.awakenTime=packet->awakenTime;
    return sleepData;
}

-(void) serialGATTCharValueUpdated:(NSString *)UUID value:(NSData *)data
{    
    unsigned char *incomingPacket = (unsigned char *)[data bytes];
    DataHeaderType header = (DataHeaderType)incomingPacket[0];
    //NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSLog(@"Receive Notify,data:%@",[data hexRepresentationWithSpaces_AS:YES]);
    [self addExchangeLog:[NSString stringWithFormat:@"Receive Notify,data:%@",[data hexRepresentationWithSpaces_AS:YES]]];
    if (header == DATA_HEADER_PEDO_SETTING_TARGET_RS) {
        [self cancelExchangeTimer];
        PEDTarget *target= [self convertDataToTarget:data];
        if(target){
            txtActInfo.text=@"Received target data."; 
            //NSLog(@"Receive Notify:UUID:%@,Target data:%@",UUID,target);
            exchangeContainer.target=target;
            if(target.pedoDataCount>0){
                exchangeContainer.exchageType=ExchangeTypePedoData;
                exchangeContainer.pedoDataIndex++;
                txtActInfo.text=[NSString stringWithFormat: @"Request pedometer data:%i.",exchangeContainer.pedoDataIndex+1]; 
                [self addExchangeLog:[NSString stringWithFormat: @"Request pedometer data:%i.",exchangeContainer.pedoDataIndex+1]];
                [self sendSettingDataWithType:DATA_HEADER_PEDO_DATA_1_RQ+exchangeContainer.pedoDataIndex];
            }    
            else if(target.sleepDataCount>0){
                exchangeContainer.exchageType=ExchangeTypeSleepData;
                exchangeContainer.sleepDataIndex++;
                txtActInfo.text=[NSString stringWithFormat: @"Request sleep data:%i.",exchangeContainer.sleepDataIndex+1];
                [self addExchangeLog:[NSString stringWithFormat: @"Request sleep data:%i.",exchangeContainer.sleepDataIndex+1]];
                [self sendSettingDataWithType:DATA_HEADER_SLEEP_DATA_1_RQ+exchangeContainer.sleepDataIndex];
            }
            else{
                exchangeContainer.isConnectingEnd=YES;
            }               
        }
        else{
            [self failToExchangeData:@"Invalid data format,connection will be terminated."];
        }        
    }
    else if(header>=DATA_HEADER_PEDO_DATA_1_RS&&header<DATA_HEADER_PEDO_DATA_1_RS+exchangeContainer.target.pedoDataCount){
        [self cancelExchangeTimer];
        PEDPedometerData *pedoData=[self convertDataToPedoData:data];
        if(pedoData){
            int dataSeq=header-DATA_HEADER_PEDO_DATA_1_RS;//以0为开始序号
            NSString *dataSeqKey=[NSString stringWithFormat:@"%i",dataSeq];
            if([exchangeContainer.pedoData containKey:dataSeqKey]){
                txtActInfo.text=[NSString stringWithFormat: @"Repeatly received pedometer data:%i,ignored.",dataSeq+1];
                [self addExchangeLog:[NSString stringWithFormat: @"Repeatly received pedometer data:%i,ignored.",dataSeq+1]];
                NSLog(@"Repeatly Received pedometer data:%i,ignored",dataSeq+1);
            }
            else{
                txtActInfo.text=[NSString stringWithFormat: @"Received pedometer data:%i.",dataSeq+1];
                [self addExchangeLog:[NSString stringWithFormat: @"Received pedometer data:%i.",dataSeq+1]];
                NSLog(@"Received pedometer data:%i.",dataSeq+1);
                
                //NSLog(@"Receive Notify:UUID:%@,Pedometer data:%@",UUID,pedoData);
                [exchangeContainer.pedoData setValue:pedoData forKey:dataSeqKey];
                exchangeContainer.pedoDataIndex++;
                if(exchangeContainer.pedoDataIndex>=exchangeContainer.target.pedoDataCount)
                {
                    if(exchangeContainer.target.sleepDataCount>0){
                        exchangeContainer.sleepDataIndex++;
                        [self addExchangeLog:[NSString stringWithFormat: @"Request sleep data:%i.",exchangeContainer.sleepDataIndex+1]];
                        txtActInfo.text=[NSString stringWithFormat: @"Request sleep data:%i.",exchangeContainer.sleepDataIndex+1];
                        txtActInfo.text=[NSString stringWithFormat: @"Request sleep data data:%i.",exchangeContainer.sleepDataIndex+1];
                        [self sendSettingDataWithType:DATA_HEADER_SLEEP_DATA_1_RQ+exchangeContainer.sleepDataIndex];
                    }
                    else{
                        exchangeContainer.isConnectingEnd=YES;
                    }
                }
                else{                
                    NSLog(@"Request pedometer data:%i,Header:%2x.",exchangeContainer.pedoDataIndex+1,DATA_HEADER_PEDO_DATA_1_RQ+exchangeContainer.pedoDataIndex);
                    [self addExchangeLog:[NSString stringWithFormat: @"Request pedometer data:%i.",exchangeContainer.pedoDataIndex+1]];
                    txtActInfo.text=[NSString stringWithFormat: @"Request pedometer data:%i.",exchangeContainer.pedoDataIndex+1]; 
                    [self sendSettingDataWithType:DATA_HEADER_PEDO_DATA_1_RQ+exchangeContainer.pedoDataIndex];
                }
            } 
        }
        else{
            [self failToExchangeData:@"Invalid data format,connection will be terminated."];
        }
    }
    else if(header>=DATA_HEADER_SLEEP_DATA_1_RS&&header<DATA_HEADER_SLEEP_DATA_1_RS+exchangeContainer.target.sleepDataCount)
    {        
        [self cancelExchangeTimer];
        PEDSleepData *sleepData=[self convertDataToSleepData:data];
        //NSLog(@"Receive Notify:UUID:%@,Sleep data:%@",UUID,sleepData);
        if(sleepData){
            int dataSeq=header-DATA_HEADER_SLEEP_DATA_1_RS;//以0为开始序号
            NSString *dataSeqKey=[NSString stringWithFormat:@"%i",dataSeq];
            if([exchangeContainer.sleepData containKey:dataSeqKey]){
                [self addExchangeLog:[NSString stringWithFormat: @"Repeatly received sleep data:%i,ignored.",dataSeq+1]];
                txtActInfo.text=[NSString stringWithFormat: @"Repeatly received sleep data:%i,ignored.",dataSeq+1];
            }
            else{
                [self addExchangeLog:[NSString stringWithFormat: @"Received sleep data:%i.",dataSeq+1]];
                txtActInfo.text=[NSString stringWithFormat: @"Received sleep data:%i.",dataSeq+1];
                [exchangeContainer.sleepData setValue:sleepData forKey:dataSeqKey];
                exchangeContainer.sleepDataIndex++;
                if(exchangeContainer.sleepDataIndex>=exchangeContainer.target.sleepDataCount)
                {
                    exchangeContainer.isConnectingEnd=YES;
                }
                else{                
                    [self addExchangeLog:[NSString stringWithFormat: @"Request sleep data:%i.",exchangeContainer.sleepDataIndex+1]];
                    txtActInfo.text=[NSString stringWithFormat: @"Request sleep data:%i.",exchangeContainer.sleepDataIndex+1];
                    [self sendSettingDataWithType:DATA_HEADER_SLEEP_DATA_1_RQ+exchangeContainer.sleepDataIndex];
                }
            }
        }
        else{
            [self failToExchangeData:@"Invalid data format,connection will be terminated."];
        }
    }
    [self testExchangeDataEnd];
}

-(void)testExchangeDataEnd
{
    if(exchangeContainer.isConnectingEnd){
        [self sendSettingDataWithType:DATA_HEADER_END_CONNECT_RQ];
        //test data
        [self finishConnection];
        [self saveExchangeDataToDatabase];
    }
}

-(void)saveExchangeDataToDatabase
{
    BOOL success=YES;
    //判断是否有效数据交互
    if(!exchangeContainer.target){
        [self failToExchangeData:@"Invalid target data,connection will be terminated."];
        return;
    }
    if(exchangeContainer.target.pedoDataCount!=exchangeContainer.pedoData.count){
        [self failToExchangeData:@"Pedo data count did not match the declare count,connection will be terminated."];
        return;
    }
    for(int i=DATA_HEADER_PEDO_DATA_1_RS;i<exchangeContainer.target.pedoDataCount;i++){
        if(![exchangeContainer.pedoData containKey:[NSString stringWithFormat:@"%i",i]]){
            [self failToExchangeData:[NSString stringWithFormat:@"Pedo data %i not existed,connection will be terminated.",
                                      i-DATA_HEADER_PEDO_DATA_1_RS+1]];
            return;  
        }
    }
    for(int i=DATA_HEADER_SLEEP_DATA_1_RQ;i<exchangeContainer.target.sleepDataCount;i++){
        if(![exchangeContainer.sleepData containKey:[NSString stringWithFormat:@"%i",i]]){
            [self failToExchangeData:[NSString stringWithFormat:@"Sleep data %i not existed,connection will be terminated.",
                                      i-DATA_HEADER_SLEEP_DATA_1_RQ+1]];
            return;  
        }
    }
    if(exchangeContainer.target.sleepDataCount!=exchangeContainer.sleepData.count){
        [self failToExchangeData:@"Sleep data count did not match the declare count,connection will be terminated."];
        return;
    }    
    
    txtActInfo.text=@"Save data to local...";
    PEDUserInfo *user =[AppConfig getInstance].settings.userInfo;
    if(exchangeContainer.target){
        PEDTarget *target =  [[BO_PEDTarget getInstance] queryTargetByUserId:user.userId];
        if(target){
            exchangeContainer.target.userId=user.userId;
            exchangeContainer.target.targetId=target.targetId;
            target=exchangeContainer.target;               
        }
        else{
            exchangeContainer.target.userId=user.userId;
            exchangeContainer.target.targetId = [UtilHelper stringWithUUID];
            target=exchangeContainer.target;
        }
        [[BO_PEDTarget getInstance] saveObject:target];
        [AppConfig getInstance].settings.target=target;
    }
    for (PEDPedometerData *data in exchangeContainer.pedoData.allValues) {
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
    for(PEDSleepData *data in exchangeContainer.sleepData.allValues){
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
            data.targetId=exchangeContainer.target.targetId;
            sleepData=data;
        }        
        [[BO_PEDSleepData getInstance] saveObject:sleepData];
    }
    if(success)
        txtActInfo.text=@"Success to import data.";
    else
        txtActInfo.text=@"Fail save data to local.";
    if(success){
        [self successToExchangeData:@"Success to import data."];
    }
    else{
        [self failToExchangeData:@"Fail to import data to database."];
    }
}

-(void)backToPeriperialList
{
    [self finishConnection];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) finishConnection
{
    @try {
        [indActive stopAnimating];
        indActive.hidden=YES;
        [sensor cancelTimer];
        [self cancelExchangeTimer];
        [sensor disconnect:sensor.activePeripheral];
        sensor.activePeripheral=nil;
        sensor.delegate=parentController;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception %@",exception);
    }
    @finally {
        
    }
}
-(void) failToExchangeData:(NSString *)reason
{
    [self finishConnection];
    [UIHelper showAlert:@"Information" message:reason func:^(AlertView *a, NSInteger i) {
        //[self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
-(void) successToExchangeData:(NSString *)tip
{
    [UIHelper showAlert:@"Information" message:tip func:^(AlertView *a, NSInteger i) {
        //[self.navigationController popToRootViewControllerAnimated:YES];
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
