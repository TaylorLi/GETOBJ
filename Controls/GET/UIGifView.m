//
//  UIGifMarker.m
//  TKD Score
//
//  Created by Eagle Du on 12/10/20.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "UIGifView.h"
@interface UIGifView (Private)

-(void)updateInterval;
@end

@implementation UIGifView

@synthesize imageNames,btnOrImageView,transferInterval;

-(id)initWithImages:(NSArray *)names andDstView:(id)view andInterval:(NSTimeInterval) interval
{
    self=[super init];
    if(self){
        imageNames=names;
        btnOrImageView=view;
        transferInterval=interval;
        imgArray=[[NSMutableArray alloc] initWithCapacity:imageNames.count];
        for (NSString *name in imageNames) {
            [imgArray addObject:[UIImage imageNamed:name]];
        }
        isAminmating=NO;
    }
    return  self;
}
-(id)initWithImagePrefiex:(NSString *)imgPrefix imgLowIndex:(NSInteger)low imgHightIndex:(NSInteger)hight andDstView:(id)view andInterval:(NSTimeInterval) interval
{
    NSMutableArray *imgNames=[[NSMutableArray alloc] initWithCapacity:6];
    for (int i=low; i<hight+1; i++) {
        [imgNames addObject:[NSString stringWithFormat:@"%@%i.png",imgPrefix, i]];
    }
    return [self initWithImages:imgNames andDstView:view andInterval:interval];
}
-(void)startAnimate
{
    if(!isAminmating){
        isAminmating=YES;
        currentImageIndex = 0;
        transferTimer = [NSTimer scheduledTimerWithTimeInterval: transferInterval/imageNames.count target:self selector:@selector(updateInterval) userInfo:nil repeats:YES];
    }    
}
-(void)stopAnimate
{
    if(isAminmating){
        isAminmating=NO;
        [transferTimer invalidate];
        UIView *view=btnOrImageView;
        view.hidden=YES;
    }
}
-(void)updateInterval
{
    currentImageIndex++;
    currentImageIndex=currentImageIndex%imgArray.count;
    UIImageView *imgView=nil;
    if([btnOrImageView isKindOfClass:[UIImageView class]])
    {
        imgView=btnOrImageView;
    }
    else if([btnOrImageView isKindOfClass:[UIButton class]])
    {
        UIButton *btn= btnOrImageView;
        imgView=btn.imageView;
    }
    if(imgView==nil)
        return;
    else
    {
        imgView.hidden = NO;
        imgView.image=[imgArray objectAtIndex:currentImageIndex];
    }
}
@end
