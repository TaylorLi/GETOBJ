//
//  DefinedUIApplication.h
//  TKD Score
//
//  Created by Eagle Du on 12/9/6.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#define TEST_KEY_REPEATE_PRESS_INTEVAL 0.1

@interface DefinedUIApplication : UIApplication
{
    //short lastPressKeyCode;
    //NSTimer *keyRepeatTimer;
    NSMutableDictionary *lastPressKeyAndRepeatTestTimers;
}

-(void) keyPressRepeatTest:(NSTimer *)timer;

@end
