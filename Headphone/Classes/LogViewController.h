//
//  LogViewController.h
//  iNfrared
//
//  Created by George Dean on 11/28/08.
//  Copyright 2008 Perceptive Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundsPlayer.h"

@interface LogViewController : UIViewController {
	UITextView* textView;
	unsigned historyLimit;
	NSMutableArray* history;
    __strong SoundsPlayer *player;
}

@property (nonatomic, retain) IBOutlet UITextView* textView;
@property unsigned historyLimit;
@property (nonatomic, retain) IBOutlet UITextField* cmdView;
- (void) addEntry:(NSString*)entry;
-(void) clearText;

-(IBAction) sendCommand:(UIButton *)sender;
-(IBAction) sendCommandByFile:(UIButton *)sender;
@end
