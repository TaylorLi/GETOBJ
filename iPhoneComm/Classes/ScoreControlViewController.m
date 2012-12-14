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
#import "ScoreInfo.h"
#import "TouchExt.h"
#import "MatchInfo.h"
#import <AudioToolbox/AudioToolbox.h>  
#import <CoreFoundation/CoreFoundation.h> 
#import "MatchInfo.h"

#define kMinimumGestureLength    25
#define kMaximumVariance         40

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
-(void)prepareForExit;

@property(nonatomic,retain) NSMutableArray *arrayTouch;
@property (nonatomic, retain) ScoreInfo *scoreInfo;
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
@synthesize arrayTouch;
@synthesize scoreInfo;

- (void)eraseText {
    imgBlueScore.hidden = YES;
    imgRedScore.hidden = YES;
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
    arrayTouch = [[NSMutableArray alloc]initWithObjects: nil];
//    if(![sendLoopTimer isValid]){
//        sendLoopTimer=[NSTimer scheduledTimerWithTimeInterval: kClientLoopInterval4Swipe/5.0 target:self selector:@selector(sendScore) userInfo:nil repeats:YES];
//    }
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"1======(%i)",touches.count);
    NSLog(@"2======(%i)",[touches allObjects].count);
    NSLog(@"3======(%i)",[event allTouches].count);
    if(arrayTouch!=nil && arrayTouch.count==2) return;
    for (UITouch *touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        TouchExt *touchExt = [[TouchExt alloc] initWithTouch:touch pointInView:point];
        [arrayTouch addObject:touchExt];
        //[touchExt release];
    }
    NSLog(@"4======(%i)", arrayTouch.count);
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"1++++++(%i)",touches.count);
    NSLog(@"2++++++(%i)",[touches allObjects].count);
    NSLog(@"3++++++(%i)",[event allTouches].count);
    for (UITouch* touch in touches) {
        int arrayTouchCount = arrayTouch.count-1;
        for (int i=arrayTouchCount; i>=0; i--) {
            TouchExt *touchExt = [arrayTouch objectAtIndex:i];
            if(touch ==  touchExt.touchObj){
                if(!touchExt.isAddedToScores){
                    BOOL isBlueSide = touchExt.beginPoint.x < screenWidth/2;
                    CGPoint currenPoint = [touch locationInView:self.view];
                    CGFloat deltaX = touchExt.beginPoint.x - currenPoint.x;
                    CGFloat deltaY = touchExt.beginPoint.y - currenPoint.y;
                    int score = 0;
                    Boolean isSendMsg = NO;
                    if(deltaX >= kMinimumGestureLength && fabsf(deltaY) <= kMaximumVariance){
                        score = 3;
                        isSendMsg = YES;
                    }
                    else if(deltaX <= -kMinimumGestureLength && fabsf(deltaY) <= kMaximumVariance){
                        score = 4;
                        isSendMsg = YES;
                    }
                    else if(deltaY >= kMinimumGestureLength && fabsf(deltaX) <= kMaximumVariance){
                        score = 2;
                        isSendMsg = YES;
                    }
                    else if(deltaY <= -kMinimumGestureLength && fabsf(deltaX) <= kMaximumVariance){
                        score = 1;
                        isSendMsg = YES;
                    }
                    if(isSendMsg){
                        [[arrayTouch objectAtIndex:i] setIsAddedToScores:YES];
                        if(scoreInfo==nil){
                            NSLog(@"%@_________1", isBlueSide?@"blue":@"red");
                            if(isBlueSide){
                                scoreInfo = [[ScoreInfo alloc]initWithBlueSide:score andDateNow:nil];
                            }else{
                                scoreInfo = [[ScoreInfo alloc]initWithRedSide:score andDateNow:nil];
                            }
                            [self sendScore];
                            //                        [self performSelector:@selector(sendScore) withObject:scoreInfo afterDelay:kHeartbeatTimeMaxDelay4Swipe];
                        }
//                        else{
//                            SwipeType stype = isBlueSide ? kSideBlue : kSideRed;
//                            NSLog(@"%@_________2", isBlueSide?@"blue":@"red");
//                            if(scoreInfo.swipeType == stype){
//                                scoreInfo = nil;
//                            }else{
//                                scoreInfo.swipeType = kSideBoth;
//                                if(isBlueSide){
//                                    scoreInfo.blueSideScore = score;
//                                }else{
//                                    scoreInfo.redSideScore = score;
//                                }
//                            }
//                        }
                        //[self sendScore:score];    
                        //                        label.text = [NSString stringWithFormat:@"%@ %i Score Record",
                        //                                      isBlueSide?[kSideBlue uppercaseString]:[kSideRed uppercaseString] ,score];;
                        //[self performSelector:@selector(eraseText) withObject:nil afterDelay:2];
                    }
                }
                
                //为了避免弹出提示信息时触发touchesCancelled事件，事件会执行删除数组元素，导致越界
                if(arrayTouchCount == arrayTouch.count-1){
                    touchExt = nil;
                    [arrayTouch removeObjectAtIndex:i];
                }
                break;
            }
        }
        
    }
    [self sendScore];
    NSLog(@"4++++++(%i)", arrayTouch.count);
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"1~~~~~~~(%i)",touches.count);
    NSLog(@"2~~~~~~~(%i)",[touches allObjects].count);
    NSLog(@"3~~~~~~~(%i)",[event allTouches].count);
    //    for (UITouch* touch in touches) {
    //        int arrayTouchCount = arrayTouch.count-1;
    //        for (int i=arrayTouchCount; i>=0; i--) {
    //            TouchExt *touchExt = [arrayTouch objectAtIndex:i];
    //            if(touch ==  touchExt.touchObj){                
    //                if(arrayTouchCount == arrayTouch.count-1){
    //                    [arrayTouch removeObjectAtIndex:i];
    //                }
    //                break;
    //            }
    //        }
    //    }
    [self touchesEnded:touches withEvent:event];
    NSLog(@"4~~~~~~~(%i)", arrayTouch.count);
    
}

