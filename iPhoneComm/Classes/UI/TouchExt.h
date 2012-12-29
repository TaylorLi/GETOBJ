//
//  TouchExt.h
//  TKD Score
//
//  Created by Yuheng Li on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchExt : NSObject
@property (nonatomic, retain) id touchObj;
@property (nonatomic) CGPoint beginPoint;
@property (nonatomic) UITouchPhase touchPhase;
@property (nonatomic) Boolean isAddedToScores;

- (id)init;
- (id)initWithTouch:(UITouch*)touch pointInView:(CGPoint)point;
@end
