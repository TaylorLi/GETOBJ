//
//  ScoreBoardViewController.m
//  Chatty
//
//  Created by Eagle Du on 12/6/30.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "ScoreBoardViewController.h"
#import "ChattyAppDelegate.h"
#import "AppConfig.h"
#import "UITextView+Utils.h"
#import "ServerSetting.h"
#import "GameInfo.h"
#import "JudgeClientInfo.h"
#import "UIHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "DuringMatchSettingDetailControllerHD.h"
#import "ShowWinnerBox.h"
#import "SelectWinnerBox.h"

#define  kMenuItemMenu 0
#define  kMenuItemExit 1
#define  kMenuItemContinueGame 2
#define  kMenuItemWarmningBlue 3
#define  kMenuItemWarmningRed 4
#define kMenuItemNextMatch 5

@interface ScoreBoardViewController ()

-(void)updatTime;
-(void)prepareForGame;
-(void)startRound:(id)sender;
-(void)contiueGame;
-(void)pauseGame;
-(void)resetRound:(BOOL)init;
-(void)setupMenu;
- (void)menuItemAction:(id)sender;
-(void)gameLoop;
-(BOOL)testSomeClientDisconnect;
-(void)sendServerInfo;
-(void)pauseTime:(BOOL) stop;
-(void)testIfScoreCanSubmit;
-(void)submitScore:(int)score andIsRedSize:(BOOL)isRedSide;
-(void)showRoundRestTimeBox:(NSTimeInterval) time andEventType:(NSInteger)eventType;
-(void)resetTimeEnd:(id)sender;
-(void)warmningPlayer:(Boolean) isForRedSide andCount:(NSInteger) count;
-(void)warmningAddToBluePlayer;
-(void)warmningAddToRedPlayer;
-(void)warmningMinusToBluePlayer;
-(void)warmningMinusToRedPlayer;
-(void)drawWarmningFlagForRed:(Boolean)isForRedSide;
-(void)setMenuByGameStatus:(GameStates)status;
-(UIButton *)getMenuItem:(int)tag;
-(void)processByGameStatus;
-(void) stopRoom;
-(void)gamePauseContinueToggle;
-(void)gamePauseAndShowResetTimeBox;
-(void)blueAddScore;
-(void)blueMinusScore;
-(void)redAddScore;
-(void)redMinusScore;
-(void)showGameSettingDialog:(UIGestureRecognizer *)recognizer;
-(void)refreshGamesettingDialogJudges;
-(void)drawRect:(CGRect)rect;
-(void)drawWarmningFlag;
-(BOOL)testPointGapReached;
-(void)showSelectWinnerBox;
-(void)showWinnerBoxForRedSide:(BOOL)isRedSide;
-(void)selectedWinnerEnd:(id)data;
-(void)showWinnerEndAndNextRound:(id)data;
-(void)drawLayoutByGameInfo;
@end 

@implementation ScoreBoardViewController

