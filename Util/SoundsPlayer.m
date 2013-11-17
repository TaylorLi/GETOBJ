//
//  SoundsPlayer.m
//  TKD Score
//
//  Created by Eagle Du on 12/8/19.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "SoundsPlayer.h"

@interface SoundsPlayer ()
-(void)replay;
@end

@implementation SoundsPlayer

@synthesize avPlayer,repeatCount,fullLoopInterval;

-(id)init
{
    self=[super init];
    if(self){
        repeatCount = 0;
        fullLoopInterval = -1;
    }
    return self;
}
-(void)playSoundWithFullPath:(NSString *)fullPath
{
    if([fullPath isEqualToString:@""]||fullPath==nil){
        return;
    }
    playFilePath=fullPath;
    NSArray *array= [fullPath componentsSeparatedByString:@"."];
    [self playSoundWithPath:[array objectAtIndex:0] ofType:[array objectAtIndex:1]];
}
-(void)playSoundWithPath:(NSString *)resourcePath ofType:(NSString *)fileType
{
    if(isPlaying){
        [self stop];
    }
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:resourcePath ofType:fileType];
    if(soundPath==nil)
        return;
    NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
    if(avPlayer==nil){
        avPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        avPlayer.delegate=self;
    }    
    avPlayer.numberOfLoops=repeatCount;
    [avPlayer prepareToPlay]; 
    soundPath=nil;
    isPlaying = YES;
    [avPlayer play];
}
-(void)stop
{
    [repeatPlayTimer invalidate];
    repeatPlayTimer=nil;
    [avPlayer stop];
    isPlaying = NO;
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(fullLoopInterval==-1){
        isPlaying = NO;
        avPlayer=nil;
    }
    else{
       repeatPlayTimer = [NSTimer scheduledTimerWithTimeInterval:fullLoopInterval target:self selector:@selector(replay) userInfo:nil repeats:NO];
        [repeatPlayTimer fire];
    }
}
-(void)replay
{
    [avPlayer prepareToPlay]; 
    [avPlayer play];
    //[self playSoundWithFullPath:playFilePath];
}
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    avPlayer=nil;
    isPlaying = NO;
}
-(void)dealloc{
    avPlayer=nil;
}
@end
