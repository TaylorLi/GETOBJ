//
//  RoundRestTimeViewController.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/24.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UATitledModalPanel.h"

@interface RoundRestTimeViewController : UATitledModalPanel
{
    IBOutlet UIView	*viewLoadedFromXib;
    NSTimer *timer;
    NSTimeInterval restTime;
}

@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (retain, nonatomic) IBOutlet UIButton *btnStart;
- (IBAction)startRound:(id)sender;
-(void)setTimerStop:(BOOL) stop;

@property (retain, nonatomic) IBOutlet UILabel *lblTime;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title andRestTime:(NSTimeInterval) _restTime;

@end
