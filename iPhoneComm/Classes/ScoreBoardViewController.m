//
//  ScoreBoardViewController.m
//  Chatty
//
//  Created by Eagle Du on 12/6/30.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "ScoreBoardViewController.h"
#import "ChattyAppDelegate.h"
#import "AppConfig.h"
#import "UITextView+Utils.h"

@implementation ScoreBoardViewController

@synthesize lblMsg;
@synthesize lblName;
@synthesize lblTitle;
@synthesize lblTotal;
@synthesize totalScore;
@synthesize txtHistory;
@synthesize chatRoom;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [lblMsg release];
    [lblName release];
    [lblTitle release];
    [lblTotal release];
    [txtHistory release];
    self.chatRoom = nil;
    [super dealloc];
}

- (void)activate {
    if (chatRoom != nil ) {
        chatRoom.delegate = self;
        [chatRoom start];
        lblTitle.text=[NSString stringWithFormat:@"%@'s Score Server", [[AppConfig getInstance] name]];
        totalScore=0;
        lblTotal.text=[NSString stringWithFormat:@"%i",totalScore];
    }
}

// We are being asked to display a chat message
- (void)displayChatMessage:(NSString*)message fromUser:(NSString*)userName {
    
    if([message isEqualToString:@"1"])
        lblMsg.textColor=[UIColor redColor];
    else if([message isEqualToString:@"2"])
        lblMsg.textColor=[UIColor blueColor];
    else if([message isEqualToString:@"3"])
        lblMsg.textColor=[UIColor purpleColor];
    else
        lblMsg.textColor=[UIColor cyanColor];
    lblMsg.text=message;
    lblName.text=userName;
    totalScore=totalScore + [message integerValue];
    lblTotal.text=[NSString stringWithFormat:@"%i",totalScore];
    lblTotal.hidden=NO;   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [txtHistory prependTextAfterLinebreak:[NSString stringWithFormat:@"%@:%@,%@",[dateFormatter stringFromDate:[NSDate date]], userName, message]];
    [txtHistory scrollsToTop];
    [self performSelector:@selector(eraseText) withObject:nil afterDelay:2];
}


// Room closed from outside
- (void)roomTerminated:(id)room reason:(NSString*)reason {
    // Explain what happened
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Server terminated" message:reason delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [self exit];
}


// User decided to exit room
- (IBAction)exit {
    // Close the room
    [chatRoom stop];
    
    // Remove keyboard
    
    // Erase chat
    lblMsg.text = @"";
    lblName.text=@"";
    // Switch back to welcome view
    [[ChattyAppDelegate getInstance] showRoomSelection];
}

- (void)eraseText {
    lblMsg.text = @"";
    lblName.text=@"";
}

@end
