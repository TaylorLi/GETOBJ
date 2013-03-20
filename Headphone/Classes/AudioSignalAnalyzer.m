//
//  AudioSignalAnalyzer.m
//  iNfrared
//
//  Created by George Dean on 11/28/08.
//  Copyright 2008 Perceptive Development. All rights reserved.
//

#import "AudioSignalAnalyzer.h"


#define SIGNAL_RATE  15000

#define SAMPLE_RATE  SIGNAL_RATE * 10

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

#define SIGN_HEADER_CONTINUE_TIME_NS 1600
#define SIGN_ZERO_CONTINUE_TIME 210
#define SIGN_ONE_CONTINUE_TIME 530
#define SIGN_END_CONTINUE_TIME 4200
//0:连续电平数
#define HEADER_ZERO_FLAG_COUNT_MIN 2
#define HEADER_ZERO_FLAG_COUNT_MAX 4
//1：连续电平数
#define HEADER_ONE_FLAG_COUNT_MIN 6
#define HEADER_ONE_FLAG_COUNT_MAX 12
//以连续0电平结束报文个数
#define END_FREQ_COUNT 24*5

#define SAMPLES_TO_NS(__samples__) (((UInt64)(__samples__) * 1000000000) / SAMPLE_RATE)
#define NS_TO_SAMPLES(__nanosec__)  (unsigned)(((UInt64)(__nanosec__)  * SAMPLE_RATE) / 1000000000)
#define US_TO_SAMPLES(__microsec__) (unsigned)(((UInt64)(__microsec__) * SAMPLE_RATE) / 1000000)
#define MS_TO_SAMPLES(__millisec__) (unsigned)(((UInt64)(__millisec__) * SAMPLE_RATE) / 1000)
#define EDGE_VALID_HIGHT_LEVEL_HOLD		15000
#define EDGE_ZERO_THRESHOLD		3000
#define EDGE_SLOPE_THRESHOLD	256
#define EDGE_MAX_WIDTH			256
#define IDLE_CHECK_PERIOD		MS_TO_SAMPLES(33)


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

