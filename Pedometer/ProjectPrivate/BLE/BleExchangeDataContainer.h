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
}ExchangeDataType;
@interface BleExchangeDataContainer : NSObject


@property BOOL isConnectingStart;
@property BOOL isConnectingEnd;
@property (strong,nonatomic) PEDTarget *target;
@property (strong,nonatomic) NSMutableArray *sleepData;
@property (strong,nonatomic) NSMutableArray *pedoData;

@property ExchangeDataType exchageType;
@property NSInteger pedoDataIndex;
@property NSInteger sleepDataIndex;

@end
