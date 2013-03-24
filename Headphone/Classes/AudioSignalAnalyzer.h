//
//  AudioSignalAnalyzer.h
//  iNfrared
//
//  Created by George Dean on 11/28/08.
//  Copyright 2008 Perceptive Development. All rights reserved.
//

#import "AudioQueueObject.h"
#import "PatternRecognizer.h"

//#define DETAILED_ANALYSIS
/*
 
 Type DB
 waveBuff(44100 * 1.4)   As Byte         '波形缓存
 waveContent             As Long
 codeBuff(1023)          As Byte         '码缓存
 codeContent             As Integer      '数据总长度
 Operation               As Byte         '本次操作命令记录
 again                   As Byte         '重操作次数,实现可靠性
 codeBackup(256)         As Byte         '备份码数据,用于重复操作
 recTimeBkp              As Single       '录音时间长度备份
 End Type
 Public soundStream          As DB           '基于声卡操作的数据流
*/
typedef struct
{
    SInt16 *waveBuff;
    unsigned long waveContent;
	Byte codeBuff[1024];
    int codeContent;
    int operation;
    int again;
    Byte codeBackup[256];
    float recTimeBkp;
}analyzerData;

typedef enum {
    WaveDecodeSuccess=0,//正确解码
    WaveDecodeNoHeader=1,//没收到正确的同步头
    WaveDecodeNoCorrectVerify=2//奇偶校验出错
}WaveDecodeResult;

@interface AudioSignalAnalyzer : AudioQueueObject {
	BOOL	stopping;
	analyzerData pulseData;
	NSMutableArray* recognizers;
}

@property (readwrite) BOOL	stopping;
@property (readonly) analyzerData* pulseData;

- (void) addRecognizer: (id<PatternRecognizer>)recognizer;

- (void) setupRecording;

- (void) record;
- (void) stop;

- (void) edge: (int)height width:(unsigned)width interval:(unsigned)interval;
- (void) idle: (unsigned)samples;
- (void) reset;
-(void) resetPulseData;

-(void) signalStart;
-(void) signalEnd;
-(void) signalInvalidAndRestart;
-(void) signalReceiveByte:(Byte) byte;

@end
