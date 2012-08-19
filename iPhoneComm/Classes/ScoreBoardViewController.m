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
#define  kMenuItemWarningBlue 3
#define  kMenuItemWarningRed 4
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
-(void)gamePauseContinueToggle;
-(void)gamePauseAndShowResetTimeBox;
-(void)blueAddScore;
-(void)blueMinusScore;
-(void)redAddScore;
-(void)redMinusScore;
-(void)showGameSettingDialog:(UIGestureRecognizer *)recognizer;
-(void)refreshGamesettingDialogJudges;
-(void)drawRect:(CGRect)rect;
-(void)drawWarningFlag;
-(BOOL)testPointGapReached;
-(void)showSelectWinnerBox;
-(void)showWinnerBoxForRedSide:(BOOL)isRedSide;
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
    self.viewBlueWarningBox.layer.borderColor = [UIColor colorWithRed:255/255 green:0/255 blue:0/255 alpha:0.8].CGColor;
    self.viewBlueWarningBox.layer.borderWidth = 1.0f;
    self.viewRedWarningBox.layer.borderColor = [UIColor colorWithRed:255/255 green:0/255 blue:0/255 alpha:0.8].CGColor;
    self.viewRedWarningBox.layer.borderWidth = 1.0f;    
    //    [self drawRect:self.viewBlueWarningBox.frame];
    //    [self drawRect:self.viewRedWarningBox.frame];
    
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
    self.viewTime.userInteractionEnabled=YES;
    [self.viewTime addGestureRecognizer:startStopGame];
    
    /*向上滑动时间控件,暂停比赛并显示休息时间*/
    UISwipeGestureRecognizer *pauseGameAndShowResetBox=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gamePauseAndShowResetTimeBox)];
    pauseGameAndShowResetBox.numberOfTouchesRequired=1;
    pauseGameAndShowResetBox.direction= UISwipeGestureRecognizerDirectionUp;
    [self.viewTime addGestureRecognizer:pauseGameAndShowResetBox];
    
    /*向上滑动分数控件,直接加1分*/
    UISwipeGestureRecognizer *blueAddRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(blueAddScore)];
    blueAddRecg.numberOfTouchesRequired=1;
    blueAddRecg.direction= UISwipeGestureRecognizerDirectionUp;
    self.viewBlueScore.userInteractionEnabled=YES;
    [self.viewBlueScore addGestureRecognizer:blueAddRecg];
    
    /*向上滑动分数控件,直接减1分*/
    UISwipeGestureRecognizer *blueMinusRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(blueMinusScore)];
    blueMinusRecg.numberOfTouchesRequired=1;
    blueMinusRecg.direction= UISwipeGestureRecognizerDirectionDown;
    self.viewBlueScore.userInteractionEnabled=YES;
    [self.viewBlueScore addGestureRecognizer:blueMinusRecg];
    
    UISwipeGestureRecognizer *redAddRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(redAddScore)];
    redAddRecg.numberOfTouchesRequired=1;
    redAddRecg.direction= UISwipeGestureRecognizerDirectionUp;
    self.viewRedScore.userInteractionEnabled=YES;
    [self.viewRedScore addGestureRecognizer:redAddRecg];
    
    UISwipeGestureRecognizer *redMinusRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(redMinusScore)];
    redMinusRecg.numberOfTouchesRequired=1;
    redMinusRecg.direction= UISwipeGestureRecognizerDirectionDown;
    viewRedScore.userInteractionEnabled=YES;
    [viewRedScore addGestureRecognizer:redMinusRecg];
    
    /*在警告控件向左拖拉,累積警告分數加一次*/
    UISwipeGestureRecognizer *blueWarningAddRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(warningAddToBluePlayer)];
    blueWarningAddRecg.numberOfTouchesRequired=1;
    blueWarningAddRecg.direction= UISwipeGestureRecognizerDirectionLeft;
    [self.viewBlueWarningBox addGestureRecognizer:blueWarningAddRecg];
    
    /*在警告控件向右拖拉,累積警告分數减一次*/
    UISwipeGestureRecognizer *blueWarningMinusRecg=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(warningMinusToBluePlayer)];
    blueWarningMinusRecg.numberOfTouchesRequired=1;
    blueWarningMinusRecg.direction= UISwipeGestureRecognizerDirectionRight;
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
    [super viewDidUnload];    
    marksFlags=nil;
    marksGrayFlags=nil;
    timeFlags=nil;
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

