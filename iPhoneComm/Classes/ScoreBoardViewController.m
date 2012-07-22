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
#import "UIHelper.h"

#define  kMenuItemExit 1
#define  kMenuItemContinueGame 2
@interface ScoreBoardViewController ()

-(void)updatTime;
-(void)prepareForGame;
-(void)startGame:(id)sender;
-(void)contiueGame;
-(void)pauseGame;
-(void)resetRound;
-(void)setupMenu;
- (void)menuItemAction:(id)sender;
-(void)gameLoop;
-(BOOL)testSomeClientDisconnect;
-(void)sendServerInfo;

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
@synthesize actionHeaderView;

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
    [self prepareForGame];
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
            JudgeClientInfo *cltInfoOld=[chatRoom.gameInfo.clients objectForKey:cltInfo.uuid];
            if(cltInfoOld==nil)
            {
                cltInfo.hasConnected=YES;
                cltInfo.lastHeartbeatDate=[NSDate date];
                [chatRoom.gameInfo.clients setObject:cltInfo forKey:cltInfo.uuid];
                [self showWaitingUserBox];
            }
            else
            {
                cltInfoOld.lastHeartbeatDate=[NSDate date];
                if(!cltInfoOld.hasConnected){                    
                    cltInfoOld.hasConnected=YES;
                    if(chatRoom.gameInfo.gameStatus==kStateWaitJudge){
                        //wait for judge
                        [self showWaitingUserBox];
                    }
                    else if([self testSomeClientDisconnect]){
                        //still some one disconnect
                        chatRoom.gameInfo.gameStatus=kStateMultiplayerReconnect;
                        [self showWaitingUserBox];
                    }
                    else{
                        //every one back to game
                        [self contiueGame];                         
                    }
                    
                }                       
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
    if(gameLoopTimer!=nil)
    {
        [gameLoopTimer invalidate];
        gameLoopTimer=nil;
    }
    waitUserPanel=nil;
    [[ChattyAppDelegate getInstance] showRoomSelection];
    [self.actionHeaderView removeFromSuperview];
    self.actionHeaderView=nil;
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
            UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"End Game" message:@"Continue to end the game?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"End", nil];
            [alertView show];
            [alertView release];            
            UADebugLog(@"onClosePressed block called from panel: %@", modalPanel);
        };
        waitUserPanel.delegate=self;
    }
    if (waitUserPanel!=nil) {
        if(![self.view.subviews containsObject:waitUserPanel])
        {
            ///////////////////////////////////
            // Add the panel to our view
            [self.view addSubview:waitUserPanel];	
            [waitUserPanel showFromPoint:[self.view center]];
            ///////////////////////////////////
            // Show the panel from the center of the button that was pressed
        }
        [waitUserPanel updateStatus:chatRoom.gameInfo.clients];
    }    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [waitUserPanel hideWithOnComplete:^(BOOL finished) {
            
            [waitUserPanel removeFromSuperview];
            [self exit];
        }];                       
    }
}

-(void)prepareForGame
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
    [self setupMenu];
    chatRoom.gameInfo.gameStatus=kStateWaitJudge;
    [self showWaitingUserBox];
    double inv=kHeartbeatTimeInterval;
    gameLoopTimer=[NSTimer scheduledTimerWithTimeInterval:inv target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}
