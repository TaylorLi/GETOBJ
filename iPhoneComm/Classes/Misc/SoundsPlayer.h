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
    
}
@property (nonatomic,strong)AVAudioPlayer *avPlayer;
-(void)playSoundWithPath:(NSString *)resourcePath ofType:(NSString *)fileType;
-(void)playSoundWithFullPath:(NSString *)fullPath; 
@end
