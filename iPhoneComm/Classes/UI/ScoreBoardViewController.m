//
//  ScoreBoardViewController.m
//  Chatty
//
//  Created by Eagle Du on 12/6/30.
//  Copyright (c) 2012年 GET. All rights reserved.
//
#import <GameKit/GameKit.h>
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
#import "SelectWinnerBox.h"
#import "ScoreInfo.h"
#import "ScoreHistoryInfo.h"
#import "MatchInfo.h"
#import "BO_GameInfo.h"
#import "BO_JudgeClientInfo.h"
#import "BO_MatchInfo.h"
#import "BO_ScoreInfo.h"
#import "BO_ServerSetting.h"
#import "BO_UserInfo.h"
#import "BO_SubmitedScoreInfo.h"
#import "SubmitedScoreInfo.h"

#define  kMenuItemMenu 0
#define  kMenuItemExit 1
#define  kMenuItemContinueGame 2
#define  kMenuItemWarningBlue 3
#define  kMenuItemWarningRed 4
#define  kMenuItemNextMatch 5
#define  kMenuItemEndMatch 6
#define  kMenuItemRestReorgernizeTimer 7
#define  kMenuItemFlight 8
#define  kMenuItemTxnReport 9

#define kSoundsRoundStart @"roundstart.wav"
#define kSoundsPointEstablished @"point_established.mp3"
#define kSoundsPointFightTimeReached @"fight_time_reached.mp3"
#define kSoundsRoundEnd @"rend.wav"
#define kSoundsCongratulation @"winner.wav"


@interface ScoreBoardViewController ()

-(void)updatTime;
-(void)prepareForGame;
-(void)startRound:(id)sender;
-(void)waitUserStartPress:(id)sender;
-(void)contiueGame;
-(void)pauseGame;
-(void)resetRound:(BOOL)init;
-(void)setupMenu;
- (void)menuItemAction:(id)sender;
-(void)gameLoop;
-(BOOL)testSomeClientDisconnect;

-(void)sendServerStatusAndDesc:(NSString *)desc;
-(void)sendServerWholeInfo;
-(void)sendServerHearbeat;
-(void)sendDenyClientToConnectInfo:(JudgeClientInfo*)client;

-(void)pauseTime:(BOOL) stop;
-(void)testIfScoreCanSubmit;
-(void)submitScore:(ScoreInfo*)scoreInfo;
-(void)submitScore4Loop;
-(void)submitScore:(int)score andIsRedSize:(BOOL)isRedSide;
-(void)showRoundRestTimeBox:(NSTimeInterval) time andEventType:(NSInteger)eventType;
-(void)resetTimeEnd:(id)sender;
-(void)toggleReorignizeTimeBox;
-(void)warningPlayer:(Boolean) isForRedSide andCount:(NSInteger) count;
-(void)warningAddToBluePlayer;
-(void)warningAddToRedPlayer;
-(void)warningMinusToBluePlayer;
-(void)warningMinusToRedPlayer;
-(void)drawWarningFlagForRed:(Boolean)isForRedSide;
-(void)setMenuByGameStatus:(GameStates)status;
-(UIButton *)getMenuItem:(int)tag;
-(void)processByGameStatus;
-(void) stopRoom;
-(void)stopRoomNextMatch:(NSTimer *)timerIns;
-(void)gamePauseContinueToggle;
-(void)gamePauseAndShowReorignizeTimeBox;
-(void)blueAddScore;
-(void)blueMinusScore;
-(void)redAddScore;
-(void)redMinusScore;
-(void)showGameSettingDialog:(UIGestureRecognizer *)recognizer;
-(void)showGameSettingDialogWithViewIndex:(NSInteger)index;
-(void)refreshGamesettingDialogJudges;
-(void)drawRect:(CGRect)rect;
-(void)drawWarningFlag;
-(BOOL)testPointGapReached;
-(void)showSelectWinnerBox;
-(void)showWinnerBoxForRedSide:(BOOL)isRedSide winType:(WinType) winnerType;
-(void)selectedWinnerEnd:(id)data;
-(void)showWinnerEndAndNextRound:(id)data;
-(void)drawLayoutByGameInfo;
-(void)drawRoundNum:(NSInteger)roundNum;
-(void)drawTotalScore:(Boolean)isForRedSide andScore:(NSInteger) score;
-(void)drawTotalScore:(Boolean)isForRedSide andScore:(NSInteger) score andGrayStype:(BOOL)grayStyle;
-(void)drawRemainTime:(NSTimeInterval)time;
-(void)setPointGapStateFor:(BOOL)hasReached;
-(void)pointGapLoop;
-(void)setWarningMaxProcess;
-(void)warnmingMaxProcessLoop;
-(BOOL)isGuestureEnable;
-(void)processHearbeatWithClientUuid:(NSString *)uuid;
-(BOOL)isDuringSleep: (NSString *)_sideKey andScoreKey:(NSString *)_scoreKey;
-(BOOL)canSubmitControlCommand;
-(void) backToHome;
//报告分数提示，关闭显示标识
-(void)reportScoreIndicatorLoop:(NSTimer *)timerIns;
//成功提交分数，闪现分数后关闭
-(void)effectivedSubmitScoreTip:(ScoreHistoryInfo *)score;
-(void)effectivedSubmitScoreTipLoop:(NSTimer *)timerIns;
-(void)showSelectWinnerButton:(BOOL)show;
-(void) toggleFightTimeBox:(BOOL)show;
-(void)toggleFightTimeBox;
@end 

@implementation ScoreBoardViewController

@synthesize lblCoachName;
@synthesize lblGameName;
@synthesize txtHistory;
@synthesize chatRoom;
@synthesize lblGameDesc;
@synthesize lblCortNo;
@synthesize lblArea;
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
@synthesize viewRedWarningBox;
@synthesize viewBlueWarningBox;
@synthesize viewBlueScore;
@synthesize viewRedScore;
@synthesize viewTime;
@synthesize imgBlueScoreDoubleTen;
@synthesize imgBlueScoreDoubleSin;
@synthesize imgBlueScoreSingle;
@synthesize imgRedScoreDoubleTen;
@synthesize imgRedScoreDoubleSin;
@synthesize imgRedScoreSingle;
@synthesize imgRoundNum;
@synthesize imgTimeMinus;
@synthesize imgTimeSecTen;
@synthesize imgTimeSecSin;
@synthesize btnShowSelectWinner;
@synthesize imgScoreReportBlue1;
@synthesize imgScoreReportBlue2;
@synthesize imgScoreReportBlue3;
@synthesize imgScoreReportBlue4;
@synthesize imgScoreReportRed1;
@synthesize imgScoreReportRed2;
@synthesize imgScoreReportRed3;
@synthesize imgScoreReportRed4;
@synthesize fighterPanel;


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
    [self setWantsFullScreenLayout:YES];
    [super viewDidLoad];    
    /*
     self.viewBlueWarningBox.layer.borderColor = [UIColor colorWithRed:255/255 green:0/255 blue:0/255 alpha:0.8].CGColor;
     self.viewBlueWarningBox.layer.borderWidth = 1.0f;
     self.viewRedWarningBox.layer.borderColor = [UIColor colorWithRed:255/255 green:0/255 blue:0/255 alpha:0.8].CGColor;
     self.viewRedWarningBox.layer.borderWidth = 1.0f;    
     */  
    //    [self drawRect:self.viewBlueWarningBox.frame];
    //    [self drawRect:self.viewRedWarningBox.frame];
    
    /*recognizer*/
    /*顶部向下滑动,显示设置面板*/
    UISwipeGestureRecognizer *viewSwapDownRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showGameSettingDialog:)];
    viewSwapDownRecg.numberOfTouchesRequired=1;
    viewSwapDownRecg.direction= UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:viewSwapDownRecg];
    
    /*单击时间控件,继续或者暂停,比赛进行时有效*/
    UITapGestureRecognizer *startStopGame=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gamePauseContinueToggle)];
    startStopGame.numberOfTapsRequired=1;//单击
    startStopGame.numberOfTouchesRequired=1;
    self.viewTime.userInteractionEnabled=YES;
    [self.viewTime addGestureRecognizer:startStopGame];
    
    /*向上滑动时间控件,暂停比赛并显示休息时间*/
    UISwipeGestureRecognizer *pauseGameAndShowResetBox=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gamePauseAndShowReorignizeTimeBox)];
    pauseGameAndShowResetBox.numberOfTouchesRequired=1;
    pauseGameAndShowResetBox.direction= UISwipeGestureRecognizerDirectionUp;
    [self.viewTime addGestureRecognizer:pauseGameAndShowResetBox];
    
    /*红方：向上滑动分数控件,直接加1分*/
    UISwipeGestureRecognizer *blueAddRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(blueAddScore)];
    blueAddRecg.numberOfTouchesRequired=1;
    blueAddRecg.direction= UISwipeGestureRecognizerDirectionUp;
    self.viewBlueScore.userInteractionEnabled=YES;
    [self.viewBlueScore addGestureRecognizer:blueAddRecg];
    
    /*红方：向上滑动分数控件,直接减1分*/
    UISwipeGestureRecognizer *blueMinusRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(blueMinusScore)];
    blueMinusRecg.numberOfTouchesRequired=1;
    blueMinusRecg.direction= UISwipeGestureRecognizerDirectionDown;
    self.viewBlueScore.userInteractionEnabled=YES;
    [self.viewBlueScore addGestureRecognizer:blueMinusRecg];
    /*蓝方：向上滑动分数控件,直接加1分*/
    UISwipeGestureRecognizer *redAddRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(redAddScore)];
    redAddRecg.numberOfTouchesRequired=1;
    redAddRecg.direction= UISwipeGestureRecognizerDirectionUp;
    self.viewRedScore.userInteractionEnabled=YES;
    [self.viewRedScore addGestureRecognizer:redAddRecg];
    /*蓝方：向上滑动分数控件,直接减1分*/
    UISwipeGestureRecognizer *redMinusRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(redMinusScore)];
    redMinusRecg.numberOfTouchesRequired=1;
    redMinusRecg.direction= UISwipeGestureRecognizerDirectionDown;
    viewRedScore.userInteractionEnabled=YES;
    [viewRedScore addGestureRecognizer:redMinusRecg];
    
    /*在警告控件向右拖拉,累積警告分數加一次*/
    UISwipeGestureRecognizer *blueWarningAddRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(warningAddToBluePlayer)];
    blueWarningAddRecg.numberOfTouchesRequired=1;
    blueWarningAddRecg.direction= UISwipeGestureRecognizerDirectionRight;
    [self.viewBlueWarningBox addGestureRecognizer:blueWarningAddRecg];
    
    /*在警告控件向左拖拉,累積警告分數减一次*/
    UISwipeGestureRecognizer *blueWarningMinusRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(warningMinusToBluePlayer)];
    blueWarningMinusRecg.numberOfTouchesRequired=1;
    blueWarningMinusRecg.direction= UISwipeGestureRecognizerDirectionLeft;
    [self.viewBlueWarningBox addGestureRecognizer:blueWarningMinusRecg];
    
    
    /*在警告控件向右拖拉,累積警告分數加一次*/
    UISwipeGestureRecognizer *redWarningAddRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(warningAddToRedPlayer)];
    redWarningAddRecg.numberOfTouchesRequired=1;
    redWarningAddRecg.direction= UISwipeGestureRecognizerDirectionRight;
    [self.viewRedWarningBox addGestureRecognizer:redWarningAddRecg];
    
    /*在警告控件向左拖拉,累積警告分數减一次*/
    UISwipeGestureRecognizer *redWarningMinusRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(warningMinusToRedPlayer)];
    redWarningMinusRecg.numberOfTouchesRequired=1;
    redWarningMinusRecg.direction= UISwipeGestureRecognizerDirectionLeft;
    [self.viewRedWarningBox addGestureRecognizer:redWarningMinusRecg];
    
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
    [self setViewRedWarningBox:nil];
    [self setViewBlueWarningBox:nil];
    [self setImgBlueScoreDoubleSin:nil];
    [self setImgBlueScoreDoubleTen:nil];
    [self setImgBlueScoreSingle:nil];
    [self setImgRedScoreDoubleTen:nil];
    [self setImgRedScoreDoubleSin:nil];
    [self setImgRedScoreSingle:nil];
    [self setImgRoundNum:nil];
    [self setImgTimeMinus:nil];
    [self setImgTimeSecTen:nil];
    [self setImgTimeSecSin:nil];
    [self setViewBlueScore:nil];
    [self setViewTime:nil];
    [self setViewRedScore:nil];
    [self setLblCortNo:nil];
    [self setLblArea:nil];
    [self setBtnShowSelectWinner:nil];
    [self setImgScoreReportBlue1:nil];
    [self setImgScoreReportBlue2:nil];
    [self setImgScoreReportBlue3:nil];
    [self setImgScoreReportBlue4:nil];
    [self setImgScoreReportRed1:nil];
    [self setImgScoreReportRed2:nil];
    [self setImgScoreReportRed3:nil];
    [self setImgScoreReportRed4:nil];
    [self setFighterPanel:nil];
    [super viewDidUnload];    
    marksFlags=nil;
    scoreReportIndicatorsBlue=nil;
    scoreReportIndicatorsRed=nil;
    scoreReportIndicatorTimersBlue=nil;
    scoreReportIndicatorTimersRed=nil;
    timeFlags=nil;
    timeFlags2=nil;
    marksGrayFlags=nil;
    scoreReportPointColors=nil;
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
    if(player==nil)
        player= [[SoundsPlayer alloc] init] ;    
    [self prepareForGame];
    [AppConfig getInstance].isGameStart=YES;
    chatRoom.gameInfo.gameStart=NO;
    //[self showRoundRestTimeBox:1 andEventType:1];
}

