//
//  PermitControlView.h
//  Chatty
//
//  Created by Yuheng Li on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"

@interface PermitControlView : UIViewController

@property(nonatomic,retain) Room* chatRoom;
@property (retain, nonatomic) IBOutlet UITextField *password;
@property (retain, nonatomic) NSString* serverPassword;
@property(nonatomic) Boolean isValidatePassword;

- (IBAction)confirm;

- (IBAction)cancel;

- (void)activate;
@end
