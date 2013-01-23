//
//  UIFighterBox.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/16.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "UIFighterBox.h"
#import "UIHelper.h"

@implementation UIFighterBox
@synthesize imgTen;
@synthesize imgSin,fightTime,imgArray,delegate,btnWarmning,btnClose;

- (id)initWithFightTime:(CGRect)frame time:(NSInteger) fightTimeInv andImgArray:(NSArray *)imgs
{
    self = [super initWithFrame:frame];
    if (self) {
        [UIHelper setColorOfButtons:[[NSArray alloc] initWithObjects:btnClose, nil]  red:144 green:144 blue:144 alpha:0.8];
        [UIHelper setColorOfButtons:[[NSArray alloc] initWithObjects:btnWarmning, nil]  red:15 green:220 blue:15 alpha:0.8];
        // Custom initialization
        fightTime=fightTimeInv;
        imgArray=imgs;  
        btnClose.hidden=YES;
        btnWarmning.hidden=YES;
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
        btnWarmning.hidden=NO;
        btnClose.hidden=NO;
        imgSin.hidden=YES;
        imgTen.hidden=YES;
        if (delegate && [delegate respondsToSelector:@selector(fightimeReached:)]) {
            [delegate fightimeReached:self];
        }
        else{
           
        }
        // self.hidden=YES;
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
    btnWarmning.hidden=YES;
    btnClose.hidden=YES;
    imgSin.hidden=NO;
    imgTen.hidden=NO;
    fightTime = fightTimeInv;
    [self drawRemainTime:fightTime];
    if(calcTimer.isValid)
        [calcTimer invalidate];
    calcTimer =[NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(fightTimeLoop) userInfo:nil repeats:YES];
}

- (IBAction)closeFighterBox:(id)sender
{
    self.hidden=YES;
}
- (IBAction)addWarmning:(id)sender
{
    self.hidden=YES;
    if (delegate && [delegate respondsToSelector:@selector(fightimeEndAndAddWarmning:)]) {
        [delegate fightimeEndAndAddWarmning:self];
    }
}
@end
