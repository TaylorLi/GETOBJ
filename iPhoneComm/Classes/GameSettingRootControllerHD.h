//
//  GameSettingRootControllerHD.h
//  TKD Score
//
//  Created by Eagle Du on 12/8/11.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameSettingDetailControllerHD.h"

@interface GameSettingRootControllerHD : UITableViewController
{
    GameSettingDetailControllerHD *detailViewController;
    NSDictionary *menus;
}

@property (nonatomic, retain) IBOutlet GameSettingDetailControllerHD *detailViewController;
@property (nonatomic, retain) NSDictionary *menus;

@end
