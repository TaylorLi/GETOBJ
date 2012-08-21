//
//  SwipesViewController.m
//  Swipes
//
//  Created by Dave Mark on 12/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScoreControlViewController.h"
#import "ChattyAppDelegate.h"
#import "Definition.h"
#import "AppConfig.h"
#import "UILoadingBox.h"
#import "JudgeClientInfo.h"
#import "GameInfo.h"
#import "UIHelper.h"
#import <AudioToolbox/AudioToolbox.h>  
#import <CoreFoundation/CoreFoundation.h> 

#define kMinimumGestureLength    25
#define kMaximumVariance         5

@interface ScoreControlViewController ()

-(void)gameLoop;
-(void)reportClientInfo;
-(void) showConnectingBox:(BOOL)show andTitle:(NSString *)title;
-(void) showTipBox:(NSString *)tip;
-(void) closeTipBox:(NSTimer *)timer;
-(void) onExited;
-(void) processGameStatus;
-(void) retryConnect;
-(void) showRetryConnect;
-(void) showReconnectConfirmBox;
-(void) testConnect:(NSTimer *)timer;
-(void)closeInfoBox;
-(void)reportClientHeartbeat;
-(void) connectedToServerSuccess;
-(void)setConnectionIndicatorToConnected:(BOOL)connected;
@end

@implementation ScoreControlViewController
@synthesize label;
@synthesize gestureStartPoint;
@synthesize chatRoom;
@synthesize screenWidth;
@synthesize viewBlue;
@synthesize viewRed;
@synthesize imgBlueScore;
@synthesize imgRedScore;
@synthesize btnMenuHideBackground;
@synthesize btnMenuHide;
@synthesize btnMenuShow;
@synthesize imgMenuShowBackground;
@synthesize imgConnectiondicator;

- (void)eraseText {
    label.text = @"";
}


/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [AppConfig shouldAutorotateToInterfaceOrientationLandscape:interfaceOrientation];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL isHorizontal = [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft] || [self shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
    if(isHorizontal)
    {
        screenWidth = [[UIScreen mainScreen] bounds].size.height;
    }
    else
    {
        screenWidth = [[UIScreen mainScreen] bounds].size.width;
    }
    
    //background
    //    isBlueSide=YES;
    //    [self setStyleBySide];
    //guesture
    UISwipeGestureRecognizer *top;   
    top = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(reportSwipeUp:)];
    top.direction = UISwipeGestureRecognizerDirectionUp;
    top.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:top];
    
    UISwipeGestureRecognizer *down;   
    
    down = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                     action:@selector(reportSwipeDown:)];
    down.direction = 
    UISwipeGestureRecognizerDirectionDown;
    down.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:down];
    
    UISwipeGestureRecognizer *left;
    left = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                     action:@selector(reportSwipeLeft:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    
    left.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *right;
    right = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(reportSwipeRight:)];
    right.direction = UISwipeGestureRecognizerDirectionRight    ;
    right.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:right];
    
    /*   UISwipeGestureRecognizer *switchRcgn;
     switchRcgn = [[[UISwipeGestureRecognizer alloc] initWithTarget:self
     action:@selector(switchSide:)] autorelease];
     switchRcgn.direction = UISwipeGestureRecognizerDirectionLeft|UISwipeGestureRecognizerDirectionRight;
     switchRcgn.numberOfTouchesRequired = 2;
     [self.view addGestureRecognizer:switchRcgn];
     
     UISwipeGestureRecognizer *switchRcgnVertical;
     switchRcgnVertical = [[[UISwipeGestureRecognizer alloc] initWithTarget:self
     action:@selector(switchSide:)] autorelease];
     switchRcgnVertical.direction = UISwipeGestureRecognizerDirectionUp|UISwipeGestureRecognizerDirectionDown;
     switchRcgnVertical.numberOfTouchesRequired = 2;
     [self.view addGestureRecognizer:switchRcgnVertical];*/
}

/*-(void)setStyleBySide
 {
 if(isBlueSide){
 self.view.backgroundColor=[UIColor blueColor];
 }
 else{
 self.view.backgroundColor=[UIColor redColor];
 }
 }*/