#pragma mark -
#pragma mark warning
//warming,when 2 warning to be a Deduction(score -1)
-(void)warningPlayer:(Boolean) isForRedSide andCount:(NSInteger)count{
    if(isForRedSide){
        if(chatRoom.gameInfo.redSideWarning+count<0)
            return;
        else if(chatRoom.gameInfo.redSideWarning+count>chatRoom.gameInfo.gameSetting.maxWarningCount){
            return;
        }
        else{
            chatRoom.gameInfo.redSideWarning+=count;
            //合计2次警告自动加对方1分
            if(count>0 && chatRoom.gameInfo.redSideWarning%2==0){
                [self submitScore:1 andIsRedSize:NO];
            }            
            [self drawWarningFlagForRed:YES];            
        }
    }
    else{
        if(chatRoom.gameInfo.blueSideWarning+count<0)
            return;
        else if(chatRoom.gameInfo.blueSideWarning+count>chatRoom.gameInfo.gameSetting.maxWarningCount){
            return;
        }
        else{
            chatRoom.gameInfo.blueSideWarning+=count;
            if(count>0 && chatRoom.gameInfo.blueSideWarning%2==0){
                [self submitScore:1 andIsRedSize:YES];
            }
            [self drawWarningFlagForRed:NO];
        }    
    }
    [self setWarningMaxProcess];
}

-(void)warningAddToBluePlayer{
    [self warningPlayer:NO andCount:1];
}
-(void)warningAddToRedPlayer{
    [self warningPlayer:YES andCount:1];
}
-(void)warningMinusToBluePlayer{
    [self warningPlayer:NO andCount:-1];
}
-(void)warningMinusToRedPlayer{
    [self warningPlayer:YES andCount:-1];
}

#pragma mark -
#pragma mark draw layout

