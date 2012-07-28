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

#define kMinimumGestureLength    25
#define kMaximumVariance         5

@interface ScoreControlViewController ()

-(void)gameLoop;
-(void)reportClientInfo;
-(void) showConnectingBox:(BOOL)show andTitle:(NSString *)title;
-(void) showTipBox:(NSString *)tip;
-(void) closeTipBox:(NSTimer *)timer;
@end

@implementation ScoreControlViewController
@synthesize label;
@synthesize gestureStartPoint;
@synthesize chatRoom;
@synthesize screenWidth;

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
    top = [[[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                     action:@selector(reportSwipeUp:)] autorelease];
    top.direction = UISwipeGestureRecognizerDirectionUp;
    top.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:top];
    
    UISwipeGestureRecognizer *down;   
    
    down = [[[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(reportSwipeDown:)] autorelease];
    down.direction = 
    UISwipeGestureRecognizerDirectionDown;
    down.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:down];
    
    UISwipeGestureRecognizer *left;
    left = [[[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(reportSwipeLeft:)] autorelease];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    
    left.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *right;
    right = [[[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(reportSwipeRight:)] autorelease];
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

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.label = nil;
    if(confirmView != nil){
        confirmView = nil;
        [confirmView release];
    }
    [super viewDidUnload];
}

- (void)dealloc {
    [label release];
    self.chatRoom = nil;
    loadingBox=nil;
    if(confirmView != nil){
        confirmView = nil;
        [confirmView release];
    }
    [super dealloc];
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
    [loadingBox showLoading];
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
            if(chatRoom.serverInfo!=nil)
                [chatRoom.serverInfo release];
            chatRoom.serverInfo=[[GameInfo alloc] initWithDictionary: cmdMsg.data];
            chatRoom.serverInfo.serverLastHeartbeatDate=serverLastMsgDate;
            //NSLog(@"Reiceive SeverInfo:%@",chatRoom.serverInfo);
        }
            break;
        default:
            break;
    }
    
}


// Room closed from outside
- (void)roomTerminated:(id)room reason:(NSString*)reason {   
    // Explain what happened
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Server terminated" message:reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    if(confirmView!=nil){
        [confirmView dismissWithClickedButtonIndex:1 animated:NO];
    }else{
        [self exit];
    }
}


// User decided to exit room
- (IBAction)exit {
    // Close the room
    [chatRoom stop];
    
    // Remove keyboard
    
    // Erase chat
    
    
    // Switch back to welcome view
    if(gameLoopTimer != nil){
        [gameLoopTimer invalidate];
        gameLoopTimer=nil;
    }
    
    if(loadingBox!=nil)
    {
        [loadingBox hideLoading];
        loadingBox=nil;
        [loadingBox release];
    }
    
    if(confirmView != nil){
        confirmView = nil;
        [confirmView release];
    }
    
    [[ChattyAppDelegate getInstance] showRoomSelection];
}
-(void) alreadyConnectToServer
{
    [self reportClientInfo];
    double inv=kHeartbeatTimeInterval;
    gameLoopTimer=[NSTimer scheduledTimerWithTimeInterval: inv target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}
-(void) failureToConnectToServer
{
    if(loadingBox!=nil)
    {
        [loadingBox hideLoading];
        loadingBox=nil;
        [loadingBox release];
    }
    [self exit];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Connect failure" message:@"Failure to connect" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}
-(void)sendScore:(NSInteger) score
{
    NSLog(@"send score date:%f",[[NSDate date] timeIntervalSinceReferenceDate]);
    [self showConnectingBox:YES andTitle:@"waitForResult"];
    [chatRoom sendCommand:[[[CommandMsg alloc] initWithType:NETWORK_REPORT_SCORE andFrom:chatRoom.clientInfo.uuid andDesc:isBlueSide?kSideBlue:kSideRed andData:[NSNumber numberWithInt:score] andDate:[NSDate date]] autorelease]];
}

-(void) showTipBox:(NSString *)tip;
{
    [loadingBox hideLoading];
   UIAlertView *tipBox= [[[UIAlertView alloc] initWithTitle:@"Information" message:tip delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil] autorelease];
    [tipBox show];
    [tipBox retain];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(closeTipBox:) userInfo:tipBox repeats:NO];
    
}
-(void) closeTipBox:(NSTimer *)timer
{
    UIAlertView *tipBox=[timer userInfo];
    [tipBox dismissWithClickedButtonIndex:-1 animated:YES];
    [tipBox release];
}
-(void)gameLoop
{
    
    static int counter = 0;  
    static int retryCounter = 0;
    counter++;
    // once every 8 updates check if we have a recent heartbeat from the other player, and send a heartbeat packet with current state          
    if(counter%3==0) {
        [self reportClientInfo];
                
    }
    if(counter%9==0) {
        double inv=kHeartbeatTimeMaxDelay;
        retryCounter++;
        if(serverLastMsgDate!=nil && fabs([serverLastMsgDate timeIntervalSinceNow]) >= inv){
            //NSLog(@"last heart:%@,%f",serverLastMsgDate,[serverLastMsgDate timeIntervalSinceNow]);
            if(retryCounter%3==0){
                if(loadingBox!=nil)
                    [loadingBox hideLoading];
                [gameLoopTimer invalidate];
                gameLoopTimer = nil;
                
                if(confirmView == nil){
                    confirmView=[[UIAlertView alloc] initWithTitle:@"Server terminated" message:@"Do you want to retry?" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: @"Exit",nil];
                }
                [confirmView show];
                return;
            }
            [self showConnectingBox:YES andTitle:@"Seems to lose connect for server,now reconnecting..."];
            return;
        }
    }
    if(preGameStates == chatRoom.serverInfo.gameStatus) return;
    switch (chatRoom.serverInfo.gameStatus) {
        case kStatePrepareGame:
            break;
        case kStateWaitJudge:
            [self showConnectingBox:YES andTitle:@"Wait for other judges..."];
            break;
        case  kStateRunning:
        {
            [self showConnectingBox:NO andTitle:nil];
            if(preGameStates== kStateWaitJudge){
                [self showTipBox:@"Game start"];
            }else if(preGameStates==kStateMultiplayerReconnect){
                [self showTipBox:@"Lost judge back and game continue"];
            }
        }
            break;
        case  kStateCalcScore:
            break;
        case kStateMultiplayerReconnect:
        {
            [self showConnectingBox:YES andTitle:@"Wait for lost judges..."];
        }
            break;
        case kStateGamePause:
            [self showConnectingBox:YES andTitle:@"Game pause"];
            break;
        case kStateGameEnd:
            [self showConnectingBox:YES andTitle:@"Game has been ended."];
            break;	
        default:
            break;
    }
    preGameStates=chatRoom.serverInfo.gameStatus;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"OK"])
    {
        [self exit];
    }
    else
    {
        if(buttonIndex==1){
            [self exit];
        }else{
            double inv=kHeartbeatTimeInterval;
            gameLoopTimer=[NSTimer scheduledTimerWithTimeInterval: inv target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
        }
    }

}

-(void)reportClientInfo
{
    CommandMsg *cmd=[[CommandMsg alloc] initWithType:NETWORK_CLIENT_INFO andFrom:chatRoom.clientInfo.displayName andDesc:nil andData:chatRoom.clientInfo andDate:[NSDate date]];
    [chatRoom sendCommand:cmd];
    [cmd release];
}
@end
