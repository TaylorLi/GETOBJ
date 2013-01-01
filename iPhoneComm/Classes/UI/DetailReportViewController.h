//
//  DetailReportViewController.h
//  TKD Score
//
//  Created by Eagle Du on 12/12/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameInfo.h"

@interface DetailReportViewController : UIViewController

@property (nonatomic) NSInteger selRound;
@property (nonatomic,strong) GameInfo *gameInfo;
- (IBAction)backToParentView:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *viewReportView;

@end
