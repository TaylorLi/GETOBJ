//
//  AppSetting.h
//  TKD Score
//
//  Created by Eagle Du on 13/1/2.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSetting : NSObjectSerialization<NSCopying,NSCoding>

@property (nonatomic,strong) NSString *enctryProductSN;
@property (nonatomic,strong) NSDate *lastProductSNValidateDate;
@property (nonatomic,strong) NSString *productSN;
@property (nonatomic,strong) NSString *registerEmail;
@property (nonatomic,strong) NSString *registerUsername;

@end