//新增完

//-(void)sendScore:(NS)(NSInteger) score
//{
//    NSLog(@"send score date:%f",[[NSDate date] timeIntervalSinceReferenceDate]);
//    [self showConnectingBox:YES andTitle:@"Wait for score result"];
//    [chatRoom sendCommand:[[[CommandMsg alloc] initWithType:NETWORK_REPORT_SCORE andFrom:chatRoom.clientInfo.uuid andDesc:isBlueSide?kSideBlue:kSideRed andData:[NSNumber numberWithInt:score] andDate:[NSDate date]] autorelease]];
//}

-(void)sendScore
{
    //修改
    if(scoreInfo!=nil){
     //   NSLog(@"%@^^^^^^^^^^^", scoreInfo.swipeType==kSideBoth?@"both":scoreInfo.swipeType==kSideBlue?@"blue":@"red");
      //  NSLog(@"^^^^^^^^^^^time:%f",fabs([scoreInfo.datetime timeIntervalSinceNow]));
     //   if(scoreInfo.swipeType == kSideBoth ||  fabs([scoreInfo.datetime timeIntervalSinceNow]) >= kClientLoopInterval4Swipe){
      //      NSLog(@"send score date:%f",[[NSDate date] timeIntervalSinceReferenceDate]);
            if(scoreInfo.swipeType == kSideBoth || scoreInfo.swipeType == kSideBlue){
                imgBlueScore.image = [UIImage imageNamed:[NSString stringWithFormat:@"scroe_controller_%i.png", scoreInfo.blueSideScore]];
                imgBlueScore.hidden = NO;
                NSLog(@"^^^^^^^^^^^blue:%i",scoreInfo.blueSideScore);
            }
            if(scoreInfo.swipeType == kSideBoth || scoreInfo.swipeType == kSideRed){
                imgRedScore.image = [UIImage imageNamed:[NSString stringWithFormat:@"scroe_controller_%i.png", scoreInfo.redSideScore]];
                imgRedScore.hidden = NO;
                NSLog(@"^^^^^^^^^^^red:%i",scoreInfo.redSideScore);
            }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [chatRoom sendCommand:[[CommandMsg alloc] initWithType:NETWORK_REPORT_SCORE andFrom:chatRoom.clientInfo.uuid andDesc:nil andData:scoreInfo andDate:[NSDate date]]];
            scoreInfo = nil;
            //    NSLog(@"send score side is %@, score is %i",isBlueSide?kSideBlue:kSideRed, score);
            [self performSelector:@selector(eraseText) withObject:nil afterDelay:1];
        //    [self showConnectingBox:YES andTitle:@"Wait for score result"];
    //    }
    }
    //修改完
}

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
    scoreInfo = nil;
    arrayTouch = nil;
    [super viewDidUnload];
}


- (NSString *)descriptionForScore:(NSUInteger)score {
    return [NSString stringWithFormat:@"%i",score];
}

#pragma mark -
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
            if(chatRoom.serverInfo.currentMatchInfo.gameStatus!=stauts){
                chatRoom.serverInfo.currentMatchInfo.gameStatus=stauts;
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
            chatRoom.serverInfo.currentMatchInfo.gameStatus=stauts;
            chatRoom.serverInfo.currentMatchInfo.statusRemark=cmdMsg.desc;
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
                [self closeInfoBox];
                __block ScoreControlViewController *seltCtl=self;
                [UIHelper showAlert:@"Information" message:@"Can not connect to the server." func:^(AlertView *a, NSInteger i) {
                    [seltCtl exit];
                }];
                return;
            }
        }
            break;
        default:
            break;
    }
    if(hasEverConnectd){
    chatRoom.serverInfo.serverLastHeartbeatDate=serverLastMsgDate;
    [self setConnectionIndicatorToConnected:YES];
    }
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

