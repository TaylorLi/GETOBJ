//
//  GameSettingDetailControllerHD.m
//  TKD Score
//
//  Created by Eagle Du on 12/8/11.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "GameSettingDetailControllerHD.h"
#import "AppConfig.h"
#import "ChattyViewController.h"
#import "ChattyAppDelegate.h"
#import "ServerSetting.h"
#import "LocalRoom.h"
#import "GameInfo.h"
#import "UIHelper.h"
#import "BO_GameInfo.h"
#import "BO_JudgeClientInfo.h"
#import "BO_MatchInfo.h"
#import "BO_ScoreInfo.h"
#import "BO_ServerSetting.h"
#import "BO_UserInfo.h"

@interface GameSettingDetailControllerHD ()
@property (nonatomic, retain) UIPopoverController *popoverController;
-(void)setSettingTable:(UIViewController *) control;
-(void)clearHistory;
-(id)getTableCellByTag:(NSInteger)tag;
-(void)refreshPointGapEffRound;
-(void)refreshSkipRound;
-(void)refreshStartRound;
-(void)retreiveProfiles;
-(void)setupNewProfile;
-(void)selectProfile:(id)sender;
-(void) bindProfile;
-(void)bindSettingGroupByGameSetting;
-(void)delProfile:(NSIndexPath *)indexPath;
@end

@implementation GameSettingDetailControllerHD
@synthesize lblProfileName;

@synthesize startButton;

@synthesize toolbar, popoverController, detailItem;
@synthesize detailControllerGameSetting,detailControllerRoundSetting,detailControllerMatchSetting,detailControllerCourtSetting,detailControllerSystemSetting,detailControllerProfile,selectedProfileId;

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
-(void)viewWillAppear:(BOOL)animated
{   
    
    if([[BO_GameInfo getInstance] hasUncompletedGame]){        
        [AppConfig getInstance].currentGameInfo = [[BO_GameInfo getInstance] getlastUncompletedGame];
        __block GameInfo *gi; 
        gi= [AppConfig getInstance].currentGameInfo;
        [UIHelper showConfirm:@"Information" message:[NSString stringWithFormat:@"Game %@ %@ is not compeleted yet,continue the game?",gi.gameSetting.gameName,gi.gameSetting.gameDesc] doneText:@"OK" doneFunc:^(AlertView *a, NSInteger i) {
            [self startGame:YES];
        } cancelText:@"Cancel" cancelfunc:^(AlertView *a, NSInteger i) {            
            gi.gameEnded=YES;
            [[BO_GameInfo getInstance] updateObject:gi];
            [self bindProfile];
        }];   
    }else{
        [self bindProfile];
    }
    lblProfileName.text = [AppConfig getInstance].currentGameInfo.gameSetting.profileName;
    [self retreiveProfiles];
    [self bindSettingGroupByGameSetting];
}

-(void) bindProfile
{
    ServerSetting *setting = [[BO_ServerSetting getInstance] getSettingLastUsedProfile];
    if(setting==nil){
        ServerSetting *defaultSetting = [[BO_ServerSetting getInstance] getDefaultProfile];
        if(defaultSetting==nil){
            setting=[[ServerSetting alloc] initWithDefault];
            [[BO_ServerSetting getInstance] insertObject:setting];                
        }else{
            setting=defaultSetting;
        }
    }
    [AppConfig getInstance].currentGameInfo=[[GameInfo alloc] initWithGameSetting:setting];
}

-(void)bindSettingGroupByGameSetting
{
    detailControllerGameSetting=nil;
    detailControllerRoundSetting=nil;
    detailControllerMatchSetting=nil;
    detailControllerCourtSetting=nil;
    detailControllerSystemSetting=nil;
    detailControllerProfile=nil;
    [self bindSettingGroupData:gsTabRoundSetting];
    [self bindSettingGroupData:gsTabCourtSetting];
    [self bindSettingGroupData:gsTabMatchSetting];    
    [self bindSettingGroupData:gsTabSystemSetting];
    [self bindSettingGroupData:gsTabGameSetting];
    [self bindSettingGroupData:gsTabProfileSetting];
}

