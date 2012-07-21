//
//  UIWaitForUserViewController.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/21.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UATitledModalPanel.h"

@interface UIWaitForUserViewController : UATitledModalPanel <UITableViewDataSource>
{
	IBOutlet UIView	*viewLoadedFromXib;
}
@property (nonatomic, retain) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic,assign) NSMutableDictionary *clients;
@property NSInteger needConnectedClientCount;
@property (retain, nonatomic) IBOutlet UILabel *txtNeedClientCount;
@property (retain, nonatomic) IBOutlet UIButton *btnStartGame;

@property (retain, nonatomic) IBOutlet UILabel *lblWaitForClientsCount;
@property (retain, nonatomic) IBOutlet UITableView *tbClientList;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

- (IBAction)startGame:(id)sender;
-(void) updateStatus:(NSMutableDictionary *)_clients;
@end
