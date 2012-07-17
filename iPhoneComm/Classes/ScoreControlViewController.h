//
//  SwipesViewController.h
//  Swipes
//
//  Created by Dave Mark on 12/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"
#import "RoomDelegate.h"

@class  UILoadingBox;

@interface ScoreControlViewController : UIViewController<RoomDelegate> {
    UILabel     *label;
    CGPoint     gestureStartPoint;
    Room* chatRoom;
    Boolean isBlueSide;
    UILoadingBox* loadingBox;
    
}
@property (nonatomic, retain) IBOutlet UILabel *label;
@property(nonatomic,retain) Room* chatRoom;
@property CGPoint gestureStartPoint;

- (void)eraseText;
// Exit back to the welcome screen
- (IBAction)exit;

// View is active, start everything up
- (void)activate;

-(void)sendScore:(NSInteger)score;
-(void)reportSwipe:(NSInteger)score;
-(void)setStyleBySide;
@end