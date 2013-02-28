//
//  BO_MatchInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOBase.h"
@class PEDUserInfo;

@interface BO_PEDUserInfo : BOBase

+ (BO_PEDUserInfo*) getInstance;

-(PEDUserInfo *) retreiveCurrentUser;

//-(NSArray *)queryLogByMatchId:(NSString *)matchId andRoundSeq:(NSInteger) roundSeq;
-(PEDUserInfo *) retreiveUserByName:(NSString *)name;
-(BOOL) updateUserProfileNotToBeCurrent;
@end
