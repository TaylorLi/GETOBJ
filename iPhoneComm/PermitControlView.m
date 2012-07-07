//
//  PermitControlView.m
//  Chatty
//
//  Created by Yuheng Li on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PermitControlView.h"
#import "ChattyAppDelegate.h"
#import "AppConfig.h"

@implementation PermitControlView
@synthesize chatRoom;
@synthesize password;
@synthesize serverPassword;
@synthesize isValidatePassword;

- (void)activate {
    // Display keyboard
    password.text = @"";
    [password becomeFirstResponder];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)confirm {
    if(!isValidatePassword)
    {
        [AppConfig getInstance].password = password.text;
        [password resignFirstResponder];
        [[ChattyAppDelegate getInstance] showScoreBoard:chatRoom];
    }
    else
    {
        if([password.text isEqualToString: serverPassword])
        {
            [password resignFirstResponder];
            [[ChattyAppDelegate getInstance] showScoreControlRoom:chatRoom];
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"System Information" message:@"Password mismatching, please retry!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
    }
}

- (IBAction)cancel {
    [password resignFirstResponder];
    if(!isValidatePassword)
    {
        [[ChattyAppDelegate getInstance] showScoreBoard:chatRoom];
    }
    else
    {
        [[ChattyAppDelegate getInstance] showRoomSelection];
    }
    
}
- (void)dealloc {
    [password release];
    self.chatRoom = nil;
    [super dealloc];
}
@end
