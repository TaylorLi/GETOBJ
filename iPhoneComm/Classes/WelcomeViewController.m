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
    NSUserDefaults *nd= [NSUserDefaults standardUserDefaults];
    playName.text=[nd stringForKey:@"playName"];
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
    [playName becomeFirstResponder];
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

@end
