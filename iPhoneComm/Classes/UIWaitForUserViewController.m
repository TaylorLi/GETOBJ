//
//  UIWaitForUserViewController.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/21.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "UIWaitForUserViewController.h"
#import "AppConfig.h"
#import "JudgeClientInfo.h"

#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@implementation UIWaitForUserViewController
@synthesize txtNeedClientCount;
@synthesize btnStartGame;
@synthesize lblWaitForClientsCount;
@synthesize tbClientList;

@synthesize viewLoadedFromXib,needConnectedClientCount,clients;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
	if ((self = [super initWithFrame:frame])) {
		
		CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		[self.titleBar setColorComponents:colors];
		self.headerLabel.text = title;
		self.margin = UIEdgeInsetsMake(20.0f,20.0f,20.0f,20.0f);
        
        // Margin between edge of panel and the content area. Default = {20.0, 20.0, 20.0, 20.0}
        self.padding=UIEdgeInsetsMake(20.0f,20.0f,20.0f,20.0f);
        self.titleBarHeight = 50.0f;        
        // The header label, a UILabel with the same frame as the titleBar
        self.headerLabel.font = [UIFont boldSystemFontOfSize:20];
        
        [[NSBundle mainBundle] loadNibNamed:@"UIWaitForUserView" owner:self options:nil];
		[self.contentView addSubview:viewLoadedFromXib];
		
	}	
	return self;
}

- (IBAction)startGame:(id)sender {
    if(clients.count!=needConnectedClientCount)
        return;
    for (JudgeClientInfo *cltInfo in clients.allValues) {
        //NSLog(@"%i",cltInfo.hasConnected);
        if(!cltInfo.hasConnected)
            return;
    }
    if ([delegate respondsToSelector:@selector(startGame:)]) {
        [self hideWithOnComplete:^(BOOL finished) {
            [self removeFromSuperview];
        }];
		[delegate performSelector:@selector(startGame:) withObject:sender];
    }    
}

-(void) viewDidLoad
{
    
}

- (void)dealloc {
	[viewLoadedFromXib release];
    clients=nil;
    [txtNeedClientCount release];
    [lblWaitForClientsCount release];
    [tbClientList release];
    [btnStartGame release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [AppConfig shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

#pragma mark -
#pragma mark UITableViewDataSource Method Implementations

// Number of rows in each section. One section by default.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [clients count];
}
- (void)layoutSubviews {
	[super layoutSubviews];
	
	[viewLoadedFromXib setFrame:self.contentView.bounds];
}

// Table view is requesting a cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* serverListIdentifier = @"ClientListIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:serverListIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:serverListIdentifier] autorelease];
	}
    JudgeClientInfo *cltInfo=[clients objectForKey:[clients.allKeys objectAtIndex: indexPath.row]];
    cell.textLabel.text=cltInfo.displayName;
    cell.detailTextLabel.text=cltInfo.hasConnected?@"Connected":@"Wait for connecting";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void) updateStatus:(NSMutableDictionary *)_clients
{
    clients=_clients;
    [clients retain];
    txtNeedClientCount.text=[NSString stringWithFormat:@"%i",needConnectedClientCount];
    int conCount=0;
    for (JudgeClientInfo *cltInfo in clients.allValues) {
        //NSLog(@"%i",cltInfo.hasConnected);
        if(cltInfo.hasConnected)
            conCount++;
    }
    lblWaitForClientsCount.text=[NSString stringWithFormat:@"%i",needConnectedClientCount-conCount];
    [tbClientList reloadData];
    if(conCount==needConnectedClientCount)
        {
            btnStartGame.hidden=NO;
        }
    else{
        btnStartGame.hidden=YES;
    }
}

@end