@synthesize lblCoachName;
@synthesize lblGameName;
@synthesize txtHistory;
@synthesize chatRoom;
@synthesize lblGameDesc;
@synthesize lblBluePlayerName;
@synthesize lblBluePlayerDesc;
@synthesize lblTime;
@synthesize lblRoundSeq;
@synthesize lblRedPlayerDesc;
@synthesize lblRedPlayerName;
@synthesize lblBlueTotal;
@synthesize lblRedTotal;
@synthesize actionHeaderView;
@synthesize lblScreening;
@synthesize viewRedWarmningBox;
@synthesize viewBlueWarmningBox;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */
- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext(); //获取上下文 
    CGFloat dash[] = {4.0, 4.0};//第一个是8.0是实线的长度，第2个8.0是空格的长度
    CGContextSetLineDash(ctx, 0.0, dash, 2);//给虚线设置下类型，其中2是dash数组大小，如果想设置个性化的虚线 可以将dash数组扩展下即可
    CGContextSetLineWidth(ctx, 1.0f); //设置线的宽度 为1个像素
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0].CGColor); //设置线的颜色为灰色
    CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y); //设置线的起始点
    CGContextAddLineToPoint(ctx,rect.origin.x+rect.size.width,rect.origin.y); //设置线中间的一个点 
    CGContextStrokePath(ctx);//直接把所有的点连起来
    
    CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y); //设置线的起始点
    CGContextAddLineToPoint(ctx,rect.origin.x,rect.origin.y+rect.size.height); //设置线中间的一个点
    CGContextStrokePath(ctx);//直接把所有的点连起来
    
    CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y+rect.size.height); //设置线的起始点
    CGContextAddLineToPoint(ctx,rect.origin.x+rect.size.width,rect.origin.y+rect.size.height); //设置线中间的一个点 
    CGContextStrokePath(ctx);//直接把所有的点连起来
    CGContextMoveToPoint(ctx, rect.origin.x+rect.size.width, rect.origin.y); //设置线的起始点
    CGContextAddLineToPoint(ctx,rect.origin.x+rect.size.width,rect.origin.y+rect.size.height); //设置线中间的一个点
    CGContextStrokePath(ctx);//直接把所有的点连起来
    
    CGContextSetLineDash(ctx, 0.0, NULL, 0); //要画其他的线的话记得清理一下
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewBlueWarmningBox.layer.borderColor = [UIColor colorWithRed:255/255 green:0/255 blue:0/255 alpha:0.8].CGColor;
    self.viewBlueWarmningBox.layer.borderWidth = 1.0f;
    self.viewRedWarmningBox.layer.borderColor = [UIColor colorWithRed:255/255 green:0/255 blue:0/255 alpha:0.8].CGColor;
    self.viewRedWarmningBox.layer.borderWidth = 1.0f;    
    //    [self drawRect:self.viewBlueWarmningBox.frame];
    //    [self drawRect:self.viewRedWarmningBox.frame];
    
    /*recognizer*/
    /*顶部向下滑动,显示设置面板*/
    UISwipeGestureRecognizer *viewSwapDownRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showGameSettingDialog:)];
    viewSwapDownRecg.numberOfTouchesRequired=1;
    viewSwapDownRecg.direction= UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:viewSwapDownRecg];
    
    /*双击时间控件,继续或者暂停*/
    UITapGestureRecognizer *startStopGame=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gamePauseContinueToggle)];
    startStopGame.numberOfTapsRequired=2;
    startStopGame.numberOfTouchesRequired=1;
    self.lblTime.userInteractionEnabled=YES;
    [self.lblTime addGestureRecognizer:startStopGame];
    
    /*向上滑动时间控件,暂停比赛并显示休息时间*/
    UISwipeGestureRecognizer *pauseGameAndShowResetBox=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gamePauseAndShowResetTimeBox)];
    pauseGameAndShowResetBox.numberOfTouchesRequired=1;
    pauseGameAndShowResetBox.direction= UISwipeGestureRecognizerDirectionUp;
    [self.lblTime addGestureRecognizer:pauseGameAndShowResetBox];
    
    /*向上滑动分数控件,直接加1分*/
    UISwipeGestureRecognizer *blueAddRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(blueAddScore)];
    blueAddRecg.numberOfTouchesRequired=1;
    blueAddRecg.direction= UISwipeGestureRecognizerDirectionUp;
    self.lblBlueTotal.userInteractionEnabled=YES;
    [self.lblBlueTotal addGestureRecognizer:blueAddRecg];
    
    /*向上滑动分数控件,直接减1分*/
    UISwipeGestureRecognizer *blueMinusRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(blueMinusScore)];
    blueMinusRecg.numberOfTouchesRequired=1;
    blueMinusRecg.direction= UISwipeGestureRecognizerDirectionDown;
    self.lblBlueTotal.userInteractionEnabled=YES;
    [self.lblBlueTotal addGestureRecognizer:blueMinusRecg];
    
    UISwipeGestureRecognizer *redAddRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(redAddScore)];
    redAddRecg.numberOfTouchesRequired=1;
    redAddRecg.direction= UISwipeGestureRecognizerDirectionUp;
    self.lblRedTotal.userInteractionEnabled=YES;
    [self.lblRedTotal addGestureRecognizer:redAddRecg];
    
    UISwipeGestureRecognizer *redMinusRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(redMinusScore)];
    redMinusRecg.numberOfTouchesRequired=1;
    redMinusRecg.direction= UISwipeGestureRecognizerDirectionDown;
    self.lblRedTotal.userInteractionEnabled=YES;
    [self.lblRedTotal addGestureRecognizer:redMinusRecg];
    
    /*在警告控件向左拖拉,累積警告分數加一次*/
    UISwipeGestureRecognizer *blueWarmningAddRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(warmningAddToBluePlayer)];
    blueWarmningAddRecg.numberOfTouchesRequired=1;
    blueWarmningAddRecg.direction= UISwipeGestureRecognizerDirectionLeft;
    [self.viewBlueWarmningBox addGestureRecognizer:blueWarmningAddRecg];
    
    /*在警告控件向右拖拉,累積警告分數减一次*/
    UISwipeGestureRecognizer *blueWarmningMinusRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(warmningMinusToBluePlayer)];
    blueWarmningMinusRecg.numberOfTouchesRequired=1;
    blueWarmningMinusRecg.direction= UISwipeGestureRecognizerDirectionRight;
    [self.viewBlueWarmningBox addGestureRecognizer:blueWarmningMinusRecg];
    
    
    /*在警告控件向右拖拉,累積警告分數加一次*/
    UISwipeGestureRecognizer *redWarmningAddRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(warmningAddToRedPlayer)];
    redWarmningAddRecg.numberOfTouchesRequired=1;
    redWarmningAddRecg.direction= UISwipeGestureRecognizerDirectionRight;
    [self.viewRedWarmningBox addGestureRecognizer:redWarmningAddRecg];
    
    /*在警告控件向左拖拉,累積警告分數减一次*/
    UISwipeGestureRecognizer *redWarmningMinusRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(warmningMinusToRedPlayer)];
    redWarmningMinusRecg.numberOfTouchesRequired=1;
    redWarmningMinusRecg.direction= UISwipeGestureRecognizerDirectionLeft;
    [self.viewRedWarmningBox addGestureRecognizer:redWarmningMinusRecg];
}

- (void)viewDidUnload
{
    if(gameLoopTimer!=nil)
    {
        [gameLoopTimer invalidate];
        gameLoopTimer=nil;
    }
    [self setLblGameDesc:nil];
    [self setLblBluePlayerName:nil];
    [self setLblBluePlayerDesc:nil];
    [self setLblTime:nil];
    [self setLblRoundSeq:nil];
    [self setLblRedPlayerDesc:nil];
    [self setLblRedPlayerName:nil];
    [self setLblScreening:nil];
    [self setViewRedWarmningBox:nil];
    [self setViewBlueWarmningBox:nil];
    [super viewDidUnload];    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [AppConfig shouldAutorotateToInterfaceOrientationLandscape:interfaceOrientation];
}

