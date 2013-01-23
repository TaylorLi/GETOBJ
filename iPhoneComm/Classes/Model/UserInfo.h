//
//  UserInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/4.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObjectSerialization<SqliteORMDelegate>

@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *pwd;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,strong) NSDate *createTime;
@end
