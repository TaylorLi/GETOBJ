//
//  RawPulseLogger.m
//  iNfrared
//
//  Created by George Dean on 12/22/08.
//  Copyright 2008 Perceptive Development. All rights reserved.
//

#import "RawPulseLogger.h"
#import "iNfraredAppDelegate.h"

#define PULSE_BUFFER_MAX		1024

@implementation RawPulseLogger

- (id) init
{
	if(self = [super init])
	{
		buffer = [[NSMutableString alloc] initWithCapacity:1024];
	}
	return self;
}

- (void) flushBuffer
{
	iNfraredAppDelegate* delegate = (iNfraredAppDelegate*)[UIApplication sharedApplication].delegate;
	[delegate.eventsLog addEntry:buffer];
	[buffer setString:@""];
}

- (void) idle: (UInt64)nanosec
{
	if(buffer.length)
		[self flushBuffer];
}

- (void) reset
{
	if(buffer.length)
		[self flushBuffer];
}

- (void) pulse: (UInt64)nanosec
{
	[buffer appendFormat:@" %d", (unsigned)(nanosec / 1000)];
}

- (void) pause: (UInt64)nanosec
{
	if(!buffer.length)
	{
		[buffer appendFormat:@"======(%d)\n", (unsigned)(nanosec / 1000)];
		return;
	}
	else
	{
		if(buffer.length > PULSE_BUFFER_MAX)
		{
			[self flushBuffer];
			[buffer appendString:@"..."];
		}
		[buffer appendFormat:@" (%d)", (unsigned)(nanosec / 1000)];
	}
}

- (void) dealloc
{
	[buffer release];
	
	[super dealloc];
}

/*开始信号*/
-(void) signalStart
{
    iNfraredAppDelegate* delegate = (iNfraredAppDelegate*)[UIApplication sharedApplication].delegate;
    [delegate.eventsLog clearText];
    [buffer appendFormat:@"\n======Signal Start======"];
    [self flushBuffer];
}
/*结束信号*/
-(void) signalEnd
{
    [buffer appendFormat:@"------Signal End------\n"];
    [self flushBuffer]; 
}
/*无法识别信号*/
-(void) signalInvalidAndRestart
{
    [buffer appendFormat:@"------Unrecognize Signal,Signal End------\n"];
    [self flushBuffer];
}
/*收到有效字节*/
-(void) signalReceiveByte:(Byte) byte
{
    int v=(int)byte;
    NSLog(@"Receive Char:%i,Hex:%2x",v,v);
    [buffer appendFormat:@"Receive Char:%i,Hex:%2x",v,v];
    [self flushBuffer];
}


@end
