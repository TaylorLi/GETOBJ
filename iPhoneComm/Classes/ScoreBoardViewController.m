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

#define  kMenuItemMenu 0
#define  kMenuItemExit 1
#define  kMenuItemContinueGame 2
#define  kMenuItemWarmningBlue 3
#define  kMenuItemWarmningRed 4
#define kMenuItemNextMatch 5

@interface ScoreBoardViewController ()

-(void)updatTime;
-(void)prepareForGame;
-(void)startRound:(id)sender;
-(void)contiueGame;
-(void)pauseGame;
-(void)resetRound;
-(void)goToNextMatch;
-(void)setupMenu;
- (void)menuItemAction:(id)sender;
-(void)gameLoop;
-(BOOL)testSomeClientDisconnect;
-(void)sendServerInfo;
-(void)pauseTime:(BOOL) stop;
-(void)testIfScoreCanSubmit;
-(void)submitScore:(int)score andIsRedSize:(BOOL)isRedSide;
-(void)showRoundRestTimeBox;
-(void)resetTimeEnd:(id)sender;
-(void)warmningPlayer:(Boolean) isForRedSide;
-(void)drawWarmningFlagForRed:(Boolean)isForRedSide;
-(void)setMenuByGameStatus:(GameStates)status;
-(UIButton *)getMenuItem:(int)tag;
-(void)processByGameStatus;
-(void) stopRoom;
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
@synthesize lblRedImg5;
@synthesize lblRedImg6;
@synthesize lblRedImg7;
@synthesize lblRedImg8;
@synthesize lblBlueImg5;
@synthesize lblBlueImg6;
@synthesize lblBlueImg7;
@synthesize lblBlueImg8;
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
    if(gameLoopTimer!=nil)
    {
        [gameLoopTimer invalidate];
        gameLoopTimer=nil;
    }
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
    waitUserPanel=nil;
    cmdHis=nil;
    for (NSArray *flags in dicSideFlags.allValues) {
        for (__strong UILabel *flag in flags) {
            flag=nil;
        }
    }
    dicSideFlags=nil;
    timer=nil;
    if(gameLoopTimer!=nil)
    {
        [gameLoopTimer invalidate];
        gameLoopTimer=nil;
    }
}

- (void)activate {
    //[self showRoundRestTimeBox];
    [self prepareForGame];
}
//when game going on,we need to refresh time 
-(void)updatTime { 
    chatRoom.gameInfo.currentRemainTime--;
	int min = chatRoom.gameInfo.currentRemainTime/60;
    int sec=fmod(chatRoom.gameInfo.currentRemainTime,60);
	lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    if(chatRoom.gameInfo.currentRemainTime==0){
        [self pauseTime:YES];
        if(chatRoom.gameInfo.currentRound==chatRoom.gameInfo.gameSetting.roundCount){
            [self setMenuByGameStatus:kStateGameEnd]; 
            [UIHelper showAlert:@"Information" message:@"The match has completed." func:nil];
        }else{    
            [self setMenuByGameStatus:kStateRoundReset]; 
            [self resetRound];
            [self showRoundRestTimeBox];
        }
    }    
} 
//show round rest when round end
-(void)showRoundRestTimeBox{
    if(roundResetPanel==nil)
    {
        CGRect frame=[AppConfig getInstance].isIPAD?CGRectMake(self.view.bounds.size.width/8, self.view.bounds.size.height/8, self.view.bounds.size.width/2, self.view.bounds.size.height/2):self.view.bounds;
        roundResetPanel = [[RoundRestTimeViewController alloc] initWithFrame:frame title:@"Rest Time" andRestTime:chatRoom.gameInfo.gameSetting.restTime];
        roundResetPanel.onClosePressed = ^(UAModalPanel* panel) {
            // [panel hide];
            //UADebugLog(@"onClosePressed block called from panel: %@", modalPanel);
        };
        roundResetPanel.delegate=self;
    }
    if (roundResetPanel!=nil) {
        if(![self.view.subviews containsObject:roundResetPanel])
        {
            ///////////////////////////////////
            // Add the panel to our view
            [self.view addSubview:roundResetPanel];	
            //[roundResetPanel showFromPoint:[self.view center]];
            ///////////////////////////////////
            // Show the panel from the center of the button that was pressed
        }
    }    
}
-(void)submitScore:(int)score andIsRedSize:(BOOL)isRedSide;
{    
    if(isRedSide){
        chatRoom.gameInfo.redSideScore+=score;
        lblRedTotal.text=[NSString stringWithFormat:@"%i",chatRoom.gameInfo.redSideScore];           
    }else{
        chatRoom.gameInfo.blueSideScore+=score;
        lblBlueTotal.text=[NSString stringWithFormat:@"%i",chatRoom.gameInfo.blueSideScore];
    }
    [self setMenuByGameStatus:kStateRunning];
}
/*
 所有裁判提交的分数必须相同,并且提交时间在1s之内,否则无效
 */
