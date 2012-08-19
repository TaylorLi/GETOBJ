//
//  d.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/22.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "UtilHelper.h"

@implementation UtilHelper
+(NSString *)formateTime:(NSDate *)date;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //[dateFormatter setDateFormat:@"hh:mm:ss"]
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *d= [dateFormatter stringFromDate:[NSDate date]];
    return d;
}
+(void)playSoundWithPath:(NSString *)resourcePath ofType:(NSString *)fileType
{
    AVAudioPlayer *player; 
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:resourcePath ofType:fileType];
    NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
    player=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [player prepareToPlay]; 
    soundPath=nil;
    [player play];
}
@end
