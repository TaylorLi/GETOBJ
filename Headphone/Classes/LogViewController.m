//
//  LogViewController.m
//  iNfrared
//
//  Created by George Dean on 11/28/08.
//  Copyright 2008 Perceptive Development. All rights reserved.
//

#import "LogViewController.h"


@implementation LogViewController

@synthesize textView;
@synthesize historyLimit;

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        // Custom initialization
		self.historyLimit = 50000;
		history = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) updateText
{
	NSMutableString* text = [NSMutableString stringWithString:@""];
	for (int i = 0; i < [history count]; ++i)
		[text appendFormat:@"%@\n", [history objectAtIndex:i]];
	textView.text = text;
}

- (void) addEntry: (NSString*)entry
{
	while([history count] >= historyLimit)
		[history removeObjectAtIndex:0];
	
	[history addObject:[NSString stringWithString:entry]];
	if (self.tabBarController.selectedViewController == self)
		[self performSelectorOnMainThread:@selector(updateText) withObject:nil waitUntilDone:YES];
}
-(void)clearText
{
    [history removeAllObjects];
}


- (void) viewWillAppear: (BOOL)animated
{
	[self updateText];
	[super viewWillAppear:animated];
}


/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
