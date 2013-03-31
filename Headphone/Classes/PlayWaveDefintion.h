//
//  PlayWaveDefintion.h
//  Headphone
//
//  Created by JILI Du on 13/3/24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#ifndef Headphone_PlayWaveDefintion_h
#define Headphone_PlayWaveDefintion_h


#define SIGNAL_RATE 5000

#define FLAG_SINAL_COUNT 10//取值点数,采样信号相对与信号的倍数，至少2倍以上才不会失真

#define SAMPLE_RATE  (SIGNAL_RATE * FLAG_SINAL_COUNT)

#define PER_BUFFER_SIZE SAMPLE_RATE*3
#define BUFFER_COUNT 1

#define SAMPLE  SInt16
#define NUM_FRAMES_PER_PACKET 1 
#define NUM_CHANNELS  1
#define BYTES_PER_FRAME  (NUM_CHANNELS * sizeof(SAMPLE))

//波形相关定义
#define WAVE_LogicH1 (pow(2,sizeof(SAMPLE)*8-1)-1) //正高电平
#define WAVE_LogicH2 (pow(2,sizeof(SAMPLE)*8-1)*-1) //负高电平
#define WAVE_LogicL 0//低电平
#define WAVE_WaveActiveDelta (WAVE_LogicH1/(FLAG_SINAL_COUNT/2)) //有效的波形波动幅度
#define WAVE_HEADER_COUNT 20 //一般情况下有两个取点电平波动不到幅度
#define WAVE_ONE_FLAG_COUNT 10 //表示1
#define WAVE_ZERO_FLAG_COUNT 5 //表示0
#define WAVE_END_COUNT 20

#endif
