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

@synthesize lblCoachName;
@synthesize lblTitle;
@synthesize txtHistory;
@synthesize chatRoom;
@synthesize lblRedImg1;
@synthesize lblRedImg2;
@synthesize lblBlueImg1;
@synthesize lblBlueImg2;
@synthesize lblBlueTotal;
@synthesize lblRedTotal;

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
    [lblCoachName release];
    [lblTitle release];
    [txtHistory release];
    [lblRedTotal release];
    [lblRedImg2 release];
    [lblRedImg1 release];
    [lblBlueTotal release];
    [lblBlueImg1 release];
    [lblBlueImg2 release];
    self.chatRoom = nil;
    [super dealloc];
}

- (void)activate {
    if (chatRoom != nil ) {
        chatRoom.delegate = self;
        [chatRoom start];
        lblTitle.text=[NSString stringWithFormat:@"%@'s Score Server", [[AppConfig getInstance] name]];
        redTotalScore=0;
        blueTotalScore=0;
        lblRedTotal.text=[NSString stringWithFormat:@"%i",redTotalScore];
        lblBlueTotal.text=[NSString stringWithFormat:@"%i",blueTotalScore];
    }
}
// We are being asked to process cmd
- (void)processCmd:(CommandMsg *)cmdMsg {
    if ([cmdMsg.type isEqualToString:kCmdScore]) {
        NSNumber *score=cmdMsg.data;
        lblCoachName.text=[NSString stringWithFormat:@"%@:",cmdMsg.from];
        Boolean isRedSide=[cmdMsg.desc isEqualToString:kSideRed];
        if(isRedSide){
            redTotalScore+=[score intValue];
            lblRedTotal.text=[NSString stringWithFormat:@"%i",redTotalScore];
        }else{
            blueTotalScore+=[score intValue];
            lblBlueTotal.text=[NSString stringWithFormat:@"%i",blueTotalScore];
        }
        
        switch ([score intValue]) {
            case 1:            
                if (isRedSide) {
                    lblRedImg1.hidden=NO;
                }else{
                    lblBlueImg1.hidden=NO;
                }
                break;
            case 2:
                if (isRedSide) {
                    lblRedImg1.hidden=NO;
                    lblRedImg2.hidden=NO;
                }
                else{
                    lblBlueImg1.hidden=NO;
                    lblBlueImg2.hidden=NO;
                }
                break;                
            default:
                break;
        }
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [txtHistory prependTextAfterLinebreak:[NSString stringWithFormat:@"%@ %@:%@ %@",[dateFormatter stringFromDate:[NSDate date]], cmdMsg.from,cmdMsg.desc,score]];
        [txtHistory scrollsToTop];
        [self performSelector:@selector(eraseText) withObject:nil afterDelay:2];
    }
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
    [self eraseText];
    lblBlueTotal.text=@"0";
    lblRedTotal.text=@"0";
    lblTitle.text=@"";
    // Switch back to welcome view
    [[ChattyAppDelegate getInstance] showRoomSelection];
}

- (IBAction)permit {
    [chatRoom stop];
    [[ChattyAppDelegate getInstance] showPermitControl:chatRoom validatePassword:NO setServerPassword:@""];
}

- (void)eraseText {
    lblBlueImg1.hidden =YES;
    lblBlueImg2.hidden=YES;    
    lblRedImg1.hidden=YES;
    lblRedImg2.hidden=YES;
}

@end
