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
#import "ServerSetting.h"

@implementation ScoreBoardViewController

@synthesize lblCoachName;
@synthesize lblGameName;
@synthesize txtHistory;
@synthesize chatRoom;
@synthesize lblGameDesc;
@synthesize lblBluePlayerName;
@synthesize lblBluePlayerDesc;
@synthesize lblTime;
@synthesize lblRoundSeq;
@synthesize lblRedPlayerDesc;
@synthesize lblRedPlayerName;
@synthesize lblRedImg1;
@synthesize lblRedImg2;
@synthesize lblRedImg3;
@synthesize lblRedImg4;
@synthesize lblBlueImg1;
@synthesize lblBlueImg2;
@synthesize lblBlueImg3;
@synthesize lblBlueImg4;
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setLblGameDesc:nil];
    [self setLblBluePlayerName:nil];
    [self setLblBluePlayerDesc:nil];
    [self setLblTime:nil];
    [self setLblRoundSeq:nil];
    [self setLblRedPlayerDesc:nil];
    [self setLblRedPlayerName:nil];
    [super viewDidUnload];    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [AppConfig shouldAutorotateToInterfaceOrientationLandscape:interfaceOrientation];
}

- (void)dealloc {
    lblCoachName=nil;
    lblGameName=nil;;
    txtHistory=nil;
    lblRedTotal=nil;
    for (NSArray *flags in dicSideFlags.allValues) {
        for (UILabel *flag in flags) {
            flag=nil;
        }
    }
    lblBlueTotal=nil;
    self.chatRoom = nil;
    dicSideFlags=nil;
    [lblGameName release];
    [lblBluePlayerName release];
    [lblBluePlayerDesc release];
    [lblTime release];
    [lblRoundSeq release];
    [lblRedPlayerDesc release];
    [lblRedPlayerName release];
    [super dealloc];
}

- (void)activate {
    if (chatRoom != nil ) {
        chatRoom.delegate = self;
        [chatRoom start];
        lblGameName.text=[NSString stringWithFormat:@"%@",chatRoom.gameSetting.gameName];
        lblGameDesc.text=chatRoom.gameSetting.gameDesc;
        lblRedPlayerName.text=chatRoom.gameSetting.redSideName;
        lblRedPlayerDesc.text=chatRoom.gameSetting.redSideDesc;
        lblBluePlayerDesc.text=chatRoom.gameSetting.blueSideDesc;
        lblBluePlayerName.text=chatRoom.gameSetting.blueSideName;
        lblTime.text=[NSString stringWithFormat:@"%i",chatRoom.gameSetting.roundTime];
        lblRoundSeq.text=[NSString stringWithFormat:@"%i",chatRoom.gameSetting.roundCount];
        redTotalScore=0;
        blueTotalScore=0;
        dicSideFlags=[[NSDictionary alloc] initWithObjectsAndKeys:[[NSArray alloc] initWithObjects:lblRedImg1,lblRedImg2,lblRedImg3,lblRedImg4, nil],kSideRed,[[NSArray alloc] initWithObjects:lblBlueImg1,lblBlueImg2,lblBlueImg3,lblBlueImg4, nil],kSideBlue, nil];
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
        NSArray *flags= [dicSideFlags valueForKey:cmdMsg.desc];
        for (int i=0; i<flags.count; i++) {
            if (i<[score intValue]) {
                UILabel *lblFlag=  [flags objectAtIndex:i];
                lblFlag.hidden=NO;
            }
        }
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [txtHistory prependTextAfterLinebreak:[NSString stringWithFormat:@"%@ %@:%@ %@",[dateFormatter stringFromDate:[NSDate date]], cmdMsg.from,cmdMsg.desc,score]];
        [txtHistory scrollsToTop];
        [self performSelector:@selector(eraseText) withObject:nil afterDelay:2];
    }
}

#pragma mark -
#pragma mark RoomDelegate
// Room closed from outside
- (void)roomTerminated:(id)room reason:(NSString*)reason {
    // Explain what happened
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Server terminated" message:reason delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [self exit];
}
//we not care this delegate
-(void) alreadyConnectToServer
{
    
}
//we not care this delegate
-(void) failureToConnectToServer
{
    
}

// User decided to exit room
- (IBAction)exit {
    // Close the room
    [[AppConfig getInstance].invalidServerPeerIds addObject:chatRoom.bluetoothServer.serverSession.peerID];
    [chatRoom stop];
    
    // Remove keyboard
    
    // Erase chat
    [self eraseText];
    lblBlueTotal.text=@"0";
    lblRedTotal.text=@"0";
    lblGameName.text=@"";
    // Switch back to welcome view
    [[ChattyAppDelegate getInstance] showRoomSelection];
}

- (IBAction)permit {
    [chatRoom stop];
    [[ChattyAppDelegate getInstance] showPermitControl:chatRoom validatePassword:NO setServerPassword:@""];
}

- (void)eraseText {
    for (NSArray *flags in dicSideFlags.allValues) {
        for (UILabel *flag in flags) {
            flag.hidden=YES;
        }
    }
}

@end