#pragma mark -
#pragma mark warning
//warming,when 2 warning to be a Deduction(score -1)
-(void)warningPlayer:(Boolean) isForRedSide andCount:(NSInteger)count{
    if(isForRedSide){
        if(chatRoom.gameInfo.currentMatchInfo.redSideWarning+count<0)
            return;
        else if(chatRoom.gameInfo.currentMatchInfo.redSideWarning+count>chatRoom.gameInfo.gameSetting.maxWarningCount){
            return;
        }
        else{
            chatRoom.gameInfo.currentMatchInfo.redSideWarning+=count;
            //合计2次警告自动加对方1分
            if(count>0 && chatRoom.gameInfo.currentMatchInfo.redSideWarning%2==0){
                [self submitScore:1 andIsRedSize:NO];
                [[BO_SubmitedScoreInfo getInstance] insertObject:[[SubmitedScoreInfo alloc] initWithSubmitScore:1 isForRedSide:NO gameId:chatRoom.gameInfo.gameId matchId:chatRoom.gameInfo.currentMatchInfo.matchId roundSeq:chatRoom.gameInfo.currentMatchInfo.currentRound clientUuids:nil isSubmitByClient:NO andScoreOperateType:ScoreOperateTypeScore]];
            }            
            [self drawWarningFlagForRed:YES];            
        }
    }
    else{
        if(chatRoom.gameInfo.currentMatchInfo.blueSideWarning+count<0)
            return;
        else if(chatRoom.gameInfo.currentMatchInfo.blueSideWarning+count>chatRoom.gameInfo.gameSetting.maxWarningCount){
            return;
        }
        else{
            chatRoom.gameInfo.currentMatchInfo.blueSideWarning+=count;
            if(count>0 && chatRoom.gameInfo.currentMatchInfo.blueSideWarning%2==0){
                [self submitScore:1 andIsRedSize:YES];
                [[BO_SubmitedScoreInfo getInstance] insertObject:[[SubmitedScoreInfo alloc] initWithSubmitScore:1 isForRedSide:YES gameId:chatRoom.gameInfo.gameId matchId:chatRoom.gameInfo.currentMatchInfo.matchId roundSeq:chatRoom.gameInfo.currentMatchInfo.currentRound clientUuids:nil isSubmitByClient:NO andScoreOperateType:ScoreOperateTypeScore]];
            }
            [self drawWarningFlagForRed:NO];
        }    
    }
    [[BO_SubmitedScoreInfo getInstance] insertObject:[[SubmitedScoreInfo alloc] initWithSubmitScore:count isForRedSide:isForRedSide gameId:chatRoom.gameInfo.gameId matchId:chatRoom.gameInfo.currentMatchInfo.matchId roundSeq:chatRoom.gameInfo.currentMatchInfo.currentRound clientUuids:nil isSubmitByClient:NO andScoreOperateType:ScoreOperateTypeWarmning]];
    [self setWarningMaxProcess];
}

-(void)warningAddToBluePlayer{
    if([self isGuestureEnable])
        [self warningPlayer:NO andCount:1];
}
-(void)warningAddToRedPlayer{
    if([self isGuestureEnable])
        [self warningPlayer:YES andCount:1];
}
-(void)warningMinusToBluePlayer{
    if([self isGuestureEnable])
        [self warningPlayer:NO andCount:-1];
}
-(void)warningMinusToRedPlayer{
    if([self isGuestureEnable])
        [self warningPlayer:YES andCount:-1];
}

#pragma mark -
#pragma mark draw layout

-(void)drawLayoutByGameInfo{
    lblGameName.text=[NSString stringWithFormat:@"%@ %@",chatRoom.gameInfo.gameSetting.gameName,chatRoom.gameInfo.gameSetting.gameDesc];
    lblCortNo.text=[NSString stringWithFormat:@"NO.%i",chatRoom.gameInfo.currentMatch];
    lblArea.text=chatRoom.gameInfo.gameSetting.screeningArea;
    lblRedPlayerName.text=[NSString stringWithFormat:@"%@ %@", chatRoom.gameInfo.gameSetting.redSideName,chatRoom.gameInfo.gameSetting.redSideDesc];
    lblBluePlayerName.text=[NSString stringWithFormat:@"%@ %@", chatRoom.gameInfo.gameSetting.blueSideName,chatRoom.gameInfo.gameSetting.blueSideDesc];
    
    /*目前没有使用下来属性*/
    lblGameDesc.text=chatRoom.gameInfo.gameSetting.gameDesc;    
    lblRedPlayerDesc.text=chatRoom.gameInfo.gameSetting.redSideDesc;
    lblBluePlayerDesc.text=chatRoom.gameInfo.gameSetting.blueSideDesc;    
    lblScreening.text=chatRoom.gameInfo.gameSetting.screeningArea;
    /*下列用图像替换*/
    
    [self drawRoundNum:chatRoom.gameInfo.currentMatchInfo.currentRound];
    [self drawTotalScore:YES andScore:chatRoom.gameInfo.currentMatchInfo.redSideScore];
    [self drawTotalScore:NO andScore:chatRoom.gameInfo.currentMatchInfo.blueSideScore];
    /*end*/
    [self drawRemainTime:chatRoom.gameInfo.currentMatchInfo.currentRemainTime];
    [self drawWarningFlag];
}

-(void)drawWarningFlag
{
    [self drawWarningFlagForRed:YES];
    [self drawWarningFlagForRed:NO];
}

-(void)drawWarningFlagForRed:(Boolean)isForRedSide{
    BOOL isBlue=!isForRedSide;
    UIView *view=isBlue?viewBlueWarningBox:viewRedWarningBox;
    
    int warningCount=isBlue?chatRoom.gameInfo.currentMatchInfo.blueSideWarning:chatRoom.gameInfo.currentMatchInfo.redSideWarning;
    int maxWarmingCount=chatRoom.gameInfo.gameSetting.maxWarningCount+(chatRoom.gameInfo.gameSetting.maxWarningCount%2>0?1:0);
    float imgHeight=63.0;
    float imgWidth=127.0;
    float actWidth=108.0;
    float padding=1;
    float paddingTop=1;
    if(isBlue){//蓝色框以右边端点为固定端点，向左延伸
        view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y,padding+(actWidth)*maxWarmingCount/2+padding*2, view.frame.size.height);
    }else{
        view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y,padding+(actWidth)*maxWarmingCount/2+padding*2, view.frame.size.height);
    }
    for (UIView *subView in view.subviews) {
        [subView removeFromSuperview];
    }
    int deducateCount=warningCount/2;    
    float initX= padding;
    for (int i=0; i<deducateCount; i++) {        
        UIImageView *lbl=[[UIImageView alloc] initWithFrame:CGRectMake(initX, paddingTop, imgWidth,imgHeight)];
        lbl.image=imgDecicade;
        initX = initX+actWidth-4;
        [view addSubview:lbl];
    }
    BOOL hasWarning=warningCount%2;
    if (hasWarning) {
        UIImageView *lbl=[[UIImageView alloc] initWithFrame:CGRectMake(initX, paddingTop, imgWidth, imgHeight)];
        lbl.image=imgWarning;
        [view addSubview:lbl];
    }
    
}
-(void)setWarningMaxProcess
{
    /*
     ---加警告---
     解發事件
     ﹣扣分
     當滿兩個警告
     1. 扣分盒會變成黃色
     2. 對方累積得分自動加一分
     ﹣扣滿最高扣分 
     所有扣分盒為黃色
     1. 比賽暫停，勝方分數閃動，敗方分數設定為灰色而所有扣分盒不停閃動
     */
    /*
     減警告
     •	程序
     ﹣累積警告分數減一次
     ﹣畫面顯示扣分控件（最高扣分可於比賽設定內設定）
     *扣分控件設定為所柜為紅色，底色為透明
     ﹣一次警告為綠色，第二次警告（即扣分）為黃色。下一次警告即亮下個扣分盒
     •	iPad控制方法
     ﹣在警告控件向左拖拉
     •	解發事件 
     ﹣消除扣滿最高扣分 
     扣滿最高扣分錯誤地觸發，例如：操作員重覆加分動作。
     1. 當比賽暫停，勝方分數閃動，敗方分數設定為灰色而所有扣分盒不停閃動
     2. 操作減分至正常。畫面回復正常。時間可以隨時開始
     */
    if(self.chatRoom.gameInfo.currentMatchInfo.blueSideWarning==self.chatRoom.gameInfo.gameSetting.maxWarningCount||self.chatRoom.gameInfo.currentMatchInfo.redSideWarning==self.chatRoom.gameInfo.gameSetting.maxWarningCount){
        self.chatRoom.gameInfo.currentMatchInfo.warningMaxReached=YES;
        BOOL isRedSide=self.chatRoom.gameInfo.currentMatchInfo.redSideWarning==self.chatRoom.gameInfo.gameSetting.maxWarningCount;
        [self pauseGame];
        [self drawTotalScore:isRedSide andScore:isRedSide?chatRoom.gameInfo.currentMatchInfo.redSideScore:chatRoom.gameInfo.currentMatchInfo.blueSideScore andGrayStype:YES];
        if(![warningMaxTimer isValid]){
            warningMaxTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(warnmingMaxProcessLoop) userInfo:nil repeats:YES];
        }
        [self showSelectWinnerButton:YES];
    }
    else{
        if([warningMaxTimer isValid])
            [warningMaxTimer invalidate];
        self.chatRoom.gameInfo.currentMatchInfo.warningMaxReached=NO;
        [self drawTotalScore:YES andScore:chatRoom.gameInfo.currentMatchInfo.redSideScore andGrayStype:chatRoom.gameInfo.currentMatchInfo.pointGapReached&&chatRoom.gameInfo.currentMatchInfo.blueSideScore>chatRoom.gameInfo.currentMatchInfo.redSideScore];
        [self drawTotalScore:NO andScore:chatRoom.gameInfo.currentMatchInfo.blueSideScore andGrayStype:chatRoom.gameInfo.currentMatchInfo.pointGapReached&&chatRoom.gameInfo.currentMatchInfo.redSideScore>chatRoom.gameInfo.currentMatchInfo.blueSideScore];
        [self showSelectWinnerButton:NO];
    }
    [[BO_MatchInfo getInstance] saveObject:chatRoom.gameInfo.currentMatchInfo];
}
-(void)warnmingMaxProcessLoop
{
    static int WarningCount=0;
    BOOL isRedSide=chatRoom.gameInfo.currentMatchInfo.redSideWarning==chatRoom.gameInfo.gameSetting.maxWarningCount;
    BOOL hidden=WarningCount%2==0;
    WarningCount++;
    //胜方闪数
    UIView *warningBox=isRedSide?viewRedWarningBox:viewBlueWarningBox;
    for (UIView *subView in warningBox.subviews) {
        subView.hidden=hidden;
    }
    if(!isRedSide){
        if(chatRoom.gameInfo.currentMatchInfo.redSideScore/10>0){
            imgRedScoreDoubleTen.hidden=hidden;
            imgRedScoreDoubleSin.hidden=hidden;
        }
        else{
            imgRedScoreSingle.hidden=hidden;
        }
    }
    else{
        if(chatRoom.gameInfo.currentMatchInfo.blueSideScore/10>0){
            imgBlueScoreDoubleTen.hidden=hidden;
            imgBlueScoreDoubleSin.hidden=hidden;
        }
        else{
            imgBlueScoreSingle.hidden=hidden;
        }
    }
}