-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.label = nil;
    if(tipBox != nil){
        tipBox = nil;
    }
    self.chatRoom = nil;
    loadingBox=nil;
    reConnectBox=nil;
    tipBox=nil;
    [self setViewBlue:nil];
    [self setViewRed:nil];
    [self setImgBlueScore:nil];
    [self setImgRedScore:nil];
    [self setImgConnectiondicator:nil];
    [self setBtnMenuHide:nil];
    [self setBtnMenuShow:nil];
    [self setImgMenuShowBackground:nil];
    [self setBtnMenuHideBackground:nil];
    [super viewDidUnload];
}


- (NSString *)descriptionForScore:(NSUInteger)score {
    return [NSString stringWithFormat:@"%i",score];
}

#pragma mark -
- (void)reportSwipeUp:(UIGestureRecognizer *)recognizer {  
    [self reportSwipe:4 fromGestureRecognizer:recognizer];
}
- (void)reportSwipeDown:(UIGestureRecognizer *)recognizer {
    [self reportSwipe:2 fromGestureRecognizer:recognizer];
}
- (void)reportSwipeLeft:(UIGestureRecognizer *)recognizer {
    [self reportSwipe:1 fromGestureRecognizer:recognizer];
}
- (void)reportSwipeRight:(UIGestureRecognizer *)recognizer {
    [self reportSwipe:3 fromGestureRecognizer:recognizer];
}
- (void)reportSwipe:(NSInteger)score fromGestureRecognizer:(UIGestureRecognizer *) recognizer{
    CGPoint currentPosition = [recognizer locationInView:self.view];
    isBlueSide = currentPosition.x < screenWidth/2;
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self sendScore:score];    
    label.text = [NSString stringWithFormat:@"%@ %i Score Record",
                  isBlueSide?[kSideBlue uppercaseString]:[kSideRed uppercaseString] ,score];;
    [self performSelector:@selector(eraseText) withObject:nil afterDelay:2];
}

/*-(void)switchSide:(UIGestureRecognizer *)recognizer
 {
 isBlueSide=!isBlueSide;
 [self setStyleBySide];
 }*/

- (void)activate {
    [AppConfig getInstance].isGameStart=YES;
    isExit=NO;
    hasEverConnectd=NO;
    imgBlueScore.hidden=YES;
    imgRedScore.hidden=YES;
    [self hideMenu:nil];
    [self setConnectionIndicatorToConnected:NO];
    if ( chatRoom != nil ) {        
        chatRoom.delegate = self;
        [chatRoom start];        
    }
    [self showConnectingBox:YES andTitle:@"Connecting to Server..."];
}

-(void) showConnectingBox:(BOOL)show andTitle:(NSString *)title;
{ if(show)
{
    if(loadingBox==nil){
        loadingBox =[[UILoadingBox alloc ]initWithLoading:title showCloseImage:YES onClosed:^{            
            [self exit];    
        }];
        
    }
    else{
        loadingBox.message=title;
    }
    if(loadingBox.superview==nil)
        [loadingBox showLoading];
    else{
        
    }
}
else{
    if(loadingBox!=nil)
        [loadingBox hideLoading];
}
}
#pragma mark -
#pragma mark RoomDeleagate
// We are being asked to display a chat message
- (void)processCmd:(CommandMsg *)cmdMsg {
    //no process old message
    //NSLog(@"client receive msg time:old:%f,new:%f",[serverLastMsgDate timeIntervalSince1970],[cmdMsg.date timeIntervalSince1970]);
    //    if(serverLastMsgDate!=nil&&[serverLastMsgDate timeIntervalSince1970]>[cmdMsg.date timeIntervalSince1970]){
    //        NSLog(@"message old return");
    //        return;
    //    }
    //NSLog(@"Receive Server Command:%@",cmdMsg);
    serverLastMsgDate=[NSDate date];
    hasEverConnectd=YES;
    switch ([cmdMsg.type intValue]) {
        case NETWORK_SERVER_WHOLE_INFO:
        {
            chatRoom.serverInfo=[[GameInfo alloc] initWithDictionary: cmdMsg.data];
            if(chatRoom.orgServerInfo.uuid==nil){
                chatRoom.orgServerInfo.uuid=chatRoom.serverInfo.serverUuid;
            }
            [self processGameStatus]; 
            [self connectedToServerSuccess];
        }
            break;
        case  NETWORK_HEARTBEAT://server heartbeat
        {             
            GameStates stauts=[cmdMsg.data intValue];
            if(chatRoom.serverInfo.gameStatus!=stauts){
                chatRoom.serverInfo.gameStatus=stauts;
                [self processGameStatus];
            }
        }
            break;
        case NETWORK_SERVER_STATUS:
        {           
            NSNumber *gameStatus = cmdMsg.data;
            GameStates stauts=[gameStatus intValue];
            if(stauts==kStateRunning){
                [self reportClientHeartbeat];
            }
            chatRoom.serverInfo.gameStatus=stauts;
            chatRoom.serverInfo.statusRemark=cmdMsg.desc;
            //NSLog(@"Reiceive SeverInfo:%@",chatRoom.serverInfo);
            [self processGameStatus];            
        }
            break;
        case NETWORK_INVALID_CLIENT:
        {
            if(isExit)
                return;
            else{
                isExit=YES;
                //we are not the valid client to the server
                [UIHelper showAlert:@"Information" message:@"Can not connect to the server." func:^(AlertView *a, NSInteger i) {
                    [self exit];
                }];
                return;
            }
        }
            break;
        default:
            break;
    }
    chatRoom.serverInfo.serverLastHeartbeatDate=serverLastMsgDate;
    [self setConnectionIndicatorToConnected:YES];
    if(isReconnect){
        isReconnect=NO;
        if(reConnectBox!=nil&&reConnectBox.superview!=nil)
        {
            [reConnectBox dismissWithClickedButtonIndex:-1 animated:NO];
        }                
        [self connectedToServerSuccess];
    }
}


