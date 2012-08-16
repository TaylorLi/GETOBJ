//
//  TouchExt.m
//  TKD Score
//
//  Created by Yuheng Li on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TouchExt.h"

@implementation TouchExt

@synthesize touchObj;
@synthesize beginPoint;
@synthesize touchPhase;
@synthesize isSendFinish;

- (id)init
{
    return [self initWithTouch:nil pointInView:CGPointMake(-10.0, -10.0)];
}

- (id)initWithTouch:(UITouch*)touch pointInView:(CGPoint)point
{
    self = [super init];
    if (self) {
        touchObj = touch;
        beginPoint = point;
        touchPhase = touch.phase;
        isSendFinish = NO;
    }
    return self;
}

- (void)dealloc {
    touchObj = nil;
    //[touchObj release];
    //[super dealloc];
}

@end
