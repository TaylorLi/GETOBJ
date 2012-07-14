//
//  ServerSetting.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/14.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerSetting : NSObject
{
    NSString *gameName;
    NSString *gameDesc;
    NSString *redSideName;
    NSString *redSideDesc;
    NSString *blueSideName;
    NSString *blueSideDesc;
    NSString *password;
    NSTimeInterval *roundTime;
    NSInteger roundCount;
}

@property (nonatomic,copy) NSString *gameName;
@property (nonatomic,copy) NSString *gameDesc;
@property (nonatomic,copy) NSString *redSideName;
@property (nonatomic,copy) NSString *redSideDesc;
@property (nonatomic,copy) NSString *blueSideName;
@property (nonatomic,copy) NSString *blueSideDesc;
@property (nonatomic,copy) NSString *password;
@property NSInteger roundCount;
@property NSTimeInterval *roundTime;
@end
