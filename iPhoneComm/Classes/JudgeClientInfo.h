//
//  JudgeClientInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/21.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JudgeClientInfo : NSObject


@property (nonatomic,copy) NSString *peerId;
@property (nonatomic,copy) NSString *sessionId;
@property (nonatomic,copy) NSString *displayName;
@property (nonatomic,copy) NSString *uuid;
@property BOOL hasConnected;
@property (nonatomic,retain) NSDate *lastHeartbeatDate;

-(id) initWithSessionId:(NSString*) _sessionId andDisplayName:(NSString *)_displayName
                andUuid:(NSString *) _uuid andPeerId:(NSString *)_peerId;
-(id)initWithDictionary:(NSDictionary *) disc;

@end
