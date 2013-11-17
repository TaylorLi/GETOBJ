//
//  BleExchangeDataContainer.h
//  Pedometer
//
//  Created by JILI Du on 13/3/3.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ExchangeTypeNone=0,
    ExchangeTypePedoData=1,
    ExchangeTypeSleepData=2,
    ExchangeTypeCurrentData=3,
}ExchangeDataType;

@class PEDPedometerData;

@interface BleExchangeDataContainer : NSObjectSerialization


@property BOOL isConnectingStart;
@property BOOL isConnectingEnd;
@property (strong,nonatomic) PEDTarget *target;
@property (strong,nonatomic) NSMutableDictionary *sleepData;
@property (strong,nonatomic) NSMutableDictionary *pedoData;
@property (strong,nonatomic)PEDPedometerData *currentData;//Current Data中Date部分有效，其他无效

@property ExchangeDataType exchageType;
@property NSInteger pedoDataIndex;
@property NSInteger sleepDataIndex;

@end
