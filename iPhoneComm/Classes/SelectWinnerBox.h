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
#import "PickerButton.h"

@interface SelectWinnerBox : UAModalPanel<PickerButtonDelegate>
{
    NSDictionary *winTypes;
    BOOL rebPlayerWin;
    WinType currentWinType;
}
- (IBAction)selectRedToWinner:(id)sender;
- (IBAction)selectBlueToWinner:(id)sender;
@property (nonatomic, strong) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic,assign) GameInfo *gameInfo;
@property (nonatomic,strong) IBOutlet PickerButton *selectWinTypeButton;
@property (nonatomic,strong) IBOutlet PickerButton *selectWinTypeButtonRed;
-(void)showWinner:(BOOL)red;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
-(void)calcWinTypeByGameInfo;
-(void)bindByGameInfo;
@end
