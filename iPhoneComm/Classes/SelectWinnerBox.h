//
//  WinnnerBox.h
//  TKD Score
//
//  Created by Eagle Du on 12/8/18.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UATitledModalPanel.h"
#import "GameInfo.h"

@interface SelectWinnerBox : UATitledModalPanel

- (IBAction)selectRedToWinner:(id)sender;
- (IBAction)selectBlueToWinner:(id)sender;
@property (nonatomic, strong) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic,assign) GameInfo *gameInfo;
-(void)showWinner:(BOOL)red;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
@end
