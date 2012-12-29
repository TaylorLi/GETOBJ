//
//  RoundRestTimeViewController.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/24.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UATitledModalPanel.h"
#import "UIGifView.h"

@interface RoundRestTimeViewController : UAModalPanel
{
    IBOutlet UIView	*viewLoadedFromXib;
    NSTimer *timer;
    NSTimeInterval restTime;
    NSMutableArray *timeFlags;
    UIGifView *startGifView;
}

@property (nonatomic, strong) IBOutlet UIView *viewLoadedFromXib;
@property (strong, nonatomic) IBOutlet UIButton *btnStart;
@property (strong,nonatomic) id relatedData;
@property (strong, nonatomic) IBOutlet UIImageView *imgTimeMin;
@property (strong, nonatomic) IBOutlet UIImageView *imgTimeSecTen;
@property (strong, nonatomic) IBOutlet UIImageView *imgTimeSecSin;
- (IBAction)startRound:(id)sender;
-(void)setTimerStop:(BOOL) stop;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;

@property (strong, nonatomic) IBOutlet UILabel *lblTime;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title andRestTime:(NSTimeInterval) _restTime;
-(void)drawTime:(NSTimeInterval)time;
@end
