//
//  BleServiceInfo.h
//  Pedometer
//
//  Created by JILI Du on 13/3/2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BleServiceInfo : NSObjectSerialization

@property (nonatomic,strong) NSString *deviceName;
@property (nonatomic,strong) NSString *appearance;
@property (nonatomic,strong) NSString *serialNumber;
@property (nonatomic,strong) NSString *manufacture;
@property (nonatomic,strong) NSString *systemID;
@property (nonatomic,strong) NSString *firewareRevision;

@end
