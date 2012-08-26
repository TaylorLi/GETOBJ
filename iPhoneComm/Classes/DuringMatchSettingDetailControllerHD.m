//
//  GameSettingDetailControllerHD.m
//  TKD Score
//
//  Created by Eagle Du on 12/8/11.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "DuringMatchSettingDetailControllerHD.h"
#import "AppConfig.h"
#import "ChattyViewController.h"
#import "ChattyAppDelegate.h"
#import "ServerSetting.h"
#import "LocalRoom.h"
#import "GameInfo.h"
#import "UIHelper.h"
#import "LocalRoom.h"
#import "JudgeClientInfo.h"

@interface DuringMatchSettingDetailControllerHD ()
@property (nonatomic, retain) UIPopoverController *popoverController;
-(void)setSettingTable:(UIViewController *) control;
-(void)backToHome;
-(id)getTableCellByTag:(NSInteger)tag;
-(void)saveSetting;
-(void)refreshCurrentTime;
-(void)restartServer;
-(void)restartServerEnd:(NSTimer *)timer;
@end

@implementation DuringMatchSettingDetailControllerHD

@synthesize startButton;

@synthesize toolbar, popoverController, detailItem;
@synthesize detailControllerMatch,detailControllerMisc,detailControllerJudge,detailControllerMainMenu,relateGameServer;
@synthesize orgGameInfo,currentRoundTime,btnRestartServer;

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
    relateGameServer = [ChattyAppDelegate getInstance].scoreBoardViewController;
    // Do any additional setup after loading the view from its nib.
    UISwipeGestureRecognizer *hideSettingRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSave)];
    //blueMinusRecg.numberOfTouchesRequired=1;
    hideSettingRecg.direction= UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:hideSettingRecg];
}

-(void)viewWillAppear:(BOOL)animated{
    orgGameInfo=[relateGameServer.chatRoom.gameInfo copyWithZone:nil];
    [self bindSettingGroupData:1];
    [self bindSettingGroupData:2];
    [self bindSettingGroupData:3];
    [self bindSettingGroupData:0];    
    isChangeSetting=FALSE;
}

