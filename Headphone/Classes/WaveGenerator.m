//
//  WaveGenerator.m
//  Headphone
//
//  Created by JILI Du on 13/3/24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "WaveGenerator.h"

@implementation WaveGenerator

+(NSData *)generatorCmdBytesByOriginCmdByte:(Byte *)bytes withLength:(int)byteLength
{
    
    if(bytes==nil||byteLength==0)
        return nil;
    else{
        NSMutableArray *waveByteArray=[[NSMutableArray alloc] init];
        //添加同步头
        for (int i=0; i<WAVE_HEADER_COUNT; i++) {
            [waveByteArray addObjectsFromArray:[WaveGenerator genWaveEdageArray]];
        }
        int flag=0;//0:产生无载波，1：产生载波
        //正文内容
        for (int i=0; i<byteLength; i++,flag=0) {            
            Byte v=bytes[i];
            int byteBits=sizeof(Byte)*8;
            //对byte进行移位操作，从高到低
            for (int j=0;j<byteBits;j++)
            {
                int bitValue = v>>(byteBits-j-1) & 0x01;
                int count=bitValue==1?WAVE_ONE_FLAG_COUNT:WAVE_ZERO_FLAG_COUNT;
                for(int z=0;z<count;z++){
                    if(flag%2==0)
                        [waveByteArray addObjectsFromArray:[WaveGenerator genPlautArray]];
                    else
                        [waveByteArray addObjectsFromArray:[WaveGenerator genWaveEdageArray]];
                }
                flag++;
            }
        }        //结束信号
        for (int i=0; i<WAVE_END_COUNT; i++) {
            [waveByteArray addObjectsFromArray:[WaveGenerator genPlautArray]];
        }
       long byteBength = waveByteArray.count*2;
        char * bytes  = malloc(sizeof(char) * byteBength);
        long i=0;
        for (NSNumber *signNum in waveByteArray) {
            short num=[signNum shortValue];
            bytes[i++] = (char)(num & 0xff);
            bytes[i++] =  (char)((num >> 8) & 0xff);
            //NSLog(@"num:%i,byte:%i",num,bytes[i-1]);
        }
        NSData *data = [NSData dataWithBytes:bytes length:byteBength];
        
        return data;
    }
}

//产生一个有载波的信息
+(NSArray *)genWaveEdageArray
{
    NSMutableArray *waveByteArray=[[NSMutableArray alloc] init];
    SInt16 hightLevel=WAVE_LogicH1;
    //SInt16 convertHightLevel=WAVE_LogicH2;
    //pi/6*hightLevel
    /*
    我们利用一个基本的正弦波来生成音调。每一个采样点的值通过下面的等式来决定：
    
    f(n) = a sin ( θ(n) )
    
    n代表当前采样的序号，a是幅度，当前的波形的相位θ(n)是：
    
    θ(n) = 2πƒ n / r
     f代表音调频率，r是音频的采样率
    */
    int startAngel=0;
    for (int i=startAngel; i<FLAG_SINAL_COUNT+startAngel; i++) {
        SInt16 currentValue = sinf(M_PI+2*M_PI*i*SIGNAL_RATE/SAMPLE_RATE)*hightLevel;
        [waveByteArray addObject:[NSNumber numberWithShort:currentValue]];
    }
    return  waveByteArray;
}
//产生一个没有载波的周期
+(NSArray *)genPlautArray
{
    NSMutableArray *waveByteArray=[[NSMutableArray alloc] init];
    for (int i=0; i<FLAG_SINAL_COUNT; i++) {
        [waveByteArray addObject:[NSNumber numberWithShort:WAVE_LogicL]];
    }
    return  waveByteArray;
}

+(NSData *)cmdReadUserInfo
{
    Byte cmdByte[4]={02,253,255};
    return [WaveGenerator generatorCmdBytesByOriginCmdByte:cmdByte withLength:4];
}

@end
