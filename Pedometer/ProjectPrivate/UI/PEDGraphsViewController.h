//
//  PEDSecondViewController.h
//  Pedometer
//
//  Created by Eagle Du on 13/2/16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "CorePlot-CocoaTouch.h"
#import <UIKit/UIKit.h>
#import "PEDUIBaseViewController.h"

@interface PEDGraphsViewController : PEDUIBaseViewController<CPTPlotDataSource, CPTAxisDelegate>
{
    CPTXYGraph *graph;
    
    NSMutableArray *dataForPlot;
}

@property (readwrite, retain, nonatomic) NSMutableArray *dataForPlot;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *cptGraphHostingView;

@end
