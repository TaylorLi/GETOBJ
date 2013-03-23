//
//  AudioSignalAnalyzer.m
//  iNfrared
//
//  Created by George Dean on 11/28/08.
//  Copyright 2008 Perceptive Development. All rights reserved.
//

#import "AudioSignalAnalyzer.h"

#define SIGNAL_RATE  15000

#define SAMPLE_RATE  SIGNAL_RATE * 14

#define PER_BUFFER_BYTE_SIZE SAMPLE_RATE*2
#define BUFFER_COUNT 10

#define SAMPLE  SInt16
#define NUM_FRAMES_PER_PACKET 1 
#define NUM_CHANNELS  1
#define BYTES_PER_FRAME  (NUM_CHANNELS * sizeof(SAMPLE))

//载波：15khz，head：1.6ms~1.7ms,24个高峰Hight
//1:530us 8个高峰,0:210us 3个高峰

//每次高峰取样点数，一个单位构成一个电平，可以采取下面策略
/*
 记录高电平的个数，达到阀值以上的连续高电平，取最高值，计数为1，视作一个波
 */
#define FLAG_SINAL_COUNT (SAMPLE_RATE / SIGNAL_RATE) 
//报文头电平数
#define HEADER_HIGHT_COUNT_MIN 21
#define HEADER_HIGHT_COUNT_MAX 25
//0:连续电平数
#define HEADER_ZERO_FLAG_COUNT_MIN 2
#define HEADER_ZERO_FLAG_COUNT_MAX 4
//1：连续电平数
#define HEADER_ONE_FLAG_COUNT_MIN 6
#define HEADER_ONE_FLAG_COUNT_MAX 12
//以连续0电平结束报文个数
#define END_FREQ_COUNT 24*5

//波形相关定义
#define WAVE_LogicH1 (int)(pow(2,sizeof(SAMPLE)*8-1)) //高电平
#define  WAVE_LogicL 0//低电平
#define  WAVE_WaveActiveDelta (WAVE_LogicH1/(FLAG_SINAL_COUNT/2-1))            //有效的波形波动幅度
#define  WAVE_HeadWaveInactiveNum  (FLAG_SINAL_COUNT/2)            //连续多个低电平判定停下的个数，用户同步头信号检测
#define  WAVE_BodyWaveInactiveNum  (FLAG_SINAL_COUNT)            //连续多个低电平判定停下的个数,用于信号检测
#define WAVE_HEADER_REACHED_EDAGE_COUNT (23 * FLAG_SINAL_COUNT * 5/8)//一般情况下两个取点电平波动不到幅度，但是有至少一半可以达到
#define WAVE_HEADER_COUNT (23 * (FLAG_SINAL_COUNT))//一般情况下有两个取点电平波动不到幅度
#define WAVE_ONE_FLAG_COUNT (6.6 * (FLAG_SINAL_COUNT))//表示1
#define WAVE_ZERO_FLAG_COUNT (4* (FLAG_SINAL_COUNT))//表示0

#define SAMPLES_TO_NS(__samples__) (((UInt64)(__samples__) * 1000000000) / SAMPLE_RATE)
#define NS_TO_SAMPLES(__nanosec__)  (unsigned)(((UInt64)(__nanosec__)  * SAMPLE_RATE) / 1000000000)
#define US_TO_SAMPLES(__microsec__) (unsigned)(((UInt64)(__microsec__) * SAMPLE_RATE) / 1000000)
#define MS_TO_SAMPLES(__millisec__) (unsigned)(((UInt64)(__millisec__) * SAMPLE_RATE) / 1000)

BOOL ApproximatelyEqual2(unsigned v1, unsigned v2)
{
	if(v1>v2)
	{
		// XOR swap trick
		v1 ^= v2;
		v2 ^= v1;
		v1 ^= v2;
	}
	return (v1 * 10 / v2) >= 8;
}

//static long HIGHT_LEVEL_STATIC_COUNT=0;

//static long HIGHT_EDGE_STATIC_COUNT=0;

