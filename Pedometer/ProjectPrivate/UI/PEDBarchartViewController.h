//
//  PEDFirstViewController.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>
#import "V8HorizontalPickerView.h"
#import "V8HorizontalPickerViewProtocol.h"
#import "PEDUIBaseViewController.h"

@interface PEDBarchartViewController : PEDUIBaseViewController<CPTPlotDataSource,V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>
{
@private
    CPTXYGraph *barChart;
    NSTimer *timer;
    NSMutableArray *monthArray;
}

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *graphicHostView;
@property (strong, nonatomic) IBOutlet V8HorizontalPickerView *monthSelectView;
@property (readwrite, retain, nonatomic) NSTimer *timer;

-(void)timerFired;


@end