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
//新增
#import "TouchExt.h"
//新增完

//修改
#define kMinimumGestureLength    10
#define kMaximumVariance         30
//修改完

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
//新增
@property(nonatomic,retain) NSMutableArray *arrayTouch;
//新增完
@end

@implementation ScoreControlViewController
@synthesize label;
@synthesize gestureStartPoint;
@synthesize chatRoom;
@synthesize screenWidth;
//新增
@synthesize arrayTouch;
//新增完

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
    
    //修改
    
    //    UISwipeGestureRecognizer *top;   
    //    top = [[[UISwipeGestureRecognizer alloc] initWithTarget:self
    //                                                     action:@selector(reportSwipeUp:)] autorelease];
    //    top.direction = UISwipeGestureRecognizerDirectionUp;
    //    top.numberOfTouchesRequired = 2;
    //
    //    [self.view addGestureRecognizer:top];
    //    
    //    UISwipeGestureRecognizer *down;   
    //    
    //    down = [[[UISwipeGestureRecognizer alloc] initWithTarget:self
    //                                                      action:@selector(reportSwipeDown:)] autorelease];
    //    down.direction = 
    //    UISwipeGestureRecognizerDirectionDown;
    //    down.numberOfTouchesRequired = 2;
    //    
    //    [self.view addGestureRecognizer:down];
    //    
    //    UISwipeGestureRecognizer *left;
    //    left = [[[UISwipeGestureRecognizer alloc] initWithTarget:self
    //                                                      action:@selector(reportSwipeLeft:)] autorelease];
    //    left.direction = UISwipeGestureRecognizerDirectionLeft;
    //    
    //    left.numberOfTouchesRequired = 2;
    //    [self.view addGestureRecognizer:left];
    //    
    //    UISwipeGestureRecognizer *right;
    //    right = [[[UISwipeGestureRecognizer alloc] initWithTarget:self
    //                                                       action:@selector(reportSwipeRight:)] autorelease];
    //    right.direction = UISwipeGestureRecognizerDirectionRight    ;
    //    right.numberOfTouchesRequired = 2;
    //    [self.view addGestureRecognizer:right];
    
    //修改完
    
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

