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

- (void)fightimeReached:(UIFighterBox *)fighterbox;
@end

@interface UIFighterBox : UIView
{
    NSTimer *calcTimer;
}
@property (strong, nonatomic) IBOutlet UIImageView *imgTen;
@property (strong, nonatomic) IBOutlet UIImageView *imgSin;

@property(assign,nonatomic) NSArray *imgArray;
@property(assign,nonatomic) NSInteger fightTime;

@property (assign) id<UIFighterBoxDelegate> delegate;

-(void)drawRemainTime:(NSTimeInterval)time;
- (id)initWithFightTime:(CGRect)frame time:(NSInteger) fightTimeInv andImgArray:(NSArray *)imgs;
-(void) hide;
-(void) showWithFightTime:(NSInteger) fightTimeInv;
@end