- (void)dealloc {
    waitUserPanel=nil;
    cmdHis=nil;
    timer=nil;
    if(gameLoopTimer!=nil)
    {
        [gameLoopTimer invalidate];
        gameLoopTimer=nil;
    }
}

- (void)activate {
    [self prepareForGame];
    //[self showRoundRestTimeBox:1 andEventType:1];
}

-(void)drawWarmningFlag
{
    [self drawWarmningFlagForRed:YES];
    [self drawWarmningFlagForRed:NO];
}
//warming,when 2 warmning to be a Deduction(score -1)
-(void)warmningPlayer:(Boolean) isForRedSide andCount:(NSInteger)count{
    if(isForRedSide){
        if(chatRoom.gameInfo.redSideWarmning+count<0)
            return;
        else if(chatRoom.gameInfo.redSideWarmning+count>chatRoom.gameInfo.gameSetting.maxWarmningCount){
            return;
        }
        else{
            chatRoom.gameInfo.redSideWarmning+=count;
            //合计2次警告自动加对方1分
            if(count>0 && chatRoom.gameInfo.redSideWarmning%2==0){
                [self submitScore:1 andIsRedSize:NO];
            }            
            [self drawWarmningFlagForRed:YES];
        }
    }
    else{
        if(chatRoom.gameInfo.blueSideWarmning+count<0)
            return;
        else if(chatRoom.gameInfo.blueSideWarmning+count>chatRoom.gameInfo.gameSetting.maxWarmningCount){
            return;
        }
        else{
            chatRoom.gameInfo.blueSideWarmning+=count;
            if(count>0 && chatRoom.gameInfo.blueSideWarmning%2==0){
                [self submitScore:1 andIsRedSize:YES];
            }
            [self drawWarmningFlagForRed:NO];
        }    
    }
}

-(void)warmningAddToBluePlayer{
    [self warmningPlayer:NO andCount:1];
}
-(void)warmningAddToRedPlayer{
    [self warmningPlayer:YES andCount:1];
}
-(void)warmningMinusToBluePlayer{
    [self warmningPlayer:NO andCount:-1];
}
-(void)warmningMinusToRedPlayer{
    [self warmningPlayer:YES andCount:-1];
}
-(void)drawWarmningFlagForRed:(Boolean)isForRedSide{
    BOOL isBlue=!isForRedSide;
    UIView *view=isBlue?viewBlueWarmningBox:viewRedWarmningBox;
    int warmningCount=isBlue?chatRoom.gameInfo.blueSideWarmning:chatRoom.gameInfo.redSideWarmning;
    int maxWarmingCount=chatRoom.gameInfo.gameSetting.maxWarmningCount;
    view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y,20+(40+20)*maxWarmingCount/2+20, view.frame.size.height);
    for (UIView *subView in view.subviews) {
        [subView removeFromSuperview];
    }
    int deducateCount=warmningCount/2;
    BOOL hasWarmning=warmningCount%2;
    float initX=isBlue?view.frame.size.width-20-40 : 20;
    for (int i=0; i<deducateCount; i++) {        
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(initX, 10, 40, 40)];
        initX = isBlue?(initX-(40+20)):(initX+(40+20));
        lbl.backgroundColor=[UIColor yellowColor];
        [view addSubview:lbl];
    }
    if (hasWarmning) {
        UILabel *lbl=[[UILabel alloc] initWithFrame:CGRectMake(initX, 10, 40, 40)];
        lbl.backgroundColor=[UIColor greenColor];
        [view addSubview:lbl];
    }
    
}

#pragma mark -
#pragma mark time hander
//when game going on,we need to refresh time 
-(void)updatTime { 
    chatRoom.gameInfo.currentRemainTime--;
	int min = chatRoom.gameInfo.currentRemainTime/60;
    int sec=fmod(chatRoom.gameInfo.currentRemainTime,60);
	lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    if(chatRoom.gameInfo.currentRemainTime==0){
        [self pauseTime:YES];
        if(chatRoom.gameInfo.currentRound>=(chatRoom.gameInfo.gameSetting.roundCount-1)*chatRoom.gameInfo.gameSetting.skipScreening+chatRoom.gameInfo.gameSetting.startScreening){
            [self setMenuByGameStatus:kStateGamePause]; 
            [self showSelectWinnerBox];
            //[UIHelper showAlert:@"Information" message:@"The match has completed." func:nil];
        }else{    
            [self setMenuByGameStatus:kStateRoundReset];              
            [self showRoundRestTimeBox:chatRoom.gameInfo.gameSetting.restTime andEventType:krestTime];
        }
    }    
} 
//show round rest when round end
-(void)showRoundRestTimeBox:(NSTimeInterval) time andEventType:(NSInteger)eventType{
    if(roundResetPanel==nil)
    {
        roundResetPanel=nil;
    }
        CGRect frame=self.view.bounds;
        roundResetPanel = [[RoundRestTimeViewController alloc] initWithFrame:frame title:(eventType==krestAndReOrgTime?@"Rest for Reorganization":@"Rest Time") andRestTime:time];
    roundResetPanel.relatedData=[[NSNumber alloc] initWithInt:eventType];
    roundResetPanel.closeButton.hidden=eventType==krestTime;
    __weak ScoreBoardViewController *_me=self;
    __weak RoundRestTimeViewController *_resetPanel=roundResetPanel;
        roundResetPanel.onClosePressed = ^(UAModalPanel* panel) {
            [_resetPanel hide];
            [_me resetTimeEnd:_resetPanel.relatedData];
            //UADebugLog(@"onClosePressed block called from panel: %@", modalPanel);
        };
        roundResetPanel.delegate=self;
    if (roundResetPanel!=nil) {
        if(![self.view.subviews containsObject:roundResetPanel])
        {
            ///////////////////////////////////
            // Add the panel to our view
            [self.view addSubview:roundResetPanel];	
            //[roundResetPanel showFromPoint:[self.view center]];
            ///////////////////////////////////
            // Show the panel from the center of the button that was pressed
        }
    }    
}

