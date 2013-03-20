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

typedef struct
{
	int			lastFrame;//幅度
	int			lastEdgeSign;
	unsigned	lastEdgeWidth;
	int			edgeSign;
	int			edgeDiff;
	unsigned	edgeWidth;
	unsigned	plateauWidth;
    
    int         lastHighSignalLevelCount;//连续相同高电平数
    int         lastLowSignalLevelCount;//连续相同高电平数
    int         lastSignalLevelType;//1高电平，0低电平
    long        hightLevelCount;//达到阀值电平数
    bool        aboveZeroLevel;//周期之前必须有上过零值
    bool        belowZeroLevel;//周期之前必须有下过零值
    bool        raiseUp;
    bool        raiseDown;
    long        frameSampleCount;//周期采样个数
    bool        signalIsStart;//开始检测到高于阀值的有效信号
    bool        headerCompleted;//已匹配header
    bool        signalCompleted;//一次通讯结束
    char         availSample[8];//存储波形值
    int         availSampleCount;//有效的波形数量
    int         continueSampleCount;//连续波形数量
    int         continueSampleType;//连续波形类型，1存在载波，0不存在载波
    /*
    bool        lastRaiseUpStart;//前一个波上升沿开始
    bool        lastRaiseDownBegin;//前一个波下降沿开始
    bool        lastHasReachedThresHold;//前一个波是否达到视为波峰的高度
    unsigned    lastWaveWidth;//前一个波单个波波长
    unsigned long        lastWaveFirstRaiseUpLocation;//前一个波上升沿时间坐标
    unsigned long        lastWaveLastRaiseUpLocation;//前一个波上升沿时间坐标
   unsigned long        waveFirstRaiseUpLocation;//前一个波上升沿时间坐标
    unsigned long        waveLastRaiseUpLocation;//前一个波上升沿时间坐标
    bool        raiseUpStart;//上升沿开始
    bool        raiseDownBegin;//下降沿开始
    bool        hasReachedHightLevelHold;//达到视为波峰的高度
    unsigned    hightLevelWaveCount;//高波数
    unsigned    waveWidth;//单个波波长
    unsigned    continueFirstHightLevelWaveLocation;//从上一个上升沿到当前取样点经历到现在的总时间
    unsigned long       currentSampleLocation;//当前时间轴取值
    */
#ifdef DETAILED_ANALYSIS
	SInt64		edgeSum;
	int			edgeMin;
	int			edgeMax;
	SInt64		plateauSum;
	int			plateauMin;
	int			plateauMax;
#endif
}
analyzerData;

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
