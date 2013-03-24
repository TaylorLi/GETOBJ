//
//  AudioSignalAnalyzer.m
//  iNfrared
//
//  Created by George Dean on 11/28/08.
//  Copyright 2008 Perceptive Development. All rights reserved.
//

#import "AudioSignalCoder.h"
#import "PlayWaveDefintion.h"
#import "WaveGenerator.h"

static void playCallback (
                          void								*inUserData,
                          AudioQueueRef						inAudioQueue,
                          AudioQueueBufferRef					inBuffer)							   
{
    
    AudioSignalCoder *analyzer = (AudioSignalCoder *) inUserData;
    if([analyzer isRunning]){
        [analyzer readPCMAndPlay:inAudioQueue buffer:inBuffer];
    }
}



@implementation AudioSignalCoder

@synthesize stopping;

- (waveCodeData*) pulseData
{
	return &pulseData;
}

- (id) init
{
    
	self = [super init];
    voiceDataQueue=[[NSQueue alloc] init];
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
		AudioQueueNewOutput (
                             &audioFormat,
                             playCallback,
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

-(void)readPCMAndPlay:(AudioQueueRef)outQ buffer:(AudioQueueBufferRef)outQB{
    @synchronized(voiceDataQueue){
        if (voiceDataQueue.count ==0) {
            [self stop];
            //AudioQueueEnqueueBuffer(outQ, outQB, 0, NULL);
        }else if(voiceDataQueue.count > 0){
            NSData *myData  = [voiceDataQueue dequeue];
            Byte *pcmDataByte = (Byte *)myData.bytes;
            outQB->mAudioDataByteSize = myData.length;		
            Byte *audiodata = (Byte *)outQB->mAudioData;
            for(int i=0;i<myData.length;i++)
            {
                audiodata[i] = pcmDataByte[i];
            }
            AudioQueueEnqueueBuffer(outQ, outQB, 0, NULL);
            [myData release];
        }
    }
}

- (void) startQueue
{		
    if([self isRunning]){
        
    }
    else{
        int bufferByteSize = PER_BUFFER_SIZE;		// this is the maximum buffer size used by the player class
        int bufferIndex;
        for (bufferIndex = 0; bufferIndex < BUFFER_COUNT; ++bufferIndex) {
            AudioQueueBufferRef bufferRef;
            AudioQueueAllocateBuffer (
                                      queueObject,
                                      bufferByteSize, &bufferRef
                                      );
            [self readPCMAndPlay:queueObject buffer:bufferRef];
        }
        AudioQueueSetParameter(queueObject, kAudioQueueParam_Volume, 1.0);
        AudioQueueStart (
                         queueObject,
                         NULL			// start time. NULL means ASAP.
                         );
    }
}

- (void) stop
{
    AudioQueueFlush(queueObject);
	AudioQueueStop (
					queueObject,
					TRUE
					);
}

- (void) dealloc
{
	AudioQueueDispose (queueObject,
					   TRUE);
	[recognizers release];
	[super dealloc];
}

- (void) playWithData:(NSData *)data
{
    [voiceDataQueue enqueue:data];
    [self startQueue];
}

- (void) playWithCommandByte:(Byte *)cmd withLength:(int)length
{
    NSData *data= [WaveGenerator generatorCmdBytesByOriginCmdByte:cmd withLength:length];
    [self playWithData:data];
}

@end