-(void)drawRoundNum:(NSInteger)roundNum{
    lblRoundSeq.text=[NSString stringWithFormat:@"Round %i",roundNum];
    imgRoundNum.image=[timeFlags objectAtIndex:roundNum];
    imgRoundNum.hidden = NO;
}
-(void)drawTotalScore:(Boolean)isForRedSide andScore:(NSInteger) score{
    [self drawTotalScore:isForRedSide andScore:score andGrayStype:NO];
}
-(void)drawTotalScore:(Boolean)isForRedSide andScore:(NSInteger) score andGrayStype:(BOOL)grayStyle{
    int ten=score/10;
    int sin=score%10;
    NSMutableArray *flagArray=grayStyle?marksGrayFlags:marksFlags;
    if(isForRedSide){
        lblRedTotal.text=[NSString stringWithFormat:@"%i",score];
        if(ten==0){
            imgRedScoreDoubleSin.hidden=YES;
            imgRedScoreDoubleTen.hidden=YES;
            imgRedScoreSingle.hidden=NO;
            imgRedScoreSingle.image=[flagArray objectAtIndex:sin];
        }
        else{
            imgRedScoreDoubleSin.hidden=NO;
            imgRedScoreDoubleTen.hidden=NO;
            imgRedScoreDoubleSin.image=[flagArray objectAtIndex:sin];
            imgRedScoreDoubleTen.image=[flagArray objectAtIndex:ten];
            imgRedScoreSingle.hidden=YES;
        }
    }
    else{
        lblBlueTotal.text=[NSString stringWithFormat:@"%i",score];
        if(ten==0){
            imgBlueScoreDoubleSin.hidden=YES;
            imgBlueScoreDoubleTen.hidden=YES;
            imgBlueScoreSingle.hidden=NO;
            imgBlueScoreSingle.image=[flagArray objectAtIndex:sin];
        }
        else{
            imgBlueScoreDoubleSin.hidden=NO;
            imgBlueScoreDoubleTen.hidden=NO;
            imgBlueScoreDoubleSin.image=[flagArray objectAtIndex:sin];
            imgBlueScoreDoubleTen.image=[flagArray objectAtIndex:ten];
            imgBlueScoreSingle.hidden=YES;
        }
    }
}
-(void)drawRemainTime:(NSTimeInterval)time{
    int min = time/60;
    int sec=(int)time%60;
    int secSin=sec%10;
    int secTen=sec/10;
    lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    NSArray *useFlags;
    if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateGamePause){
        useFlags=timeFlags2;
    }else
    {
        useFlags=timeFlags;
    }
    
    imgTimeMinus.image=[useFlags objectAtIndex:min];
    imgTimeSecTen.image=[useFlags objectAtIndex:secTen];
    imgTimeSecSin.image=[useFlags objectAtIndex:secSin];
}

#pragma mark -
#pragma mark time hander
//when game going on,we need to refresh time 
-(void)updatTime { 
    //static int MATCH_SAVE_INTERVAL=1;
    if(chatRoom.gameInfo.currentMatchInfo.currentRemainTime>0)
        chatRoom.gameInfo.currentMatchInfo.currentRemainTime=chatRoom.gameInfo.currentMatchInfo.currentRemainTime-kUpdateTimeInterval;
    if(chatRoom.gameInfo.currentMatchInfo.currentRemainTime - floor(chatRoom.gameInfo.currentMatchInfo.currentRemainTime)>0){
        return;   
    }
    else{
        int min = chatRoom.gameInfo.currentMatchInfo.currentRemainTime/60;
        int sec=fmod(chatRoom.gameInfo.currentMatchInfo.currentRemainTime,60);
        [self drawRemainTime:chatRoom.gameInfo.currentMatchInfo.currentRemainTime];
        lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
        //    if(MATCH_SAVE_INTERVAL%5==0){
        //        [[BO_MatchInfo getInstance] updateObject:chatRoom.gameInfo.currentMatchInfo];
        //    }
        //    MATCH_SAVE_INTERVAL++;
        if(chatRoom.gameInfo.currentMatchInfo.currentRemainTime==0){
            [self pauseTime:YES];
            [player playSoundWithFullPath:kSoundsRoundEnd];
            //比赛结束条件1：在所有回合结束后，得分间有差距；
            //加时赛时，有选手得分
            if((chatRoom.gameInfo.currentMatchInfo.currentRound==chatRoom.gameInfo.gameSetting.roundCount&&
                chatRoom.gameInfo.currentMatchInfo.blueSideScore!=chatRoom.gameInfo.currentMatchInfo.redSideScore)
               ||chatRoom.gameInfo.currentMatchInfo.currentRound==chatRoom.gameInfo.gameSetting.roundCount+1){
                [self setMenuByGameStatus:kStateGamePause]; 
                //[self showSelectWinnerBox];
                [self showSelectWinnerButton:YES];
                //[UIHelper showAlert:@"Information" message:@"The match has completed." func:nil];
            }else{    
                [self setMenuByGameStatus:kStateRoundReset];              
                [self showRoundRestTimeBox:chatRoom.gameInfo.gameSetting.restTime andEventType:krestTime];
            }
        }
        //加时赛
        else if(chatRoom.gameInfo.currentMatchInfo.currentRound==chatRoom.gameInfo.gameSetting.roundCount+1 && chatRoom.gameInfo.currentMatchInfo.redSideScore!=chatRoom.gameInfo.currentMatchInfo.blueSideScore)
        {
            [self pauseGame];
            [self showWinnerBoxForRedSide:chatRoom.gameInfo.currentMatchInfo.redSideScore>chatRoom.gameInfo.currentMatchInfo.blueSideScore winType:kWinByPoint];
            [[BO_MatchInfo getInstance] updateObject:chatRoom.gameInfo.currentMatchInfo];
        }
    }
} 
-(void)showSelectWinnerButton:(BOOL)show
{
    if(show){
        self.btnShowSelectWinner.hidden=NO;
        [UIView animateWithDuration:0.5 
                         animations:^{
                             btnShowSelectWinner.frame = CGRectMake(btnShowSelectWinner.frame.origin.x, btnShowSelectWinner.frame.origin.y, btnShowSelectWinner.frame.size.width/2, btnShowSelectWinner.frame.size.height/2);
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.5 
                                              animations:^{
                                                  btnShowSelectWinner.frame = CGRectMake(btnShowSelectWinner.frame.origin.x, btnShowSelectWinner.frame.origin.y, btnShowSelectWinner.frame.size.width*2, btnShowSelectWinner.frame.size.height*2);
                                              } completion:^(BOOL finished) {
                                                  
                                              }];
                         }];
    }
    else{
        self.btnShowSelectWinner.hidden=YES;
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

-(void)toggleReorignizeTimeBox{
    if([self.view.subviews containsObject:roundResetPanel])
    {
        if([roundResetPanel.relatedData intValue]==krestAndReOrgTime)
        {
            [roundResetPanel hide];
            [self resetTimeEnd:roundResetPanel.relatedData];
        }
    }
    else{
        [self gamePauseAndShowReorignizeTimeBox];
    }
}
-(void)toggleFightTimeBox:(BOOL)show{
    if(show){
        [fighterPanel showWithFightTime:chatRoom.gameInfo.gameSetting.fightTimeInterval];
    }
    else{
        [fighterPanel hide];
    }
}
/*切换fihgt time box*/
-(void)toggleFightTimeBox{
    if(fighterPanel!=nil && fighterPanel.hidden==NO){
        [self toggleFightTimeBox:NO];
    }
    else{
        [self toggleFightTimeBox:YES];
    }
}

-(void)fightimeReached:(UIFighterBox *)fighterbox
{
    [self warningAddToRedPlayer];
    [self warningAddToBluePlayer];
    //warmning competitor/instructor when point is established
    //[player playSoundWithFullPath:kSoundsPointFightTimeReached];
}

#pragma mark -
#pragma mark score
-(void)submitScore:(int)score andIsRedSize:(BOOL)isRedSide;
{    
    [fighterPanel hide];
    if(isRedSide){
        if(chatRoom.gameInfo.currentMatchInfo.redSideScore+score<0)
            return;
        if(chatRoom.gameInfo.currentMatchInfo.redSideScore+score>99)
            return;
        chatRoom.gameInfo.currentMatchInfo.redSideScore+=score;
        [self drawTotalScore:YES andScore:chatRoom.gameInfo.currentMatchInfo.redSideScore];
        lblRedTotal.text=[NSString stringWithFormat:@"%i",chatRoom.gameInfo.currentMatchInfo.redSideScore];           
    }else{
        if(chatRoom.gameInfo.currentMatchInfo.blueSideScore+score<0)
            return;
        if(chatRoom.gameInfo.currentMatchInfo.blueSideScore+score>99)
            return;
        chatRoom.gameInfo.currentMatchInfo.blueSideScore+=score;
        [self drawTotalScore:NO andScore:chatRoom.gameInfo.currentMatchInfo.blueSideScore];
        lblBlueTotal.text=[NSString stringWithFormat:@"%i",chatRoom.gameInfo.currentMatchInfo.blueSideScore];
    }
    //warmning competitor/instructor when point is established
    [player playSoundWithFullPath:kSoundsPointEstablished];
    [[BO_MatchInfo getInstance] saveObject:chatRoom.gameInfo.currentMatchInfo];
    if(chatRoom.gameInfo.currentMatchInfo.currentRound<=chatRoom.gameInfo.gameSetting.roundCount){
        //比赛正常进行时
        [self testPointGapReached];
    }
    else{
        //加时赛处理
        [self pauseGame];
        [self showWinnerBoxForRedSide:chatRoom.gameInfo.currentMatchInfo.redSideScore>chatRoom.gameInfo.currentMatchInfo.blueSideScore winType:kWinByPoint];
    }
    //修改
    //    cmdHis = nil;
    //修改完
    //if(![self testPointGapReached])
    //[self contiueGame];
}

-(void)submitScore:(ScoreInfo *)scoreInfo{
    if(scoreInfo!=nil){
        switch (scoreInfo.swipeType) {
            case kSideRed:
                [self submitScore:scoreInfo.redSideScore andIsRedSize:YES];
                break;
            case kSideBlue:
                [self submitScore:scoreInfo.blueSideScore andIsRedSize:NO];
                break;
            case kSideBoth:
                if(chatRoom.gameInfo.currentMatchInfo.redSideScore+scoreInfo.redSideScore<0||chatRoom.gameInfo.currentMatchInfo.blueSideScore+scoreInfo.blueSideScore<0) return;
                [self submitScore:scoreInfo.redSideScore andIsRedSize:YES];
                [self submitScore:scoreInfo.blueSideScore andIsRedSize:NO];
                break;
            default:
                break;
        }
        if(scoreInfos != nil){
            [scoreInfos removeAllObjects];
        }
        scoreInfo = nil;
    }
}

-(BOOL)isGuestureEnable{
    return chatRoom.gameInfo.currentMatchInfo.gameStatus!=kStateWaitJudge&&chatRoom.gameInfo.currentMatchInfo.gameStatus!=kStateGameExit&&chatRoom.gameInfo.currentMatchInfo.gameStatus!=kStateGameEnd;
}
//add score to blue side
-(void)blueAddScore{
    if([self isGuestureEnable]){
        [self submitScore:1 andIsRedSize:NO];
        [[BO_SubmitedScoreInfo getInstance] insertObject:[[SubmitedScoreInfo alloc] initWithSubmitScore:1 isForRedSide:NO gameId:chatRoom.gameInfo.gameId matchId:chatRoom.gameInfo.currentMatchInfo.matchId roundSeq:chatRoom.gameInfo.currentMatchInfo.currentRound clientUuids:nil isSubmitByClient:NO andScoreOperateType:ScoreOperateTypeScore]];
    }
}
-(void)blueMinusScore{
    if([self isGuestureEnable]){
        [self submitScore:-1 andIsRedSize:NO];
        [[BO_SubmitedScoreInfo getInstance] insertObject:[[SubmitedScoreInfo alloc] initWithSubmitScore:-1 isForRedSide:NO gameId:chatRoom.gameInfo.gameId matchId:chatRoom.gameInfo.currentMatchInfo.matchId roundSeq:chatRoom.gameInfo.currentMatchInfo.currentRound clientUuids:nil isSubmitByClient:NO andScoreOperateType:ScoreOperateTypeScore]];
    }
}
-(void)redAddScore{
    if([self isGuestureEnable]){
        [self submitScore:1 andIsRedSize:YES];
        [[BO_SubmitedScoreInfo getInstance] insertObject:[[SubmitedScoreInfo alloc] initWithSubmitScore:1 isForRedSide:YES gameId:chatRoom.gameInfo.gameId matchId:chatRoom.gameInfo.currentMatchInfo.matchId roundSeq:chatRoom.gameInfo.currentMatchInfo.currentRound clientUuids:nil isSubmitByClient:NO andScoreOperateType:ScoreOperateTypeScore]];
    }
}
-(void)redMinusScore{
    if([self isGuestureEnable]){
        [self submitScore:-1 andIsRedSize:YES];
        [[BO_SubmitedScoreInfo getInstance] insertObject:[[SubmitedScoreInfo alloc] initWithSubmitScore:-1 isForRedSide:YES gameId:chatRoom.gameInfo.gameId matchId:chatRoom.gameInfo.currentMatchInfo.matchId roundSeq:chatRoom.gameInfo.currentMatchInfo.currentRound clientUuids:nil isSubmitByClient:NO andScoreOperateType:ScoreOperateTypeScore]];
    }
}

-(void)submitScore4Loop{
	if(scoreInfos!=nil){
		for(NSString *sideKey in scoreInfos){
			NSMutableDictionary *scoreDic = [scoreInfos objectForKey: sideKey];
			if(scoreDic!=nil){
				for(NSString *scoreKey in scoreDic){
				    ScoreHistoryInfo *scoreHistoryInfo = [scoreDic objectForKey: scoreKey];
				    if(scoreHistoryInfo!=nil&&scoreHistoryInfo.startTime!=nil){
                        if(scoreHistoryInfo.endTime==nil){
                            double maxDelay = chatRoom.gameInfo.gameSetting.serverLoopMaxDelay;
                            //double maxDelay = 1;
                            int judgeCount = chatRoom.gameInfo.gameSetting.availScoreWithJudgesCount;
                            NSLog(@"////////////////");
                            if(fabs([scoreHistoryInfo.startTime timeIntervalSinceNow]) >= maxDelay){
                                if(scoreHistoryInfo.uuids!=nil && scoreHistoryInfo.uuids.count<judgeCount){
                                    scoreHistoryInfo.endTime = [NSDate date];
                                    [scoreHistoryInfo.uuids removeAllObjects];
                                    scoreHistoryInfo.calTimer = nil;
                                    return;
                                }
                                NSLog(@"//////////sfdsfdsfds////////////");
                            }
                            if(scoreHistoryInfo.uuids!=nil && scoreHistoryInfo.uuids.count>=judgeCount){
                                NSLog(@"/////sdfdsfs");
                                scoreHistoryInfo.calTimer = nil;
                                scoreHistoryInfo.endTime = [NSDate date];
                                [self effectivedSubmitScoreTip:scoreHistoryInfo];                                
                                int score=[scoreHistoryInfo.scoreKey intValue];
                                BOOL isForRed=[scoreHistoryInfo.sideKey isEqualToString:@"red"];
                                [self submitScore:score andIsRedSize:isForRed];
                                [[BO_SubmitedScoreInfo getInstance] insertObject:[[SubmitedScoreInfo alloc] initWithSubmitScore:score isForRedSide:isForRed gameId:chatRoom.gameInfo.gameId matchId:chatRoom.gameInfo.currentMatchInfo.matchId roundSeq:chatRoom.gameInfo.currentMatchInfo.currentRound clientUuids:scoreHistoryInfo.uuids isSubmitByClient:YES andScoreOperateType:ScoreOperateTypeScore]];
                                //                                for (ScoreInfo *si in scoreHistoryInfo.scoreInfos) {
                                //                                    si.successSubmited=YES;
                                //                                    [[BO_ScoreInfo getInstance] updateObject:si];
                                //                                }
                                [scoreHistoryInfo.uuids removeAllObjects];
                                //[scoreHistoryInfo.scoreInfos removeAllObjects];
                            }
                        }
				    }
				}
			}
		}
	}
}

/*
 所有裁判提交的分数必须相同,并且提交时间在1s之内,否则无效
 */
-(void)testIfScoreCanSubmit
{    
    if(!(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRunning||chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateCalcScore))
    {
        return;
    }
    if(cmdHis==nil||cmdHis.count==0)
        return;
    NSLog(@"Cmd his count:%i,client cout:%i",cmdHis.count,chatRoom.gameInfo.clients.count);
    //    int score=0;
    //    ScoreInfo *scoreInfo = nil;
    //    BOOL timeout=NO;
    //    NSDate *minTime=nil;
    //    for (CommandMsg *cmd in cmdHis) {
    //        if(minTime==nil)
    //        {
    //            minTime=cmd.date;
    //            continue;
    //        }
    //        else{
    //            if (cmd.date<minTime) {
    //                minTime=cmd.date;
    //            }
    //        }
    //        
    //    }
    //    double elaspedTime=chatRoom.gameInfo.gameSetting.availTimeDuringScoreCalc;
    //timeout now
    //    NSLog(@"%f",fabs([minTime timeIntervalSinceNow]));
    //    if(fabs([minTime timeIntervalSinceNow]) >= elaspedTime){
    //        timeout=YES;
    //    }
    //    if(timeout){
    //        [self setMenuByGameStatus:kStateRunning];
    //        cmdHis = nil;
    //        return;
    //    }
    //    if(scoreInfos == nil){
    //        scoreInfos=[[NSMutableArray alloc] initWithCapacity:cmdHis.count];
    //    }
    //    NSMutableArray *uuids=[[NSMutableArray alloc] initWithCapacity:cmdHis.count];
    //    CommandMsg *firstCmd=[cmdHis objectAtIndex:0];
    //    [scoreInfos addObject:firstCmd.data];
    // scoreInfo = [firstCmd data];
    //    scoreInfo = [[ScoreInfo alloc]initWithDictionary: firstCmd.data];
    //    NSLog(@"^^^^^^^^^^^^^redScore:%i  blueScore:%i", scoreInfo.redSideScore, scoreInfo.blueSideScore);
    //score=[[firstCmd data] intValue];
    //NSString *side=firstCmd.desc;
    //    if(cmdHis.count>chatRoom.gameInfo.clients.count)
    //    {
    //        [self setMenuByGameStatus:kStateRunning];
    //        cmdHis = nil;
    //        return;
    //    }
    //    else if(cmdHis.count==chatRoom.gameInfo.clients.count){
    //        int availCount = 0;
    int cmdCount = cmdHis.count-1;
    for (int i=cmdCount;i>=0;i--) {
        CommandMsg *cmd = [cmdHis objectAtIndex:i];
        //            NSLog(@"||||||||availCount:%i  judesCount:%i", availCount, [AppConfig getInstance].serverSettingInfo.availScoreWithJudesCount);
        //            
        //            //if(availCount >= [AppConfig getInstance].serverSettingInfo.availScoreWithJudesCount) break;
        //
        //            ScoreInfo* scoreInfoTemp = [[ScoreInfo alloc]initWithDictionary: cmd.data];
        //
        //            NSLog(@"^^^^^^^^^^^^^||||||||redScore:%i  blueScore:%i", scoreInfoTemp.redSideScore, scoreInfoTemp.blueSideScore);
        //            if(scoreInfoTemp.blueSideScore != scoreInfo.blueSideScore || scoreInfoTemp.redSideScore != scoreInfo.redSideScore){
        //                [self setMenuByGameStatus:kStateRunning];
        //                cmdHis = nil;
        //                return; 
        //            }
        //            if([uuids containsObject:cmd.from]){//uuid
        //                [self setMenuByGameStatus:kStateRunning];
        //                cmdHis = nil;
        //                return;
        //            }
        //            else
        //                [uuids addObject:cmd.from];
        //            availCount++;
        //ScoreInfo* scoreInfoTemp=cmd.data;
        ScoreInfo* scoreInfoTemp = [[ScoreInfo alloc]initWithDictionary: cmd.data];
        NSString *sideKey = scoreInfoTemp.swipeType==kSideRed? @"red": @"blue";
        NSLog(@"]]]]]]]]]]]]]]]side:%@", sideKey);
        NSString *scoreKey = [NSString stringWithFormat:@"%i",scoreInfoTemp.swipeType==kSideRed? scoreInfoTemp.redSideScore:scoreInfoTemp.blueSideScore];
        if([self isDuringSleep:sideKey andScoreKey:scoreKey]){
            cmd = nil;
            [cmdHis removeObjectAtIndex:i];
            continue;
        }
        ScoreHistoryInfo *scoreHistoryInfo = [[ScoreHistoryInfo alloc]initWithInfo:nil andEndTime:nil andSideKey:sideKey andScoreKey:scoreKey andUuid: cmd.from];
        if(scoreInfos==nil){
            scoreInfos = [NSMutableDictionary dictionaryWithObjectsAndKeys: [NSMutableDictionary dictionaryWithObjectsAndKeys:scoreHistoryInfo,scoreKey,nil],sideKey,nil];
            if(!calcTimer.isValid){
                double maxDelay = chatRoom.gameInfo.gameSetting.serverLoopMaxDelay;
                //double maxDelay = 1;
                calcTimer =[NSTimer scheduledTimerWithTimeInterval: maxDelay/10.0 target:self selector:@selector(submitScore4Loop) userInfo:nil repeats:YES];
            }
        }else if([scoreInfos objectForKey:sideKey]==nil){
            //                ScoreHistoryInfo *scoreHistoryInfo = [[ScoreHistoryInfo alloc]initWithInfo:nil andEndTime:nil andSideKey:sideKey andScoreKey:scoreKey andUuid: cmd.from];
            [scoreInfos setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:scoreHistoryInfo,scoreKey,nil] forKey:sideKey];
        }
        else if([[scoreInfos objectForKey:sideKey] objectForKey:scoreKey]==nil){
            //                ScoreHistoryInfo *scoreHistoryInfo = [[ScoreHistoryInfo alloc]initWithInfo:nil andEndTime:nil andSideKey:sideKey andScoreKey:scoreKey andUuid: cmd.from];
            [[scoreInfos objectForKey:sideKey] setObject:scoreHistoryInfo forKey:scoreKey];
            //                if(!scoreHistoryInfo.calTimer.isValid){
            //                    scoreHistoryInfo.calTimer =[NSTimer scheduledTimerWithTimeInterval: maxDelay/10.0 target:self selector:@selector(sendScore) userInfo:nil repeats:YES];
            //                }
        }else if(![[[[scoreInfos objectForKey:sideKey] objectForKey:scoreKey] uuids] containsObject:cmd.from]){
            [[[[scoreInfos objectForKey:sideKey] objectForKey:scoreKey] uuids] addObject:cmd.from];
        }else{
            
        }
        
        cmd = nil;
        [cmdHis removeObjectAtIndex:i];
    }
    //        for (NSString *cltUuid in chatRoom.gameInfo.clients.allKeys) {
    //            if(![uuids containsObject:cltUuid]){
    //                return;//wait for next test
    //            }
    //        }
    //        [self submitScore:scoreInfo];
    
    //    } 
}

