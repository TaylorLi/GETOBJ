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
    Room* chatRoom;
    UILabel *lblTitle;
    UILabel *lblRedImg1;
    UILabel *lblRedImg2;
    UILabel *lblBlueImg1;
    UILabel *lblBlueImg2;
    UILabel *lblRedTotal;
    UILabel *lblBlueTotal;
    UITextView *txtHistory;
    NSInteger blueTotalScore;
    NSInteger redTotalScore;
    UILabel *lblCoachName;
}

@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblRedImg1;
@property (nonatomic, retain) IBOutlet UILabel *lblRedImg2;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueImg1;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueImg2;
@property (nonatomic, retain) IBOutlet UILabel *lblRedTotal;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueTotal;
@property (nonatomic, retain) IBOutlet UILabel *lblCoachName;
@property (nonatomic, retain) IBOutlet UITextView *txtHistory;
@property(nonatomic,retain) Room* chatRoom;

// Exit back to the welcome screen
- (IBAction)exit;

- (IBAction)permit;

// View is active, start everything up
- (void)activate;

- (void)eraseText;
@end
