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
#import "PickerButton.h"
#import "ServerSetting.h"
#import "OrderedDictionary.h"

@interface ShowWinnerBox : UAModalPanel
{
    OrderedDictionary *availSettingProfiles;
    OrderedDictionary *availCourts;
}
@property (nonatomic,weak) GameInfo *gameInfo;
@property (nonatomic) BOOL winnerIsRedSide;
@property (nonatomic, strong) IBOutlet UIView *viewLoadedFromXib;
@property (strong, nonatomic) IBOutlet UILabel *lblWinner;
@property (strong, nonatomic) IBOutlet UIImageView *imgBackground;
@property (strong, nonatomic) IBOutlet PickerButton *pkProfileName;
@property (nonatomic) WinType winnerWinType;
@property (strong, nonatomic) IBOutlet PickerButton *pkProfileNextMatch;
- (IBAction)btnNextRound:(id)sender;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
-(void)bindSetting;
@end
