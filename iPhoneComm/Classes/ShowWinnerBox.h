//
//  ShowWinnerBox.h
//  TKD Score
//
//  Created by Eagle Du on 12/8/18.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameInfo.h"
#import "UATitledModalPanel.h"

@interface ShowWinnerBox : UATitledModalPanel

@property (nonatomic,weak) GameInfo *gameInfo;
@property (nonatomic) BOOL winnerIsRedSide;
@property (nonatomic, strong) IBOutlet UIView *viewLoadedFromXib;
@property (strong, nonatomic) IBOutlet UILabel *lblWinner;
- (IBAction)btnNextRound:(id)sender;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
-(void)bindSetting;
@end