#pragma mark -
#pragma mark score
-(void)submitScore:(int)score andIsRedSize:(BOOL)isRedSide;
{    
    if(isRedSide){
        if(chatRoom.gameInfo.redSideScore+score<0)
            return;
        chatRoom.gameInfo.redSideScore+=score;
        lblRedTotal.text=[NSString stringWithFormat:@"%i",chatRoom.gameInfo.redSideScore];           
    }else{
        if(chatRoom.gameInfo.blueSideScore+score<0)
            return;
        chatRoom.gameInfo.blueSideScore+=score;
        lblBlueTotal.text=[NSString stringWithFormat:@"%i",chatRoom.gameInfo.blueSideScore];
    }
    //修改
//    cmdHis = nil;
    //修改完
    if(![self testPointGapReached])
        [self setMenuByGameStatus:kStateRunning];
}
//add score to blue side
-(void)blueAddScore{
    [self submitScore:1 andIsRedSize:NO];
}
-(void)blueMinusScore{
    [self submitScore:-1 andIsRedSize:NO];
}
-(void)redAddScore{
    [self submitScore:1 andIsRedSize:YES];
}
-(void)redMinusScore{
    [self submitScore:-1 andIsRedSize:YES];
}
/*
 所有裁判提交的分数必须相同,并且提交时间在1s之内,否则无效
 */
-(void)testIfScoreCanSubmit
{    
    if(!(chatRoom.gameInfo.gameStatus==kStateRunning||chatRoom.gameInfo.gameStatus==kStateCalcScore))
        {
            return;
        }
    if(cmdHis==nil)
        return;
    NSLog(@"Cmd his count:%i,client cout:%i",cmdHis.count,chatRoom.gameInfo.clients.count);
    int score=0;
    BOOL timeout=NO;
    NSDate *minTime=nil;
    for (CommandMsg *cmd in cmdHis) {
        if(minTime==nil)
        {
            minTime=cmd.date;
            continue;
        }
        else{
            if (cmd.date<minTime) {
                minTime=cmd.date;
            }
        }
        
    }
    double elaspedTime=chatRoom.gameInfo.gameSetting.availTimeDuringScoreCalc;
    //timeout now
    NSLog(@"%f",fabs([minTime timeIntervalSinceNow]));
    if(fabs([minTime timeIntervalSinceNow]) >= elaspedTime){
        timeout=YES;
    }
    if(timeout){
        [self setMenuByGameStatus:kStateRunning];
        cmdHis = nil;
        return;
    }
    
    NSMutableArray *scores=[[NSMutableArray alloc] initWithCapacity:cmdHis.count];
    NSMutableArray *uuids=[[NSMutableArray alloc] initWithCapacity:cmdHis.count];
    CommandMsg *firstCmd=[cmdHis objectAtIndex:0];
    [scores addObject:firstCmd.data];
    score=[[firstCmd data] intValue];
    NSString *side=firstCmd.desc;
    if(cmdHis.count>chatRoom.gameInfo.clients.count)
    {
        [self setMenuByGameStatus:kStateRunning];
        cmdHis = nil;
        return;
    }
    else if(cmdHis.count==chatRoom.gameInfo.clients.count){
        for (CommandMsg *cmd in cmdHis) {
            if(![cmd.desc isEqualToString:side])//not the same side,cancel
            {
                [self setMenuByGameStatus:kStateRunning];
                cmdHis = nil;
                return;
            }
            if([scores containsObject:cmd.data]){//score
                
            }
            else{
                [self setMenuByGameStatus:kStateRunning];
                cmdHis = nil;
                return; //not same score
            }
            if([uuids containsObject:cmd.from]){//uuid
                [self setMenuByGameStatus:kStateRunning];
                cmdHis = nil;
                return;
            }
            else
                [uuids addObject:cmd.from];
        }
        for (NSString *cltUuid in chatRoom.gameInfo.clients.allKeys) {
            if(![uuids containsObject:cltUuid]){
                return;//wait for next test
            }
        }
        
        [self submitScore:score andIsRedSize:[side isEqualToString:kSideRed]];
        
    } 
}

