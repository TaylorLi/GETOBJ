//
//  MatchLog.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchLog : NSObject

@property (nonatomic,strong) NSString *logId;
@property (nonatomic,strong) NSString *matchId;
@property (nonatomic) NSInteger round;
@property (nonatomic,strong) NSDate *createTime;
@property (nonatomic,strong) NSString *blueScoreByJudge1;
@property (nonatomic,strong) NSString *blueScoreByJudge2;
@property (nonatomic,strong) NSString *blueScoreByJudge3;
@property (nonatomic,strong) NSString *blueScoreByJudge4;
@property (nonatomic,strong) NSString *redScoreByJudge1;
@property (nonatomic,strong) NSString *redScoreByJudge2;
@property (nonatomic,strong) NSString *redScoreByJudge3;
@property (nonatomic,strong) NSString *redScoreByJudge4;
@property (nonatomic,strong) NSString *events;
@property (nonatomic,strong) NSString *score;
@property (nonatomic) BOOL isSubmitedScore;
@property (nonatomic,strong) NSString *submitedScoreInfo;

@end
