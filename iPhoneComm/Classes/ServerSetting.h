//
//  ServerSetting.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/14.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerSetting : NSObject<NSCopying>
{
    NSString *gameName;
    NSString *gameDesc;
    NSString *redSideName;
    NSString *redSideDesc;
    NSString *blueSideName;
    NSString *blueSideDesc;
    NSString *password;
    NSTimeInterval roundTime;
    NSInteger roundCount;
    NSInteger judgeCount;
}

@property (nonatomic,copy) NSString *gameName;
@property (nonatomic,copy) NSString *gameDesc;
@property (nonatomic,copy) NSString *redSideName;
@property (nonatomic,copy) NSString *redSideDesc;
@property (nonatomic,copy) NSString *blueSideName;
@property (nonatomic,copy) NSString *blueSideDesc;
@property (nonatomic,copy) NSString *password;
@property NSInteger roundCount;
@property NSTimeInterval roundTime;
@property NSInteger judgeCount;

-(id) initWithDefault;
-(id) initWithGameName:(NSString *)_gameName andGameDesc:(NSString *)_gameDesc
        andRedSideName:(NSString *)_redSideName andRedSideDesc:(NSString *)_redSideDesc andBlueSideName:(NSString *)_blueSideName andBlueSideDesc:(NSString *)_blueSideDesc andPassword:(NSString *)_password andRoundCount:(NSInteger)_roundCount andRoundTime:(NSTimeInterval)_roundTime;
@end
