//
//  SoundsPlayer.m
//  TKD Score
//
//  Created by Eagle Du on 12/8/19.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "SoundsPlayer.h"

@implementation SoundsPlayer

@synthesize avPlayer;

-(id)init
{
    self=[super init];
    if(self){
    }
    return self;
}
-(void)playSoundWithFullPath:(NSString *)fullPath
{
    if([fullPath isEqualToString:@""]||fullPath==nil){
        return;
    }
    NSArray *array= [fullPath componentsSeparatedByString:@"."];
    [self playSoundWithPath:[array objectAtIndex:0] ofType:[array objectAtIndex:1]];
}
-(void)playSoundWithPath:(NSString *)resourcePath ofType:(NSString *)fileType
{
    NSString *soundPath=[[NSBundle mainBundle] pathForResource:resourcePath ofType:fileType];
    if(soundPath==nil)
        return;
    NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
    if(avPlayer==nil){
        avPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
        avPlayer.delegate=self;
    }    
    [avPlayer prepareToPlay]; 
    soundPath=nil;
    [avPlayer play];
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    avPlayer=nil;
}
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    avPlayer=nil;
}
-(void)dealloc{
    avPlayer=nil;
}
@end
