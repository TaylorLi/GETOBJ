//
//  AppConfig.m
//  Chatty
//
//  Copyright (c) 2009 Peter Bakhyryev <peter@byteclub.com>, ByteClub LLC
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import "AppConfig.h"

static AppConfig* instance;

@implementation AppConfig

@synthesize name;
@synthesize password;
@synthesize isIPAD;
@synthesize networkUsingWifi;
@synthesize timeout;
// Initialization
- (id) init {
  self.name = @"unknown";
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.width);
  isIPAD=[UIScreen mainScreen].bounds.size.width>=600 && [UIScreen mainScreen].bounds.size.height>=600;
    networkUsingWifi=NO;  
    timeout=30;
  return self;
}


// Cleanup
- (void)dealloc {
  self.name = nil;
  self.password = nil;
  [super dealloc];
}


// Automatically initialize if called for the first time
+ (AppConfig*) getInstance {
  @synchronized([AppConfig class]) {
    if ( instance == nil ) {
      instance = [[AppConfig alloc] init];
    }
  }
  
  return instance;
}

+ (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if([AppConfig getInstance].isIPAD)
        return interfaceOrientation== UIInterfaceOrientationLandscapeRight;
    else
        return  interfaceOrientation==UIInterfaceOrientationPortrait;
}
@end
