//
//  SwipesViewController.m
//  Swipes
//
//  Created by Dave Mark on 12/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScoreControlViewController.h"
#import "ChattyAppDelegate.h"
#import "AppConfig.h"

#define kMinimumGestureLength    25
#define kMaximumVariance         5

@implementation ScoreControlViewController
@synthesize label;
@synthesize gestureStartPoint;
@synthesize chatRoom;

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



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    for(int i=0;i<5;i++)
        {
    UISwipeGestureRecognizer *top;   
    top = [[[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                     action:@selector(reportSwipeUp:)] autorelease];
    top.direction = UISwipeGestureRecognizerDirectionUp;
    top.numberOfTouchesRequired = i;
    [self.view addGestureRecognizer:top];
    
    UISwipeGestureRecognizer *down;   
    
    down = [[[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(reportSwipeDown:)] autorelease];
    down.direction = 
    UISwipeGestureRecognizerDirectionDown;
    down.numberOfTouchesRequired = i;
    [self.view addGestureRecognizer:down];
    
    UISwipeGestureRecognizer *left;
    left = [[[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(reportSwipeLeft:)] autorelease];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    
    left.numberOfTouchesRequired = i;
    [self.view addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *right;
    right = [[[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(reportSwipeRight:)] autorelease];
    right.direction = UISwipeGestureRecognizerDirectionRight    ;
    left.numberOfTouchesRequired = i;
    [self.view addGestureRecognizer:right];
            }
    
}



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
    [super dealloc];
}

- (NSString *)descriptionForScore:(NSUInteger)score {
    return [NSString stringWithFormat:@"%i",score];
}

#pragma mark -
- (void)reportSwipeUp:(UIGestureRecognizer *)recognizer {
    [self reportSwipe:4];
}
- (void)reportSwipeDown:(UIGestureRecognizer *)recognizer {
    [self reportSwipe:3];
}
- (void)reportSwipeLeft:(UIGestureRecognizer *)recognizer {
    [self reportSwipe:1];
}
- (void)reportSwipeRight:(UIGestureRecognizer *)recognizer {
    [self reportSwipe:2];
}
- (void)reportSwipe:(NSInteger)score {
    NSString *scoreStr=[self descriptionForScore:score];
        [self sendScore:scoreStr];    
        label.text = [NSString stringWithFormat:@"%i Score Record",
                      score];;
        [self performSelector:@selector(eraseText) withObject:nil afterDelay:2];
}

- (void)activate {
    if ( chatRoom != nil ) {
        chatRoom.delegate = self;
        [chatRoom start];
    }
}

// We are being asked to display a chat message
- (void)displayChatMessage:(NSString*)message fromUser:(NSString*)userName {
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

-(void)sendScore:(NSString *)score
{
    [chatRoom broadcastChatMessage:score fromUser:[AppConfig getInstance].name];
    
}

@end
