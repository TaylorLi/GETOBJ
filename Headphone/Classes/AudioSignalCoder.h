//
//  AudioSignalAnalyzer.h
//  iNfrared
//
//  Created by George Dean on 11/28/08.
//  Copyright 2008 Perceptive Development. All rights reserved.
//

#import "AudioQueueObject.h"
#import "PatternRecognizer.h"
#import "NSQueue.h"


typedef struct
{
   
}waveCodeData;

@interface AudioSignalCoder : AudioQueueObject {
	BOOL	stopping;
	waveCodeData pulseData;
	NSMutableArray* recognizers;
    NSQueue *voiceDataQueue;
}


@property (readwrite) BOOL	stopping;
@property (readonly) waveCodeData* pulseData;

- (void) addRecognizer: (id<PatternRecognizer>)recognizer;

- (void) startQueue;
- (void)readPCMAndPlay:(AudioQueueRef)outQ buffer:(AudioQueueBufferRef)outQB;
- (void) stop;
- (void) playWithData:(NSData *)data;
- (void) playWithCommandByte:(Byte *)cmd withLength:(int)length;
@end