static int analyze( SAMPLE *inputBuffer,
                   unsigned long framesPerBuffer,
                   AudioSignalAnalyzer* analyzer)
{
	analyzerData *data = analyzer.pulseData;
	SAMPLE *pSample = inputBuffer;
	int lastFrame = data->lastFrame;
    
	//unsigned idleInterval = data->plateauWidth + data->lastEdgeWidth + data->edgeWidth;
	for (long i=0; i < framesPerBuffer; i++, pSample++)
	{
		int thisFrame = *pSample;
        
        //data->currentSampleLocation++;
        int diff = thisFrame - lastFrame;
        
        int sign = 0;
        if (diff > EDGE_SLOPE_THRESHOLD)
        {
            // Signal is rising
            sign = 1;
            //NSLog(@"1, (%i,%i,diff:%i)\n",thisFrame,lastFrame,diff);
        }
        else if(-diff > EDGE_SLOPE_THRESHOLD)
        {
            // Signal is falling
            sign = -1;
            //NSLog(@"-1, (%i,%i,diff:%i)\n",thisFrame,lastFrame,diff);
        }
        
#pragma mark -
#pragma mark 使用对应的取样频率进行计算，实验过发现此方法不可行
        data->frameSampleCount++;
        if(thisFrame>EDGE_ZERO_THRESHOLD){
            data->aboveZeroLevel=true;
        }
        else{
            data->belowZeroLevel=true;
        }
        if(sign==1){
            data->raiseUp=true;
        }
        else if(sign==-1){
            data->raiseDown=true;
        }
        if(thisFrame>EDGE_VALID_HIGHT_LEVEL_HOLD){
            data->hightLevelCount++;
            
        }
        //if(thisFrame>10000)
          //  NSLog(@"%i",thisFrame);
        if(data->frameSampleCount==FLAG_SINAL_COUNT){//一个采样周期
            //判断上个波形有载波还是没有载波
            int levelType=0;
            //if(data->hightLevelCount>1 && data->belowZeroLevel && data->aboveZeroLevel
            //   &&data->raiseUp &&data->raiseDown){
            if(data->hightLevelCount>0&&data->raiseUp &&data->raiseDown){
                //属于高波
                levelType=1;
                
            }
            else{
                levelType=0;
            } 
            if(levelType==data->continueSampleType){
                data->continueSampleCount++;
                if(data->headerCompleted){
                    if(data->continueSampleType==0 &&data->continueSampleCount > END_FREQ_COUNT)
                    {
                        [analyzer resetPulseData];
                        NSLog(@"=======Communicate completed.=======");
                        [analyzer signalEnd];
                        
                    }      
                }
            }
            else{
                //连续相同时进行判断
                if(!data->headerCompleted)
                {
                    if(data->continueSampleType==1 &&data->continueSampleCount>=HEADER_HIGHT_COUNT_MIN
                       &&data->continueSampleCount<=HEADER_HIGHT_COUNT_MAX)
                    {
                        data->headerCompleted=true;
                        NSLog(@"=======Header completed.=======,%i",data->continueSampleCount);
                        [analyzer signalStart];
                    }
                }   
                //已经header结束，在变化前判断波形数
                else{
                    if(data->continueSampleCount>=HEADER_ONE_FLAG_COUNT_MIN&&data->continueSampleType<=HEADER_ONE_FLAG_COUNT_MAX){
                        NSLog(@"Data Signal:1,count:%i,type:%i",data->continueSampleCount,data->continueSampleType);
                        data->availSample[data->availSampleCount++]=1;
                    }
                    else if(data->continueSampleCount>=HEADER_ZERO_FLAG_COUNT_MIN&&data->continueSampleType<=HEADER_ZERO_FLAG_COUNT_MAX){
                        NSLog(@"Data Signal:0,count:%i,type:%i",data->continueSampleCount,data->continueSampleType);                        data->availSample[data->availSampleCount++]=0;
                    }
                    else{
                        if(data->continueSampleCount<HEADER_ONE_FLAG_COUNT_MIN){
                            //实际未发生变化
                            data->continueSampleCount++;
                        }
                        else{
                            NSLog(@"Unrecognize Sample Continue Count:%i",data->continueSampleCount);
                            data->headerCompleted=false;
                            [analyzer resetPulseData];
                            NSLog(@"=======Header test restart.=======");
                            [analyzer signalInvalidAndRestart];
                        }
                    }
                    if(data->availSampleCount==8){
                        unsigned v=0;
                        NSMutableString *mulStr=[[NSMutableString alloc] initWithCapacity:8];
                        for (int i=0; i<8; i++) {
                            [mulStr appendFormat:@"%i",(unsigned)data->availSample[i]];
                            v+=data->availSample[i]<<8-1-i;
                        }
                        NSLog(@"Receive Char:%i,Hex:%2x,All String:%@",v,v,mulStr);
                        data->availSampleCount=0;
                        memset(&data->availSample,0,sizeof(char)*8);
                        [analyzer signalReceiveByte:v];
                    }
                }                
                data->continueSampleCount=1;
                data->continueSampleType=levelType;
            }
            data->belowZeroLevel=false;
            data->aboveZeroLevel=false;
            data->raiseUp=false;
            data->raiseDown=false;
            data->frameSampleCount=0;
            data->hightLevelCount=0;
        }
        data->lastFrame=thisFrame;
#pragma mark -       
    }
	
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
        
		self.pulseData->lastLowSignalLevelCount=0;
		self.pulseData->lastHighSignalLevelCount=0;
        self.pulseData->lastSignalLevelType=0;
        
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
	int bufferByteSize = 4096    *4;		// this is the maximum buffer size used by the player class
	int bufferIndex;
	
	for (bufferIndex = 0; bufferIndex < 20; ++bufferIndex) {
		
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