-(void)prepareForExit
{
    isExit=YES;
    [AppConfig getInstance].isGameStart=NO;
    if(retryTimer!=nil)
    {
        [retryTimer invalidate];
        retryTimer=nil;
    }
    // Switch back to welcome view
    if(gameLoopTimer != nil){
        [gameLoopTimer invalidate];
        gameLoopTimer=nil;
    }
    [AppConfig getInstance].isGameStart=NO;
    [self setConnectionIndicatorToConnected:NO];
    // Close the room
    [chatRoom stop];

}
// User decided to exit room
- (IBAction)exit {
    loadingBox.title=@"Now prepare to exit ...";    
    // Remove keyboard
    [self prepareForExit];
    // Erase chat
    
//    if(sendLoopTimer !=nil){
//        [sendLoopTimer invalidate];
//        sendLoopTimer = nil;
//    }
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onExited) userInfo:nil repeats:NO];
    
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
        if([sview isKindOfClass:[UIAlertView class]])
            [sview removeFromSuperview];
    }
}
-(void) onExited{
    [self closeInfoBox];    
    [[ChattyAppDelegate getInstance] showRoomSelection];
}
-(void) alreadyConnectToServer
{
    if(!isExit)
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
        [self closeInfoBox];
        __block ScoreControlViewController *seltCtl=self;
        [UIHelper showAlert:@"Information" message:@"Unable connect to server" func:^(AlertView *a, NSInteger i) {
            [seltCtl exit];
        }];
    }
    else{
        isReconnect=NO;
        [self testConnect:nil];
    }
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
    if(isExit)
        return;
    static int counter = 0;  
    //static int reConnCounter = 0;
    counter++;
    
    if( chatRoom.serverInfo.currentMatchInfo.gameStatus==kStateGameExit||chatRoom.serverInfo.currentMatchInfo.gameStatus== kStateGameEnd||chatRoom.serverInfo.currentMatchInfo.gameStatus==kStatePrepareGame)
        return;
    
    [self reportClientHeartbeat];
    
    double inv;
    if(chatRoom.serverInfo.currentMatchInfo.gameStatus==kStateRoundReset||chatRoom.serverInfo.currentMatchInfo.gameStatus==kStateGamePause)
        inv=kClientTestServerHearbeatTimeWhenPause;
    else
        inv=kClientTestServerHearbeatTime;
    if(counter%(int)(inv/kClientHeartbeatTimeInterval)==0) {
        if(serverLastMsgDate!=nil && fabs([serverLastMsgDate timeIntervalSinceNow]) >= inv){
            isReconnect=YES;
            [self setConnectionIndicatorToConnected:NO];
            [self retryConnect];    
            return;
        }
    }
}
-(void) retryConnect
{
    if(isReconnect&&!isDoingReconnect){
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
        isDoingReconnect=YES;
       retryTimer= [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(testConnect:) userInfo:nil repeats:NO];
    }
}
-(void)tryToReconnect
{
    if(!isExit&&[AppConfig getInstance].isGameStart&&(!chatRoom.bluetoothClient.gameSession.isAvailable||![chatRoom isConnected])){
        [self showConnectingBox:YES andTitle:@"Try to reconnect for server..."];
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
        if(loadingBox!=nil)
            [loadingBox removeFromSuperview];
        if(tipBox!=nil)
            [tipBox dismissWithClickedButtonIndex:-1 animated:NO];
        [self showConnectingBox:YES andTitle:@"Reconnecting"];
        if(gameLoopTimer!=nil)
        {
            [gameLoopTimer invalidate];
            gameLoopTimer = nil;  
        }
        if([chatRoom isConnected]){
            [self reportClientInfo];
            return;
        }        
        
        
        [self retryConnect];
    }else{
        [self alreadyConnectToServer];
    }
}

-(void) testConnect:(NSTimer *)timer
{
    isDoingReconnect=NO;
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
    isDoingReconnect=NO;
    //if(preGameStates == chatRoom.serverInfo.gameStatus) return;
    switch (chatRoom.serverInfo.currentMatchInfo.gameStatus) {
        case kStatePrepareGame:
            break;
        case kStateWaitJudge:
            [self showConnectingBox:YES andTitle:@"Wait for other Referees"];
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
            [self showConnectingBox:YES andTitle:@"Wait for lost Referees"];
        }
            break;
        case  kStateRoundReset:
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
            [self closeInfoBox];
            [self prepareForExit];
            __block ScoreControlViewController *seltCtl=self;
            [UIHelper showAlert:@"Information" message:@"Game has completed,Continue to exit" func:^(AlertView *a, NSInteger i) {
                [seltCtl onExited];
            }];
        }
            break;
        default:
        {
            
        }
            break;
    }
    preGameStates=chatRoom.serverInfo.currentMatchInfo.gameStatus;
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
