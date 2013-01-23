//
//  ServerRelateInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/16.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerRelateInfo : NSObject

@property (nonatomic,copy) NSString *peerId;
@property (nonatomic,copy) NSString *sessionId;
//"TKDScore||SERVER||UUID||DISPLAYNAME||PASSWORD"
@property (nonatomic,copy) NSString *orgSeverName;
@property (nonatomic,copy) NSString *displaySeverName;
@property (nonatomic,copy) NSString *password;
@property(nonatomic,strong) NSDate *createTime;
@property (nonatomic,copy)NSString *uuid;
@end
