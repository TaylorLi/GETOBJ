//
//  WinnnerBox.m
//  TKD Score
//
//  Created by Eagle Du on 12/8/18.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "SelectWinnerBox.h"
#import "AppConfig.h"
#import "ShowWinnerBox.h"

#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@implementation SelectWinnerBox

@synthesize viewLoadedFromXib;
@synthesize gameInfo;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
		CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		[self.titleBar setColorComponents:colors];
		self.headerLabel.text = title;
        //self.closeButton.hidden=YES;
		self.margin = UIEdgeInsetsMake(220.0f,220.0f,220.0f,220.0f);
        
        // Margin between edge of panel and the content area. Default = {20.0, 20.0, 20.0, 20.0}
        self.padding=UIEdgeInsetsMake(20.0f,20.0f,20.0f,20.0f);
        self.titleBarHeight = 30.0f;        
        // The header label, a UILabel with the same frame as the titleBar
        self.headerLabel.font = [UIFont boldSystemFontOfSize:20];
        
        viewLoadedFromXib= [[[NSBundle mainBundle] loadNibNamed:@"SelectWinnerBox" owner:self options:nil] objectAtIndex:0];
       [self.contentView addSubview:viewLoadedFromXib];    
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    [viewLoadedFromXib setFrame:self.contentView.bounds];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [AppConfig shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (IBAction)selectRedToWinner:(id)sender {
    [self showWinner:YES];
}

- (IBAction)selectBlueToWinner:(id)sender {
    [self showWinner:NO];
}

-(void)showWinner:(BOOL)red
{
    [self hideWithOnComplete:^(BOOL finished) {
        if ([delegate respondsToSelector:@selector(selectedWinnerEnd:)]) {
            [self removeFromSuperview];
       
        [delegate performSelector:@selector(selectedWinnerEnd:) withObject:[NSNumber numberWithBool:red]];
        }  
    }]; 
}
@end