- (void)viewDidUnload
{    
    [self setLblProfileName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;    
}

-(void)viewDidDisappear:(BOOL)animated
{
    detailControllerGameSetting=nil;
    detailControllerSystemSetting=nil;
    detailControllerCourtSetting=nil;
    detailControllerMatchSetting=nil;
    detailControllerRoundSetting=nil;
    detailControllerProfile=nil;
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

-(void) touchSaveButton
{
    [self startGame:NO];
}
- (void)startGame:(BOOL)isCallByRestoreFromGameInfo
{        
    [[BO_ServerSetting getInstance] updateObject:[AppConfig getInstance].currentGameInfo.gameSetting];
    if([AppConfig getInstance].currentGameInfo.gameSetting.startScreening==0){
        [UIHelper showAlert:@"Error" message:@"Start court should not to be 0." func:nil];
        return;
    }
    [AppConfig getInstance].currentGameInfo.gameSetting.lastUsingDate=[NSDate date];
    [[BO_ServerSetting getInstance] updateObject:[AppConfig getInstance].currentGameInfo.gameSetting];
    if(!isCallByRestoreFromGameInfo){
        [[AppConfig getInstance].currentGameInfo resetGameInfoToStart];
        [AppConfig getInstance].currentGameInfo.serverFullName=[AppConfig getInstance].currentGameInfo.gameSetting.serverName;
        [[BO_GameInfo getInstance] AddGameInfo:[AppConfig getInstance].currentGameInfo];
    }
    LocalRoom* room = [[LocalRoom alloc] initWithGameInfo:[AppConfig getInstance].currentGameInfo];
    //[UtilHelper serializeObjectToFile:KEY_FILE_SETTING withObject:[AppConfig getInstance].currentGameInfo dataKey:KEY_FILE_SETTING_GAME_INFO];
    [[ChattyAppDelegate getInstance].viewController stopBrowser];
    room.isRestoredGame=isCallByRestoreFromGameInfo;
    [[ChattyAppDelegate getInstance] showScoreBoard:room];
}
- (IBAction)touchCancelButton:(id)sender {
    [[ChattyAppDelegate getInstance] showRoomSelection];
}

#pragma mark -
#pragma mark Bind Table Cells 
-(void) bindSettingGroupData:(GameSettingTabs)group
{
    __weak ServerSetting *si=[AppConfig getInstance].currentGameInfo.gameSetting;
    __weak GameSettingDetailControllerHD *selfCtl=self;
    switch (group) {
        case gsTabGameSetting:
        {
            if(detailControllerGameSetting==nil)
            {                    
                detailControllerGameSetting =  [[JMStaticContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];  
                [detailControllerGameSetting addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
                    StringInputTableViewCell *matchNameCell= [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Match Name" andTitle:NSLocalizedString(@"Match Name", @"Match Name") andText:si.gameName];   
                    matchNameCell.tag=kgameName;
                    matchNameCell.delegate=selfCtl;
                    [section addCustomerCell:matchNameCell];
                    
                    StringInputTableViewCell *matchDescCell= [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Match Description" andTitle:NSLocalizedString(@"Match Description", @"Match Description") andText:si.gameDesc];   
                    matchDescCell.tag=kgameDesc;
                    matchDescCell.delegate=selfCtl;
                    [section addCustomerCell:matchDescCell];
                } andHeader:@"Game Info" andFooter:nil];
            }
            [self setSettingTable:detailControllerGameSetting];
            
            [detailControllerGameSetting addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
                StringInputTableViewCell *redNameCell= [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Red Side Name" andTitle:NSLocalizedString(@"Red Side Name", @"Red Side Name") andText:si.redSideName];   
                redNameCell.tag=kredSideName;
                redNameCell.delegate=selfCtl;
                [section addCustomerCell:redNameCell];
                
                StringInputTableViewCell *redDescCell= [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Red Side Description" andTitle:NSLocalizedString(@"Red Side Description", @"Red Side Description") andText:si.redSideDesc];   
                redDescCell.tag=kredSideDesc;
                redDescCell.delegate=selfCtl;
                [section addCustomerCell:redDescCell];
            } andHeader:@"Red Setting" andFooter:nil];
            
            [detailControllerGameSetting addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
                StringInputTableViewCell *blueNameCell= [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Blue Side Name" andTitle:NSLocalizedString(@"Blue Side Name", @"Blue Side Name") andText:si.blueSideName];   
                blueNameCell.tag=kblueSideName;
                blueNameCell.delegate=selfCtl;
                [section addCustomerCell:blueNameCell];
                
                StringInputTableViewCell *blueDescCell= [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Blue Side Description" andTitle:NSLocalizedString(@"Blue Side Description", @"Blue Side Description") andText:si.blueSideDesc];   
                blueDescCell.tag=kblueSideDesc;
                blueDescCell.delegate=selfCtl;
                [section addCustomerCell:blueDescCell];
            } andHeader:@"Blue Setting" andFooter:nil];
        }
            break;
        case gsTabRoundSetting:{
            if(detailControllerRoundSetting==nil){                    
                detailControllerRoundSetting =  [[JMStaticContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];                  
                [detailControllerRoundSetting addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
                    TimePickerTableViewCell *roundTime=[[TimePickerTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Round time" title:NSLocalizedString(@"Round Time", @"Round Time") selectValue:si.roundTime maxTime:600 minTime:10 interval:10];
                    roundTime.tag=kroundTime;
                    roundTime.delegate=selfCtl;
                    [section addCustomerCell:roundTime];
                    NSMutableArray *restTimeSource=[[NSMutableArray alloc] init];
                    for(int i=10;i<=90;i=i+10)
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
                    
                    SimplePickerInputTableViewCell *restAndReOrgTime= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title:NSLocalizedString(@"Rest And Reorganization Time", @"Rest Time") selectValue:[NSString stringWithFormat:@"%.f Seconds",si.restAndReorganizationTime] dataSource:pauserestTimeSource];               
                    restAndReOrgTime.tag=krestAndReOrgTime;
                    restAndReOrgTime.delegate=selfCtl;
                    [section addCustomerCell:restAndReOrgTime]; 
                    
                    
                    NSMutableArray *roundCounts=[[NSMutableArray alloc] init];
                    for(int i=1;i<=9;i++)
                    {
                        [roundCounts addObject:[NSString stringWithFormat:@"%i",i]];
                    }
                    SimplePickerInputTableViewCell *roundCountCell= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Round Count", @"Round Count") selectValue:[NSString stringWithFormat:@"%i",si.roundCount] dataSource:roundCounts];      
                    roundCountCell.tag=kroundCount;
                    roundCountCell.delegate=selfCtl;
                    [section addCustomerCell:roundCountCell];
                }];   
                [detailControllerRoundSetting addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex){
                    NSMutableArray *maxWarmning=[[NSMutableArray alloc] init];
                    for(int i=4;i<=8;i++)
                    {
                        [maxWarmning addObject:[NSString stringWithFormat:@"%i",i]];
                    }
                    SimplePickerInputTableViewCell *maxWarmningCell= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Max Warmning", @"Max Warmning") selectValue:[NSString stringWithFormat:@"%i", si.maxWarningCount] dataSource:maxWarmning];   
                    maxWarmningCell.tag=kmaxWarmningCount;
                    maxWarmningCell.delegate=selfCtl;
                    [section addCustomerCell:maxWarmningCell];
                }];
            }
            [self setSettingTable:detailControllerRoundSetting];
        }
            break;
        case gsTabCourtSetting:
        {
            if(detailControllerMatchSetting==nil){ 
                detailControllerMatchSetting =  [[JMStaticContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [detailControllerMatchSetting addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
                    NSMutableArray *areas=[[NSMutableArray alloc] init];
                    for(int i=65;i<=88;i++)
                    {
                        [areas addObject:[NSString stringWithFormat:@"%c",(char)i]];
                    }
                    SimplePickerInputTableViewCell *screenArea= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Court Area", @"Screening Court") selectValue:si.screeningArea dataSource:areas];   
                    screenArea.tag=kscreeningArea;
                    screenArea.delegate=selfCtl;
                    [section addCustomerCell:screenArea];   
                    
                    //                    NSMutableArray *startSeqs=[[NSMutableArray alloc] init];
                    //                    for(int i=1;i<=999;i++)
                    //                    {
                    //                        [startSeqs addObject:[NSString stringWithFormat:@"%i",i]];
                    //                    }
                    //                    SimplePickerInputTableViewCell *startSeqCell= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Start Court", @"Start Court") selectValue:[NSString stringWithFormat:@"%i",si.startScreening] dataSource:startSeqs];      
                    
                    IntegerInputTableViewCell *startSeqCell=[[IntegerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"StartCell"                                                                                                       title:NSLocalizedString(@"Start Court", @"Start Court") lowerLimit:0 hightLimit:999 selectedValue:si.startScreening];
                    startSeqCell.tag=kstartScreening;
                    startSeqCell.delegate=selfCtl;
                    [section addCustomerCell:startSeqCell];                                        
                    
                    NSMutableArray *skipSeqs=[[NSMutableArray alloc] init];
                    for(int i=1;i<=10;i++)
                    {
                        NSMutableString *disSample=[[NSMutableString alloc] initWithCapacity:6];
                        [disSample appendFormat:@"%i(",i];
                        for(int j=0;j<4;j++)
                            [disSample appendFormat:@"%i,",si.startScreening+j*i];
                        [disSample appendString:@"...)"];
                        [skipSeqs addObject:[NSString stringWithFormat:@"%@",disSample]];
                    }                    
                    SimplePickerInputTableViewCell *skipSeqCell= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Skip Court", @"Skip Court") selectValue:nil dataSource:skipSeqs];    
                    skipSeqCell.selectedIndex=si.skipScreening-1;
                    skipSeqCell.tag=kskipScreening;
                    skipSeqCell.delegate=selfCtl;
                    [section addCustomerCell:skipSeqCell];                     
                }];                  
            }
            [self setSettingTable:detailControllerMatchSetting];
            break;
        }
        case gsTabMatchSetting:
        {
            if(detailControllerCourtSetting==nil){                
                
                detailControllerCourtSetting =  [[JMStaticContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];              
                [detailControllerCourtSetting addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
                    
                    NSMutableArray *refCounts=[[NSMutableArray alloc] init];
                    for(int i=1;i<=4;i++)
                    {
                        [refCounts addObject:[NSString stringWithFormat:@"%i Referees",i]];
                    }
                    SimplePickerInputTableViewCell *referenceCountCell= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Referee Count", @"Referee Count") selectValue:[NSString stringWithFormat:@"%i Referees",si.judgeCount] dataSource:refCounts];   
                    referenceCountCell.tag=kjudgeCount;
                    referenceCountCell.delegate=selfCtl;
                    [section addCustomerCell:referenceCountCell];                                          
                    
                    NSMutableArray *availRefCounts=[[NSMutableArray alloc] init];
                    for(int i=1;i<=si.judgeCount;i++)
                    {
                        [availRefCounts addObject:[NSString stringWithFormat:@"%i/%i",i,si.judgeCount]];
                    }
                    SimplePickerInputTableViewCell *availScoreRefCountCell= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Avail Score Via Referee", @"Avail Score Via Referee") selectValue:[NSString stringWithFormat:@"%i/%i",si.availScoreWithJudgesCount,si.judgeCount] dataSource:availRefCounts];   
                    availScoreRefCountCell.tag=kavailScoreWithJudesCount;
                    availScoreRefCountCell.delegate=selfCtl;
                    [section addCustomerCell:availScoreRefCountCell]; 
                    
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
                    for(int i=1;i<=si.roundCount;i=i+1)
                    {
                        [pointGapEffCounts addObject:[NSString stringWithFormat:@"%i",i]];
                    }
                    SimplePickerInputTableViewCell *pointGapEffCell= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Point Gap Effect Round", @"Point Gap Effect Round") selectValue:[NSString stringWithFormat:@"%i",si.pointGapAvailRound] dataSource:pointGapEffCounts];    
                    pointGapEffCell.tag=kpointGapAvailRound;
                    pointGapEffCell.delegate=selfCtl;
                    [section addCustomerCell:pointGapEffCell];                     
                    
                    NSMutableArray *fightTimeInvs=[[NSMutableArray alloc] init];
                    for(int i=10;i<=20;i=i+1)
                    {
                        [fightTimeInvs addObject:[NSString stringWithFormat:@"%i",i]];
                    }
                    SimplePickerInputTableViewCell *fightTimeCell= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Fight Time(Second)", @"Fight Time(Second)") selectValue:[NSString stringWithFormat:@"%i",si.fightTimeInterval] dataSource:fightTimeInvs];    
                    fightTimeCell.tag=kFightTime;
                    fightTimeCell.delegate=selfCtl;
                    [section addCustomerCell:fightTimeCell];
                    
                }]; 
            }
            [self setSettingTable:detailControllerCourtSetting];
            break;
        }
        case gsTabProfileSetting:{
            if(detailControllerProfile==nil){
                detailControllerProfile = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                detailControllerProfile.tableView.dataSource=self;
                //[detailControllerJudge.tableView reloadData];
                //detailControllerJudge.tableView.delegate=self;
            }
            [self setSettingTable:detailControllerProfile];
            break;
        }
        case gsTabSystemSetting:
        {
            if(detailControllerSystemSetting==nil){
                detailControllerSystemSetting =  [[JMStaticContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [detailControllerSystemSetting addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
                    StringInputTableViewCell *serverNameCell= [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Server Name" andTitle:NSLocalizedString(@"Server Name", @"Server Name") andText:si.serverName];   
                    serverNameCell.tag=kserverName;
                    serverNameCell.delegate=selfCtl;
                    [section addCustomerCell:serverNameCell];
                    
                    StringInputTableViewCell *joinPwdCell= [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Join Password" andTitle:NSLocalizedString(@"Join Password", @"Join Password") andText:si.password];   
                    joinPwdCell.tag=kpassword;
                    joinPwdCell.textField.secureTextEntry=YES;
                    joinPwdCell.delegate=selfCtl;
                    [section addCustomerCell:joinPwdCell];
                }];
                if(si.currentJudgeDevice==JudgeDeviceKeyboard && ![AppConfig getInstance].productSNValidate){
                    si.currentJudgeDevice=JudgeDeviceiPhone;
                    [UIHelper showAlert:@"Warmning" message:@"Product not active yet,can not use [Peripheral Device] mode." func:nil];
                }
                [detailControllerSystemSetting addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
                    NSArray *clientDeviceType=[[NSArray alloc] initWithObjects:@"iPod or iPhone",@"Peripheral Device", nil];
                    NSString *currentDeviceType;
                    switch (si.currentJudgeDevice) {
                        case JudgeDeviceiPhone:
                            currentDeviceType=@"iPod or iPhone";
                            break;
                        case JudgeDeviceKeyboard:
                            currentDeviceType=@"Peripheral Device";
                            break;
                        case JudgeDeviceHeadphone:
                            currentDeviceType=@"Headphone Device";
                            break;
                        default:
                            break;
                    }
                    SimplePickerInputTableViewCell *deviceCell= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Referee Device Type", @"Referee Device Type") selectValue:currentDeviceType dataSource:clientDeviceType];
                    deviceCell.tag=kDeviceType;
                    deviceCell.delegate=selfCtl;
                    [section addCustomerCell:deviceCell]; 
                }];
                [detailControllerSystemSetting addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
                    [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        staticContentCell.cellStyle = UITableViewCellStyleValue1;
                        staticContentCell.reuseIdentifier = @"Clear Record";                        
                        cell.textLabel.text = NSLocalizedString(@"Clear Record", @"Clear Record");
                        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        [clearBtn setTitle:@"Clear" forState:UIControlStateNormal];
                        [clearBtn setFrame:CGRectMake(0, 0, 100, 35)];                     
                        [clearBtn  addTarget:selfCtl action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];                        
                        cell.accessoryView = clearBtn;
                        //cell.detailTextLabel.text = NSLocalizedString(@"On", @"On");
                    } whenSelected:^(NSIndexPath *indexPath) {
                        //TODO			
                    }];
                    
                    [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        staticContentCell.cellStyle = UITableViewCellStyleValue1;
                        staticContentCell.reuseIdentifier = @"Reset Setting";                        
                        cell.textLabel.text = NSLocalizedString(@"Reset Setting", @"Reset");
                        UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        [resetBtn setTitle:@"Reset" forState:UIControlStateNormal];
                        [resetBtn setFrame:CGRectMake(0, 0, 100, 35)];
                        [resetBtn  addTarget:selfCtl action:@selector(resetSetting) forControlEvents:UIControlEventTouchUpInside];
                        cell.accessoryView = resetBtn;
                        //cell.detailTextLabel.text = NSLocalizedString(@"On", @"On");
                    } whenSelected:^(NSIndexPath *indexPath) {
                        //TODO			
                    }];
                    
                }];
            }
            [self setSettingTable:detailControllerSystemSetting];
            break;
        }
        default:
            break;
    }    
}
-(void)setSettingTable:(UIViewController *) control
{
    NSArray *array=[[NSArray alloc] initWithObjects:detailControllerGameSetting,detailControllerRoundSetting,detailControllerMatchSetting,detailControllerCourtSetting,detailControllerSystemSetting,detailControllerProfile, nil];
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
    //NSLog(@"simple picker selected:%@",value);
    ServerSetting *si=[AppConfig getInstance].currentGameInfo.gameSetting;
    switch (cell.tag) {   
        case kroundCount:
        {
            si.roundCount=[value intValue];    
            [self refreshStartRound];
            [self refreshSkipRound];
            [self refreshPointGapEffRound];
        }
            break;
        case krestTime:
        {
            NSTimeInterval t=[value intValue];
            if(t<10)
            {
                [UIHelper showAlert:@"Information" message:@"Round can not be 0 seconds." func:nil];
            }
            else
                si.restTime=t;
        }
            
            break;
        case krestAndReOrgTime:
            si.restAndReorganizationTime=[value intValue];
            break;            
        case  kmaxWarmningCount:
            si.maxWarningCount=[value intValue];
            break;
        case kscreeningArea:
            si.screeningArea=value;
            break;
            //        case kstartScreening:
            //        {
            //            si.startScreening=[value intValue];
            //            [self refreshSkipRound];
            //            [self refreshPointGapEffRound];
            //        }
            //            break;
        case kskipScreening:
        {
            si.skipScreening=[value intValue];
            [self refreshPointGapEffRound];
        }
            break;
        case kjudgeCount:
        {
            int preJudgeCount=si.judgeCount;
            if(preJudgeCount!=[value intValue]){
                si.judgeCount=[value intValue];
                SimplePickerInputTableViewCell *cell=[self getTableCellByTag:kavailScoreWithJudesCount];
                if(cell!=nil){
                    NSMutableArray *availRefCounts= [[NSMutableArray alloc] init];
                    for(int i=1;i<=si.judgeCount;i++)
                    {
                        [availRefCounts addObject:[NSString stringWithFormat:@"%i/%i",i,si.judgeCount]];
                    }                    
                    [cell reloadPicker:availRefCounts];
                    [cell setValue:[NSString stringWithFormat:@"%i/%i",si.judgeCount,si.judgeCount]];
                    si.availScoreWithJudgesCount=[cell.value intValue];
                }               
            }
        }
            break;
        case kavailScoreWithJudesCount:
            si.availScoreWithJudgesCount=[value intValue];
            break;
        case kavailTimeDuringScoreCalc:
            si.availTimeDuringScoreCalc=[value floatValue];
            break;
        case kpointGap:
            si.pointGap=[value intValue];
            break;
        case kpointGapAvailRound:
            si.pointGapAvailRound=[value intValue];
            break;
        case kFightTime:
            si.fightTimeInterval=[value intValue];
            break;
        case  kDeviceType:
            if(value==@"Peripheral Device")
                si.currentJudgeDevice=JudgeDeviceKeyboard;
            else if(value==@"Headphone Device")
                si.currentJudgeDevice=JudgeDeviceHeadphone ;
            else
                si.currentJudgeDevice=JudgeDeviceiPhone;
            break;
        default:
            break;
    }        
}
-(void)tableViewCell:(IntegerInputTableViewCell *)cell didEndEditingWithInteger:(NSUInteger)value
{
    ServerSetting *si=[AppConfig getInstance].currentGameInfo.gameSetting;
    si.startScreening=value;
    [self refreshSkipRound];
    [self refreshPointGapEffRound];
}

-(void)refreshStartRound
{
    /*
     ServerSetting *si=[AppConfig getInstance].serverSettingInfo;
     NSMutableArray *startSeqs=[[NSMutableArray alloc] init];
     for(int i=1;i<=si.roundCount;i++)
     {
     [startSeqs addObject:[NSString stringWithFormat:@"%i",i]];
     }
     SimplePickerInputTableViewCell *cell=[self getTableCellByTag:kstartScreening];
     [cell reloadPicker:startSeqs];
     si.pointGapAvailRound=[cell.value intValue];
     */
}
-(void)refreshPointGapEffRound{
    ServerSetting *si=[AppConfig getInstance].currentGameInfo.gameSetting;
    SimplePickerInputTableViewCell *cellGapEff=[self getTableCellByTag:kpointGapAvailRound];
    NSMutableArray *pointGapEffCounts=[[NSMutableArray alloc] init];
    for(int i=1;i<=si.roundCount;i=i+1)
    {
        [pointGapEffCounts addObject:[NSString stringWithFormat:@"%i",i]];
    }
    [cellGapEff reloadPicker:pointGapEffCounts];
    int orgGap=[cellGapEff.value intValue];
    if(orgGap>=si.roundCount){
        if(si.roundCount>1)
            orgGap=2;
        else
            orgGap=1;
    }
    si.pointGapAvailRound=orgGap;
}
-(void)refreshSkipRound{
    ServerSetting *si=[AppConfig getInstance].currentGameInfo.gameSetting;
    NSMutableArray *skipSeqs=[[NSMutableArray alloc] init];
    SimplePickerInputTableViewCell *cell=[self getTableCellByTag:kskipScreening];
    for(int i=1;i<=10;i++)
    {
        NSMutableString *disSample=[[NSMutableString alloc] initWithCapacity:6];
        [disSample appendFormat:@"%i(",i];
        for(int j=0;j<4;j++)
            [disSample appendFormat:@"%i,",si.startScreening+j*i];
        [disSample appendString:@"...)"];
        [skipSeqs addObject:[NSString stringWithFormat:@"%@",disSample]];
    }  
    [cell reloadPicker:skipSeqs];
    si.pointGapAvailRound=[cell.value intValue];
}
- (void)tableViewCell:(TimePickerTableViewCell *)cell didEndEditingWithInterval:(NSTimeInterval)value
{
    NSLog(@"timer picker selected:%.1f",value);
    ServerSetting *si=[AppConfig getInstance].currentGameInfo.gameSetting;
    switch (cell.tag) {
        case kroundTime:
            si.roundTime=value;
            break;   
    }
}
- (void)valueChanged:(UISwitch *)theSwitch {
    [AppConfig getInstance].currentGameInfo.gameSetting.enableGapScore=theSwitch.isOn;
}    

- (void)tableViewCell:(StringInputTableViewCell *)cell didEndEditingWithString:(NSString *)value{
    ServerSetting *si=[AppConfig getInstance].currentGameInfo.gameSetting;
    switch (cell.tag) {
        case kserverName:
            si.serverName=value;
            break;
        case kgameName:
            si.gameName=value;
            break;
        case kgameDesc:
            si.gameDesc=value;
            break;
        case kblueSideDesc:
            si.blueSideDesc=value;
            break;
        case kredSideDesc:
            si.redSideDesc=value;
            break;
        case kredSideName:
            si.redSideName=value;
            break;
        case kblueSideName:
            si.blueSideName=value;
            break;
        case kpassword:
            si.password=value;
            break;
        case kProfileName:
            cell.textLabel.text=value;
            si.profileName=value;
            lblProfileName.text=value;
            break;
        default:
            break;
    }
}

-(void) clearHistory
{
}

-(void)resetSetting
{
    detailControllerGameSetting=nil;
    detailControllerRoundSetting=nil;
    detailControllerMatchSetting=nil;
    detailControllerCourtSetting=nil;
    detailControllerSystemSetting=nil;
    detailControllerProfile=nil;
    [[AppConfig getInstance].currentGameInfo.gameSetting reset];
    [self bindSettingGroupByGameSetting];
    [UIHelper showAlert:@"Information" message:@"Settings have been reseted." func:nil];
}
-(id)getTableCellByTag:(NSInteger)tag
{    
    NSArray *ctls=[[NSArray alloc] initWithObjects:detailControllerGameSetting,detailControllerRoundSetting,detailControllerMatchSetting,detailControllerCourtSetting,detailControllerSystemSetting, nil];
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
        return availProfiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        static NSString* serverOptIdentifier = @"ProfileAddIdentifier";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:serverOptIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:serverOptIdentifier];
            cell.textLabel.text=@"Profile Manage";
            UIButton *btnAddProfile = [UIButton buttonWithType:UIButtonTypeContactAdd];
            //[btnAddProfile setTitle:@"Add" forState:UIControlStateNormal];
            //[btnAddProfile setFrame:CGRectMake(0, 0, 100, 35)];                     
            [btnAddProfile  addTarget:self action:@selector(setupNewProfile) forControlEvents:UIControlEventTouchUpInside];  
            cell.accessoryView = btnAddProfile;       
            cell.tag=kServerRefresh;
        }        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{      
        ServerSetting *setting=[availProfiles objectAtIndex: indexPath.row];
        if([[AppConfig getInstance].currentGameInfo.gameSetting.settingId isEqualToString:setting.settingId]){
            static NSString* profileCurrentIdentifier = @"ProfileCurrentIdentifier";
            StringInputTableViewCell *profileCurrentCell= [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:profileCurrentIdentifier andTitle:setting.profileName andText:setting.profileName];   
            profileCurrentCell.tag=kProfileName;
            profileCurrentCell.detailTextLabel.text=[NSString stringWithFormat:@"%@", [UtilHelper formateDateWithTime:setting.createDate]];
            //            if(availProfiles.count > 1){
            //                UIButton *btnDelProfile = [UIButton buttonWithType: UIButtonTypeCustom];
            //                [btnDelProfile setBackgroundImage: [UIImage imageNamed:@"alert-close.png"] forState:UIControlStateNormal];
            //                //[btnAddProfile setTitle:@"Add" forState:UIControlStateNormal];
            //                [btnDelProfile setFrame:CGRectMake(0, 0, 24, 24)];                     
            //                [btnDelProfile  addTarget:self action:@selector(delProfile:) forControlEvents:UIControlEventTouchUpInside];  
            //                profileCurrentCell.accessoryView = btnDelProfile;
            //            }
            
            profileCurrentCell.delegate=self;
            //profileCurrentCell.detailTextLabel.textColor=[UIColor redColor];
            return profileCurrentCell;
        }
        else{
            static NSString* profileOtherIdentifier = @"ProfileOtherIdentifier";
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:profileOtherIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:profileOtherIdentifier];
            }
            cell.textLabel.text=setting.profileName;  
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@", [UtilHelper formateDateWithTime:setting.createDate]];
            UIButton *btnUseProfile = [UIButton buttonWithType:UIButtonTypeCustom];
            //[btnUseProfile setTitle:@"Using This Profile" forState:UIControlStateNormal];
            UIImage *buttonImageNormal = [UIImage imageNamed:@"profile-accept.png"];
            [btnUseProfile setBackgroundImage:buttonImageNormal forState:UIControlStateNormal];
            [btnUseProfile setFrame:CGRectMake(0, 0, 24, 24)];  
            [btnUseProfile addTarget:self action:@selector(selectProfile:) forControlEvents:UIControlEventTouchUpInside]; 
            btnUseProfile.tag=indexPath.row;
            cell.accessoryView = btnUseProfile;   
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }       
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { 
    if(indexPath.section==1)
    {
        if(availProfiles.count>1)
            return YES;
        else
            return NO;
    }
    else        
        return NO;
} 
#pragma mark -
#pragma mark Add Delete Func for table view
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { 
    if (editingStyle == UITableViewCellEditingStyleDelete) { 
        [self delProfile:indexPath];       
    }    
    else if (editingStyle == UITableViewCellEditingStyleInsert) { 
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view. 
    }    
} 
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{ 
} 
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    // Delete the row from the data source. 
    [tableView deleteRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade]; 
} 

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{ 
    return @"Delete"; 
} 
#pragma mark Add Delete Func for table view end

-(void)retreiveProfiles
{
    availProfiles=[[BO_ServerSetting getInstance] getProfiles];
}
-(void)setupNewProfile
{
    ServerSetting *setting=[AppConfig getInstance].currentGameInfo.gameSetting;
    [[BO_ServerSetting getInstance] updateObject:setting];
    setting=[[ServerSetting alloc] initWithDefault];
//    [UtilHelper deserializeFromFile:KEY_FILE_SETTING dataKey:KEY_FILE_SETTING_GAME_INFO];
    setting.profileName=[NSString stringWithFormat:@"User Profile %i", [AppConfig getInstance].profileIndex];
    if([[BO_ServerSetting getInstance] insertObject:setting])
    {
        [AppConfig getInstance].currentGameInfo.gameSetting=setting;     
        lblProfileName.text = setting.profileName;
        [self bindSettingGroupByGameSetting];
        [self retreiveProfiles];
        [self bindSettingGroupData:gsTabProfileSetting];
        [AppConfig getInstance].profileIndex++;
        [[AppConfig getInstance] saveProfileIndexToFile];
//        [UtilHelper serializeObjectToFile:KEY_FILE_SETTING withObject:[AppConfig getInstance].currentGameInfo dataKey:KEY_FILE_SETTING_GAME_INFO];
        [UIHelper showAlert:@"Information" message:[NSString stringWithFormat:@"New profile:%@ have been created.",setting.profileName] func:nil];
    }
    else{
        [UIHelper showAlert:@"Error" message:@"New profile created failed,please retry later." func:nil];
    }
}
-(void)selectProfile:(id)sender
{
    UIView *firstView=[UIHelper findFirstResponder:detailControllerProfile.view];
    if(firstView!=nil){
        [firstView resignFirstResponder];
    }
    UIButton *send=sender;
    ServerSetting *setting=[AppConfig getInstance].currentGameInfo.gameSetting;
    [[BO_ServerSetting getInstance] updateObject:setting];
    setting=nil;
    setting=[availProfiles objectAtIndex:send.tag]; 
    [self retreiveProfiles];
    [AppConfig getInstance].currentGameInfo.gameSetting=setting;
    lblProfileName.text = setting.profileName;
    [self bindSettingGroupByGameSetting];   
    [self bindSettingGroupData:gsTabProfileSetting];
}
-(void)delProfile:(NSIndexPath *)indexPath
{
    ServerSetting *selSetting = [availProfiles objectAtIndex:indexPath.row];
    if([[BO_ServerSetting getInstance] deleteObjectById:selSetting.settingId]){
        [self retreiveProfiles];
        [AppConfig getInstance].currentGameInfo.gameSetting = [availProfiles objectAtIndex:0];
        lblProfileName.text = [AppConfig getInstance].currentGameInfo.gameSetting.profileName;
        [self bindSettingGroupByGameSetting];   
        [self bindSettingGroupData:gsTabProfileSetting];
    }
    else{
        [UIHelper showAlert:@"Error" message:@"Delete profile failed,please retry later." func:nil];
    }
    
}
@end