-(BOOL)isDuringSleep: (NSString *)_sideKey andScoreKey:(NSString *)_scoreKey{
    BOOL ret = NO;
    double dulTime = chatRoom.gameInfo.gameSetting.availTimeDuringScoreCalc;
    if(scoreInfos!=nil&& [scoreInfos objectForKey:_sideKey]!=nil&&[[scoreInfos objectForKey:_sideKey] objectForKey:_scoreKey]!=nil){
        ScoreHistoryInfo *scoreHistoryInfo = [[scoreInfos objectForKey:_sideKey] objectForKey:_scoreKey];
        if(scoreHistoryInfo!=nil && scoreHistoryInfo.endTime!=nil){
            if(fabs([scoreHistoryInfo.endTime timeIntervalSinceNow]) < dulTime){
                ret = YES;
            }else{
                [[scoreInfos objectForKey:_sideKey] removeObjectForKey:_scoreKey];
            }
        }
    }
    return ret;
}

-(BOOL)testPointGapReached;
{
    if(chatRoom.gameInfo.gameSetting.enableGapScore&&chatRoom.gameInfo.currentMatchInfo.currentRound>=chatRoom.gameInfo.gameSetting.pointGapAvailRound && fabs(chatRoom.gameInfo.currentMatchInfo.redSideScore-chatRoom.gameInfo.currentMatchInfo.blueSideScore)>=chatRoom.gameInfo.gameSetting.pointGap){
        [self setPointGapStateFor:YES];
        return YES;
    }
    else{
        [self setPointGapStateFor:NO];
        return NO;
    }    
}

-(void)setPointGapStateFor:(BOOL)hasReached
{
    if(hasReached){
        self.chatRoom.gameInfo.currentMatchInfo.pointGapReached=YES;
        [self pauseGame];
        BOOL drawRedGrayStype=chatRoom.gameInfo.currentMatchInfo.blueSideScore-chatRoom.gameInfo.currentMatchInfo.redSideScore>0;
        [self drawTotalScore:drawRedGrayStype andScore:drawRedGrayStype?chatRoom.gameInfo.currentMatchInfo.redSideScore:chatRoom.gameInfo.currentMatchInfo.blueSideScore andGrayStype:YES];
        if(![pointGapTimer isValid]){
            pointGapTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pointGapLoop) userInfo:nil repeats:YES];
        }
        [self showSelectWinnerButton:YES];
        [[BO_MatchInfo getInstance] saveObject:chatRoom.gameInfo.currentMatchInfo];
    }
    else{
        if(self.chatRoom.gameInfo.currentMatchInfo.pointGapReached){
            if([pointGapTimer isValid])
                [pointGapTimer invalidate];
            self.chatRoom.gameInfo.currentMatchInfo.pointGapReached=NO;
        }
        [self drawTotalScore:YES andScore:chatRoom.gameInfo.currentMatchInfo.redSideScore andGrayStype:chatRoom.gameInfo.currentMatchInfo.redSideWarning==chatRoom.gameInfo.gameSetting.maxWarningCount];
        [self drawTotalScore:NO andScore:chatRoom.gameInfo.currentMatchInfo.blueSideScore andGrayStype:chatRoom.gameInfo.currentMatchInfo.blueSideWarning==chatRoom.gameInfo.gameSetting.maxWarningCount];
        [self showSelectWinnerButton:NO];
    }
}

