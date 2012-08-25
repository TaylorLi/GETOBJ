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

@interface GameSettingDetailControllerHD ()
@property (nonatomic, retain) UIPopoverController *popoverController;
-(void)setSettingTable:(UIViewController *) control;
-(void)clearHistory;
-(id)getTableCellByTag:(NSInteger)tag;
-(void)refreshPointGapEffRound;
-(void)refreshSkipRound;
-(void)refreshStartRound;
@end

@implementation GameSettingDetailControllerHD

@synthesize startButton;

@synthesize toolbar, popoverController, detailItem;
@synthesize detailController0,detailController1,detailController2,detailController3,detailController4;

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
    [self bindSettingGroupData:1];
    [self bindSettingGroupData:2];
    [self bindSettingGroupData:3];
    [self bindSettingGroupData:4];
    [self bindSettingGroupData:0];
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;    
}

-(void)viewDidDisappear:(BOOL)animated
{
    detailController0=nil;
    detailController1=nil;
    detailController2=nil;
    detailController3=nil;
    detailController4=nil;
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
    LocalRoom* room = [[LocalRoom alloc] initWithGameInfo:[[GameInfo alloc] initWithGameSetting:[AppConfig getInstance].serverSettingInfo]];
    [AppConfig getInstance].currentGameInfo=room.gameInfo;
    [[ChattyAppDelegate getInstance].viewController stopBrowser];
    [[ChattyAppDelegate getInstance] showScoreBoard:room];
}
- (IBAction)touchCancelButton:(id)sender {
    [[ChattyAppDelegate getInstance] showRoomSelection];
}

