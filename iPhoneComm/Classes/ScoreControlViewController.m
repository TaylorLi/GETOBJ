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

#define kMinimumGestureLength    25
#define kMaximumVariance         5

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
    [super viewDidUnload];
}

- (void)dealloc {
    [label release];
    self.chatRoom = nil;
    loadingBox=nil;
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
        loadingBox =[[UILoadingBox alloc ]initWithLoading:@"Connection..." showCloseImage:YES onClosed:^{
            [self exit];    
        }];
        [loadingBox showLoading];
        chatRoom.delegate = self;
        [chatRoom start];
        
    }
}

#pragma mark -
#pragma mark RoomDeleagate
// We are being asked to display a chat message
- (void)processCmd:(CommandMsg *)cmdMsg {
    //label.text=message;
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
    
    
    // Switch back to welcome view
    [[ChattyAppDelegate getInstance] showRoomSelection];
}
-(void) alreadyConnectToServer
{
    if(loadingBox!=nil)
    {
        [loadingBox hideLoading];
        loadingBox=nil;
        [loadingBox release];
    }
}
-(void) failureToConnectToServer
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Connect failure" message:@"Failure to connect" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    if(loadingBox!=nil)
    {
        [loadingBox hideLoading];
        loadingBox=nil;
        [loadingBox release];
    }
    [self exit];
}
-(void)sendScore:(NSInteger) score
{
    [chatRoom sendCommand:[[[CommandMsg alloc] initWithType:NETWORK_REPORT_SCORE andFrom:[AppConfig getInstance].name andDesc:isBlueSide?kSideBlue:kSideRed andData:[NSNumber numberWithInt:score]] autorelease]];
}

@end
