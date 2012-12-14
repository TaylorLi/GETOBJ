//
//  UIGifMarker.h
//  TKD Score
//
//  Created by Eagle Du on 12/10/20.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIGifView : NSObject
{
    NSMutableArray *imgArray;
    NSInteger currentImageIndex;
    NSTimer *transferTimer;
    BOOL isAminmating;
}
@property (nonatomic,strong) NSArray *imageNames;
@property (nonatomic,strong) id btnOrImageView;
@property (nonatomic) NSTimeInterval transferInterval;

-(void)startAnimate;
-(void)stopAnimate;

-(id)initWithImages:(NSArray *)names andDstView:(id)view andInterval:(NSTimeInterval) interval;
-(id)initWithImagePrefiex:(NSString *)imgPrefix imgLowIndex:(NSInteger)low imgHightIndex:(NSInteger)hight andDstView:(id)view andInterval:(NSTimeInterval) interval;
@end
