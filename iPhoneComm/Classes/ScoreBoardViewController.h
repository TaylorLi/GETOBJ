//
//  ScoreBoardViewController.h
//  Chatty
//
//  Created by Eagle Du on 12/6/30.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"
#import "RoomDelegate.h"

@interface ScoreBoardViewController : UIViewController<RoomDelegate>{
    UILabel *lblMsg;
    Room* chatRoom;
    UILabel *lblTitle;
    UILabel *lblTotal;
    UILabel *lblName;
    UITextView *txtHistory;
    NSInteger totalScore;
}

@property (nonatomic, retain) IBOutlet UILabel *lblMsg;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblTotal;
@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UITextView *txtHistory;
@property  NSInteger totalScore;
@property(nonatomic,retain) Room* chatRoom;

// Exit back to the welcome screen
- (IBAction)exit;

// View is active, start everything up
- (void)activate;

- (void)eraseText;
@end