//新增

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

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"1------(%i)",touches.count);
//    NSLog(@"2------(%i)",[touches allObjects].count);
//    NSLog(@"3------(%i)",[event allTouches].count);
//    if(arrayTouch!=nil && arrayTouch.count==2) return;
//    for (UITouch* touch in touches) {
//        CGPoint point = [touch locationInView:self.view];
//        Boolean isExist = NO;
//        for (TouchExt *touchExt in arrayTouch) {
//            if (touch == touchExt.touchObj) {
//                isExist = YES;
//                break;
//            }
//        }
//        if (!isExist) {
//            TouchExt *touchExt = [[TouchExt alloc] initWithTouch:touch pointInView:point];
//            [arrayTouch addObject:touchExt];
//            [touchExt release];
//        }
//    }
//    NSLog(@"4------(%i)", arrayTouch.count);
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"1++++++(%i)",touches.count);
    NSLog(@"2++++++(%i)",[touches allObjects].count);
    NSLog(@"3++++++(%i)",[event allTouches].count);
    for (UITouch* touch in touches) {
        int arrayTouchCount = arrayTouch.count-1;
        for (int i=arrayTouchCount; i>=0; i--) {
            TouchExt *touchExt = [arrayTouch objectAtIndex:i];
            if(touch ==  touchExt.touchObj){
                if(!touchExt.isSendFinish){
                    isBlueSide = touchExt.beginPoint.x >= screenWidth/2;
                    CGPoint currenPoint = [touch locationInView:self.view];
                    CGFloat deltaX = touchExt.beginPoint.x - currenPoint.x;
                    CGFloat deltaY = touchExt.beginPoint.y - currenPoint.y;
                    int score = 0;
                    Boolean isSendMsg = NO;
                    if(deltaX >= kMinimumGestureLength && fabsf(deltaY) <= kMaximumVariance){
                        score = 1;
                        isSendMsg = YES;
                    }
                    else if(deltaX <= -kMinimumGestureLength && fabsf(deltaY) <= kMaximumVariance){
                        score = 3;
                        isSendMsg = YES;
                    }
                    else if(deltaY >= kMinimumGestureLength && fabsf(deltaX) <= kMaximumVariance){
                        score = 4;
                        isSendMsg = YES;
                    }
                    else if(deltaY <= -kMinimumGestureLength && fabsf(deltaX) <= kMaximumVariance){
                        score = 2;
                        isSendMsg = YES;
                    }
                    if(isSendMsg){
                        [[arrayTouch objectAtIndex:i] setIsSendFinish:YES];
                        [self sendScore:score];    
                        label.text = [NSString stringWithFormat:@"%@ %i Score Record",
                                      isBlueSide?[kSideBlue uppercaseString]:[kSideRed uppercaseString] ,score];;
                        [self performSelector:@selector(eraseText) withObject:nil afterDelay:2];
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
    isBlueSide = currentPosition.x >= screenWidth/2;
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
    isExit=NO;
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
    serverLastMsgDate=[NSDate date];
    switch ([cmdMsg.type intValue]) {
        case  NETWORK_HEARTBEAT://server heartbeat
        { 
            chatRoom.serverInfo=[[GameInfo alloc] initWithDictionary: cmdMsg.data];
            chatRoom.serverInfo.serverLastHeartbeatDate=serverLastMsgDate;
            //NSLog(@"Reiceive SeverInfo:%@",chatRoom.serverInfo);
            [self processGameStatus];
            if(isReconnect){
                isReconnect=NO;
                if(reConnectBox!=nil&&reConnectBox.superview!=nil)
                    {
                        [reConnectBox dismissWithClickedButtonIndex:-1 animated:NO];
                    }
                [self alreadyConnectToServer];
            }
        }
            break;
        default:
            break;
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
-(void) onExited{
    if(loadingBox!=nil)
    {
        [loadingBox hideLoading];
        loadingBox=nil;
    }
    if(tipBox!=nil)
    {
        [tipBox removeFromSuperview];
        tipBox=nil;
    }
    for(UIView *sview in self.view.subviews){
        if([sview isMemberOfClass:[UIAlertView class]])
            [sview removeFromSuperview];
    }
    
    [[ChattyAppDelegate getInstance] showRoomSelection];
}
-(void) alreadyConnectToServer
{
    [self reportClientInfo];
    double inv=kHeartbeatTimeInterval;
    if(![gameLoopTimer isValid]){
    gameLoopTimer=[NSTimer scheduledTimerWithTimeInterval: inv target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
    }
}
//fail to connect to server,we can test this by heartbeat
-(void) failureToConnectToServer
{
//    [UIHelper showAlert:@"Information" message:@"Unable connect to server" func:^(AlertView *a, NSInteger i) {
//        [self exit];
//    }];
    
    
}
-(void)sendScore:(NSInteger) score
{
    NSLog(@"send score date:%f",[[NSDate date] timeIntervalSinceReferenceDate]);
    //修改
    [chatRoom sendCommand:[[CommandMsg alloc] initWithType:NETWORK_REPORT_SCORE andFrom:chatRoom.clientInfo.uuid andDesc:isBlueSide?kSideBlue:kSideRed andData:[NSNumber numberWithInt:score] andDate:[NSDate date]] ];
    NSLog(@"send score side is %@, score is %i",isBlueSide?kSideBlue:kSideRed, score);
    [self showConnectingBox:YES andTitle:@"Wait for score result"];
    //修改完
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
    if( chatRoom.serverInfo.gameStatus==kStateGameExit)
        return;
    
    static int counter = 0;  
    //static int reConnCounter = 0;
    counter++;
    // once every 8 updates check if we have a recent heartbeat from the other player, and send a heartbeat packet with current state          
    if(counter%3==0) {
        [self reportClientInfo];
        
    }
    if(counter%9==0) {
        double inv=kHeartbeatTimeMaxDelay;
        if(serverLastMsgDate!=nil && fabs([serverLastMsgDate timeIntervalSinceNow]) >= inv){
            //reConnCounter++;
            //if(reConnCounter%5==0){
            //NSLog(@"last heart:%@,%f",serverLastMsgDate,[serverLastMsgDate timeIntervalSinceNow]);    
            isReconnect=YES;
            [self showRetryConnect];    
            
            return;
//                }
//            else
//                return;
        }
    }
    //[self processGameStatus];
}
-(void) retryConnect
{
    if(isReconnect){
        NSLog(@"reconnect log");
    [self showConnectingBox:YES andTitle:@"Try to reconnect for server..."];
       NSString *peerId=[ chatRoom.serverInfo.serverPeerId copy];
        [self.chatRoom stop];
        self.chatRoom=nil;
        chatRoom=[[RemoteRoom alloc] initWithPeerId:peerId];
        chatRoom.delegate = self;
        [chatRoom start]; 
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(testConnect:) userInfo:nil repeats:NO];
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
    [timer invalidate];
    if(!isReconnect){
        [self alreadyConnectToServer];
    }else{
        [self showReconnectConfirmBox];
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
            if(preGameStates== kStateWaitJudge){
                //[self showTipBox:@"Game start"];
            }else if(preGameStates==kStateMultiplayerReconnect){
                [self showTipBox:@"Lost judge back and game continue"];
            }
        }
            break;
        case  kStateCalcScore:
            break;
        case kStateMultiplayerReconnect:
        {
            [self showConnectingBox:YES andTitle:@"Wait for lost judges"];
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
            isExit=YES;
            [chatRoom stop];
            if(gameLoopTimer != nil){
                [gameLoopTimer invalidate];
                gameLoopTimer=nil;
            }
            [UIHelper showAlert:@"Information" message:@"Game has completed,Continue to   exit" func:^(AlertView *a, NSInteger i) {
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
    CommandMsg *cmd=[[CommandMsg alloc] initWithType:NETWORK_CLIENT_INFO andFrom:chatRoom.clientInfo.displayName andDesc:nil andData:chatRoom.clientInfo andDate:[NSDate date]];
    [chatRoom sendCommand:cmd];
}
@end
