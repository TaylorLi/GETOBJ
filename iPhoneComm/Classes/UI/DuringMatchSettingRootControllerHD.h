//
//  GameSettingRootControllerHD.h
//  TKD Score
//
//  Created by Eagle Du on 12/8/11.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DuringMatchSettingDetailControllerHD.h"

@interface DuringMatchSettingRootControllerHD : UITableViewController
{
    DuringMatchSettingDetailControllerHD *detailViewController;
    NSArray *menus;
}

@property (nonatomic, retain) IBOutlet DuringMatchSettingDetailControllerHD *detailViewController;
@property (nonatomic, retain) NSArray *menus;
@property (nonatomic) NSInteger showingTabIndex;

@end
