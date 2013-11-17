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
#import "UIHelper.h"

//#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@implementation UIWaitForUserViewController
@synthesize txtNeedClientCount;
@synthesize btnStartGame;
@synthesize imgReferee1;
@synthesize imgReferee2;
@synthesize imgReferee3;
@synthesize imgReferee4;
@synthesize imgControl;
@synthesize imgLoading1;
@synthesize imgLoadingControl;
@synthesize imgLoading3;
@synthesize imgLoading4;
@synthesize imgLoading2;
@synthesize lblWaitForClientsCount;
@synthesize tbClientList;

@synthesize viewLoadedFromXib,needConnectedClientCount,clients;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title {
	if ((self = [super initWithFrame:frame])) {
		
		//CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		//[self.titleBar setColorComponents:colors];
		//self.headerLabel.text = title;
		self.margin = UIEdgeInsetsMake(36.0f,35.0f,32.0f,35.0f);
        self.borderWidth=0;
        
        // Margin between edge of panel and the content area. Default = {20.0, 20.0, 20.0, 20.0}
        self.padding=UIEdgeInsetsMake(0.0f,0.0f,0.0f,0.0f);
        //self.titleBarHeight = 30.0f;        
        // The header label, a UILabel with the same frame as the titleBar
        //self.headerLabel.font = [UIFont boldSystemFontOfSize:20];
        viewLoadedFromXib= [[[NSBundle mainBundle] loadNibNamed:@"UIWaitForUserView" owner:self options:nil] objectAtIndex:0];
		[self.contentView addSubview:viewLoadedFromXib];		
	}	
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    [viewLoadedFromXib setFrame:self.contentView.bounds];
    CGRect f = [self roundedRectFrame];
    
    self.closeButton.frame = CGRectMake(f.origin.x+f.size.width - floor(closeButton.frame.size.width*0.5),
                                        f.origin.y - floor(closeButton.frame.size.height*0.5),
                                        closeButton.frame.size.width,
                                        closeButton.frame.size.height);
}

- (IBAction)startGame:(id)sender {
    if(clients.count!=needConnectedClientCount)
        return;
    for (JudgeClientInfo *cltInfo in clients.allValues) {
        //NSLog(@"%i",cltInfo.hasConnected);
        if(!cltInfo.hasConnected)
            return;
    }
    if ([delegate respondsToSelector:@selector(waitUserStartPress:)]) {
        [self hideWithOnComplete:^(BOOL finished) {
            [self removeFromSuperview];
        }];
		[delegate performSelector:@selector(waitUserStartPress:) withObject:sender];
    }    
}

-(void) viewDidLoad
{
    
}

