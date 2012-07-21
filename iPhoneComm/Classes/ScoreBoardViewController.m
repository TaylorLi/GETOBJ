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
#import "GameInfo.h"
#import "JudgeClientInfo.h"

@interface ScoreBoardViewController ()

-(void)updatTime;
-(void)preparForGame;
-(void)startOrContinueGame:(id)sender;
-(void)resetRound;

@end 

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
    lblGameName=nil;
    waitUserPanel=nil;
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
    timer=nil;
    [super dealloc];
}

- (void)activate {
    [self preparForGame];
}
//when game going on,we need to refresh time 
-(void)updatTime {    
	int min = chatRoom.gameInfo.currentRemainTime/60;
    int sec=fmod(chatRoom.gameInfo.currentRemainTime,60);
	lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    chatRoom.gameInfo.currentRemainTime--;
} 

// We are being asked to process cmd
- (void)processCmd:(CommandMsg *)cmdMsg {
    
    switch ([cmdMsg.type intValue]) {
        case NETWORK_REPORT_SCORE:
        {
            NSNumber *score;  score=(NSNumber *)cmdMsg.data;
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
            break;
        case  NETWORK_CLIENT_INFO:
        { 
            JudgeClientInfo *cltInfo =[[JudgeClientInfo alloc] initWithDictionary:   cmdMsg.data];
            BOOL contains=NO;
            for (NSString* key in [chatRoom.gameInfo.clients allKeys]) {
                if ([key isEqualToString:cltInfo.uuid]) {
                    contains=YES;
                    break;
                }
            }
            if(!contains){
                cltInfo.hasConnected=YES;
                [chatRoom.gameInfo.clients setObject:cltInfo forKey:cltInfo.uuid];
                [self showWaitingUserBox];
            }            
        }
            break;
        default:
            break;
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
    if(timer!=nil)
    {
        [timer invalidate];
        timer=nil;
    }
    waitUserPanel=nil;
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

-(void)showWaitingUserBox
{
    if(waitUserPanel==nil)
    {
        waitUserPanel = [[[UIWaitForUserViewController alloc] initWithFrame:self.view.bounds title:@"Connecting Judge"] autorelease];
        waitUserPanel.needConnectedClientCount=chatRoom.gameInfo.needClientsCount;
        waitUserPanel.onClosePressed = ^(UAModalPanel* panel) {
            // [panel hide];
            [panel hideWithOnComplete:^(BOOL finished) {
                [panel removeFromSuperview];
            }];
            UADebugLog(@"onClosePressed block called from panel: %@", modalPanel);
        };
        waitUserPanel.delegate=self;
    }
    if (waitUserPanel!=nil) {
        if(waitUserPanel.superview==nil)
        {
            ///////////////////////////////////
            // Add the panel to our view
            [self.view addSubview:waitUserPanel];	
            ///////////////////////////////////
            // Show the panel from the center of the button that was pressed
        }
        [waitUserPanel showFromPoint:[self.view center]];
        [waitUserPanel updateStatus:chatRoom.gameInfo.clients];
    }    
}

-(void)preparForGame
{
    chatRoom.gameInfo.gameStatus=kStatePrepareGame;
    if (chatRoom != nil ) {
        chatRoom.delegate = self;
        [chatRoom start];
        lblGameName.text=[NSString stringWithFormat:@"%@",chatRoom.gameInfo.gameSetting.gameName];
        lblGameDesc.text=chatRoom.gameInfo.gameSetting.gameDesc;
        lblRedPlayerName.text=chatRoom.gameInfo.gameSetting.redSideName;
        lblRedPlayerDesc.text=chatRoom.gameInfo.gameSetting.redSideDesc;
        lblBluePlayerDesc.text=chatRoom.gameInfo.gameSetting.blueSideDesc;
        lblBluePlayerName.text=chatRoom.gameInfo.gameSetting.blueSideName;
        lblRoundSeq.text=[NSString stringWithFormat:@"Round %i",chatRoom.gameInfo.currentRound];
        dicSideFlags=[[NSDictionary alloc] initWithObjectsAndKeys:[[NSArray alloc] initWithObjects:lblRedImg1,lblRedImg2,lblRedImg3,lblRedImg4, nil],kSideRed,[[NSArray alloc] initWithObjects:lblBlueImg1,lblBlueImg2,lblBlueImg3,lblBlueImg4, nil],kSideBlue, nil];
        
    }
    [self resetRound];
    chatRoom.gameInfo.gameStatus=kStateWaitJudge;
    [self showWaitingUserBox];
}
-(void)startOrContinueGame:(id)sender
{
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(updatTime) userInfo:nil repeats:YES];
    [timer fire];
    chatRoom.gameInfo.gameStatus=kStateRunning;
    
}
-(void)resetRound
{
    redTotalScore=0;
    blueTotalScore=0;
    lblRedTotal.text=[NSString stringWithFormat:@"%i",redTotalScore];
    lblBlueTotal.text=[NSString stringWithFormat:@"%i",blueTotalScore];
    int min = chatRoom.gameInfo.currentRemainTime/60;
    int sec=fmod(chatRoom.gameInfo.currentRemainTime,60);
    lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec]; 
}
@end