-(void)drawLayoutByGameInfo{
    lblGameName.text=[NSString stringWithFormat:@"%@",chatRoom.gameInfo.gameSetting.gameName];
    lblRedPlayerName.text=chatRoom.gameInfo.gameSetting.redSideName;
    lblBluePlayerName.text=chatRoom.gameInfo.gameSetting.blueSideName;
    
    /*目前没有使用下来属性*/
    lblGameDesc.text=chatRoom.gameInfo.gameSetting.gameDesc;    
    lblRedPlayerDesc.text=chatRoom.gameInfo.gameSetting.redSideDesc;
    lblBluePlayerDesc.text=chatRoom.gameInfo.gameSetting.blueSideDesc;    
    lblScreening.text=chatRoom.gameInfo.gameSetting.screeningArea;
    /*下列用图像替换*/
    
    [self drawRoundNum:chatRoom.gameInfo.currentRound];
    [self drawTotalScore:YES andScore:chatRoom.gameInfo.redSideScore];
    [self drawTotalScore:NO andScore:chatRoom.gameInfo.blueSideScore];
    /*end*/
    [self drawRemainTime:chatRoom.gameInfo.currentRemainTime];
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
    
    int warningCount=isBlue?chatRoom.gameInfo.blueSideWarning:chatRoom.gameInfo.redSideWarning;
    int maxWarmingCount=chatRoom.gameInfo.gameSetting.maxWarningCount;
    float imgHeight=41.0;
    float imgWidth=76.0;
    float actWidth=62.0;
    float padding=1;
    float paddingTop=1;
    if(isBlue){//蓝色框以右边端点为固定端点，向左延伸
    view.frame=CGRectMake(view.frame.origin.x+view.frame.size.width-(padding+(actWidth)*maxWarmingCount/2+padding), view.frame.origin.y,padding+(actWidth)*maxWarmingCount/2+padding, view.frame.size.height);
    }else{
             view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y,padding+(actWidth)*maxWarmingCount/2+padding, view.frame.size.height);
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
    if(self.chatRoom.gameInfo.blueSideWarning==self.chatRoom.gameInfo.gameSetting.maxWarningCount||self.chatRoom.gameInfo.redSideWarning==self.chatRoom.gameInfo.gameSetting.maxWarningCount){
        [self setMenuByGameStatus:kStateMaxWarningReached];
        BOOL isRedSide=self.chatRoom.gameInfo.redSideWarning==self.chatRoom.gameInfo.gameSetting.maxWarningCount;
        warningMaxReached = YES;
        [self pauseTime:YES];
        [self drawTotalScore:isRedSide andScore:isRedSide?chatRoom.gameInfo.redSideScore:chatRoom.gameInfo.blueSideScore andGrayStype:YES];
        if(![warningMaxTimer isValid]){
            warningMaxTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(warnmingMaxProcessLoop) userInfo:nil repeats:YES];
        }
    }
    else{
        if(warningMaxReached){
            if([warningMaxTimer isValid])
                [warningMaxTimer invalidate];
            warningMaxReached=NO;
            [self drawTotalScore:YES andScore:chatRoom.gameInfo.redSideScore];
            [self drawTotalScore:NO andScore:chatRoom.gameInfo.blueSideScore];
        }
    }
}
-(void)warnmingMaxProcessLoop
{
    static int WarningCount=0;
    BOOL isRedSide=chatRoom.gameInfo.redSideWarning==chatRoom.gameInfo.gameSetting.maxWarningCount;
    BOOL hidden=WarningCount%2==0;
    WarningCount++;
    //胜方闪数
    UIView *warningBox=isRedSide?viewRedWarningBox:viewBlueWarningBox;
    for (UIView *subView in warningBox.subviews) {
        subView.hidden=hidden;
    }
    if(!isRedSide){
        if(chatRoom.gameInfo.redSideScore/10>0){
            imgRedScoreDoubleTen.hidden=hidden;
            imgRedScoreDoubleSin.hidden=hidden;
        }
        else{
            imgRedScoreSingle.hidden=hidden;
        }
    }
    else{
        if(chatRoom.gameInfo.blueSideScore/10>0){
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
    imgTimeMinus.image=[timeFlags objectAtIndex:min];
    imgTimeSecTen.image=[timeFlags objectAtIndex:secTen];
    imgTimeSecSin.image=[timeFlags objectAtIndex:secSin];
}

#pragma mark -
#pragma mark time hander
//when game going on,we need to refresh time 
-(void)updatTime { 
    chatRoom.gameInfo.currentRemainTime--;
	int min = chatRoom.gameInfo.currentRemainTime/60;
    int sec=fmod(chatRoom.gameInfo.currentRemainTime,60);
    [self drawRemainTime:chatRoom.gameInfo.currentRemainTime];
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
        [self drawTotalScore:YES andScore:chatRoom.gameInfo.redSideScore];
        lblRedTotal.text=[NSString stringWithFormat:@"%i",chatRoom.gameInfo.redSideScore];           
    }else{
        if(chatRoom.gameInfo.blueSideScore+score<0)
            return;
        chatRoom.gameInfo.blueSideScore+=score;
        [self drawTotalScore:NO andScore:chatRoom.gameInfo.blueSideScore];
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
    if(chatRoom.gameInfo.gameSetting.enableGapScore&&chatRoom.gameInfo.currentRound>=chatRoom.gameInfo.gameSetting.pointGapAvailRound && fabs(chatRoom.gameInfo.redSideScore-chatRoom.gameInfo.blueSideScore)>=chatRoom.gameInfo.gameSetting.pointGap){
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
        [self setMenuByGameStatus:kStatePointGapReached];
        pointGapReached=YES;
        [self pauseTime:YES];
        BOOL drawRedGrayStype=chatRoom.gameInfo.blueSideScore-chatRoom.gameInfo.redSideScore>0;
        [self drawTotalScore:drawRedGrayStype andScore:drawRedGrayStype?chatRoom.gameInfo.redSideScore:chatRoom.gameInfo.blueSideScore andGrayStype:YES];
        if(![pointGapTimer isValid]){
        pointGapTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pointGapLoop) userInfo:nil repeats:YES];
        }
    }
    else{
        if(pointGapReached){
            if([pointGapTimer isValid])
                [pointGapTimer invalidate];
            pointGapReached=NO;
            [self drawTotalScore:YES andScore:chatRoom.gameInfo.redSideScore];
            [self drawTotalScore:NO andScore:chatRoom.gameInfo.blueSideScore];
        }
    }
}

-(void)pointGapLoop
{
    static int PointWarningCount=0;
    BOOL isRedSide=chatRoom.gameInfo.redSideScore-chatRoom.gameInfo.blueSideScore>0;
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
        if(chatRoom.gameInfo.redSideScore/10>0){
            imgRedScoreDoubleTen.hidden=hidden;
            imgRedScoreDoubleSin.hidden=hidden;
        }
        else{
            imgRedScoreSingle.hidden=hidden;
        }
    }
    else{
        if(chatRoom.gameInfo.blueSideScore/10>0){
            imgBlueScoreDoubleTen.hidden=hidden;
            imgBlueScoreDoubleSin.hidden=hidden;
        }
        else{
            imgBlueScoreSingle.hidden=hidden;
        }
    }
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
    chatRoom.gameInfo=nil;
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(stopRoom) userInfo:nil repeats:NO];
}
//stop peer server
-(void)stopRoom
{
    [chatRoom stop];
    [[ChattyAppDelegate getInstance] showRoomSelection];
}