- (void)dealloc {
    clients=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [AppConfig shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}
-(NSUInteger)supportedInterfaceOrientations{
    return [AppConfig supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    return [AppConfig shouldAutorotate];
}

#pragma mark -
#pragma mark UITableViewDataSource Method Implementations

// Number of rows in each section. One section by default.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [clients count];
}

// Table view is requesting a cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* serverListIdentifier = @"ClientListIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:serverListIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:serverListIdentifier];
	}
    
    JudgeClientInfo *cltInfo=[[[clients allValues] sortedArrayUsingComparator:^(id obj1, id obj2){
        return [((JudgeClientInfo *)obj1).displayName compare:((JudgeClientInfo *)obj2).displayName options:NSWidthInsensitiveSearch];
    }] objectAtIndex: indexPath.row];
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
    txtNeedClientCount.text=[NSString stringWithFormat:@"%i",needConnectedClientCount];
    int conCount=0;
    if(imgReferees==nil){
        imgReferees=[[NSArray alloc] initWithObjects:imgReferee1,imgReferee2,imgReferee3,imgReferee4, nil];
    }
    if(imgLoadings==nil){
        NSMutableArray *loaingImgNames=[[NSMutableArray alloc] initWithCapacity:6];
        for (int i=1; i<7; i++) {
            [loaingImgNames addObject:[NSString stringWithFormat:@"loading_%i.png",i]];
        }
        imgLoadings=[[NSMutableArray alloc] initWithCapacity:imgReferees.count];
        NSArray *loadingImgs=[[NSArray alloc] initWithObjects:imgLoading1,imgLoading2,imgLoading3,imgLoading4,nil];
        for (UIImageView *view in  loadingImgs) {
            [imgLoadings addObject:[[UIGifView alloc] initWithImages:loaingImgNames andDstView:view andInterval:1.5]];
        }
        gifControl=  [[UIGifView alloc] initWithImages:loaingImgNames andDstView:imgLoadingControl andInterval:1.5];
    }    
    if(needConnectedClientCount>imgReferees.count){
        [UIHelper showAlert:@"Warnming" message:[NSString stringWithFormat: @"Can not support more than %i referees",imgReferees.count] func:nil];
        return;
    }    
    UIImageView *imgReferee;
    UIGifView *gifReferee;
    for (int i=0; i<imgReferees.count; i++) {
        imgReferee=  [imgReferees objectAtIndex:i];
        gifReferee=[imgLoadings objectAtIndex:i];
        if(i<needConnectedClientCount){
            imgReferee.hidden=NO;
            [gifReferee startAnimate];
        }else{
            imgReferee.hidden=YES;
            [gifReferee stopAnimate];
        }
    }
    
    for (JudgeClientInfo *cltInfo in clients.allValues) {
        //NSLog(@"%i",cltInfo.hasConnected);
        imgReferee = [imgReferees objectAtIndex:cltInfo.sequence-1];  
        gifReferee=[imgLoadings objectAtIndex:cltInfo.sequence-1];
        
        if(cltInfo.hasConnected){
            conCount++;
            UIImage *img=[UIImage imageNamed:[NSString stringWithFormat:@"game_wait_user_referee%i_ready.png",cltInfo.sequence]];
            imgReferee.image=img;
            [gifReferee stopAnimate];
        }
        else{
            UIImage *img=[UIImage imageNamed:[NSString stringWithFormat:@"game_wait_user_referee%i_wait_clear.png",cltInfo.sequence]];
            imgReferee.image=img;
            [gifReferee startAnimate];
        }
    }
    lblWaitForClientsCount.text=[NSString stringWithFormat:@"%i",needConnectedClientCount-conCount];
    [tbClientList reloadData];
    if(conCount==needConnectedClientCount)
    {
        [gifControl stopAnimate];
        UIImage *img=[UIImage imageNamed:@"game_wait_user_control_ready.png"];
        imgControl.image=img;
        btnStartGame.hidden=NO;        
        [UIView animateWithDuration:0.5 
						 animations:^{
                             imgControl.frame = CGRectMake(imgControl.frame.origin.x, imgControl.frame.origin.y, imgControl.frame.size.width/2, imgControl.frame.size.height/2);
						 } completion:^(BOOL finished) {
                             [UIView animateWithDuration:1 
                                              animations:^{
                                                  imgControl.frame = CGRectMake(imgControl.frame.origin.x, imgControl.frame.origin.y, imgControl.frame.size.width*3, imgControl.frame.size.height*3);
                                              } completion:^(BOOL finished) {
                                                  [UIView animateWithDuration:0.5 
                                                                   animations:^{
                                                                       imgControl.frame = CGRectMake(imgControl.frame.origin.x, imgControl.frame.origin.y, imgControl.frame.size.width/1.5, imgControl.frame.size.height/1.5);
                                                                   }];
                                                  
                                              }];
                         }];
        
    }
    else{
        btnStartGame.hidden=YES;
        UIImage *img=[UIImage imageNamed:@"game_wait_user_control_wait_clear.png"];
        imgControl.image=img;
        [gifControl startAnimate];
    }
}

@end