static WaveDecodeResult waveDecode(analyzerData *soundStream,AudioSignalAnalyzer* analyzer)
{
    soundStream->codeContent = 0;                         
    WaveDecodeResult decodeResult=WaveDecodeSuccess;
    //同步头判断
    int cntJudge[2]={0,0};//序cntJudge[1]:超过波动值的个数
    unsigned long positionNote=0;   
    int temp16=0;
    int structSize=pow(2, sizeof(int)*8);
    unsigned long i=0;
    bool findHeader=false;
    for (i=0; i<soundStream->waveContent-1; i++) 
    {       
        temp16=(int)soundStream->waveBuff[i+1]-(int)soundStream->waveBuff[i];
        if(abs(temp16)>WAVE_WaveActiveDelta)
        {
            //Print #1, 200
            if(cntJudge[1]<structSize){
                if(cntJudge[1] == 0)
                {
                    positionNote = i;
                }
                cntJudge[1]=cntJudge[1]+1;
            }
            cntJudge[0] = 0;
        }
        else{
            if(cntJudge[0]<structSize)
                cntJudge[0]=cntJudge[0]+1;
            if(cntJudge[0]>=WAVE_HeadWaveInactiveNum &&cntJudge[1]>WAVE_HEADER_REACHED_EDAGE_COUNT
               &&i-positionNote>=WAVE_HEADER_COUNT)
            {
                findHeader=true;
                break;
            }
            if(cntJudge[0]>=WAVE_HeadWaveInactiveNum){
                 //NSLog(@"%i",cntJudge[1]); NSLog(@"%i",cntJudge[1]);
                cntJudge[1]=0;
            }
        }
    }
    if(!findHeader){
        decodeResult=WaveDecodeNoHeader;
        return decodeResult;
    }
    else{
        NSLog(@"=======Header completed.=======,%ld,Sample count:%d,Wave count:%i",i-positionNote,FLAG_SINAL_COUNT,(int)((i-positionNote)/FLAG_SINAL_COUNT));
        [analyzer signalStart];
        //正文接收
        
        positionNote = i;
        cntJudge[0] = 0;
        Byte cntBit=0;//正文以0开始以有载波没有载波形式01010101
        int cntByte=0;
        int codeValue=0;
        for(i=positionNote;i<soundStream->waveContent;i++)
        {
            temp16 = (int)soundStream->waveBuff[i + 1] - (int)soundStream->waveBuff[i];
            //Print #1, (cntBit And 1) * 200
            //cntJudge[0]用来记录没有变化数
            if(cntBit % 2 == 1 ){//cntBit为单数1时，检测的波形为1，只需检测连续未达到波动的个数，超过指定个数则判断其值
                if(abs(temp16)<WAVE_WaveActiveDelta){
                    cntJudge[0]=cntJudge[0]+1;
                }
                else{
                    cntJudge[0]=0;
                }
            }
            else{
                //cntBit为偶数0时，检测的波形为0，只需检测达到波动的个数，超过指定个数则判断其值
                if(abs(temp16)>WAVE_WaveActiveDelta){
                    cntJudge[0]=cntJudge[0]+1;
                }
                else{
                    //cntJudge[0]=0;  
                }
            }                
            if(cntJudge[0]>=WAVE_BodyWaveInactiveNum){
                codeValue=codeValue*2;
                temp16=i-positionNote;
                
                if(temp16>=WAVE_ONE_FLAG_COUNT){
                    codeValue=codeValue+1;
                    NSLog(@"Rate Continue:%i,%i,FLAG:%i",temp16,temp16/FLAG_SINAL_COUNT,1);
                }
                else{
                    NSLog(@"Rate Continue:%i,%i,FLAG:%i",temp16,temp16/FLAG_SINAL_COUNT,0);
                }
                cntBit=cntBit+1;
                if(cntBit>=8){
                    soundStream->codeBuff[cntByte]=codeValue;
                    cntByte++;                   
                    NSLog(@"Receive Seq %i Char:0x%2x",cntByte,codeValue);
                    [analyzer signalReceiveByte:codeValue];
                    codeValue=0;
                    cntBit=0;
                }
                positionNote=i;
                cntJudge[0]=0;
            }               
        }  
        //校验
        /*
         协议定义:
         在时序上按下列顺序排列
         1. 开始信号;
         2. 1byte,命令;
         3. 1byte,命令的反码(保证命令的可靠);
         4. 0~N bytes,数据部分,具体长度由命令事先约定;
         5. 1byte,前面所有数据的和校验(包括命令);
         */
        //校验结束
        if(findHeader)
        {
            NSLog(@"=======Communicate completed.=======");
            [analyzer resetPulseData];
            [analyzer signalEnd];            
        }
        return decodeResult;
    }
    
    
}


static int analyze( SAMPLE *inputBuffer,
                   unsigned long framesPerBuffer,
                   AudioSignalAnalyzer* analyzer)
{
	analyzerData *soundStream = analyzer.pulseData;    
    //RESET
    soundStream->waveBuff=inputBuffer;
    soundStream->waveContent=framesPerBuffer;
    waveDecode(soundStream,analyzer);
    return 0;
}