// Room closed from outside
- (void)roomTerminated:(id)room reason:(NSString*)reason {   
    //    [UIHelper showAlert:@"Information" message:@"server exited." func:^(AlertView *a, NSInteger i) {
    //        [self exit];
    //    }];
}


// User decided to exit room
- (IBAction)exit {
    isExit=YES;
    [AppConfig getInstance].isGameStart=NO;
    loadingBox.title=@"Now prepare to exit ...";
    // Close the room
    [chatRoom stop];
    
    // Remove keyboard
    
    // Erase chat
    
    
    // Switch back to welcome view
    if(gameLoopTimer != nil){
        [gameLoopTimer invalidate];
        gameLoopTimer=nil;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onExited) userInfo:nil repeats:NO];
    
}

- (IBAction)showMenu:(id)sender {
    btnMenuShow.hidden=NO;
    imgMenuShowBackground.hidden=NO;
    btnMenuHide.hidden=YES;
    btnMenuHideBackground.hidden=YES;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideMenuWithAnimate) userInfo:nil repeats:NO];
}
-(IBAction)hideMenu:(id)sender
{
    btnMenuShow.hidden=YES;
    imgMenuShowBackground.hidden=YES;
    btnMenuHide.hidden=NO;
    btnMenuHideBackground.hidden=NO;
}
-(void)hideMenuWithAnimate{
    CGRect btnFrame=btnMenuShow.frame;
    CGRect btnBg=imgMenuShowBackground.frame;
    CGRect btnFrameX=btnFrame;
    CGRect btnBgX=btnBg;
    [UIView animateWithDuration:1
                     animations:^{
                         btnMenuShow.frame=CGRectMake(0, 0, btnFrame.size.width, btnFrame.size.height/2);
                         imgMenuShowBackground.frame=CGRectMake(0, 0, btnBg.size.width, btnBg.size.height/2);
                     }];
    [UIView animateWithDuration:1
                     animations:^{
                         btnMenuShow.frame=CGRectMake(0, 0, btnFrame.size.width, 0);
                         imgMenuShowBackground.frame=CGRectMake(0, 0, btnBg.size.width, 0);                
                     }];
    btnMenuShow.hidden=YES;
    imgMenuShowBackground.hidden=YES;
    btnMenuShow.frame=btnFrameX;
    imgMenuShowBackground.frame=btnBgX;
    btnMenuHide.hidden=NO;
    btnMenuHideBackground.hidden=NO;
}
-(void)closeInfoBox
{
    if(loadingBox!=nil)
    {
        [loadingBox dismissWithClickedButtonIndex:-1 animated:NO];
        loadingBox=nil;
    }
    if(tipBox!=nil)
    {
        [tipBox dismissWithClickedButtonIndex:-1 animated:NO];
        tipBox=nil;
    }
    for(UIView *sview in self.view.subviews){
        if([sview isMemberOfClass:[UIAlertView class]])
            [sview removeFromSuperview];
    }
}
-(void) onExited{
    [self closeInfoBox];    
    [[ChattyAppDelegate getInstance] showRoomSelection];
}
-(void) alreadyConnectToServer
{
    [self reportClientInfo];
}
-(void) connectedToServerSuccess
{
    double inv=kClientHeartbeatTimeInterval;
    if(![gameLoopTimer isValid]){
        gameLoopTimer=[NSTimer scheduledTimerWithTimeInterval: inv target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
    }
}
//fail to connect to server,we can test this by heartbeat
-(void) failureToConnectToServer
{
    if(isExit)
        return;
    if(!hasEverConnectd){
        [reConnectBox dismissWithClickedButtonIndex:-1 animated:NO];
        [tipBox dismissWithClickedButtonIndex:-1 animated:NO];    
        [UIHelper showAlert:@"Information" message:@"Unable connect to server" func:^(AlertView *a, NSInteger i) {
            [self exit];
        }];
    }
    else{
        [self testConnect:nil];
    }
}
-(void)sendScore:(NSInteger) score
{
    NSLog(@"send score date:%f",[[NSDate date] timeIntervalSinceReferenceDate]);
    [self showConnectingBox:YES andTitle:@"Wait for score result"];
    [chatRoom sendCommand:[[CommandMsg alloc] initWithType:NETWORK_REPORT_SCORE andFrom:chatRoom.clientInfo.uuid andDesc:isBlueSide?kSideBlue:kSideRed andData:[NSNumber numberWithInt:score] andDate:[NSDate date]]];
}

-(void) showTipBox:(NSString *)tip;
{
    [loadingBox hideLoading];
    if(tipBox==nil){
        tipBox= [[UIAlertView alloc] initWithTitle:@"Information" message:tip delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    }    
    if(tipBox.superview==nil){
        [tipBox show];
    }  
    else{
        tipBox.message=tip;
    }
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(closeTipBox:) userInfo:tipBox repeats:NO];
    
}
-(void) closeTipBox:(NSTimer *)timer
{
    UIAlertView *box=[timer userInfo];
    [box dismissWithClickedButtonIndex:-1 animated:NO];
}
-(void)gameLoop
{    
    static int counter = 0;  
    //static int reConnCounter = 0;
    counter++;
    
    if( chatRoom.serverInfo.gameStatus==kStateGameExit||chatRoom.serverInfo.gameStatus== kStateGameEnd||chatRoom.serverInfo.gameStatus==kStatePrepareGame)
        return;
    
    [self reportClientHeartbeat];
    
    if(chatRoom.serverInfo.gameStatus==kStateRoundRest||chatRoom.serverInfo.gameStatus==kStateGamePause)
        return;
    if(counter%(int)(kClientTestServerHearbeatTime/kClientHeartbeatTimeInterval)==0) {
        double inv=kClientTestServerHearbeatTime;
        if(serverLastMsgDate!=nil && fabs([serverLastMsgDate timeIntervalSinceNow]) >= inv){
            isReconnect=YES;
            [self setConnectionIndicatorToConnected:NO];
            [self showRetryConnect];    
            return;
        }
    }
}
-(void) retryConnect
{
    if(isReconnect){
        [self setConnectionIndicatorToConnected:NO];
        NSLog(@"reconnect log");
        [self showConnectingBox:YES andTitle:@"Try to reconnect for server..."];
        [chatRoom testUnavailableAndRestart];
        //报告自己        
        //        [self.chatRoom stop];
        //        self.chatRoom=nil;
        //        chatRoom=[[RemoteRoom alloc] initWithPeerId:peerId];
        //        chatRoom.delegate = self;
        //        [chatRoom start]; 
        //        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(testConnect:) userInfo:nil repeats:NO];
    }
}
-(void)tryToReconnect
{
    [self showConnectingBox:YES andTitle:@"Try to reconnect for server..."];
    if(!isExit&&[AppConfig getInstance].isGameStart&&(!chatRoom.bluetoothClient.gameSession.isAvailable||![chatRoom isConnected])){
            isReconnect=YES;            
            [self retryConnect];
    }
    else{
        [self alreadyConnectToServer];
    }
}
-(void) showRetryConnect
{
    if(isReconnect){ 
        if(gameLoopTimer!=nil)
        {
            [gameLoopTimer invalidate];
            gameLoopTimer = nil;  
        }
        if([chatRoom isConnected]){
            [self reportClientInfo];
            return;
        }
        
        if(loadingBox!=nil)
            [loadingBox hideLoading];
        if(tipBox!=nil)
            [tipBox removeFromSuperview];
        [self showConnectingBox:YES andTitle:@"Reconnecting"];
        
        [self retryConnect];
    }else{
        [self alreadyConnectToServer];
    }
}

-(void) testConnect:(NSTimer *)timer
{
    if(timer!=nil)
        [timer invalidate];
    if(!isReconnect){
        [self alreadyConnectToServer];
    }else{
        [self showReconnectConfirmBox];
        [self setConnectionIndicatorToConnected:NO];
    }
}
-(void) showReconnectConfirmBox
{
    if(reConnectBox==nil)
    {
        reConnectBox = [[AlertView alloc] initWithTitle:NSLocalizedString(@"Fail connect to server", @"") message:NSLocalizedString(@"Do you want to retry?", @"")];
        [reConnectBox addButtonWithTitle:NSLocalizedString(@"Retry", @"") block:[^(AlertView* a, NSInteger i){
            [self retryConnect];        
        } copy]];
        [reConnectBox addButtonWithTitle:NSLocalizedString(@"Exit", @"") block:[^(AlertView* a, NSInteger i){
            [self exit];
        } copy]];
        reConnectBox.tag=15;
    }
    if(reConnectBox.superview==nil)
        [reConnectBox show];
}
-(void) processGameStatus;
{
    if(isExit) return;
    //if(preGameStates == chatRoom.serverInfo.gameStatus) return;
    switch (chatRoom.serverInfo.gameStatus) {
        case kStatePrepareGame:
            break;
        case kStateWaitJudge:
            [self showConnectingBox:YES andTitle:@"Wait for other judges"];
            break;
        case  kStateRunning:
        {
            [self showConnectingBox:NO andTitle:nil];
            //            if(preGameStates== kStateWaitJudge){
            //                //[self showTipBox:@"Game start"];
            //            }
            //            else if(preGameStates==kStateMultiplayerReconnect){
            //                [self showTipBox:@"Lost judge back and game continue"];
            //            }
        }
            break;
        case  kStateCalcScore:
            break;
        case kStateMultiplayerReconnect:
        {
            [self showConnectingBox:YES andTitle:@"Wait for lost judges"];
        }
            break;
        case  kStateRoundRest:
            [self showConnectingBox:YES andTitle:@"Round rest time"];
            break;
        case kStateGamePause:
            [self showConnectingBox:YES andTitle:@"Game pause"];
            break;
        case kStateGameEnd:
            [self showConnectingBox:YES andTitle:@"Match has been ended"];
            break;	
        case  kStateGameExit:
        {
            if(isExit)
                return;
            isExit=YES;
            [chatRoom stop];
            if(gameLoopTimer != nil){
                [gameLoopTimer invalidate];
                gameLoopTimer=nil;
            }
            [self closeInfoBox];
            [UIHelper showAlert:@"Information" message:@"Game has completed,Continue to exit" func:^(AlertView *a, NSInteger i) {
                [self onExited];
            }];
        }
            break;
        default:
        {
            
        }
            break;
    }
    preGameStates=chatRoom.serverInfo.gameStatus;
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

-(void)reportClientInfo
{
    CommandMsg *cmd=[[CommandMsg alloc] initWithType:NETWORK_CLIENT_INFO andFrom:chatRoom.clientInfo.uuid andDesc:nil andData:chatRoom.clientInfo andDate:[NSDate date]];
    [chatRoom sendCommand:cmd];
}

-(void)reportClientHeartbeat
{
    CommandMsg *cmd=[[CommandMsg alloc] initWithType:NETWORK_HEARTBEAT andFrom:chatRoom.clientInfo.uuid andDesc:nil andData:nil andDate:nil];
    [chatRoom sendCommand:cmd];
}

#pragma draw layout
-(void)setConnectionIndicatorToConnected:(BOOL)connected
{   
    imgConnectiondicator.image=[UIImage imageNamed:connected?@"scroe_controller_connection_avail":@"scroe_controller_connection_disconnect"];
}
@end
