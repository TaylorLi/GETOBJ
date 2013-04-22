//
//  BO_MatchInfo.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/8.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BOBase.h"

@class  PEDTarget;

@interface BO_PEDTarget: BOBase

+ (BO_PEDTarget*) getInstance;


-(PEDTarget *)queryTargetByUserId:(NSString *)userId;
-(void)clearTargetData:(NSString *)targetId;
-(PEDTarget *)clearBindingDevice:(PEDTarget *)target;

@end