//erase warning flags
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
#pragma mark -
#pragma mark Game Logic Process
//prepare for game to start
-(void)prepareForGame
{
    pointGapReached=NO;
    if(timeFlags==nil)
        {
            timeFlags=[[NSMutableArray alloc] initWithCapacity:10];
            for (int i=0; i<10; i++) {
                [timeFlags addObject:[UIImage imageNamed:[NSString stringWithFormat:@"time_%i",i]]];
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
    if(imgDecicade==nil)
        imgDecicade=[UIImage imageNamed:@"dedecade_flag"];
    if(imgWarning==nil)
        imgWarning =[UIImage imageNamed:@"warning_flag"];
    [self setMenuByGameStatus:kStatePrepareGame];
    if (chatRoom != nil ) {
        chatRoom.delegate = self;
        [chatRoom start];
    }
    [self resetRound:YES];    
    //取消原来的圆形菜单
    //[self setupMenu];
    [self setMenuByGameStatus:kStateWaitJudge];
    [self showWaitingUserBox];
    double inv=kHeartbeatTimeInterval;
    gameLoopTimer=[NSTimer scheduledTimerWithTimeInterval:inv target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
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
    UIButton *redWarningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [redWarningButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [redWarningButton setImage:[UIImage imageNamed:@"minus-red"] forState:UIControlStateNormal];
    redWarningButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    redWarningButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    redWarningButton.center = CGPointMake(125.0f, 25.0f);
    redWarningButton.tag=kMenuItemWarningRed;
    
    UIButton *blueWarningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [blueWarningButton addTarget:self action:@selector(menuItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [blueWarningButton setImage:[UIImage imageNamed:@"minus-blue"] forState:UIControlStateNormal];
    blueWarningButton.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    blueWarningButton.imageEdgeInsets = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    blueWarningButton.center = CGPointMake(175.0f, 25.0f);
    blueWarningButton.tag=kMenuItemWarningBlue;
    
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
    self.actionHeaderView.items = [NSArray arrayWithObjects:menuButton, continueButton,redWarningButton,blueWarningButton,nextMatchButton, exitButton, nil];	
	
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
        case  kMenuItemWarningBlue:
            [self warningPlayer:NO andCount:1];
            break;
        case  kMenuItemWarningRed:
            [self warningPlayer:YES andCount:1];
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
    chatRoom.gameInfo.redSideWarning=0;
    chatRoom.gameInfo.blueSideWarning=0;
    chatRoom.gameInfo.currentMatch++;
    //resetRound will add round sequence
    chatRoom.gameInfo.currentRound=0;
    //reset round info
    [self resetRound:YES];
    [self startRound:nil];
}

#pragma mark -
#pragma mark Game Status Process
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
        case kStatePointGapReached:
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
    UIButton *redWarningButton=[self getMenuItem:kMenuItemWarningRed];
    UIButton *blueWarningButton=[self getMenuItem:kMenuItemWarningBlue];
    UIButton *nextMatchButton=[self getMenuItem:kMenuItemNextMatch];
    if(chatRoom.gameInfo.gameStatus==kStateGameEnd)
    {
        continueButton.hidden=YES;
        redWarningButton.hidden=YES;
        blueWarningButton.hidden=YES;
        nextMatchButton.hidden=NO;
    }
    else if(chatRoom.gameInfo.gameStatus==kStateRunning)
    {
        continueButton.hidden=NO;
        redWarningButton.hidden=NO;
        blueWarningButton.hidden=NO;
        nextMatchButton.hidden=YES;
    }else{
        if(chatRoom.gameInfo.gameStatus==kStateGamePause)
            continueButton.hidden=NO;
        else
            continueButton.hidden=YES;
        redWarningButton.hidden=YES;
        blueWarningButton.hidden=YES;
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
    ShowWinnerBox *box=[[ShowWinnerBox alloc] initWithFrame:self.view.bounds title:@"Winner"];
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