-(BOOL)testPointGapReached;
{
    if(chatRoom.gameInfo.gameSetting.enableGapScore&&chatRoom.gameInfo.currentRound>=chatRoom.gameInfo.gameSetting.pointGapAvailRound){
        if(fabs(chatRoom.gameInfo.redSideScore-chatRoom.gameInfo.blueSideScore)>=chatRoom.gameInfo.gameSetting.pointGap)
        {            
            [self pauseTime:YES];
            [self setMenuByGameStatus:kStateGamePause];
            [self showSelectWinnerBox];
            return YES;
        }
    }
    return NO;
}
#pragma mark -
#pragma mark cmd handler
// We are being asked to process cmd
- (void)processCmd:(CommandMsg *)cmdMsg {
    
    switch ([cmdMsg.type intValue]) {
        case NETWORK_REPORT_SCORE:
        {
            //NSLog(@"msg date:%f",[cmdMsg.date timeIntervalSince1970]);
            //NSLog(@"receive date:%f",[[NSDate date] timeIntervalSince1970]);
            //NSLog(@"%f",[cmdMsg.date timeIntervalSince1970]-[[NSDate date] timeIntervalSince1970]);
            if(chatRoom.gameInfo.gameStatus==kStateRunning||chatRoom.gameInfo.gameStatus==kStateCalcScore)
            {
                [self setMenuByGameStatus:kStateCalcScore];
                cmdMsg.date=[NSDate date];
                if(cmdHis==nil){
                    cmdHis = [[NSMutableArray alloc] initWithObjects:cmdMsg, nil];
                }
                else{
                    [cmdHis addObject:cmdMsg];
                }
                //test if all judges have sent score
                [self testIfScoreCanSubmit];
            }            
        }
            break;
        case  NETWORK_CLIENT_INFO:
        { 
            JudgeClientInfo *cltInfo =[[JudgeClientInfo alloc] initWithDictionary:   cmdMsg.data];
            JudgeClientInfo *cltInfoOld=[chatRoom.gameInfo.clients objectForKey:cltInfo.uuid];
            if(cltInfoOld==nil)
            {//new client connected
                cltInfo.hasConnected=YES;
                cltInfo.lastHeartbeatDate=[NSDate date];
                [chatRoom.gameInfo.clients setObject:cltInfo forKey:cltInfo.uuid];
                [self showWaitingUserBox];//no all has enter the game
            }
            else
            {
                cltInfoOld.lastHeartbeatDate=[NSDate date];
                if(!cltInfoOld.hasConnected){                    
                    cltInfoOld.hasConnected=YES;
                    if(chatRoom.gameInfo.gameStatus==kStateWaitJudge){
                        //wait for judge
                        [self showWaitingUserBox];
                    }
                    else if([self testSomeClientDisconnect]){
                        //still some one disconnect
                        [self setMenuByGameStatus:kStateMultiplayerReconnect];
                        [self showWaitingUserBox];
                    }
                    else{
                        //every one back to game
                        chatRoom.gameInfo.gameStatus=chatRoom.gameInfo.preGameStatus;
                        if(chatRoom.gameInfo.gameStatus==kStateRunning)
                            [self contiueGame];
                        else
                        {
                            if(waitUserPanel!=nil&&[self.view.subviews containsObject:waitUserPanel]){
                                [waitUserPanel removeFromSuperview];
                                waitUserPanel=nil;
                            }
                            if(chatRoom.gameInfo.gameStatus==kStateRoundReset)
                            {
                                [roundResetPanel setTimerStop:NO];
                            }
                        }
                    }
                    
                }                       
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark RoomDelegate
// Room closed from outside
- (void)roomTerminated:(id)room reason:(NSString*)reason {
    // Explain what happened
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Server terminated" message:reason delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    [self exit];
}
//we not care this delegate
-(void) alreadyConnectToServer
{
    
}
//we not care this delegate
-(void) failureToConnectToServer
{
    
}

// User decided to exit room
- (IBAction)exit {
    // Close the room
    [self setMenuByGameStatus:kStateGameExit];
    [self sendServerInfo];
    [[AppConfig getInstance].invalidServerPeerIds addObject:chatRoom.bluetoothServer.serverSession.peerID];
    
    // Remove keyboard
    
    // Erase chat
    [self eraseText];
    lblBlueTotal.text=@"0";
    lblRedTotal.text=@"0";
    lblGameName.text=@"";
    // Switch back to welcome view
    if(timer!=nil)
    {
        [timer invalidate];
        timer=nil;
    }
    if(gameLoopTimer!=nil)
    {
        [gameLoopTimer invalidate];
        gameLoopTimer=nil;
    }
    waitUserPanel=nil;
    [roundResetPanel removeFromSuperview];
    roundResetPanel=nil;
    [self.actionHeaderView removeFromSuperview];
    self.actionHeaderView=nil;
    //send last message
    chatRoom.gameInfo=nil;
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(stopRoom) userInfo:nil repeats:NO];
}
//stop peer server
-(void)stopRoom
{
    [chatRoom stop];
    [[ChattyAppDelegate getInstance] showRoomSelection];
}

//erase warmning flags
- (void)eraseText {
  
}
//show waiting for user
-(void)showWaitingUserBox
{
    [self pauseTime:YES];
    if(waitUserPanel==nil)
    {
        __block typeof (self) me = self;
        waitUserPanel = [[UIWaitForUserViewController alloc] initWithFrame:self.view.bounds title:@"Connecting Judge"];
        waitUserPanel.needConnectedClientCount=chatRoom.gameInfo.needClientsCount;
        waitUserPanel.onClosePressed = ^(UAModalPanel* panel) {
            // [panel hide];
            UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"End Game" message:@"Continue to end the game?" delegate:me cancelButtonTitle:@"Cancel" otherButtonTitles:@"End", nil];
            [alertView show];            
            UADebugLog(@"onClosePressed block called from panel: %@", modalPanel);
        };
        waitUserPanel.delegate=self;
    }
    if (waitUserPanel!=nil) {
        if(![self.view.subviews containsObject:waitUserPanel])
        {
            ///////////////////////////////////
            // Add the panel to our view
            [self.view addSubview:waitUserPanel];	
            [waitUserPanel showFromPoint:[self.view center]];
            ///////////////////////////////////
            // Show the panel from the center of the button that was pressed
        }
        [waitUserPanel updateStatus:chatRoom.gameInfo.clients];
    }    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        if(waitUserPanel!=nil){
            [waitUserPanel hideWithOnComplete:^(BOOL finished) {
                
                [waitUserPanel removeFromSuperview];
                [self exit];
            }];                    
        }else{
            [self exit];
        }
    }
}
//prepare for game to start
-(void)prepareForGame
{
    [self setMenuByGameStatus:kStatePrepareGame];
    if (chatRoom != nil ) {
        chatRoom.delegate = self;
        [chatRoom start];
    }
    [self resetRound:YES];    
    [self setupMenu];
    [self setMenuByGameStatus:kStateWaitJudge];
    [self showWaitingUserBox];
    double inv=kHeartbeatTimeInterval;
    gameLoopTimer=[NSTimer scheduledTimerWithTimeInterval:inv target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}
-(void)drawLayoutByGameInfo{
    lblGameName.text=[NSString stringWithFormat:@"%@",chatRoom.gameInfo.gameSetting.gameName];
    lblGameDesc.text=chatRoom.gameInfo.gameSetting.gameDesc;
    lblRedPlayerName.text=chatRoom.gameInfo.gameSetting.redSideName;
    lblRedPlayerDesc.text=chatRoom.gameInfo.gameSetting.redSideDesc;
    lblBluePlayerDesc.text=chatRoom.gameInfo.gameSetting.blueSideDesc;
    lblBluePlayerName.text=chatRoom.gameInfo.gameSetting.blueSideName;
    lblScreening.text=chatRoom.gameInfo.gameSetting.screeningArea;
    lblRedTotal.text=[NSString stringWithFormat:@"%i",chatRoom.gameInfo.redSideScore];
    lblBlueTotal.text=[NSString stringWithFormat:@"%i",chatRoom.gameInfo.blueSideScore];
    lblRoundSeq.text=[NSString stringWithFormat:@"Round %i", chatRoom.gameInfo.currentRound];
    int min = chatRoom.gameInfo.currentRemainTime/60;
    int sec=(int)chatRoom.gameInfo.currentRemainTime%60;
    lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec]; 
    [self drawWarmningFlag];
}
//set up bottom menu
-(void)setupMenu
{
    self.actionHeaderView = [[DDActionHeaderView alloc] initWithFrame:self.view.bounds];
	
    // Set title
    self.actionHeaderView.titleLabel.text = @"";
	
    // Create action items, have to be UIView subclass, and set frame position by yourself.
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    menuButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    menuButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    menuButton.center = CGPointMake(25.0f, 25.0f);
    menuButton.tag=kMenuItemMenu;
    
    UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [continueButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [continueButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    continueButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    continueButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    continueButton.center = CGPointMake(75.0f, 25.0f);
    continueButton.tag=kMenuItemContinueGame;
    
    // Create action items, have to be UIView subclass, and set frame position by yourself.
    UIButton *redWarmningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redWarmningButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [redWarmningButton setImage:[UIImage imageNamed:@"minus-red"] forState:UIControlStateNormal];
    redWarmningButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    redWarmningButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    redWarmningButton.center = CGPointMake(125.0f, 25.0f);
    redWarmningButton.tag=kMenuItemWarmningRed;
    
    UIButton *blueWarmningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [blueWarmningButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [blueWarmningButton setImage:[UIImage imageNamed:@"minus-blue"] forState:UIControlStateNormal];
    blueWarmningButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    blueWarmningButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    blueWarmningButton.center = CGPointMake(175.0f, 25.0f);
    blueWarmningButton.tag=kMenuItemWarmningBlue;
    
    UIButton *nextMatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextMatchButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [nextMatchButton setImage:[UIImage imageNamed:@"next-match"] forState:UIControlStateNormal];
    nextMatchButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    nextMatchButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    nextMatchButton.center = CGPointMake(225.0f, 25.0f);
	nextMatchButton.tag=kMenuItemNextMatch;
    
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [exitButton setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
    exitButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    exitButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    exitButton.center = CGPointMake(275.0f, 25.0f);
	exitButton.tag=kMenuItemExit;
    // Set action items, and previous items will be removed from action picker if there is any.
    self.actionHeaderView.items = [NSArray arrayWithObjects:menuButton, continueButton,redWarmningButton,blueWarmningButton,nextMatchButton, exitButton, nil];	
	
    [self.view addSubview:self.actionHeaderView];
}
- (void)menuItemAction:(id)sender;{
    
    // Reset action picker
    int tag=[(UIButton *)sender tag];
    switch (tag) {
        case kMenuItemMenu:
            [self.actionHeaderView shrinkActionPicker];
            break;
        case kMenuItemExit:
        {
            UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"End Game" message:@"Continue to end the game?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"End", nil];
            [alertView show];
        }
            break;
        case kMenuItemContinueGame:
            if(chatRoom.gameInfo.gameStatus==kStateGamePause)
            {
                [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
                [self contiueGame];
            }
            else{
                [self pauseGame];
                [sender setImage:[UIImage imageNamed:@"continue"] forState:UIControlStateNormal];
            }
            break;
        case  kMenuItemNextMatch:
            [self goToNextMatch];
            break;
        case  kMenuItemWarmningBlue:
            [self warmningPlayer:NO andCount:1];
            break;
        case  kMenuItemWarmningRed:
            [self warmningPlayer:YES andCount:1];
            break;
        default:
            break;
    }
    self.actionHeaderView.hidden=YES;
    //[self.actionHeaderView shrinkActionPicker];
}

//start round
-(void)startRound:(id)sender
{
    if([self testPointGapReached]){
        return;
    }
    waitUserPanel=nil;
    if(timer==nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatTime) userInfo:nil repeats:YES];
    } 
    [self setMenuByGameStatus:kStateRunning];
    
}
-(void)contiueGame
{
    if(waitUserPanel!=nil&&[self.view.subviews containsObject:waitUserPanel]){
        [waitUserPanel removeFromSuperview];
        waitUserPanel=nil;
    }
    [self pauseTime:NO];
    [self setMenuByGameStatus:kStateRunning];
}
-(void)resetTimeEnd:(id)sender{
    NSNumber *eventData=sender;
    NSInteger eventType=[eventData intValue];
    roundResetPanel=nil;
    switch (eventType) {
        case krestTime:
            {                
                [self resetRound:NO];
                [self startRound:nil];
            }
            break;
            case krestAndReOrgTime:
            {
                [self contiueGame];
            }
            break;
        default:
            break;
    }
}
-(void)pauseTime:(BOOL) stop;
{
    if(stop){
        if(timer!=nil){
            [timer invalidate];
            timer=nil;
        }
    }
    else{
        if (timer==nil) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatTime) userInfo:nil repeats:YES];            
        }
    }
}
-(void)pauseGame
{
    [self pauseTime:YES];
    [self setMenuByGameStatus:kStateGamePause];
}
//toggle game status to pause or continue
-(void)gamePauseContinueToggle{
    if(chatRoom.gameInfo.gameStatus== kStateGamePause){
        [self contiueGame];
    }
    else if(chatRoom.gameInfo.gameStatus==kStateRunning){
        [self pauseGame];
    }
}
//pause game and show resetime box
-(void)gamePauseAndShowResetTimeBox
{
    if (chatRoom.gameInfo.gameStatus==kStateRunning || chatRoom.gameInfo.gameStatus==kStateCalcScore) {
        [self pauseTime:YES];        
        [self setMenuByGameStatus:kStateGamePause];
        [self showRoundRestTimeBox:chatRoom.gameInfo.gameSetting.restAndReorganizationTime andEventType:krestAndReOrgTime];
    }
}
//重置回合信息
-(void)resetRound:(BOOL)init;
{
    chatRoom.gameInfo.currentRemainTime=chatRoom.gameInfo.gameSetting.roundTime;
    //chatRoom.gameInfo.redSideScore=0;
    //chatRoom.gameInfo.blueSideScore=0;
    if(init)
        chatRoom.gameInfo.currentRound=chatRoom.gameInfo.gameSetting.startScreening;
    else
        chatRoom.gameInfo.currentRound=chatRoom.gameInfo.currentRound+chatRoom.gameInfo.gameSetting.skipScreening;
    [self drawLayoutByGameInfo];
}

-(void)goToNextMatch
{
    chatRoom.gameInfo.redSideScore=0;
    chatRoom.gameInfo.blueSideScore=0;
    chatRoom.gameInfo.redSideWarmning=0;
    chatRoom.gameInfo.blueSideWarmning=0;
    chatRoom.gameInfo.currentMatch++;
    //resetRound will add round sequence
    chatRoom.gameInfo.currentRound=0;
    //reset round info
    [self resetRound:YES];
    [self startRound:nil];
}

//game loop here,send server's status to clients
-(void)gameLoop
{
    static int counter = 0;    
    if (chatRoom.gameInfo.gameStatus!=kStatePrepareGame) {
        counter++;
        // once every 8 updates check if we have a recent heartbeat from the other player, and send a heartbeat packet with current state        
        if(counter%3==0) {
            
            [self sendServerInfo];
        }
        
        if(counter%9==0){
            [self testSomeClientDisconnect];          
        }    
    }   
	[self processByGameStatus];
}
-(void)processByGameStatus
{
    switch (chatRoom.gameInfo.gameStatus) {
		case kStatePrepareGame:
            break;
        case kStateWaitJudge:
            
            break;
        case  kStateRunning:
        {
            
        }
            break;
        case  kStateCalcScore:
            [self testIfScoreCanSubmit];
            break;
        case kStateMultiplayerReconnect:
        {
            [self showWaitingUserBox];
        }
            break;
        case kStateGamePause:
            break;
        case kStateGameEnd:
            break;	
		default:
			break;
	}
}
-(BOOL)testSomeClientDisconnect
{
    BOOL hasDisconnect=NO;
    double inv=chatRoom.gameInfo.gameSetting.availTimeDuringScoreCalc;
    //NSLog(@"tesc disconnect:%i",chatRoom.gameInfo.clients.count);
    for (JudgeClientInfo *clt in chatRoom.gameInfo.clients.allValues) {
        if(!clt.hasConnected)
            hasDisconnect=YES;
        else if(clt.lastHeartbeatDate!=nil && fabs([clt.lastHeartbeatDate timeIntervalSinceNow]) >= inv) {
            clt.hasConnected=NO;
            hasDisconnect=YES;
            if(chatRoom.gameInfo.gameStatus==kStateRoundReset)
            {
                [roundResetPanel setTimerStop:YES];
            }
            [self setMenuByGameStatus:kStateMultiplayerReconnect];   
            [self showWaitingUserBox];
        }
    }
    return hasDisconnect;           
}
-(void)sendServerInfo
{
    chatRoom.gameInfo.serverLastHeartbeatDate=[NSDate date];
    CommandMsg *reconnectCmd=[[CommandMsg alloc] initWithType:NETWORK_HEARTBEAT andFrom:[AppConfig getInstance].name 
                                                      andDesc:nil andData:chatRoom.gameInfo andDate:[NSDate date]];
    [chatRoom sendCommand:reconnectCmd andPeerId:nil andSendDataReliable:YES];
}

-(void)setMenuByGameStatus:(GameStates)status;
{
    chatRoom.gameInfo.gameStatus = status;
    [self sendServerInfo];
    [self processByGameStatus];
    UIButton *continueButton=[self getMenuItem:kMenuItemContinueGame];
    UIButton *redWarmningButton=[self getMenuItem:kMenuItemWarmningRed];
    UIButton *blueWarmningButton=[self getMenuItem:kMenuItemWarmningBlue];
    UIButton *nextMatchButton=[self getMenuItem:kMenuItemNextMatch];
    if(chatRoom.gameInfo.gameStatus==kStateGameEnd)
    {
        continueButton.hidden=YES;
        redWarmningButton.hidden=YES;
        blueWarmningButton.hidden=YES;
        nextMatchButton.hidden=NO;
    }
    else if(chatRoom.gameInfo.gameStatus==kStateRunning)
    {
        continueButton.hidden=NO;
        redWarmningButton.hidden=NO;
        blueWarmningButton.hidden=NO;
        nextMatchButton.hidden=YES;
    }else{
        if(chatRoom.gameInfo.gameStatus==kStateGamePause)
            continueButton.hidden=NO;
        else
            continueButton.hidden=YES;
        redWarmningButton.hidden=YES;
        blueWarmningButton.hidden=YES;
        nextMatchButton.hidden=YES;
    }
    
}

-(UIButton *)getMenuItem:(int)tag{
    for (UIButton *btn in self.actionHeaderView.items) {
        if(btn.tag==tag)
            return btn;
    }   
    return nil;
}

#pragma mark -
#pragma mark During Match Setting

-(void)updateForGameSetting:(BOOL)hasChange{
    if(hasChange)
        {
            [self drawLayoutByGameInfo];
        }
    if (chatRoom.gameInfo.preGameStatus==kStateRunning||chatRoom.gameInfo.preGameStatus==kStateCalcScore) {
        [self contiueGame];
    }
}
-(void)showGameSettingDialog:(UIGestureRecognizer *)recognizer{
    
    CGPoint point= [recognizer locationInView:self.view];
    if(point.y>10&&point.y<100){
        if(chatRoom.gameInfo.gameStatus==kStateRunning||chatRoom.gameInfo.gameStatus==kStateCalcScore){
            [self pauseGame];
        }else{
        
        }
        [[ChattyAppDelegate getInstance] showDuringMatchSettingView];
    }
}
-(void)refreshGamesettingDialogJudges
{
    UISplitViewController *splitView=[ChattyAppDelegate getInstance].duringMathSplitViewCtl;
    if(splitView.view.superview!=nil){
     DuringMatchSettingDetailControllerHD *settingDetail= [splitView.viewControllers objectAtIndex:1];
        [settingDetail refreshJudges];
    }
}

-(void)duringSettingEndPress
{
    [self showSelectWinnerBox];
}

#pragma mark -
#pragma mark Winner Selected
-(void)showSelectWinnerBox
{
    SelectWinnerBox *box=[[SelectWinnerBox alloc] initWithFrame:self.view.bounds title:@"Please Select Winner"];
    box.gameInfo=chatRoom.gameInfo;
    box.delegate=self;
    [self.view addSubview:box];	
    [box showFromPoint:[self.view center]];
}
-(void)selectedWinnerEnd:(id)data
{
    NSNumber *num=data;
    BOOL winnerIsRedSide=[num boolValue];
    [self showWinnerBoxForRedSide:winnerIsRedSide];
}
-(void)showWinnerBoxForRedSide:(BOOL)isRedSide;
{
    ShowWinnerBox *box=[[ShowWinnerBox alloc] initWithFrame:self.view.bounds title:@"Congratulations"];
    box.gameInfo=chatRoom.gameInfo;
    box.winnerIsRedSide=isRedSide;
    [box bindSetting];
    box.delegate=self;
    [self.view addSubview:box];	
    [box showFromPoint:[self.view center]];
}
-(void)showWinnerEndAndNextRound:(id)data
{
    [self setMenuByGameStatus:kStateGameEnd];
    [self goToNextMatch];
}

@end