#pragma mark -
#pragma mark Bind Table Cells 
-(void) bindSettingGroupData:(int)group
{
    __weak ServerSetting *si=[AppConfig getInstance].serverSettingInfo;
    __weak GameSettingDetailControllerHD *selfCtl=self;
    switch (group) {
        case 0:
        {
            if(detailController0==nil)
            {                    
                detailController0 =  [[JMStaticContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];  
                [detailController0 addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
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
            [self setSettingTable:detailController0];
            
            [detailController0 addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
                StringInputTableViewCell *redNameCell= [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Red Side Name" andTitle:NSLocalizedString(@"Red Side Name", @"Red Side Name") andText:si.redSideName];   
                redNameCell.tag=kredSideName;
                redNameCell.delegate=selfCtl;
                [section addCustomerCell:redNameCell];
                
                StringInputTableViewCell *redDescCell= [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Red Side Description" andTitle:NSLocalizedString(@"Red Side Description", @"Red Side Description") andText:si.redSideDesc];   
                redDescCell.tag=kredSideDesc;
                redDescCell.delegate=selfCtl;
                [section addCustomerCell:redDescCell];
            } andHeader:@"Red Setting" andFooter:nil];
            
            [detailController0 addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
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
        case 1:{
            if(detailController1==nil){                    
                detailController1 =  [[JMStaticContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];                  
                [detailController1 addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
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
                [detailController1 addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex){
                    NSMutableArray *maxWarmning=[[NSMutableArray alloc] init];
                    for(int i=6;i<=12;i++)
                    {
                        [maxWarmning addObject:[NSString stringWithFormat:@"%i",i]];
                    }
                    SimplePickerInputTableViewCell *maxWarmningCell= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Max Warmning", @"Max Warmning") selectValue:[NSString stringWithFormat:@"%i", si.maxWarningCount] dataSource:maxWarmning];   
                    maxWarmningCell.tag=kmaxWarmningCount;
                    maxWarmningCell.delegate=selfCtl;
                    [section addCustomerCell:maxWarmningCell];
                }];
            }
            [self setSettingTable:detailController1];
        }
            break;
        case 2:
        {
            if(detailController2==nil){ 
                detailController2 =  [[JMStaticContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [detailController2 addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
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
                    
                    IntegerInputTableViewCell *startSeqCell=[[IntegerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"StartCell"
                                                                                                       title:NSLocalizedString(@"Start Court", @"Start Court") lowerLimit:1 hightLimit:999 selectedValue:si.startScreening       ];
                    startSeqCell.lowerLimit=1;
                    startSeqCell.upperLimit=999;
                    startSeqCell.numberValue=si.startScreening;
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
            [self setSettingTable:detailController2];
            break;
        }
        case 3:
        {
            if(detailController3==nil){                
                
                detailController3 =  [[JMStaticContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];              
                [detailController3 addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
                    
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
                    SimplePickerInputTableViewCell *availScoreRefCountCell= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Avail Score Via Referee", @"Avail Score Via Referee") selectValue:[NSString stringWithFormat:@"%i/%i",si.availScoreWithJudesCount,si.judgeCount] dataSource:availRefCounts];   
                    availScoreRefCountCell.tag=kavailScoreWithJudesCount;
                    availScoreRefCountCell.delegate=selfCtl;
                    [section addCustomerCell:availScoreRefCountCell]; 
                    
                    NSMutableArray *bufferSecCounts=[[NSMutableArray alloc] init];
                    for(float i=0.5;i<=2;i=i+0.1)
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
                    for(int i=si.startScreening;i<=(si.roundCount-1)*si.skipScreening+si.startScreening;i=i+si.skipScreening)
                    {
                        [pointGapEffCounts addObject:[NSString stringWithFormat:@"%i",i]];
                    }
                    SimplePickerInputTableViewCell *pointGapEffCell= [[SimplePickerInputTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil title: NSLocalizedString(@"Point Gap Effect Round", @"Point Gap Effect Round") selectValue:[NSString stringWithFormat:@"%i",si.pointGapAvailRound] dataSource:pointGapEffCounts];    
                    pointGapEffCell.tag=kpointGapAvailRound;
                    pointGapEffCell.delegate=selfCtl;
                    [section addCustomerCell:pointGapEffCell];                     
                    
                }]; 
            }
            [self setSettingTable:detailController3];
            break;
        }
        case 4:
        {
            if(detailController4==nil){
                detailController4 =  [[JMStaticContentTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
                [detailController4 addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
                    StringInputTableViewCell *serverNameCell= [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Server Name" andTitle:NSLocalizedString(@"Server Name", @"Server Name") andText:si.serverName];   
                    serverNameCell.tag=kserverName;
                    serverNameCell.delegate=selfCtl;
                    [section addCustomerCell:serverNameCell];
                    
                    StringInputTableViewCell *joinPwdCell= [[StringInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Join Password" andTitle:NSLocalizedString(@"Join Password", @"Join Password") andText:si.password];   
                    joinPwdCell.tag=kpassword;
                    joinPwdCell.textField.secureTextEntry=YES;
                    joinPwdCell.delegate=selfCtl;
                    [section addCustomerCell:joinPwdCell];
                    
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
            [self setSettingTable:detailController4];
            break;
        }
        default:
            break;
    }    
}
-(void)setSettingTable:(UIViewController *) control
{
    NSArray *array=[[NSArray alloc] initWithObjects:detailController0,detailController1,detailController2,detailController3,detailController4, nil];
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
    ServerSetting *si=[AppConfig getInstance].serverSettingInfo;
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
                    si.availScoreWithJudesCount=[cell.value intValue];
                }               
            }
        }
            break;
        case kavailScoreWithJudesCount:
            si.availScoreWithJudesCount=[value intValue];
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
        default:
            break;
    }        
}
-(void)tableViewCell:(IntegerInputTableViewCell *)cell didEndEditingWithInteger:(NSUInteger)value
{
    ServerSetting *si=[AppConfig getInstance].serverSettingInfo;
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
    ServerSetting *si=[AppConfig getInstance].serverSettingInfo;
    SimplePickerInputTableViewCell *cellGapEff=[self getTableCellByTag:kpointGapAvailRound];
    NSMutableArray *pointGapEffCounts=[[NSMutableArray alloc] init];
    for(int i=si.startScreening;i<=(si.roundCount-1)*si.skipScreening+si.startScreening;i=i+si.skipScreening)
    {
        [pointGapEffCounts addObject:[NSString stringWithFormat:@"%i",i]];
    }
    [cellGapEff reloadPicker:pointGapEffCounts];
    si.pointGapAvailRound=[cellGapEff.value intValue];
}
-(void)refreshSkipRound{
    ServerSetting *si=[AppConfig getInstance].serverSettingInfo;
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
    ServerSetting *si=[AppConfig getInstance].serverSettingInfo;
    switch (cell.tag) {
        case kroundTime:
            si.roundTime=value;
            break;   
    }
}
- (void)valueChanged:(UISwitch *)theSwitch {
    [AppConfig getInstance].serverSettingInfo.enableGapScore=theSwitch.isOn;
}    

- (void)tableViewCell:(StringInputTableViewCell *)cell didEndEditingWithString:(NSString *)value{
    ServerSetting *si=[AppConfig getInstance].serverSettingInfo;
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
        default:
            break;
    }
}

-(void) clearHistory
{
}

-(void)resetSetting
{
    detailController0=nil;
    detailController1=nil;
    detailController2=nil;
    detailController3=nil;
    detailController4=nil;
    [[AppConfig getInstance].serverSettingInfo reset];
    [self bindSettingGroupData:0];
    [self bindSettingGroupData:1];
    [self bindSettingGroupData:2];
    [self bindSettingGroupData:3];  
    [self bindSettingGroupData:4]; 
    [UIHelper showAlert:@"Information" message:@"Settings have beend reseted." func:nil];
}
-(id)getTableCellByTag:(NSInteger)tag
{    
    NSArray *ctls=[[NSArray alloc] initWithObjects:detailController0,detailController1,detailController2,detailController3,detailController4, nil];
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
@end
