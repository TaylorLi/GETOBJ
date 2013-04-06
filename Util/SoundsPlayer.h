//
//  SoundsPlayer.h
//  TKD Score
//
//  Created by Eagle Du on 12/8/19.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h> 

@interface SoundsPlayer : NSObject<AVAudioPlayerDelegate>
{
    NSTimer *repeatPlayTimer;
    BOOL isPlaying;
    NSString *playFilePath;
}
@property (nonatomic,strong)AVAudioPlayer *avPlayer;
@property (nonatomic) NSInteger repeatCount;//单曲播放循环次数
@property (nonatomic) NSTimeInterval fullLoopInterval;//完全循环间歇时间

-(void)playSoundWithPath:(NSString *)resourcePath ofType:(NSString *)fileType;
-(void)playSoundWithFullPath:(NSString *)fullPath; 
-(void)stop;

@end
