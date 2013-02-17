//
//  PEDFirstViewController.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>

@interface PEDBarchartViewController : UIViewController<CPTPlotDataSource>
{
@private
    CPTXYGraph *barChart;
    NSTimer *timer;
    CGContextRef contextRef;
}

@property (readwrite, retain, nonatomic) NSTimer *timer;

-(void)timerFired;

@end