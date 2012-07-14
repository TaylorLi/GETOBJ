//
//  ScoreBoardViewController.h
//  Chatty
//
//  Created by Eagle Du on 12/6/30.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalRoom.h"
#import "RoomDelegate.h"

@interface ScoreBoardViewController : UIViewController<RoomDelegate>{
    LocalRoom* chatRoom;
    UILabel *lblTitle;
    UILabel *lblRedImg1;
    UILabel *lblRedImg2;
    UILabel *lblRedImg3;
    UILabel *lblRedImg4;
    UILabel *lblBlueImg1;
    UILabel *lblBlueImg2;
    UILabel *lblBlueImg3;
    UILabel *lblBlueImg4;
    UILabel *lblRedTotal;
    UILabel *lblBlueTotal;
    UITextView *txtHistory;
    NSInteger blueTotalScore;
    NSInteger redTotalScore;
    UILabel *lblCoachName;
    NSDictionary *dicSideFlags;
}

@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblRedImg1;
@property (nonatomic, retain) IBOutlet UILabel *lblRedImg2;
@property (nonatomic, retain) IBOutlet UILabel *lblRedImg3;
@property (nonatomic, retain) IBOutlet UILabel *lblRedImg4;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueImg1;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueImg2;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueImg3;
@property (nonatomic, retain) IBOutlet UILabel *lblBlueImg4;
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
