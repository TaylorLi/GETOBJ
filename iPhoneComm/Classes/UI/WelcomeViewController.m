//
//  WelcomeViewController.m
//  Chatty
//
//  Copyright (c) 2009 Peter Bakhyryev <peter@byteclub.com>, ByteClub LLC
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import "WelcomeViewController.h"
#import "AppConfig.h"
#import "ChattyAppDelegate.h"
#import "UIHelper.h"
#import "RegisterAndActiveViewController.h"

@implementation WelcomeViewController
@synthesize segNetwork;

@synthesize playName;

-(id)init{
    self = [super init];
    if(self==nil)
        return nil;
    
    return  self;
}

-(void)viewDidLoad
{
    [self setWantsFullScreenLayout:YES];
    NSUserDefaults *nd= [NSUserDefaults standardUserDefaults];
    playName.text=[nd stringForKey:@"playName"];
    if(playName.text==nil || [playName.text isEqual:@""]){
        playName.text=[AppConfig getInstance].settngs.registerUsername;
    }
}
-(void)viewDidUnload
{
    [self setPlayName:nil];
    [self setSegNetwork:nil];
    playName=nil;
}
-(void)dealloc
{
    
}
// App delegate will call this whenever this view becomes active
- (void)activate {
    // Display keyboard
    if([AppConfig getInstance].isIPAD && ![[AppConfig getInstance] productSNValidate])
    {
        [self showRegisterAndProductActiveBox];    
    }
    else
    {
        [playName becomeFirstResponder];
    }    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [AppConfig shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}
// This is called whenever "Return" is touched on iPhone's keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if ( theTextField.text == nil || [theTextField.text length] < 1 ) {
        return NO;
    }
    //    if( [segNetwork selectedSegmentIndex]==1)//wifi
    //    {
    //        
    //    }
    //    else
    //    {
    //        if ([btManager enabled]) {//bluetooth enable
    //            
    //            
    //        }
    //        else{
    //            [self showConfrimMsg:@"Information" message:@"This application need to use your bluetooth device,continue to turn on?"];
    //            return NO;
    //        }
    //    }    
    
    // Save user's name
    [AppConfig getInstance].name = theTextField.text;
    NSUserDefaults *nd= [NSUserDefaults standardUserDefaults];
    // Dismiss keyboard
    [theTextField resignFirstResponder];
    
    [nd setObject:theTextField.text forKey:@"playName"];
    // Move on to the next screen
    if([AppConfig getInstance].isIPAD)
        [[ChattyAppDelegate getInstance] showGameSettingView];
    else
        [[ChattyAppDelegate getInstance] showRoomSelection];
	return YES;
}

#pragma mark -
#pragma mark Register Box
-(void)showRegisterAndProductActiveBox
{
    RegisterAndActiveViewController *regControl=  [[RegisterAndActiveViewController alloc] init];
    regPannel=[[DialogBoxContainer alloc] initWithFrame:self.view.bounds title:nil loadViewController:regControl withClossButton:NO];
    regPannel.delegate=self;
    regPannel.formDelegate = self;
    [self.view addSubview:regPannel];	
    [regPannel showFromPoint:[self.view center]];
}

- (IBAction)showActiveForm:(id)sender {
    [playName resignFirstResponder];
    [self showRegisterAndProductActiveBox]; 
}
- (void)actionByLoadedView:(UAModalPanel *)modalPanel subController:(id)controller eventType:(NSInteger) type eventArgs:(NSDictionary *)args
{
    switch (type) {
        case kFormResultTypeSuccess:
        {
            [regPannel hide];
            regPannel = nil;
            [playName becomeFirstResponder];
            playName.text=[AppConfig getInstance].settngs.registerUsername;
        }
            break;
        case kFormResultTypeCancel:
        {
            [regPannel hide];
            regPannel = nil;
            [playName becomeFirstResponder];
        }
        default:
            break;
    }
}

@end
