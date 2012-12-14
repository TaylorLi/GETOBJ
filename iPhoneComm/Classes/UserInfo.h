//
//  UserInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/4.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObjectSerialization<SqliteORMDelegate>

@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *pwd;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSDate *createTime;
@end