-(void)setupMenu
{
    self.actionHeaderView = [[[DDActionHeaderView alloc] initWithFrame:self.view.bounds] autorelease];
	
    // Set title
    self.actionHeaderView.titleLabel.text = @"";
	
    // Create action items, have to be UIView subclass, and set frame position by yourself.
    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [facebookButton setImage:[UIImage imageNamed:@"facebook"] forState:UIControlStateNormal];
    facebookButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    facebookButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    facebookButton.center = CGPointMake(25.0f, 25.0f);
    
    UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [twitterButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [twitterButton setImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
    twitterButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    twitterButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    twitterButton.center = CGPointMake(75.0f, 25.0f);
    twitterButton.tag=kMenuItemContinueGame;
    
    UIButton *mailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mailButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [mailButton setImage:[UIImage imageNamed:@"mail"] forState:UIControlStateNormal];
    mailButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    mailButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    mailButton.center = CGPointMake(125.0f, 25.0f);
	mailButton.tag=kMenuItemExit;
    // Set action items, and previous items will be removed from action picker if there is any.
    self.actionHeaderView.items = [NSArray arrayWithObjects:facebookButton, twitterButton, mailButton, nil];	
	
    [self.view addSubview:self.actionHeaderView];
}
- (void)menuItemAction:(id)sender;{
    
    // Reset action picker
    int tag=[(UIButton *)sender tag];
    if(tag==kMenuItemExit)
    {
        [self exit];
    }
    else if(tag==kMenuItemContinueGame)
    {
        if(chatRoom.gameInfo.gameStatus==kStateGamePause)
        {
            [self contiueGame];
        }
        else{
            [self pauseGame];
        }
    }
    [self.actionHeaderView shrinkActionPicker];
}
-(void)startGame:(id)sender
{
    waitUserPanel=nil;
    if(timer==nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatTime) userInfo:nil repeats:YES];
        [timer fire];
    } 
    chatRoom.gameInfo.gameStatus=kStateRunning;
    
}
-(void)contiueGame
{
    if(waitUserPanel!=nil&&[self.view.subviews containsObject:waitUserPanel]){
        [waitUserPanel removeFromSuperview];
        waitUserPanel=nil;
    }
    if(timer==nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatTime) userInfo:nil repeats:YES];
        [timer fire];
    } 
    chatRoom.gameInfo.gameStatus=kStateRunning;
}
-(void)pauseGame
{
    [timer invalidate];
    timer=nil;
    chatRoom.gameInfo.gameStatus=kStateGamePause;
}
-(void)resetRound
{
    redTotalScore=0;
    blueTotalScore=0;
    lblRedTotal.text=[NSString stringWithFormat:@"%i",redTotalScore];
    lblBlueTotal.text=[NSString stringWithFormat:@"%i",blueTotalScore];
    int min = chatRoom.gameInfo.currentRemainTime/60;
    int sec=(int)chatRoom.gameInfo.currentRemainTime%60;
    lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec]; 
}
//game loop here,send server's status to clients
-(void)gameLoop
{
    static int counter = 0;    
    if (chatRoom.gameInfo.gameStatus!=kStatePrepareGame) {
        counter++;
        // once every 8 updates check if we have a recent heartbeat from the other player, and send a heartbeat packet with current state        
        if(counter%3==0) {
            
            [self sendServerInfo];
        }
        
        if(counter%6==0){
            [self testSomeClientDisconnect];          
        }    
    }    
	switch (chatRoom.gameInfo.gameStatus) {
		case kStatePrepareGame:
            break;
        case kStateWaitJudge:
            
            break;
        case  kStateRunning:
        {
            
        }
            break;
        case  kStateCalcScore:
            break;
        case kStateMultiplayerReconnect:
        {
        }
            break;
        case kStateGamePause:
            break;
        case kStateGameEnd:
            break;	
		default:
			break;
	}
}
-(BOOL)testSomeClientDisconnect
{
    BOOL hasDisconnect=NO;
    double inv=kHeartbeatTimeMaxDelay;
    for (JudgeClientInfo *clt in chatRoom.gameInfo.clients.allValues) {
        if(!clt.hasConnected)
            hasDisconnect=YES;
        else if(clt.lastHeartbeatDate!=nil && fabs([clt.lastHeartbeatDate timeIntervalSinceNow]) >= inv) {
            clt.hasConnected=NO;
            hasDisconnect=YES;
            chatRoom.gameInfo.gameStatus=kStateMultiplayerReconnect;
            [self showWaitingUserBox];
        }
    }
    return hasDisconnect;           
}
-(void)sendServerInfo
{
    chatRoom.gameInfo.serverLastHeartbeatDate=[NSDate date];
    CommandMsg *reconnectCmd=[[CommandMsg alloc] initWithType:NETWORK_HEARTBEAT andFrom:[AppConfig getInstance].name 
                                                      andDesc:nil andData:chatRoom.gameInfo andDate:[NSDate date]];
    [chatRoom sendCommand:reconnectCmd andPeerId:nil andSendDataReliable:NO];
}
@end
