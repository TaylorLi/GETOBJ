//
//  UIWaitForUserViewController.h
//  TKD Score
//
//  Created by Eagle Du on 12/7/21.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UATitledModalPanel.h"
#import "UIGifView.h"

@interface UIWaitForUserViewController : UAModalPanel <UITableViewDataSource>
{
	IBOutlet UIView	*viewLoadedFromXib;
    NSArray *imgReferees;
    NSMutableArray *imgLoadings;
    UIGifView *gifControl;
}
@property (nonatomic, strong) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic,assign) NSMutableDictionary *clients;
@property NSInteger needConnectedClientCount;
@property (strong, nonatomic) IBOutlet UILabel *txtNeedClientCount;
@property (strong, nonatomic) IBOutlet UIButton *btnStartGame;
@property (strong, nonatomic) IBOutlet UIImageView *imgReferee1;
@property (strong, nonatomic) IBOutlet UIImageView *imgReferee2;
@property (strong, nonatomic) IBOutlet UIImageView *imgReferee3;
@property (strong, nonatomic) IBOutlet UIImageView *imgReferee4;
@property (strong, nonatomic) IBOutlet UIImageView *imgControl;
@property (strong, nonatomic) IBOutlet UIImageView *imgLoading1;
@property (strong, nonatomic) IBOutlet UIImageView *imgLoadingControl;
@property (strong, nonatomic) IBOutlet UIImageView *imgLoading3;
@property (strong, nonatomic) IBOutlet UIImageView *imgLoading4;
@property (strong, nonatomic) IBOutlet UIImageView *imgLoading2;

@property (strong, nonatomic) IBOutlet UILabel *lblWaitForClientsCount;
@property (strong, nonatomic) IBOutlet UITableView *tbClientList;
- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

- (IBAction)startGame:(id)sender;
-(void) updateStatus:(NSMutableDictionary *)_clients;

@end