-(void)pointGapLoop
{
    static int PointWarningCount=0;
    BOOL isRedSide=chatRoom.gameInfo.currentMatchInfo.redSideScore-chatRoom.gameInfo.currentMatchInfo.blueSideScore>0;
    BOOL hidden=PointWarningCount%2==0;
    PointWarningCount++;
    /*
     比賽暫停，勝方分數閃數，敗方分數設定為灰色
     1. 當 相隔分數 設定為開啟
     2. 當 已到開始計算 相隔分數 回合
     3. 當分數已到相隔分數
     例如：相隔分數為12分，開始計算回合為第2回合
     例子1：第1回合，藍方12:紅方0，
     事件未能觸發（因未到開始回合）
     例子2：第2回合，藍方13:紅方1，
     事件觸發（因己達開始回合及分收己達相隔分數）
     */
    if(isRedSide){
        if(chatRoom.gameInfo.currentMatchInfo.redSideScore/10>0){
            imgRedScoreDoubleTen.hidden=hidden;
            imgRedScoreDoubleSin.hidden=hidden;
        }
        else{
            imgRedScoreSingle.hidden=hidden;
        }
    }
    else{
        if(chatRoom.gameInfo.currentMatchInfo.blueSideScore/10>0){
            imgBlueScoreDoubleTen.hidden=hidden;
            imgBlueScoreDoubleSin.hidden=hidden;
        }
        else{
            imgBlueScoreSingle.hidden=hidden;
        }
    }
}
//timout隐藏分数指示
-(void)reportScoreIndicatorLoop:(NSTimer *)timerIns
{
    NSArray *userInfo=timerIns.userInfo;
    NSNumber *inx=[userInfo objectAtIndex:0];
    SwipeType swType=[[userInfo objectAtIndex:1] intValue];
    NSArray *scoreReportIndicators=swType== kSideRed?scoreReportIndicatorsRed:scoreReportIndicatorsBlue;
    UIImageView *img= [scoreReportIndicators objectAtIndex:[inx intValue]];
    img.hidden=YES;
}
//如果分数有效闪动同种分数
-(void)effectivedSubmitScoreTip:(ScoreHistoryInfo *)score
{
    NSMutableArray *relatedJudges=[[NSMutableArray alloc] initWithCapacity:4];
    NSMutableArray *scoreReportIndicators;
    NSMutableDictionary *scoreReportIndicatorTimers;
    if(score.sideKey==@"red"){
        scoreReportIndicators=scoreReportIndicatorsRed;
        scoreReportIndicatorTimers=scoreReportIndicatorTimersRed;
    }else{
        scoreReportIndicators=scoreReportIndicatorsBlue;
        scoreReportIndicatorTimers=scoreReportIndicatorTimersBlue;
    }   
    //关闭之前的消失图片循环、显示有效分数图片
    for (NSString *uuid in score.uuids) {
        if([scoreReportIndicatorTimers containKey:uuid]){
            NSTimer *timerIns = [scoreReportIndicatorTimers objectForKey:uuid];
            [timerIns invalidate];
        }
        JudgeClientInfo *clt=[chatRoom.gameInfo.clients objectForKey:uuid];
        [relatedJudges addObject:[scoreReportIndicators objectAtIndex:clt.sequence-1]];
    }
    for (UIImageView *img in relatedJudges) {
        img.hidden=NO;
    }  
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(effectivedSubmitScoreTipLoop:) userInfo:[[NSArray alloc] initWithObjects:relatedJudges,[NSDate date], nil] repeats:YES];
}
//闪动结束隐藏
-(void)effectivedSubmitScoreTipLoop:(NSTimer *)timerIns
{
    NSArray *info= [timerIns userInfo];
    NSMutableArray *relatedJudges=[info objectAtIndex:0];
    NSDate * startDate=[info objectAtIndex:1];    
    if(fabs([startDate timeIntervalSinceNow])<chatRoom.gameInfo.gameSetting.serverLoopMaxDelay/3){
        for (UIImageView *img in relatedJudges) {
            img.hidden=!img.hidden;
        }
    }
    else{
        for (UIImageView *img in relatedJudges) {
            img.hidden=YES;
        }
        [timerIns invalidate];
    }
}
#pragma mark -
#pragma mark cmd handler
// We are being asked to process cmd
- (void)processCmd:(CommandMsg *)cmdMsg {
    //NSLog(@"Receive Client Command:%@",cmdMsg);
    switch ([cmdMsg.type intValue]) {
        case NETWORK_REPORT_SCORE:
        {
            //NSLog(@"msg date:%f",[cmdMsg.date timeIntervalSince1970]);
            //NSLog(@"receive date:%f",[[NSDate date] timeIntervalSince1970]);
            //NSLog(@"%f",[cmdMsg.date timeIntervalSince1970]-[[NSDate date] timeIntervalSince1970]);
            if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRunning||chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateCalcScore)
            {
                [self setMenuByGameStatus:kStateCalcScore];
                cmdMsg.date=[NSDate date];                
                JudgeClientInfo *cltInfo = [chatRoom.gameInfo.clients objectForKey:cmdMsg.from];
                if(cltInfo!=nil){
                    //显示分数指示
                    ScoreInfo* scoreInfoTemp = [[ScoreInfo alloc]initWithDictionary: cmdMsg.data];
                    scoreInfoTemp.gameId=chatRoom.gameInfo.gameId;
                    scoreInfoTemp.clientId=cltInfo.clientId;
                    scoreInfoTemp.clientUuid=cltInfo.uuid;
                    scoreInfoTemp.matchId=chatRoom.gameInfo.currentMatchInfo.matchId;
                    scoreInfoTemp.roundSeq=chatRoom.gameInfo.currentMatchInfo.currentRound;
                    [[BO_ScoreInfo getInstance] insertObject:scoreInfoTemp];
                    NSMutableArray *scoreReportIndicators;
                    NSMutableDictionary *scoreReportIndicatorTimers;
                    int score;
                    if(scoreInfoTemp.swipeType== kSideRed){
                        scoreReportIndicators=scoreReportIndicatorsRed;
                        scoreReportIndicatorTimers=scoreReportIndicatorTimersRed;
                        score=scoreInfoTemp.redSideScore;
                    }
                    else{
                        scoreReportIndicators=scoreReportIndicatorsBlue;
                        scoreReportIndicatorTimers=scoreReportIndicatorTimersBlue;
                        score=scoreInfoTemp.blueSideScore;
                    }
                    UIImageView *img= [scoreReportIndicators objectAtIndex:cltInfo.sequence-1];
                    img.hidden=NO;
                    img.backgroundColor=[scoreReportPointColors objectForKey:[NSString stringWithFormat:@"%i",score]];
                    NSTimer *reportTimer=[scoreReportIndicatorTimers objectForKey:
                                          [NSString stringWithFormat:@"%i",cltInfo.sequence-1]];
                    if(reportTimer!=nil){
                        [reportTimer invalidate];
                    }
                    reportTimer =[NSTimer scheduledTimerWithTimeInterval:chatRoom.gameInfo.gameSetting.serverLoopMaxDelay*2/3 target:self selector:@selector(reportScoreIndicatorLoop:) userInfo:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:cltInfo.sequence-1],[NSNumber numberWithInt:scoreInfoTemp.swipeType], nil] repeats:NO];
                    [scoreReportIndicatorTimers setObject:reportTimer forKey:[NSString stringWithFormat:@"%i",cltInfo.sequence-1]];
                    //                    cmdMsg.data=scoreInfoTemp;
                }
                //                else{
                //                    cmdMsg.data=nil;
                //                }
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
        case NETWORK_HEARTBEAT:
        {
            [self processHearbeatWithClientUuid:cmdMsg.from];            
        }
            break;
        case  NETWORK_CLIENT_INFO:
        {             
            JudgeClientInfo *cltInfo =[[JudgeClientInfo alloc] initWithDictionary:   cmdMsg.data];
            JudgeClientInfo *cltInfoOld=[chatRoom.gameInfo.clients objectForKey:cltInfo.uuid];
            if(cltInfoOld==nil)
            {
                //if all client connected,new client is invalid
                if(chatRoom.gameInfo.clients.count==chatRoom.gameInfo.gameSetting.judgeCount){
                    [self sendDenyClientToConnectInfo:cltInfo];
                    return;
                }                                   
                //new client connected
                cltInfo.sequence=chatRoom.gameInfo.clients.count+1;
                cltInfo.clientId=[UtilHelper stringWithUUID];
                cltInfo.gameId=chatRoom.gameInfo.gameId;
                [chatRoom.gameInfo.clients setObject:cltInfo forKey:cltInfo.uuid];
                [self processHearbeatWithClientUuid:cltInfo.uuid];
                [[BO_JudgeClientInfo getInstance] saveObject:cltInfo];
            }
            else{
                cltInfoOld.peerId=cltInfo.peerId;
                cltInfoOld.uuid=cltInfo.uuid;
                cltInfoOld.displayName=cltInfo.displayName;
                [self processHearbeatWithClientUuid:cltInfoOld.uuid];
                [[BO_JudgeClientInfo getInstance] saveObject:cltInfoOld];
            }
            
            
            [self sendServerWholeInfo];
        }
            break;
        default:
            break;
    }
}
//处理客户端的心跳
-(void)processHearbeatWithClientUuid:(NSString *)uuid{
    JudgeClientInfo *cltInfoOld=[chatRoom.gameInfo.clients objectForKey:uuid];
    if(cltInfoOld==nil)//一般不会进入到本情况
    {
        return;
    }
    else
    {
        cltInfoOld.lastHeartbeatDate=[NSDate date];
        if(!cltInfoOld.hasConnected){          
            [self refreshGamesettingDialogJudges];
            cltInfoOld.hasConnected=YES;                    
            cltInfoOld.lastHeartbeatDate=[NSDate date];
            [self refreshGamesettingDialogJudges];
            if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateWaitJudge){
                //wait for judge
                [self showWaitingUserBox];                
                return;
            }
            if([self testSomeClientDisconnect]){
                //still some one disconnect                        
                [self showWaitingUserBox];
            }
            else{
                //every one back to game
                if(!isAtMatchSetting){
                    chatRoom.gameInfo.currentMatchInfo.gameStatus=chatRoom.gameInfo.currentMatchInfo.preGameStatus;
                    if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRunning)
                        [self contiueGame];
                    else
                    {
                        if(waitUserPanel!=nil&&[self.view.subviews containsObject:waitUserPanel]){
                            [waitUserPanel removeFromSuperview];
                            //waitUserPanel=nil;
                        }
                        if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRoundReset)
                        {
                            [roundResetPanel setTimerStop:NO];
                        }
                    }
                }else{
                    //                    if(chatRoom.gameInfo.preGameStatus==kStateRunning)
                    //                        chatRoom.gameInfo.currentMatchInfo.gameStatus=kStateGamePause;
                }
            }
            [[BO_JudgeClientInfo getInstance] updateObject:cltInfoOld];
        }else{
            static int RECORD_INTERVAL=1;
            //if(RECORD_INTERVAL%5==0)
            //[[BO_JudgeClientInfo getInstance] updateObject:cltInfoOld];
            RECORD_INTERVAL++;
        }
    }
}
//发送服务器状态，在服务器游戏状态变化时发送
-(void)sendServerStatusAndDesc:(NSString *)desc
{
    if(chatRoom.gameInfo.gameSetting.currentJudgeDevice==JudgeDeviceiPhone){
        chatRoom.gameInfo.serverLastHeartbeatDate=[NSDate date];
        CommandMsg *reconnectCmd=[[CommandMsg alloc] initWithType:NETWORK_SERVER_STATUS andFrom:nil
                                                          andDesc:desc andData:[NSNumber numberWithInt:chatRoom.gameInfo.currentMatchInfo.gameStatus] andDate:nil];
        [chatRoom sendCommand:reconnectCmd andPeerId:nil andSendDataReliable:YES];
    }
}
//发送完整服务器信息，主要用于首次与服务器沟通时
-(void)sendServerWholeInfo
{
    if(chatRoom.gameInfo.gameSetting.currentJudgeDevice==JudgeDeviceiPhone){
        GameInfo *gi=chatRoom.gameInfo;
        CommandMsg *reconnectCmd=[[CommandMsg alloc] initWithType:NETWORK_SERVER_WHOLE_INFO andFrom:nil 
                                                          andDesc:nil andData:gi andDate:nil];
        [chatRoom sendCommand:reconnectCmd andPeerId:nil andSendDataReliable:YES];
    }
}
//发送心跳，不带任何额外信息
-(void)sendServerHearbeat
{if(chatRoom.gameInfo.gameSetting.currentJudgeDevice==JudgeDeviceiPhone){
    CommandMsg *reconnectCmd=[[CommandMsg alloc] initWithType:NETWORK_HEARTBEAT andFrom:nil 
                                                      andDesc:nil andData:[NSNumber numberWithInt:chatRoom.gameInfo.currentMatchInfo.gameStatus] andDate:nil];
    [chatRoom sendCommand:reconnectCmd andPeerId:nil andSendDataReliable:YES];
}
}
//拒绝非法客户端连接
-(void)sendDenyClientToConnectInfo:(JudgeClientInfo*)client
{if(chatRoom.gameInfo.gameSetting.currentJudgeDevice==JudgeDeviceiPhone){
    if(client==nil)
        return;
    CommandMsg *reconnectCmd=[[CommandMsg alloc] initWithType:NETWORK_INVALID_CLIENT andFrom:nil 
                                                      andDesc:@"Invalid client" andData:nil andDate:nil];
    [chatRoom sendCommand:reconnectCmd andPeerId:client.peerId andSendDataReliable:YES];
    [chatRoom.bluetoothServer.serverSession disconnectPeerFromAllPeers:client.peerId];
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
- (IBAction)exit {
    [self exitProcess];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(stopRoom) userInfo:nil repeats:NO];
}
- (void)exitWithSettingInfo:(NSArray *)nextProfileInfo
{
    [self exitProcess];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(stopRoomNextMatch:) userInfo:nextProfileInfo repeats:NO];
}
// User decided to exit room
- (void)exitProcess {
    [AppConfig getInstance].isGameStart=NO;
    // Close the room
    chatRoom.gameInfo.gameEnded=YES;
    chatRoom.gameInfo.gameEndTime=[NSDate date];
    [self setMenuByGameStatus:kStateGameExit];
    [self sendServerStatusAndDesc:nil];
    //[[AppConfig getInstance].invalidServerPeerIds addObject:chatRoom.bluetoothServer.serverSession.peerID];
    
    // Remove keyboard
    
    // Erase chat
    [self eraseText];
    //lblBlueTotal.text=@"0";
    //lblRedTotal.text=@"0";
    //lblGameName.text=@"";
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
    [[BO_GameInfo getInstance] updateObject:chatRoom.gameInfo];
    chatRoom.gameInfo=nil;    
    
}
//stop peer server
-(void)stopRoom
{
    [chatRoom stop];
    if([AppConfig getInstance].isIPAD)
        [[ChattyAppDelegate getInstance] showGameSettingView];
    else
        [[ChattyAppDelegate getInstance] showRoomSelection];
}
//以选定的profile开始新的比赛
-(void)stopRoomNextMatch:(NSTimer *)timerIns
{
    [chatRoom stop];    
    NSString *profileId=[[timerIns userInfo] objectAtIndex:0];
    int nextCourtValue=[[[timerIns userInfo] objectAtIndex:1] intValue];
    ServerSetting *setting = [[BO_ServerSetting getInstance] queryObjectById:profileId];
    setting.lastUsingDate=[NSDate date];
    [[BO_ServerSetting getInstance] updateObject:setting];
    setting.startScreening = nextCourtValue;
    [AppConfig getInstance].currentGameInfo =[[GameInfo alloc] initWithGameSetting:setting];
    [[AppConfig getInstance].currentGameInfo resetGameInfoToStart];
    [AppConfig getInstance].currentGameInfo.serverFullName=[AppConfig getInstance].currentGameInfo.gameSetting.serverName;
    [[BO_GameInfo getInstance] AddGameInfo:[AppConfig getInstance].currentGameInfo];
    LocalRoom* room = [[LocalRoom alloc] initWithGameInfo:[AppConfig getInstance].currentGameInfo];
    room.isRestoredGame=false;
    [[ChattyAppDelegate getInstance] showScoreBoard:room];
}