-(void)testIfScoreCanSubmit
{    
    if(cmdHis==nil)
        return;
    NSLog(@"Cmd his count:%i,client cout:%i",cmdHis.count,chatRoom.gameInfo.clients.count);
    int score=0;
    BOOL timeout=NO;
    NSDate *minTime=nil;
    for (CommandMsg *cmd in cmdHis) {
        if(minTime==nil)
        {
            minTime=cmd.date;
            continue;
        }
        else{
            if (cmd.date<minTime) {
                minTime=cmd.date;
            }
        }
        
    }
    double elaspedTime=kScoreCalcMaxDelay;
    //timeout now
    NSLog(@"%f",fabs([minTime timeIntervalSinceNow]));
    if(fabs([minTime timeIntervalSinceNow]) >= elaspedTime){
        timeout=YES;
    }
    if(timeout){
        [self setMenuByGameStatus:kStateRunning];
        cmdHis = nil;
        return;
    }
    
    NSMutableArray *scores=[[NSMutableArray alloc] initWithCapacity:cmdHis.count];
    NSMutableArray *uuids=[[NSMutableArray alloc] initWithCapacity:cmdHis.count];
    CommandMsg *firstCmd=[cmdHis objectAtIndex:0];
    [scores addObject:firstCmd.data];
    score=[[firstCmd data] intValue];
    NSString *side=firstCmd.desc;
    if(cmdHis.count>chatRoom.gameInfo.clients.count)
    {
        [self setMenuByGameStatus:kStateRunning];
        cmdHis = nil;
        return;
    }
    else if(cmdHis.count==chatRoom.gameInfo.clients.count){
        for (CommandMsg *cmd in cmdHis) {
            if(![cmd.desc isEqualToString:side])//not the same side,cancel
            {
                [self setMenuByGameStatus:kStateRunning];
                cmdHis = nil;
                return;
            }
            if([scores containsObject:cmd.data]){//score
                
            }
            else{
                [self setMenuByGameStatus:kStateRunning];
                cmdHis = nil;
                return; //not same score
            }
            if([uuids containsObject:cmd.from]){//uuid
                [self setMenuByGameStatus:kStateRunning];
                cmdHis = nil;
                return;
            }
            else
                [uuids addObject:cmd.from];
        }
        for (NSString *cltUuid in chatRoom.gameInfo.clients.allKeys) {
            if(![uuids containsObject:cltUuid]){
                return;//wait for next test
            }
        }
        
        [self submitScore:score andIsRedSize:[side isEqualToString:kSideRed]];
        
    }  
    
    
    
}
// We are being asked to process cmd
- (void)processCmd:(CommandMsg *)cmdMsg {
    
    switch ([cmdMsg.type intValue]) {
        case NETWORK_REPORT_SCORE:
        {
            //NSLog(@"msg date:%f",[cmdMsg.date timeIntervalSince1970]);
            //NSLog(@"receive date:%f",[[NSDate date] timeIntervalSince1970]);
            //NSLog(@"%f",[cmdMsg.date timeIntervalSince1970]-[[NSDate date] timeIntervalSince1970]);
            if(chatRoom.gameInfo.gameStatus==kStateRunning||chatRoom.gameInfo.gameStatus==kStateCalcScore)
            {
                [self setMenuByGameStatus:kStateCalcScore];
                cmdMsg.date=[NSDate date];
                if(cmdHis==nil){
                    cmdHis = [[NSMutableArray alloc] initWithObjects:cmdMsg, nil];
                }
                else{
                    [cmdHis addObject:cmdMsg];
                }
                //test if all judges have sent score
                [self testIfScoreCanSubmit];
            }            
        }
            break;
        case  NETWORK_CLIENT_INFO:
        { 
            JudgeClientInfo *cltInfo =[[JudgeClientInfo alloc] initWithDictionary:   cmdMsg.data];
            JudgeClientInfo *cltInfoOld=[chatRoom.gameInfo.clients objectForKey:cltInfo.uuid];
            if(cltInfoOld==nil)
            {//new client connected
                cltInfo.hasConnected=YES;
                cltInfo.lastHeartbeatDate=[NSDate date];
                [chatRoom.gameInfo.clients setObject:cltInfo forKey:cltInfo.uuid];
                [self showWaitingUserBox];//no all has enter the game
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
                        [self setMenuByGameStatus:kStateMultiplayerReconnect];
                        [self showWaitingUserBox];
                    }
                    else{
                        //every one back to game
                        chatRoom.gameInfo.gameStatus=chatRoom.gameInfo.preGameStatus;
                        if(chatRoom.gameInfo.gameStatus==kStateRunning)
                            [self contiueGame];
                        else
                        {
                            if(waitUserPanel!=nil&&[self.view.subviews containsObject:waitUserPanel]){
                                [waitUserPanel removeFromSuperview];
                                waitUserPanel=nil;
                            }
                            if(chatRoom.gameInfo.gameStatus==kStateRoundReset)
                            {
                                [roundResetPanel setTimerStop:NO];
                            }
                        }
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
    [self setMenuByGameStatus:kStateGameExit];
    [self sendServerInfo];
    [[AppConfig getInstance].invalidServerPeerIds addObject:chatRoom.bluetoothServer.serverSession.peerID];
    
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
    [roundResetPanel removeFromSuperview];
    roundResetPanel=nil;
    [self.actionHeaderView removeFromSuperview];
    self.actionHeaderView=nil;
    //send last message
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(stopRoom) userInfo:nil repeats:NO];
}

-(void)stopRoom
{
    [chatRoom stop];
    [[ChattyAppDelegate getInstance] showRoomSelection];
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
    [self pauseTime:YES];
    if(waitUserPanel==nil)
    {
        __block typeof (self) me = self;
        waitUserPanel = [[UIWaitForUserViewController alloc] initWithFrame:self.view.bounds title:@"Connecting Judge"];
        waitUserPanel.needConnectedClientCount=chatRoom.gameInfo.needClientsCount;
        waitUserPanel.onClosePressed = ^(UAModalPanel* panel) {
            // [panel hide];
            UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"End Game" message:@"Continue to end the game?" delegate:me cancelButtonTitle:@"Cancel" otherButtonTitles:@"End", nil];
            [alertView show];            
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
        if(waitUserPanel!=nil){
            [waitUserPanel hideWithOnComplete:^(BOOL finished) {
                
                [waitUserPanel removeFromSuperview];
                [self exit];
            }];                    
        }else{
            [self exit];
        }
    }
}

-(void)prepareForGame
{
    [self setMenuByGameStatus:kStatePrepareGame];
    if (chatRoom != nil ) {
        chatRoom.delegate = self;
        [chatRoom start];
        lblGameName.text=[NSString stringWithFormat:@"%@",chatRoom.gameInfo.gameSetting.gameName];
        lblGameDesc.text=chatRoom.gameInfo.gameSetting.gameDesc;
        lblRedPlayerName.text=chatRoom.gameInfo.gameSetting.redSideName;
        lblRedPlayerDesc.text=chatRoom.gameInfo.gameSetting.redSideDesc;
        lblBluePlayerDesc.text=chatRoom.gameInfo.gameSetting.blueSideDesc;
        lblBluePlayerName.text=chatRoom.gameInfo.gameSetting.blueSideName;
        dicSideFlags=[[NSDictionary alloc] initWithObjectsAndKeys:[[NSArray alloc] initWithObjects:lblRedImg1,lblRedImg2,lblRedImg3,lblRedImg4,lblRedImg5,lblRedImg6,lblRedImg7,lblRedImg8, nil],kSideRed,[[NSArray alloc] initWithObjects:lblBlueImg1,lblBlueImg2,lblBlueImg3,lblBlueImg4,lblBlueImg5,lblBlueImg6,lblBlueImg7,lblBlueImg8, nil],kSideBlue, nil];
        
    }
    [self resetRound];
    [self setupMenu];
    [self setMenuByGameStatus:kStateWaitJudge];
    [self showWaitingUserBox];
    double inv=kHeartbeatTimeInterval;
    gameLoopTimer=[NSTimer scheduledTimerWithTimeInterval:inv target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}
-(void)setupMenu
{
    self.actionHeaderView = [[DDActionHeaderView alloc] initWithFrame:self.view.bounds];
	
    // Set title
    self.actionHeaderView.titleLabel.text = @"";
	
    // Create action items, have to be UIView subclass, and set frame position by yourself.
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    menuButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    menuButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    menuButton.center = CGPointMake(25.0f, 25.0f);
    menuButton.tag=kMenuItemMenu;
    
    UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [continueButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [continueButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    continueButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    continueButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    continueButton.center = CGPointMake(75.0f, 25.0f);
    continueButton.tag=kMenuItemContinueGame;
    
    // Create action items, have to be UIView subclass, and set frame position by yourself.
    UIButton *redWarmningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redWarmningButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [redWarmningButton setImage:[UIImage imageNamed:@"minus-red"] forState:UIControlStateNormal];
    redWarmningButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    redWarmningButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    redWarmningButton.center = CGPointMake(125.0f, 25.0f);
    redWarmningButton.tag=kMenuItemWarmningRed;
    
    UIButton *blueWarmningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [blueWarmningButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [blueWarmningButton setImage:[UIImage imageNamed:@"minus-blue"] forState:UIControlStateNormal];
    blueWarmningButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    blueWarmningButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    blueWarmningButton.center = CGPointMake(175.0f, 25.0f);
    blueWarmningButton.tag=kMenuItemWarmningBlue;
    
    UIButton *nextMatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextMatchButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextMatchButton setImage:[UIImage imageNamed:@"next-match"] forState:UIControlStateNormal];
    nextMatchButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    nextMatchButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    nextMatchButton.center = CGPointMake(225.0f, 25.0f);
	nextMatchButton.tag=kMenuItemNextMatch;
    
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [exitButton setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
    exitButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    exitButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    exitButton.center = CGPointMake(275.0f, 25.0f);
	exitButton.tag=kMenuItemExit;
    // Set action items, and previous items will be removed from action picker if there is any.
    self.actionHeaderView.items = [NSArray arrayWithObjects:menuButton, continueButton,redWarmningButton,blueWarmningButton,nextMatchButton, exitButton, nil];	
	
    [self.view addSubview:self.actionHeaderView];
}
- (void)menuItemAction:(id)sender;{
    
    // Reset action picker
    int tag=[(UIButton *)sender tag];
    switch (tag) {
        case kMenuItemMenu:
            [self.actionHeaderView shrinkActionPicker];
            break;
        case kMenuItemExit:
        {
            UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"End Game" message:@"Continue to end the game?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"End", nil];
            [alertView show];
        }
            break;
        case kMenuItemContinueGame:
            if(chatRoom.gameInfo.gameStatus==kStateGamePause)
            {
                [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
                [self contiueGame];
            }
            else{
                [self pauseGame];
                [sender setImage:[UIImage imageNamed:@"continue"] forState:UIControlStateNormal];
            }
            break;
        case  kMenuItemNextMatch:
            [self goToNextMatch];
            break;
        case  kMenuItemWarmningBlue:
            [self warmningPlayer:NO];
            break;
        case  kMenuItemWarmningRed:
            [self warmningPlayer:YES];
            break;
        default:
            break;
    }
    //[self.actionHeaderView shrinkActionPicker];
}
//warming,when 2 warmning to be a Deduction(score -1)
-(void)warmningPlayer:(Boolean) isForRedSide{
    if(isForRedSide){
        chatRoom.gameInfo.redSideWarmning++;
        [self drawWarmningFlagForRed:YES];
    }
    else{
        chatRoom.gameInfo.blueSideWarmning++;
        [self drawWarmningFlagForRed:NO];
    }
    
}

-(void)drawWarmningFlagForRed:(Boolean)isForRedSide{
    
    NSArray *flags= [dicSideFlags valueForKey:isForRedSide?kSideRed: kSideBlue];
    int warmningCount=isForRedSide?chatRoom.gameInfo.redSideWarmning:chatRoom.gameInfo.blueSideWarmning;
    for (int i=0; i<flags.count; i++) {
        if (i<warmningCount) {
            UILabel *lblFlag=  [flags objectAtIndex:i];
            lblFlag.hidden=NO;
        }
    }
    //[self performSelector:@selector(eraseText) withObject:nil afterDelay:2];
    
}

//start round
-(void)startRound:(id)sender
{
    waitUserPanel=nil;
    if(timer==nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatTime) userInfo:nil repeats:YES];
    } 
    [self setMenuByGameStatus:kStateRunning];
    
}
-(void)contiueGame
{
    if(waitUserPanel!=nil&&[self.view.subviews containsObject:waitUserPanel]){
        [waitUserPanel removeFromSuperview];
        waitUserPanel=nil;
    }
    [self pauseTime:NO];
    [self setMenuByGameStatus:kStateRunning];
}
-(void)resetTimeEnd:(id)sender{
    roundResetPanel=nil;
    [self startRound:nil];
}
-(void)pauseTime:(BOOL) stop;
{
    if(stop){
        if(timer!=nil){
            [timer invalidate];
            timer=nil;
        }
    }
    else{
        if (timer==nil) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatTime) userInfo:nil repeats:YES];            
        }
    }
}
-(void)pauseGame
{
    [self pauseTime:YES];
    [self setMenuByGameStatus:kStateGamePause];
}
-(void)resetRound
{
    chatRoom.gameInfo.currentRemainTime=chatRoom.gameInfo.gameSetting.roundTime;
    //chatRoom.gameInfo.redSideScore=0;
    //chatRoom.gameInfo.blueSideScore=0;
    lblRedTotal.text=[NSString stringWithFormat:@"%i",chatRoom.gameInfo.redSideScore];
    lblBlueTotal.text=[NSString stringWithFormat:@"%i",chatRoom.gameInfo.blueSideScore];
    lblRoundSeq.text=[NSString stringWithFormat:@"Round %i", ++chatRoom.gameInfo.currentRound];
    int min = chatRoom.gameInfo.currentRemainTime/60;
    int sec=(int)chatRoom.gameInfo.currentRemainTime%60;
    lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec]; 
}

-(void)goToNextMatch
{
    chatRoom.gameInfo.redSideScore=0;
    chatRoom.gameInfo.blueSideScore=0;
    chatRoom.gameInfo.redSideWarmning=0;
    chatRoom.gameInfo.blueSideWarmning=0;
    chatRoom.gameInfo.currentMatch++;
    //resetRound will add round sequence
    chatRoom.gameInfo.currentRound=0;
    //reset round info
    [self resetRound];
    [self startRound:nil];
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
        
        if(counter%9==0){
            [self testSomeClientDisconnect];          
        }    
    }   
	[self processByGameStatus];
}
-(void)processByGameStatus
{
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
            [self testIfScoreCanSubmit];
            break;
        case kStateMultiplayerReconnect:
        {
            [self showWaitingUserBox];
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
    //NSLog(@"tesc disconnect:%i",chatRoom.gameInfo.clients.count);
    for (JudgeClientInfo *clt in chatRoom.gameInfo.clients.allValues) {
        if(!clt.hasConnected)
            hasDisconnect=YES;
        else if(clt.lastHeartbeatDate!=nil && fabs([clt.lastHeartbeatDate timeIntervalSinceNow]) >= inv) {
            clt.hasConnected=NO;
            hasDisconnect=YES;
            if(chatRoom.gameInfo.gameStatus==kStateRoundReset)
            {
                [roundResetPanel setTimerStop:YES];
            }
            [self setMenuByGameStatus:kStateMultiplayerReconnect];   
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
    [chatRoom sendCommand:reconnectCmd andPeerId:nil andSendDataReliable:YES];
}

-(void)setMenuByGameStatus:(GameStates)status;
{
    chatRoom.gameInfo.gameStatus = status;
    [self sendServerInfo];
    [self processByGameStatus];
    UIButton *continueButton=[self getMenuItem:kMenuItemContinueGame];
    UIButton *redWarmningButton=[self getMenuItem:kMenuItemWarmningRed];
    UIButton *blueWarmningButton=[self getMenuItem:kMenuItemWarmningBlue];
    UIButton *nextMatchButton=[self getMenuItem:kMenuItemNextMatch];
    if(chatRoom.gameInfo.gameStatus==kStateGameEnd)
    {
        continueButton.hidden=YES;
        redWarmningButton.hidden=YES;
        blueWarmningButton.hidden=YES;
        nextMatchButton.hidden=NO;
    }
    else if(chatRoom.gameInfo.gameStatus==kStateRunning)
    {
        continueButton.hidden=NO;
        redWarmningButton.hidden=NO;
        blueWarmningButton.hidden=NO;
        nextMatchButton.hidden=YES;
    }else{
        if(chatRoom.gameInfo.gameStatus==kStateGamePause)
            continueButton.hidden=NO;
        else
            continueButton.hidden=YES;
        redWarmningButton.hidden=YES;
        blueWarmningButton.hidden=YES;
        nextMatchButton.hidden=YES;
    }
    
}

-(UIButton *)getMenuItem:(int)tag{
    for (UIButton *btn in self.actionHeaderView.items) {
        if(btn.tag==tag)
            return btn;
    }   
    return nil;
}

@end