-(void)viewWillDisappear:(BOOL)animated{
    detailControllerMatch=nil;
    detailControllerMisc=nil;
    detailControllerJudge=nil;
    detailControllerMainMenu=nil;
    orgGameInfo=nil;
}
- (void)viewDidUnload
{    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    items=nil;
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    items=nil;
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [AppConfig shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

#pragma mark -
#pragma mark Bind Table Cells 
-(void) bindSettingGroupData:(int)group
{
     __weak GameInfo *gameInfo= orgGameInfo;
     __weak ServerSetting *si=gameInfo.gameSetting;
    __weak DuringMatchSettingDetailControllerHD *selfCtl=self;
    switch (group) {
        case 0:{
            if(detailControllerMatch==nil){                    
                detailControllerMatch =  [[JMStaticContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];                  
                [detailControllerMatch addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
                    TimePickerTableViewCell *roundTime=[[TimePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Round time" title:NSLocalizedString(@"Round Time", @"Round Time") selectValue:si.roundTime maxTime:600 minTime:0 interval:10];
                    roundTime.tag=kroundTime;
                    roundTime.delegate=selfCtl;
                    [section addCustomerCell:roundTime];
                    NSMutableArray *restTimeSource=[[NSMutableArray alloc] init];
                    for(int i=10;i<=50;i=i+10)
                    {
                        [restTimeSource addObject:[NSString stringWithFormat:@"%i Seconds",i]];
                    }
                    SimplePickerInputTableViewCell *restTime= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title:NSLocalizedString(@"Rest Time", @"Rest Time") selectValue:[NSString stringWithFormat:@"%.f Seconds",si.restTime] dataSource:restTimeSource];               
                    restTime.tag=krestTime;
                    restTime.delegate=selfCtl;
                    [section addCustomerCell:restTime]; 
                    
                    NSMutableArray *pauserestTimeSource=[[NSMutableArray alloc] init];
                    for(int i=30;i<=90;i=i+10)
                    {
                        [pauserestTimeSource addObject:[NSString stringWithFormat:@"%i Seconds",i]];
                    }
                    
                    NSMutableArray *areas=[[NSMutableArray alloc] init];
                    for(int i=65;i<=88;i++)
                    {
                        [areas addObject:[NSString stringWithFormat:@"%c",(char)i]];
                    }
                    SimplePickerInputTableViewCell *screenArea= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Screening Area", @"Screening Area") selectValue:si.screeningArea dataSource:areas];   
                    screenArea.tag=kscreeningArea;
                    screenArea.delegate=selfCtl;
                    [section addCustomerCell:screenArea];
                }];   
                
                [detailControllerMatch addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
                    TimePickerTableViewCell *currentTime=[[TimePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Current time" title:NSLocalizedString(@"Current Time", @"Current Time") selectValue:gameInfo.gameSetting.roundTime - gameInfo.currentRemainTime maxTime:si.roundTime minTime:0 interval:1];
                    selfCtl.currentRoundTime=gameInfo.gameSetting.roundTime - gameInfo.currentRemainTime;
                    currentTime.tag=kCurrentTime;
                    currentTime.delegate=selfCtl;
                    [section addCustomerCell:currentTime];
                }];
                
            }
            [self setSettingTable:detailControllerMatch];
        }
            break;           
        case 1:
        {
            if(detailControllerMisc==nil){                
                
                detailControllerMisc =  [[JMStaticContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];              
                [detailControllerMisc addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
                    NSMutableArray *bufferSecCounts=[[NSMutableArray alloc] init];
                    for(float i=0.5;i<=2.1;i=i+0.1)
                    {
                        [bufferSecCounts addObject:[NSString stringWithFormat:@"%.1f",i]];
                    }
                    SimplePickerInputTableViewCell *bufferCell= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Score Buffer", @"Score Buffer") selectValue:[NSString stringWithFormat:@"%.1f",si.availTimeDuringScoreCalc] dataSource:bufferSecCounts]; 
                    bufferCell.tag=kavailTimeDuringScoreCalc;
                    bufferCell.delegate=selfCtl;
                    [section addCustomerCell:bufferCell];                    
                    
                    [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        staticContentCell.cellStyle = UITableViewCellStyleValue1;
                        staticContentCell.reuseIdentifier = @"Top Score";                        
                        cell.textLabel.text = NSLocalizedString(@"Top Score", @"Top Score");
                        UISwitch *topScoreSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
                        [topScoreSwitch  addTarget:selfCtl action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
                        topScoreSwitch.on=si.enableGapScore;
                        cell.accessoryView = topScoreSwitch;
                        //cell.detailTextLabel.text = NSLocalizedString(@"On", @"On");
                    } whenSelected:^(NSIndexPath *indexPath) {
                        //TODO			
                    }];
                    
                    NSMutableArray *pointGapCounts=[[NSMutableArray alloc] init];
                    for(int i=12;i<=20;i++)
                    {
                        [pointGapCounts addObject:[NSString stringWithFormat:@"%i",i]];
                    }
                    SimplePickerInputTableViewCell *pointGapCell= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Point Gap", @"Point Gap") selectValue:[NSString stringWithFormat:@"%i",si.pointGap] dataSource:pointGapCounts];
                    pointGapCell.tag=kpointGap;
                    pointGapCell.delegate=selfCtl;
                    [section addCustomerCell:pointGapCell];                 
                    
                    NSMutableArray *pointGapEffCounts=[[NSMutableArray alloc] init];
                    for(int i=1;i<=si.roundCount;i=i+si.skipScreening)
                    {
                        [pointGapEffCounts addObject:[NSString stringWithFormat:@"%i",i]];
                    }
                    SimplePickerInputTableViewCell *pointGapEffCell= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Point Gap Effect Round", @"Point Gap Effect Round") selectValue:[NSString stringWithFormat:@"%i",si.pointGapAvailRound] dataSource:pointGapEffCounts];    
                    pointGapEffCell.tag=kpointGapAvailRound;
                    pointGapEffCell.delegate=selfCtl;
                    [section addCustomerCell:pointGapEffCell];                     
                    
                }]; 
            }
            [self setSettingTable:detailControllerMisc];
            break;
        }
        case 2:
        {
            if(detailControllerJudge==nil){
                detailControllerJudge =  [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                detailControllerJudge.tableView.dataSource=self;
                //[detailControllerJudge.tableView reloadData];
                //detailControllerJudge.tableView.delegate=self;
            }
            [self setSettingTable:detailControllerJudge];
        }
            break;
        case 3:
        {
            if(detailControllerMainMenu==nil){
                detailControllerMainMenu =  [[JMStaticContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [detailControllerMainMenu addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {                    
                                       
                    [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        staticContentCell.cellStyle = UITableViewCellStyleValue1;
                        staticContentCell.reuseIdentifier = @"End Match";                        
                        cell.textLabel.text = NSLocalizedString(@"End Match", @"End Match");
                        UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        [resetBtn setTitle:@"End Match" forState:UIControlStateNormal];
                        [resetBtn setFrame:CGRectMake(0, 0, 100, 35)];
                        [resetBtn  addTarget:selfCtl action:@selector(endMatch) forControlEvents:UIControlEventTouchUpInside];
                        cell.accessoryView = resetBtn;
                        //cell.detailTextLabel.text = NSLocalizedString(@"On", @"On");
                    } whenSelected:^(NSIndexPath *indexPath) {
                        //TODO			
                    }];
                    
                    [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        staticContentCell.cellStyle = UITableViewCellStyleValue1;
                        staticContentCell.reuseIdentifier = @"Back To Home";                        
                        cell.textLabel.text = NSLocalizedString(@"Back To Home", @"Back To Home");
                        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        [clearBtn setTitle:@"Exit" forState:UIControlStateNormal];
                        [clearBtn setFrame:CGRectMake(0, 0, 100, 35)];                     
                        [clearBtn  addTarget:selfCtl action:@selector(backToHome) forControlEvents:UIControlEventTouchUpInside];                        
                        cell.accessoryView = clearBtn;
                        //cell.detailTextLabel.text = NSLocalizedString(@"On", @"On");
                    } whenSelected:^(NSIndexPath *indexPath) {
                        //TODO			
                    }];

                    
                }];
            }
            [self setSettingTable:detailControllerMainMenu];
            break;
        }
        default:
            break;
    }    
}
-(void)setSettingTable:(UIViewController *) control
{
    NSArray *array=[[NSArray alloc] initWithObjects:detailControllerMatch,detailControllerMisc,detailControllerJudge,detailControllerMainMenu, nil];
    for (UIViewController *ctl in array) {
        if(control==ctl){            
            if(control.view.superview==nil){
                [control.view setFrame:CGRectMake(self.view.bounds.origin.x, toolbar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.view.bounds.origin.y)];
                [self.view addSubview:control.view];
            }    
            [self.view bringSubviewToFront:control.view];
        }
        else{
            [ctl.view removeFromSuperview];
        }
    }
}
#pragma mark -
#pragma mark picker delegate
- (void)tableViewCell:(SimplePickerInputTableViewCell *)cell didEndEditingWithValue:(NSString *)value
{
    NSLog(@"simple picker selected:%@",value);
    ServerSetting *si=orgGameInfo.gameSetting;
    switch (cell.tag) {   
        case krestTime:
            si.restTime=[value intValue];
            isChangeSetting=YES;
            break;           
        case kscreeningArea:
            si.screeningArea=value;
            isChangeSetting=YES;
            break;       
        case kavailTimeDuringScoreCalc:
            si.availTimeDuringScoreCalc=[value floatValue];
            isChangeSetting=YES;
            break;
        case kpointGap:
            si.pointGap=[value intValue];
            isChangeSetting=YES;
            break;
        case kpointGapAvailRound:
            si.pointGapAvailRound=[value intValue];
            isChangeSetting=YES;
            break;
        default:
            break;
    }        
}
- (void)tableViewCell:(TimePickerTableViewCell *)cell didEndEditingWithInterval:(NSTimeInterval)value
{
    NSLog(@"timer picker selected:%.1f",value);
    ServerSetting *si=orgGameInfo.gameSetting;
    switch (cell.tag) {
        case kroundTime:
            si.roundTime=value;
            [self refreshCurrentTime];
            isChangeSetting=YES;
            break;               
        case kCurrentTime:
            currentRoundTime=value;
            isChangeSetting=YES;
            break;  
    }
}
-(void)refreshCurrentTime
{
    TimePickerTableViewCell *currentTime=[self getTableCellByTag:kCurrentTime];
   currentRoundTime = [currentTime reloadPickerWithselectValue:currentRoundTime maxTime:orgGameInfo.gameSetting.roundTime minTime:0 interval:1];
}
- (void)valueChanged:(UISwitch *)theSwitch {
    orgGameInfo.gameSetting.enableGapScore=theSwitch.isOn;
    isChangeSetting=YES;
}    

- (void)tableViewCell:(StringInputTableViewCell *)cell didEndEditingWithString:(NSString *)value{
    switch (cell.tag) {
        default:
            break;
    }
}

-(void) backToHome
{
   AlertView *confirmBox= [[AlertView alloc] initWithTitle:NSLocalizedString(@"Warmning", @"") message:NSLocalizedString(@"Do you want to end this game?", @"")];
    [confirmBox addButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:[^(AlertView* a, NSInteger i){
     
    } copy]];
    [confirmBox addButtonWithTitle:NSLocalizedString(@"Exit", @"") block:[^(AlertView* a, NSInteger i){
        [relateGameServer exit];
    } copy]];
    [confirmBox show];
}

-(void)endMatch
{
    /*
    AlertView *confirmBox= [[AlertView alloc] initWithTitle:NSLocalizedString(@"Information", @"") message:NSLocalizedString(@"Do you want to goto next match?", @"")];
    [confirmBox addButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:[^(AlertView* a, NSInteger i){
        
    } copy]];
    [confirmBox addButtonWithTitle:NSLocalizedString(@"Go", @"") block:[^(AlertView* a, NSInteger i){
        [self saveSetting];
        [[ChattyAppDelegate getInstance] swithView:relateGameServer.view];
        [relateGameServer goToNextMatch];
    } copy]];
    [confirmBox show];
    */
    [[ChattyAppDelegate getInstance] swithView:relateGameServer.view]; 
    [relateGameServer duringSettingEndPress];
}

-(void)saveSetting
{
    if(isChangeSetting){
        GameInfo *currSetting=  relateGameServer.chatRoom.gameInfo;
        currSetting.gameSetting.roundTime=orgGameInfo.gameSetting.roundTime;
        currSetting.gameSetting.restTime=orgGameInfo.gameSetting.restTime;
        currSetting.currentRemainTime=currSetting.gameSetting.roundTime-currentRoundTime;
        if(currSetting.currentRemainTime<0)
            currSetting.currentRemainTime=0;
        currSetting.gameSetting.availTimeDuringScoreCalc=orgGameInfo.gameSetting.availTimeDuringScoreCalc;
        currSetting.gameSetting.enableGapScore=orgGameInfo.gameSetting.enableGapScore;
        currSetting.gameSetting.pointGap=orgGameInfo.gameSetting.pointGap;
        currSetting.gameSetting.pointGapAvailRound=orgGameInfo.gameSetting.pointGapAvailRound;
        currSetting.gameSetting.screeningArea=orgGameInfo.gameSetting.screeningArea;
    }
}

-(void) touchSaveButton
{
    [self saveSetting];
    [[ChattyAppDelegate getInstance] swithView:relateGameServer.view];    
    [relateGameServer updateForGameSetting:isChangeSetting];
}

-(void) cancelSave
{
    if(relateGameServer.view!=nil)
        {
        
    [[ChattyAppDelegate getInstance] swithView:relateGameServer.view];
    [relateGameServer updateForGameSetting:NO];
            }
    else{
        [[ChattyAppDelegate getInstance] showGameSettingView];
    }
}

-(void)restartServer
{
   UITableViewCell *cell= [self getTableCellByTag:kServerRefresh];
    btnRestartServer.hidden=YES;
    UIActivityIndicatorView *loading=  [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loading.frame=CGRectMake(0, 0, 32, 32);
    loading.tag=2;
    [loading startAnimating];
    cell.accessoryView=loading;
    [relateGameServer.chatRoom start];
    
    [NSTimer scheduledTimerWithTimeInterval: 5 target:self selector:@selector(restartServerEnd:) userInfo:cell repeats:NO];
}
-(void)restartServerEnd:(NSTimer *)timer
{
    NSArray *availPeerIds = [relateGameServer.chatRoom.bluetoothServer.serverSession peersWithConnectionState:GKPeerStateConnected];
    for (JudgeClientInfo *clt in relateGameServer.chatRoom.gameInfo.clients.allValues) {
        if([availPeerIds containsObject:clt.peerId]){
            clt.hasConnected=YES;
        }
        else
            clt.hasConnected=NO;
    }
    [detailControllerJudge.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    UITableViewCell *cell = [timer userInfo];
    UIView *loading=[cell viewWithTag:2];
    loading.hidden=YES;
    loading=nil;
    cell.accessoryView=btnRestartServer;
    btnRestartServer.hidden=NO;    
}
-(id)getTableCellByTag:(NSInteger)tag
{    
    NSArray *ctls=[[NSArray alloc] initWithObjects:detailControllerMatch,detailControllerMisc,detailControllerJudge,detailControllerMainMenu, nil];
    for (JMStaticContentTableViewController * ctl in ctls) {
        for (NSInteger j = 0; j < [ctl.tableView numberOfSections]; ++j)
        {
            for (NSInteger i = 0; i < [ctl.tableView numberOfRowsInSection:j]; ++i)
            {
                UITableViewCell * cell= [ctl.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
                if(cell.tag==tag)
                    return cell;
            }
        }
    }
    return nil;
}

#pragma mark - Judge Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 1;
    else
    {
        // Return the number of rows in the section.
        if(relateGameServer.chatRoom.gameInfo.clients==nil||[relateGameServer.chatRoom.gameInfo.clients count]==0)
            return  0;
        return relateGameServer.chatRoom.gameInfo.clients.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        static NSString* serverOptIdentifier = @"ServerRefreshIdentifier";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:serverOptIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:serverOptIdentifier];
            cell.textLabel.text=@"Refresh server";
            if(btnRestartServer==nil){
                btnRestartServer = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [btnRestartServer setTitle:@"Refresh" forState:UIControlStateNormal];
                [btnRestartServer setFrame:CGRectMake(0, 0, 100, 35)];                     
                [btnRestartServer  addTarget:self action:@selector(restartServer) forControlEvents:UIControlEventTouchUpInside];  
                btnRestartServer.tag=1;
            }
            cell.accessoryView = btnRestartServer;       
            cell.tag=kServerRefresh;
        }        
        return cell;
    }
        else{
    static NSString* serverListIdentifier = @"JudgeListIdentifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:serverListIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:serverListIdentifier];
	}
    JudgeClientInfo *cltInfo=[relateGameServer.chatRoom.gameInfo.clients objectForKey:[relateGameServer.chatRoom.gameInfo.clients.allKeys objectAtIndex: indexPath.row]];
    
    UIImage *img;
    if (cltInfo.hasConnected) {
        cell.textLabel.textColor=[UIColor darkTextColor];
        img=[UIImage imageNamed:@"circle_green.png"];
        cell.textLabel.text=cltInfo.displayName;
    }
    else{
        cell.textLabel.textColor=[UIColor redColor];
        img=[UIImage imageNamed:@"circle_red.png"];
        cell.textLabel.text=[NSString stringWithFormat:@"%@!%", cltInfo.displayName];
    }
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    imgView.image=img;
    cell.accessoryView=imgView;
    return cell;
        }
}

-(void)refreshJudges{
    [detailControllerJudge.tableView reloadData];
}
@end