static void recordingCallback (
							   void								*inUserData,
							   AudioQueueRef						inAudioQueue,
							   AudioQueueBufferRef					inBuffer,
							   const AudioTimeStamp				*inStartTime,
							   UInt32								inNumPackets,
							   const AudioStreamPacketDescription	*inPacketDesc
                               ) {
	// This is not a Cocoa thread, it needs a manually allocated pool
    //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
 	// This callback, being outside the implementation block, needs a reference to the AudioRecorder object
	AudioSignalAnalyzer *analyzer = (AudioSignalAnalyzer *) inUserData;
	
	// if there is audio data, analyze it
	if (inNumPackets > 0) {
		analyze((SAMPLE*)inBuffer->mAudioData, inBuffer->mAudioDataByteSize / BYTES_PER_FRAME, analyzer);		
	}
	
	// if not stopping, re-enqueue the buffer so that it can be filled again
	if ([analyzer isRunning]) {		
		AudioQueueEnqueueBuffer (
								 inAudioQueue,
								 inBuffer,
								 0,
								 NULL
								 );
	}
	
    //	[pool release];
}



@implementation AudioSignalAnalyzer

@synthesize stopping;

- (analyzerData*) pulseData
{
	return &pulseData;
}

- (id) init
{
	self = [super init];
    
	if (self != nil) 
	{
		recognizers = [[NSMutableArray alloc] init];
		// these statements define the audio stream basic description
		// for the file to record into.
		audioFormat.mSampleRate			= SAMPLE_RATE;
		audioFormat.mFormatID			= kAudioFormatLinearPCM;
		audioFormat.mFormatFlags		= kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
		audioFormat.mFramesPerPacket	= NUM_FRAMES_PER_PACKET;
		audioFormat.mChannelsPerFrame	= NUM_CHANNELS;
		audioFormat.mBitsPerChannel		= BYTES_PER_FRAME / NUM_CHANNELS * 8;
        audioFormat.mBytesPerFrame		= BYTES_PER_FRAME;
		audioFormat.mBytesPerPacket		= audioFormat.mBytesPerFrame * audioFormat.mFramesPerPacket;		
        
		AudioQueueNewInput (
							&audioFormat,
							recordingCallback,
							self,									// userData
							NULL,									// run loop
							NULL,									// run loop mode
							0,										// flags
							&queueObject
							);
		
	}
	return self;
}

- (void) addRecognizer: (id<PatternRecognizer>)recognizer
{
	[recognizers addObject:recognizer];
}

- (void) record
{
	[self setupRecording];
	
	[self reset];
	
	AudioQueueStart (
					 queueObject,
					 NULL			// start time. NULL means ASAP.
					 );	
}


- (void) stop
{
	AudioQueueStop (
					queueObject,
					TRUE
					);
	
	[self reset];
}


- (void) setupRecording
{
	// allocate and enqueue buffers
	int bufferByteSize = PER_BUFFER_BYTE_SIZE;		// this is the maximum buffer size used by the player class
	int bufferIndex;
	
	for (bufferIndex = 0; bufferIndex < BUFFER_COUNT; ++bufferIndex) {
		
		AudioQueueBufferRef bufferRef;
		
		AudioQueueAllocateBuffer (
								  queueObject,
								  bufferByteSize, &bufferRef
								  );
		
		AudioQueueEnqueueBuffer (
								 queueObject,
								 bufferRef,
								 0,
								 NULL
								 );
	}
}

- (void) idle: (unsigned)samples
{
	// Convert to microseconds
	UInt64 nsInterval = SAMPLES_TO_NS(samples);
	for (id<PatternRecognizer> rec in recognizers)
		[rec idle:nsInterval];
}

- (void) edge: (int)height width:(unsigned)width interval:(unsigned)interval
{
	// Convert to microseconds
	UInt64 nsInterval = SAMPLES_TO_NS(interval);
	UInt64 nsWidth = SAMPLES_TO_NS(width);
	for (id<PatternRecognizer> rec in recognizers)
		[rec edge:height width:nsWidth interval:nsInterval];
}

- (void) reset
{
	[recognizers makeObjectsPerformSelector:@selector(reset)];
	
	memset(&pulseData, 0, sizeof(pulseData));
}

-(void) resetPulseData
{
    memset(&pulseData, 0, sizeof(pulseData));
}

-(void) signalStart
{
    [recognizers makeObjectsPerformSelector:@selector(signalStart)];
}

-(void) signalEnd
{
    [recognizers makeObjectsPerformSelector:@selector(signalEnd)];
}
-(void) signalInvalidAndRestart
{
    [recognizers makeObjectsPerformSelector:@selector(signalInvalidAndRestart)];
}
-(void) signalReceiveByte:(Byte) byte
{
    for (id<PatternRecognizer> rec in recognizers)
		[rec signalReceiveByte:byte];
}

- (void) dealloc
{
	AudioQueueDispose (queueObject,
					   TRUE);
	
	[recognizers release];
	
	[super dealloc];
}

@end
