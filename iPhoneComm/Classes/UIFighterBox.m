//
//  UIFighterBox.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/16.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "UIFighterBox.h"

@implementation UIFighterBox
@synthesize imgTen;
@synthesize imgSin,fightTime,imgArray,delegate;

- (id)initWithFightTime:(CGRect)frame time:(NSInteger) fightTimeInv andImgArray:(NSArray *)imgs
{
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        fightTime=fightTimeInv;
        imgArray=imgs;        
    }
    return self;
}

#pragma mark - View lifecycle

-(void)fightTimeLoop
{
    fightTime--;
    [self drawRemainTime:fightTime];
    if(fightTime<=0){
        [calcTimer invalidate];        
        if (delegate && [delegate respondsToSelector:@selector(fightimeReached:)]) {
            [delegate fightimeReached:self];
            self.hidden=YES;
        }
        else{
            self.hidden=YES;
        }
    }
    else{        
        
    }    
}


-(void)drawRemainTime:(NSTimeInterval)time{
    //int min = time/60;
    int sec=(int)time%60;
    int secSin=sec%10;
    int secTen=sec/10; 
    imgTen.image=[imgArray objectAtIndex:secTen];
    imgSin.image=[imgArray objectAtIndex:secSin];
}

-(void) hide
{
    if(!self.hidden){
        self.hidden=YES;
        if(calcTimer.isValid){
            [calcTimer invalidate];
        }
    }
}

-(void) showWithFightTime:(NSInteger) fightTimeInv
{
    self.hidden=NO;
    fightTime = fightTimeInv;
    [self drawRemainTime:fightTime];
    if(calcTimer.isValid)
        [calcTimer invalidate];
    calcTimer =[NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(fightTimeLoop) userInfo:nil repeats:YES];
}
@end