//erase warning flags
- (void)eraseText {
    
}

//show waiting for user
-(void)showWaitingUserBox
{
    [self pauseTime:YES];
    if(self.view.subviews==nil)
        return;
    if(waitUserPanel==nil)
    {
        __block typeof (self) me = self;
        waitUserPanel = [[UIWaitForUserViewController alloc] initWithFrame:self.view.bounds title:@"Connecting Referee"];
        waitUserPanel.needConnectedClientCount=chatRoom.gameInfo.gameSetting.judgeCount;
        waitUserPanel.onClosePressed = ^(UAModalPanel* panel) {
            // [panel hide];
            UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"End Game" message:@"Continue to end the game?" delegate:me cancelButtonTitle:@"Cancel" otherButtonTitles:@"End", nil];
            [alertView show];            
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
-(void) backToHome
{
    AlertView *confirmBox= [[AlertView alloc] initWithTitle:NSLocalizedString(@"Warmning", @"") message:NSLocalizedString(@"Do you want to end this game?", @"")];
    [confirmBox addButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:[^(AlertView* a, NSInteger i){
        
    } copy]];
    [confirmBox addButtonWithTitle:NSLocalizedString(@"Exit", @"") block:[^(AlertView* a, NSInteger i){
        [self exit];
    } copy]];
    [confirmBox show];
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
#pragma mark -
#pragma mark Game Logic Process
//prepare for game to start
-(void)prepareForGame
{    
    isAtMatchSetting=NO;    
    if(timeFlags==nil)
    {
        timeFlags=[[NSMutableArray alloc] initWithCapacity:10];
        for (int i=0; i<10; i++) {
            [timeFlags addObject:[UIImage imageNamed:[NSString stringWithFormat:@"time_%i",i]]];
        }
    }
    if(timeFlags2==nil)
    {
        timeFlags2=[[NSMutableArray alloc] initWithCapacity:10];
        for (int i=0; i<10; i++) {
            [timeFlags2 addObject:[UIImage imageNamed:[NSString stringWithFormat:@"time_s2_%i",i]]];
        }
    }
    if(marksFlags==nil)
    {
        marksFlags=[[NSMutableArray alloc] initWithCapacity:10];
        for (int i=0; i<10; i++) {
            [marksFlags addObject:[UIImage imageNamed:[NSString stringWithFormat:@"marks_%i",i]]];
        }
    }
    if(marksGrayFlags==nil){
        marksGrayFlags=[[NSMutableArray alloc] initWithCapacity:10];
        for (int i=0; i<10; i++) {
            [marksGrayFlags addObject:[UIImage imageNamed:[NSString stringWithFormat:@"marks_gray_%i",i]]];
        }
    }
    //显示报分项
    if(scoreReportIndicatorsBlue==nil){
        scoreReportIndicatorsBlue=[[NSMutableArray alloc] initWithObjects:imgScoreReportBlue1,imgScoreReportBlue2,imgScoreReportBlue3,imgScoreReportBlue4, nil];
    }
    if(scoreReportIndicatorTimersBlue==nil){
        scoreReportIndicatorTimersBlue=[[NSMutableDictionary alloc] initWithCapacity:4];
    }
    if(scoreReportIndicatorsRed==nil){
        scoreReportIndicatorsRed=[[NSMutableArray alloc] initWithObjects:imgScoreReportRed1,imgScoreReportRed2,imgScoreReportRed3,imgScoreReportRed4, nil];
    }
    if(scoreReportIndicatorTimersRed==nil){
        scoreReportIndicatorTimersRed=[[NSMutableDictionary alloc] initWithCapacity:4];
    }
    if(scoreReportPointColors==nil){
        scoreReportPointColors=[[NSDictionary alloc] initWithObjectsAndKeys:[UIColor grayColor],@"1", [UIColor greenColor],@"2",[UIColor yellowColor],@"3",[UIColor orangeColor],@"4",nil];
    }
    if(imgDecicade==nil)
        imgDecicade=[UIImage imageNamed:@"dedecade_flag"];
    if(imgWarning==nil)
        imgWarning =[UIImage imageNamed:@"warning_flag"];
    if(!chatRoom.isRestoredGame){
        [self setMenuByGameStatus:kStatePrepareGame];
    }
    if (chatRoom != nil ) {
        chatRoom.delegate = self;
        [chatRoom start];
    }
    if(!chatRoom.isRestoredGame){
        [self resetRound:YES];    
    }
    else{
        [self drawLayoutByGameInfo];
    }
    //恢复原来的圆形菜单，2012-11-24
    [self setupMenu];    
    if(chatRoom.isRestoredGame)
    {
        if(chatRoom.gameInfo.clients!=nil)
        {
            for (JudgeClientInfo *clt in chatRoom.gameInfo.clients.allValues) {
                clt.hasConnected=NO;
            }
        }
    }
    else{
        //如果是非iphone作为客户端，直接视为已连接
        if(chatRoom.gameInfo.gameSetting.currentJudgeDevice!=JudgeDeviceiPhone)  
        {
            for (int i=1; i<=chatRoom.gameInfo.gameSetting.judgeCount; i++) {
                JudgeClientInfo *cltInfo=[[JudgeClientInfo alloc] initWithSessionId:@"TKD Score"andDisplayName:[NSString stringWithFormat:@"Referee %i",i] andUuid:[NSString stringWithFormat:@"%i",i] andPeerId:[NSString stringWithFormat:@"Referee Peer Id %i",i]];
                cltInfo.sequence=chatRoom.gameInfo.clients.count+1;
                cltInfo.hasConnected=NO;
                cltInfo.gameId=chatRoom.gameInfo.gameId;
                [chatRoom.gameInfo.clients setValue:cltInfo forKey:cltInfo.uuid];
                [[BO_JudgeClientInfo getInstance] saveObject:cltInfo];
            }           
        }
    }
    fighterPanel.delegate=self;
    fighterPanel.imgArray=timeFlags2;
    [fighterPanel hide];
    [self setMenuByGameStatus:kStateWaitJudge];
    [self showWaitingUserBox];
    double inv=kServerLoopInterval;
    [[BO_GameInfo getInstance] updateObject:chatRoom.gameInfo];
    [[BO_ServerSetting getInstance] updateObject:chatRoom.gameInfo.gameSetting];
    gameLoopTimer=[NSTimer scheduledTimerWithTimeInterval:inv target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

-(CGPoint)calMenuCenter:(int)index
{
    float centerX=25.0+50.0*index;
    float centerY=25.0f;
    return CGPointMake(centerX, centerY);
}
//set up bottom menu
-(void)setupMenu
{
    self.actionHeaderView = [[DDActionHeaderView alloc] initWithFrame:self.view.bounds];
	
    // Set title
    self.actionHeaderView.titleLabel.text = @"";
	CGRect iconRect = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    UIEdgeInsets iconEdge = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    NSMutableArray *menuItems = [[NSMutableArray alloc] initWithCapacity:5];
    int i=0;
    
    // Create action items, have to be UIView subclass, and set frame position by yourself.
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    menuButton.frame = iconRect;
    menuButton.imageEdgeInsets = iconEdge;
    menuButton.center = [self calMenuCenter:i++];
    menuButton.tag=kMenuItemMenu;
    [menuItems addObject:menuButton];
    
    UIButton *endMatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [endMatchButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [endMatchButton setImage:[UIImage imageNamed:@"end-match"] forState:UIControlStateNormal];
    endMatchButton.frame = iconRect;
    endMatchButton.imageEdgeInsets = iconEdge;
    endMatchButton.center = [self calMenuCenter:i++];
	endMatchButton.tag=kMenuItemEndMatch;
    [menuItems addObject:endMatchButton];
    
    UIButton *continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [continueButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [continueButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    continueButton.frame = iconRect;
    continueButton.imageEdgeInsets = iconEdge;
    continueButton.center = [self calMenuCenter:i++];
    continueButton.tag=kMenuItemContinueGame;
    [menuItems addObject:continueButton];
    
    UIButton *enableTimerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [enableTimerButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [enableTimerButton setImage:[UIImage imageNamed:@"enable-timer"] forState:UIControlStateNormal];
    enableTimerButton.frame = iconRect;
    enableTimerButton.imageEdgeInsets = iconEdge;
    enableTimerButton.center = [self calMenuCenter:i++];
    enableTimerButton.tag=kMenuItemRestReorgernizeTimer;
    [menuItems addObject:enableTimerButton];
    
    UIButton *flightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [flightButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [flightButton setImage:[UIImage imageNamed:@"fight"] forState:UIControlStateNormal];
    flightButton.frame = iconRect;
    flightButton.imageEdgeInsets = iconEdge;
    flightButton.center = [self calMenuCenter:i++];
    flightButton.tag=kMenuItemFlight;
    [menuItems addObject:flightButton];
    
    UIButton *txtReportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [txtReportButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [txtReportButton setImage:[UIImage imageNamed:@"txn-report"] forState:UIControlStateNormal];
    txtReportButton.frame = iconRect;
    txtReportButton.imageEdgeInsets = iconEdge;
    txtReportButton.center = [self calMenuCenter:i++];
    txtReportButton.tag=kMenuItemTxnReport;
    [menuItems addObject:txtReportButton];
    
    /*
     // Create action items, have to be UIView subclass, and set frame position by yourself.
     UIButton *redWarningButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [redWarningButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
     [redWarningButton setImage:[UIImage imageNamed:@"minus-red"] forState:UIControlStateNormal];
     redWarningButton.frame = iconRect;
     redWarningButton.imageEdgeInsets = iconEdge;
     redWarningButton.center = [self calMenuCenter:i++];
     redWarningButton.tag=kMenuItemWarningRed;
     [menuItems addObject:redWarningButton];
     
     UIButton *blueWarningButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [blueWarningButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
     [blueWarningButton setImage:[UIImage imageNamed:@"minus-blue"] forState:UIControlStateNormal];
     blueWarningButton.frame = iconRect;
     blueWarningButton.imageEdgeInsets = iconEdge;
     blueWarningButton.center = [self calMenuCenter:i++];
     blueWarningButton.tag=kMenuItemWarningBlue;
     [menuItems addObject:blueWarningButton];
     
     UIButton *nextMatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [nextMatchButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
     [nextMatchButton setImage:[UIImage imageNamed:@"next-match"] forState:UIControlStateNormal];
     nextMatchButton.frame = iconRect;
     nextMatchButton.imageEdgeInsets = iconEdge;
     nextMatchButton.center = [self calMenuCenter:i++];
     nextMatchButton.tag=kMenuItemNextMatch;
     [menuItems addObject:nextMatchButton];
     */
    /*
     UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [exitButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
     [exitButton setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
     exitButton.frame = iconRect;
     exitButton.imageEdgeInsets = iconEdge;
     exitButton.center = CGPointMake(275.0f, 25.0f);
     exitButton.tag=kMenuItemExit;
     [menuItems addObject:exitButton];
     */
    
    // Set action items, and previous items will be removed from action picker if there is any.
    self.actionHeaderView.items = menuItems;		
    [self.view addSubview:self.actionHeaderView];
    float actionWidth=(iconRect.size.width)*(menuItems.count+0.5);
    [self.actionHeaderView setFrame:CGRectMake(self.actionHeaderView.bounds.size.width - actionWidth, self.actionHeaderView.frame.origin.y, actionWidth, self.actionHeaderView.frame.size.height)];
}
- (void)menuItemAction:(id)sender{
    
    // Reset action picker
    int tag=[(UIButton *)sender tag];
    switch (tag) {
        case kMenuItemMenu://收缩显示菜单
            [self.actionHeaderView shrinkActionPicker];
            break;
        case kMenuItemExit://退出游戏
        {
            [self backToHome];
        }
            break;
        case kMenuItemEndMatch://结束比赛,选择胜利者
        {
            if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRunning)
            {
                [self pauseGame];
            }
            [self showSelectWinnerBox];
        }
            break;
        case kMenuItemContinueGame://继续，暂停比赛
            if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateGamePause)
            {
                [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
                [self contiueGame];
            }
            else{
                [self pauseGame];
                [sender setImage:[UIImage imageNamed:@"continue"] forState:UIControlStateNormal];
            }
            break;            
        case  kMenuItemNextMatch://进入下一场比赛
            [self goToNextMatch];
            break;
        case  kMenuItemWarningBlue://警告蓝方
            [self warningPlayer:NO andCount:1];
            break;
        case  kMenuItemWarningRed://警告红方
            [self warningPlayer:YES andCount:1];
            break;
        case kMenuItemRestReorgernizeTimer://显示休整时间
        {
            [self gamePauseAndShowReorignizeTimeBox];
        }
            break;
        case kMenuItemTxnReport://显示报表项
        {
            [self showGameSettingDialogWithViewIndex:3];
        }
            break;
        case kMenuItemFlight://显示对战框
        {
            [self toggleFightTimeBox];
            break;
        }
        default:
            break;
    }
    //self.actionHeaderView.hidden=YES;
    [self.actionHeaderView shrinkActionPicker];
}

//start round
-(void)startRound:(id)sender
{    
    [player playSoundWithFullPath:kSoundsRoundStart];
    if([self testPointGapReached]||chatRoom.gameInfo.currentMatchInfo.warningMaxReached){
        return;
    }
    waitUserPanel=nil;
    /*Do not start timmer automatically when start match/round*/
    /*
     if(timer==nil){
     timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatTime) userInfo:nil repeats:YES];
     } 
     [self setMenuByGameStatus:kStateRunning]; 
     */
    [self pauseGame];
}
-(void)waitUserStartPress:(id)sender{
    if(!chatRoom.gameInfo.gameStart){
        chatRoom.gameInfo.gameStart=YES;
        chatRoom.gameInfo.gameStartTime=[NSDate date];
        [[BO_GameInfo getInstance] updateObject:chatRoom.gameInfo];
    } 
    
    [self pauseGame];
}
-(void)contiueGame
{    
    if(waitUserPanel!=nil&&[self.view.subviews containsObject:waitUserPanel]){
        [waitUserPanel removeFromSuperview];
        waitUserPanel=nil;
    }    
    [self pauseTime:NO];
    [self setMenuByGameStatus:kStateRunning];
    [self drawRemainTime:chatRoom.gameInfo.currentMatchInfo.currentRemainTime];
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
            [self pauseGame];
            //[self contiueGame];
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
            //更新时间的精密度变成毫秒级别
            timer = [NSTimer scheduledTimerWithTimeInterval:kUpdateTimeInterval target:self selector:@selector(updatTime) userInfo:nil repeats:YES];            
        }
    }
}
-(void)pauseGame
{
    [self pauseTime:YES];
    [self setMenuByGameStatus:kStateGamePause];
    [self drawRemainTime:chatRoom.gameInfo.currentMatchInfo.currentRemainTime];
}
//toggle game status to pause or continue
-(void)gamePauseContinueToggle{
    if(self.chatRoom.gameInfo.currentMatchInfo.pointGapReached||self.chatRoom.gameInfo.currentMatchInfo.warningMaxReached)
    {
        return;
    }
    if(roundResetPanel!=nil&&roundResetPanel.superview!=nil)
    {
        return;
    }
    if(chatRoom.gameInfo.currentMatchInfo.gameStatus== kStateGamePause||chatRoom.gameInfo.currentMatchInfo.gameStatus== kStateCalcScore){
        [self contiueGame];
    }
    else if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRunning){
        [self pauseGame];
    }
    
}
//pause game and show resetime box
-(void)gamePauseAndShowReorignizeTimeBox
{
    if (chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRunning || chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateCalcScore) {        
        [self pauseGame];
        [self showRoundRestTimeBox:chatRoom.gameInfo.gameSetting.restAndReorganizationTime andEventType:krestAndReOrgTime];
        [self setMenuByGameStatus:chatRoom.gameInfo.currentMatchInfo.gameStatus];
    }
}
//重置回合信息
-(void)resetRound:(BOOL)init;
{
    chatRoom.gameInfo.currentMatchInfo.currentRemainTime=chatRoom.gameInfo.gameSetting.roundTime;
    //chatRoom.gameInfo.redSideScore=0;
    //chatRoom.gameInfo.blueSideScore=0;
    if(init)
        chatRoom.gameInfo.currentMatchInfo.currentRound=1;    
    else
        chatRoom.gameInfo.currentMatchInfo.currentRound=chatRoom.gameInfo.currentMatchInfo.currentRound+1;
    [self drawLayoutByGameInfo];
    [[BO_MatchInfo getInstance] saveObject:chatRoom.gameInfo.currentMatchInfo];
}
-(void)goToNextMatchWithProfileId:(NSString *)profileId startCourt:(int)courtSeq
{if([pointGapTimer isValid])
    [pointGapTimer invalidate];
    if([warningMaxTimer isValid])
        [warningMaxTimer invalidate];
    
    //todo
    /*
     [chatRoom.gameInfo rollToNextMatch];
     [self resetRound:YES];
     [self startRound:nil];
     [[BO_GameInfo getInstance] updateObject:chatRoom.gameInfo];
     [[BO_MatchInfo getInstance] saveObject:chatRoom.gameInfo.currentMatchInfo];
     */
    [[BO_GameInfo getInstance] updateAllGameInfo:chatRoom.gameInfo];
    [self exitWithSettingInfo:[[NSArray alloc] initWithObjects:profileId,[NSNumber numberWithInt:courtSeq],nil]];
}
-(void)goToNextMatch
{
    [self goToNextMatchWithProfileId:chatRoom.gameInfo.gameSetting.profileId startCourt:chatRoom.gameInfo.gameSetting.startScreening+chatRoom.gameInfo.gameSetting.skipScreening];
}

#pragma mark -
#pragma mark Game Status Process
//game loop here,send server's status to clients
-(void)gameLoop
{
    static int counter = 0;        
    counter++;
    GameStates status=chatRoom.gameInfo.currentMatchInfo.gameStatus;
    //this status not need to test connection
    if (status==kStatePrepareGame||status==kStateGameExit||status== kStateGameEnd) {
        return;     
    } 
    if(chatRoom.gameInfo.gameSetting.currentJudgeDevice==JudgeDeviceiPhone){
        // once every 8 updates check if we have a recent heartbeat from the other player, and send a heartbeat packet with current state        
        if(counter%(int)(kServerHeartbeatTimeInterval/kServerLoopInterval)==0) {            
            [self sendServerHearbeat];
        }
        
        if(counter%(int)(kServerTestClientHearbeatTime/kServerLoopInterval)==0){
            [self testSomeClientDisconnect];         
        }    
    }
	[self processByGameStatus];
}
-(void)processByGameStatus
{
    switch (chatRoom.gameInfo.currentMatchInfo.gameStatus) {
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
    //NSLog(@"test client connected(elasped time)");
    BOOL hasDisconnect=NO;
    double inv=kServerTestClientHearbeatTime;
    //NSLog(@"tesc disconnect:%i",chatRoom.gameInfo.clients.count);
    for (JudgeClientInfo *clt in chatRoom.gameInfo.clients.allValues) {
        //NSLog(@"test client %@ heartbeat(elasped time):%d",clt.displayName, fabs([clt.lastHeartbeatDate timeIntervalSinceNow]) >= inv);
        if(!clt.hasConnected)
            hasDisconnect=YES;
        else if(clt.lastHeartbeatDate!=nil && fabs([clt.lastHeartbeatDate timeIntervalSinceNow]) >= inv) {
            hasDisconnect=YES;
            if(clt.hasConnected){
                clt.hasConnected=NO;            
                [[BO_JudgeClientInfo getInstance] updateObject:clt];
            }    
        }
    }
    if(hasDisconnect){
        if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRoundReset)
            [roundResetPanel setTimerStop:YES];
        [self showWaitingUserBox];
        if(chatRoom.gameInfo.currentMatchInfo.gameStatus!=kStateMultiplayerReconnect&&chatRoom.gameInfo.currentMatchInfo.gameStatus!=kStateWaitJudge){
            [self setMenuByGameStatus:kStateMultiplayerReconnect];            
        }
    }
    else{
        [self refreshGamesettingDialogJudges];
    }
    //GKSession *gk=chatRoom.bluetoothServer.serverSession;
    //NSLog(@"available:%i",gk.isAvailable);    
    return hasDisconnect;           
}

-(void)setMenuByGameStatus:(GameStates)status;
{
    [self showSelectWinnerButton:NO];
    if(chatRoom.gameInfo.currentMatchInfo.gameStatus!=kStateMultiplayerReconnect){
        chatRoom.gameInfo.currentMatchInfo.preGameStatus=chatRoom.gameInfo.currentMatchInfo.gameStatus;
    }
    chatRoom.gameInfo.currentMatchInfo.gameStatus = status;
    NSLog(@"Game Status:%i,Previous Status:%i",chatRoom.gameInfo.currentMatchInfo.gameStatus,chatRoom.gameInfo.currentMatchInfo.preGameStatus);
    [self sendServerStatusAndDesc:nil];
    [self processByGameStatus];
    
    UIButton *continueButton=[self getMenuItem:kMenuItemContinueGame];
    UIButton *endMatchButton=[self getMenuItem:kMenuItemEndMatch];
    UIButton *enableTimerButton=[self getMenuItem:kMenuItemRestReorgernizeTimer];
    UIButton *enableFightButton=[self getMenuItem:kMenuItemFlight];
    UIButton *txnReportButton=[self getMenuItem:kMenuItemTxnReport];
    
    continueButton.hidden=(self.chatRoom.gameInfo.currentMatchInfo.pointGapReached||self.chatRoom.gameInfo.currentMatchInfo.warningMaxReached)||(roundResetPanel!=nil&&roundResetPanel.superview!=nil);
    endMatchButton.hidden=!chatRoom.gameInfo.gameStart;
    enableTimerButton.hidden=!(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRunning || chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateCalcScore);
    enableFightButton.hidden=NO;
    txnReportButton.hidden=!chatRoom.gameInfo.gameStart;
    if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRunning || chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateCalcScore)
    {
        enableFightButton.hidden=NO;
    }
    else{
        enableFightButton.hidden=YES;
    }
    if(!fighterPanel.hidden&&!(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRunning || chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateCalcScore)){
        [fighterPanel hide];
    }
    
    //UIButton *redWarningButton=[self getMenuItem:kMenuItemWarningRed];
    //UIButton *blueWarningButton=[self getMenuItem:kMenuItemWarningBlue];
    //UIButton *nextMatchButton=[self getMenuItem:kMenuItemNextMatch];
    /*
     if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateGameEnd)
     {
     continueButton.hidden=YES;
     endMatchButton.hidden=YES;
     //redWarningButton.hidden=YES;
     //blueWarningButton.hidden=YES;
     //nextMatchButton.hidden=NO;
     }
     else if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRunning)
     {
     continueButton.hidden=NO;
     endMatchButton.hidden=NO;
     //redWarningButton.hidden=NO;
     //blueWarningButton.hidden=NO;
     //nextMatchButton.hidden=YES;
     }else{
     if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateGamePause)
     continueButton.hidden=NO;
     else
     continueButton.hidden=YES;
     
     //redWarningButton.hidden=YES;
     //blueWarningButton.hidden=YES;
     //nextMatchButton.hidden=YES;
     }
     */
    //[[AppConfig getInstance] saveGameInfoToFile];
    [[BO_MatchInfo getInstance] updateObject:chatRoom.gameInfo.currentMatchInfo];
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
    isAtMatchSetting=NO;
    if(hasChange)
    {
        [self drawLayoutByGameInfo];
    }
    if (chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateGamePause&&( chatRoom.gameInfo.currentMatchInfo.preGameStatus==kStateRunning||chatRoom.gameInfo.currentMatchInfo.preGameStatus==kStateCalcScore)) {
        [self contiueGame];
    }
    else if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRoundReset)
    {
        [roundResetPanel setTimerStop:NO];
    }
    
}
-(void)showGameSettingDialog:(UIGestureRecognizer *)recognizer{
    CGPoint point= [recognizer locationInView:self.view];
    if(point.y>10&&point.y<100){
        [self showGameSettingDialogWithViewIndex:0];
    }
}
-(void)showGameSettingDialogWithViewIndex:(NSInteger)index{
    isAtMatchSetting=YES;
    if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRunning||chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateCalcScore){
        [self pauseGame];
    }else{
        if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRoundReset)
        {
            [roundResetPanel setTimerStop:YES];
        }
    }
    [[ChattyAppDelegate getInstance] showDuringMatchSettingView:index];
    
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
    isAtMatchSetting=NO;
    [self showSelectWinnerBox];
}

#pragma mark -
#pragma mark Winner Selected
-(void)showSelectWinnerBox
{
    if(selectWinnerBoxPanel==nil)
        selectWinnerBoxPanel=[[SelectWinnerBox alloc] initWithFrame:self.view.bounds title:@"Please Select Winner"];
    selectWinnerBoxPanel.gameInfo=chatRoom.gameInfo;
    selectWinnerBoxPanel.delegate=self;
    [selectWinnerBoxPanel bindByGameInfo];
    if(![self.view.subviews containsObject:selectWinnerBoxPanel]){
        [self.view addSubview:selectWinnerBoxPanel];	
        [selectWinnerBoxPanel showFromPoint:[self.view center]];
    }
}
-(void)selectedWinnerEnd:(id)data
{
    BOOL winnerIsRedSide=[[data objectAtIndex:0] boolValue];
    WinType winnerType=[[data objectAtIndex:1] intValue];
    [self showWinnerBoxForRedSide:winnerIsRedSide winType:winnerType];
}
-(void)showWinnerBoxForRedSide:(BOOL)isRedSide winType:(WinType) winnerType;
{
    [self pauseGame];
    [player playSoundWithFullPath:kSoundsCongratulation];
    if(showWinnerBoxPanel==nil)
        showWinnerBoxPanel=[[ShowWinnerBox alloc] initWithFrame:self.view.bounds title:@"Winner"];
    showWinnerBoxPanel.gameInfo=chatRoom.gameInfo;
    showWinnerBoxPanel.winnerIsRedSide=isRedSide;
    showWinnerBoxPanel.winnerWinType=winnerType;
    [showWinnerBoxPanel bindSetting];
    showWinnerBoxPanel.delegate=self;
    if(![self.view.subviews containsObject:showWinnerBoxPanel]){
        [self.view addSubview:showWinnerBoxPanel];	
        [showWinnerBoxPanel showFromPoint:[self.view center]];
    }    
}
-(void)showWinnerEndAndNextRound:(id)data
{
    chatRoom.gameInfo.currentMatchInfo.isRedToBeWinner=showWinnerBoxPanel.winnerIsRedSide;
    chatRoom.gameInfo.currentMatchInfo.winByType=showWinnerBoxPanel.winnerWinType;
    [self setMenuByGameStatus:kStateGameEnd]; 
    [[BO_GameInfo getInstance] updateAllGameInfo:chatRoom.gameInfo];
    int nextCourt=[[data objectAtIndex:1] intValue];
    NSString *profileId=[data objectAtIndex:0];
    [self goToNextMatchWithProfileId:profileId startCourt:nextCourt];
}

#pragma mark -
#pragma mark Blue toothkey borad process

-(BOOL)canSubmitControlCommand{
    if(self.view.superview==nil)
        return NO;
    else
    {
        if(showWinnerBoxPanel.superview!=nil ||roundResetPanel.superview!=nil ||selectWinnerBoxPanel.superview!=nil)
            return NO;
        else
            return YES;
    }
}
/*
 最多4组裁判按键，每组8个按键，
 分别为：裁判1：A - H  4-11   控制结果 A(4):红+1 B:红+2 C:红+3 D:红+4 E:蓝+1 F:蓝+2 G:蓝+3 H(11):蓝+4
 裁判2：I - P  12-19  控制结果 I(12):红+1 J:红+2 K:红+3 L:红+4 M:蓝+1 N:蓝+2 O:蓝+3 P(19):蓝+4
 裁判3：Q - X  20-27  控制结果 Q:红+1 R:红+2 S:红+3 T:红+4 U:蓝+1 V:蓝+2 W:蓝+3 X:蓝+4
 裁判4：-=[]\;'`  45-49 51-53 -(45):红+1 +(46):红+2 [(47)红+3 ](48)红+4 \(49)蓝+1 ;(51)蓝+2 '(52)蓝+3 ~(53)蓝+4
 
 数字按键用来与配对蓝牙键盘时使用,使用回车键结束配对
 功能键：
 空格键（44） 比赛开始或者暂停、继续切换，休息时间到时按此键可继续下一回合比赛 Start Stop.
 斜杠键/(56) 显示或者隐藏休整时间 Injury Timer Start Stop.
 回车键 (40) 蓝牙匹配时输入确认；
 Num 0(39) 红方加1警告 Red Warning;选择胜利方时，选择红方.
 Num 1(30) 蓝方加1警告 Blue Warning；选择胜利方时，选择蓝方.
 Num 2(31) 红方扣1分（两次警告） Red Penalty Deduction.
 Num 3(32) 蓝方扣1分（两次警告） Blue Penalty Deduction.
 Num 4(33) 红方加1分 Red Add Point Override.
 Num 5(34) 蓝方加1分 Blue Add Point Override.
 Num 6(35) 红方减1分 Red Deduct Point Override.
 Num 7(36) 蓝方减1分 Blue Deduct Point Override.
 Num 8(37) 红方胜利 Red Win Override.
 Num 9(38) 蓝方胜利 Blue Win Override.
 */
-(void)bluetoothKeyboardPressed:(KeyBoradEventInfo *)keyboardArgv
{
    if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateWaitJudge || chatRoom.gameInfo.currentMatchInfo.gameStatus ==kStateMultiplayerReconnect){
        int pointToReferee=-1;
        if(keyboardArgv.keyCode>=GSEVENTKEY_KEYCODE_ALP_A&&keyboardArgv.keyCode<=GSEVENTKEY_KEYCODE_ALP_H)
            pointToReferee=1;
        else if(keyboardArgv.keyCode>=GSEVENTKEY_KEYCODE_ALP_I&&keyboardArgv.keyCode<=GSEVENTKEY_KEYCODE_ALP_P)
            pointToReferee=2;
        else if(keyboardArgv.keyCode>=GSEVENTKEY_KEYCODE_ALP_Q&&keyboardArgv.keyCode<=GSEVENTKEY_KEYCODE_ALP_X)
            pointToReferee=3;
        else if((keyboardArgv.keyCode>=GSEVENTKEY_KEYCODE_SNL_HYPHENS && keyboardArgv.keyCode<=GSEVENTKEY_KEYCODE_SNL_REVSLASH)
                ||(keyboardArgv.keyCode>=GSEVENTKEY_KEYCODE_SNL_SEMICOLON && keyboardArgv.keyCode<=GSEVENTKEY_KEYCODE_SNL_Wave))
        {
            pointToReferee=4;
        }
        if(pointToReferee>0&&pointToReferee<=chatRoom.gameInfo.gameSetting.judgeCount){
            JudgeClientInfo *cltInfo=  [chatRoom.gameInfo clientBySequence:pointToReferee];
            if(!cltInfo.hasConnected){
                cltInfo.hasConnected=YES;
                [[BO_JudgeClientInfo getInstance] updateObject:cltInfo];
                [self refreshGamesettingDialogJudges];
                [self showWaitingUserBox];
            }
            return;
        }        
    }
    if(keyboardArgv.keyCode==GSEVENTKEY_KEYCODE_SNL_SPACE)
    {
        if(!chatRoom.gameInfo.gameStart)
        {
            if((self.chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateMultiplayerReconnect
                ||self.chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateWaitJudge)&&
               waitUserPanel.btnStartGame.hidden==NO){
                [waitUserPanel startGame:self];
            }
        }
        else{       
            if(self.chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRunning)
                [self gamePauseContinueToggle]; 
            else if(self.chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateGamePause)
            {
                if(showWinnerBoxPanel.superview!=nil||selectWinnerBoxPanel.superview!=nil){
                    //显示选择胜利者或者显示胜利者时不做处理
                }else
                {
                    [self gamePauseContinueToggle]; 
                }
            }
            else if(self.chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRoundReset){
                if(roundResetPanel.btnStart.hidden==NO)
                    [roundResetPanel startRound:self];
            }
        }
        return;
    }
    if(!chatRoom.gameInfo.gameStart)
    {
        return;
    }
    
    switch (keyboardArgv.keyCode) {
        case GSEVENTKEY_KEYCODE_SNL_SLASH:
            if([self canSubmitControlCommand])
            {
                [self toggleReorignizeTimeBox];
            }
            return;
        case GSEVENTKEY_KEYCODE_NUM_0:
            if(selectWinnerBoxPanel.superview!=nil)
            {
                [selectWinnerBoxPanel showWinner:YES];  
            }
            else  if([self canSubmitControlCommand])
                [self warningAddToRedPlayer];
            return;
        case GSEVENTKEY_KEYCODE_NUM_1:
            if(selectWinnerBoxPanel.superview!=nil)
            {
                [selectWinnerBoxPanel showWinner:NO];  
            }
            if([self canSubmitControlCommand])
                [self warningAddToBluePlayer];
            return;
        case GSEVENTKEY_KEYCODE_NUM_2:
            if([self canSubmitControlCommand]){
                [self warningAddToRedPlayer];
                [self warningAddToRedPlayer];
            }
            return;
        case GSEVENTKEY_KEYCODE_NUM_3:
            if([self canSubmitControlCommand]){
                [self warningAddToBluePlayer];
                [self warningAddToBluePlayer];
            }
            return;
        case GSEVENTKEY_KEYCODE_NUM_4:
            if([self canSubmitControlCommand])
                [self redAddScore];
            return;
        case GSEVENTKEY_KEYCODE_NUM_5:
            if([self canSubmitControlCommand])
                [self blueAddScore];
            return;
        case GSEVENTKEY_KEYCODE_NUM_6:
            if([self canSubmitControlCommand])
                [self redMinusScore];
            return;
        case GSEVENTKEY_KEYCODE_NUM_7:
            if([self canSubmitControlCommand])
                [self blueMinusScore];
            return;
        case GSEVENTKEY_KEYCODE_NUM_8:
            [self showWinnerBoxForRedSide:YES winType:kWinByPoint];
            return;
        case GSEVENTKEY_KEYCODE_NUM_9:
            [self showWinnerBoxForRedSide:NO winType:kWinByPoint];
            return;
        case GSEVENTKEY_KEYCODE_SNL_RETURN:
            if(showWinnerBoxPanel.superview!=nil){
                [showWinnerBoxPanel btnNextRound:self];
            }
            return;
        default:
            break;
    }
    if(chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateCalcScore || chatRoom.gameInfo.currentMatchInfo.gameStatus==kStateRunning)
    {
        if((keyboardArgv.keyCode>=GSEVENTKEY_KEYCODE_ALP_A&&keyboardArgv.keyCode<=GSEVENTKEY_KEYCODE_ALP_X)|| (keyboardArgv.keyCode>=GSEVENTKEY_KEYCODE_SNL_HYPHENS && keyboardArgv.keyCode<=GSEVENTKEY_KEYCODE_SNL_REVSLASH)||(keyboardArgv.keyCode>=GSEVENTKEY_KEYCODE_SNL_SEMICOLON && keyboardArgv.keyCode<=GSEVENTKEY_KEYCODE_SNL_Wave))
        {
            short refreedNum=(keyboardArgv.keyCode-4)/8+1;//对应哪个裁判
            short cmdNum=(keyboardArgv.keyCode-4)%8; //对应哪个命令，0-7
            if(keyboardArgv.keyCode>=GSEVENTKEY_KEYCODE_SNL_HYPHENS){
                refreedNum=4;
                if(keyboardArgv.keyCode<=GSEVENTKEY_KEYCODE_SNL_REVSLASH){
                    cmdNum=(keyboardArgv.keyCode-GSEVENTKEY_KEYCODE_SNL_HYPHENS)%8;
                }
                else{
                    cmdNum=(keyboardArgv.keyCode-1-GSEVENTKEY_KEYCODE_SNL_HYPHENS)%8;
                }
            }
            
            if(refreedNum>chatRoom.gameInfo.gameSetting.judgeCount)//如果大于指定裁判数量的按键，视为无效
                return;
            BOOL isRedSide=cmdNum<4;
            short score=cmdNum%4+1;
            ScoreInfo  *scoreInfo ;
            if(isRedSide)
                scoreInfo = [[ScoreInfo alloc] initWithRedSide:score andDateNow:nil];
            else
                scoreInfo=[[ScoreInfo alloc] initWithBlueSide:score andDateNow:nil];                                        
            CommandMsg *cmd=[[CommandMsg alloc] initWithType:NETWORK_REPORT_SCORE andFrom:
                             [NSString stringWithFormat:@"%i",refreedNum] andDesc:nil andData:[scoreInfo proxyForJson] andDate:[NSDate date]];
            [self processCmd:cmd];
        }
    }
    
    //[UIHelper showAlert:@"" message:keyboardArgv.description func:nil];
}

- (IBAction)btnShowSelectWinnerPressed:(id)sender
{
    [self showSelectWinnerBox];
}
@end
