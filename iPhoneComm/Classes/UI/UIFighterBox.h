//
//  UIFighterBox.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/16.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIFighterBox;
@protocol UIFighterBoxDelegate <NSObject>
//时间到
- (void)fightimeReached:(UIFighterBox *)fighterbox;
//时间到，用户选择加警告
- (void)fightimeEndAndAddWarmning:(UIFighterBox *)fighterbox;
@end

@interface UIFighterBox : UIView
{
    NSTimer *calcTimer;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgTen;
@property (strong, nonatomic) IBOutlet UIImageView *imgSin;

@property (strong, nonatomic) IBOutlet UIButton *btnClose;
@property (strong, nonatomic) IBOutlet UIButton *btnWarmning;

@property(assign,nonatomic) NSArray *imgArray;
@property(assign,nonatomic) NSInteger fightTime;

@property (assign) id<UIFighterBoxDelegate> delegate;

-(void)drawRemainTime:(NSTimeInterval)time;
- (id)initWithFightTime:(CGRect)frame time:(NSInteger) fightTimeInv andImgArray:(NSArray *)imgs;
-(void) hide;
-(void) showWithFightTime:(NSInteger) fightTimeInv;
- (IBAction)closeFighterBox:(id)sender;
- (IBAction)addWarmning:(id)sender;
@end
