//
//  SummaryReportViewController.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SummaryReportViewController.h"

#import "RoundInfo.h"
#import "MatchLog.h"
#import "MatchInfo.h"
#import "GameInfo.h"
#import "BO_MatchLog.h"
#import "BO_RoundInfo.h"
#import "BO_SubmitedScoreInfo.h"
#import "GameInfo.h"
#import "ServerSetting.h"
#import "BO_ScoreInfo.h"

@interface SummaryReportViewController ()

-(NSString *)genReportHTML;
-(NSString *)displayFoString:(NSString *)str;
-(RoundInfo *)recalcRoundInfo:(RoundInfo *)roundDetail;

@end

@implementation SummaryReportViewController
@synthesize viewReportView;

@synthesize gameInfo,selMatch;

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
    [self reloadReport];
}
-(void)reloadReport{
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"DetailReport.html" ofType:nil];
    //[viewReportView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]]; 
    // 加载字符串html代码，并且显示其中的资源文件。
    NSString *html = [self genReportHTML];
    NSString *path = [[NSBundle mainBundle] resourcePath];
    NSURL *base = [NSURL fileURLWithPath:path];
    [viewReportView loadHTMLString:html baseURL:base]; 
}


-(NSString *)genReportHTML
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SummaryReport.html" ofType:nil];
    NSString *html= [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    html=[html stringByReplacingOccurrencesOfString:@"%Court%" withString:[NSString stringWithFormat:@"%@%03i",gameInfo.gameSetting.screeningArea,gameInfo.currentMatch]];
    html=[html stringByReplacingOccurrencesOfString:@"%StartTime%" withString:[UtilHelper formateDate:gameInfo.gameStartTime withFormat:@"dd MMM,yyyy(HH:mm:ss)"]];
    NSString *endDate=@"";
    NSString *blueWinFlag=@"";
    NSString *redWinFlag=@"";
    NSNumberFormatter* nf = [[NSNumberFormatter alloc] init];
    nf.positiveFormat = @"0.#";
    if(gameInfo.gameEnded && gameInfo.gameEndTime!=nil){
        endDate =[NSString stringWithFormat:@"End Time: %@", [UtilHelper formateDate:gameInfo.gameEndTime withFormat:@"dd MMM,yyyy(HH:mm:ss)"]];
        if(gameInfo.currentMatchInfo.isRedToBeWinner){
            redWinFlag=@"(Winner)";
        }
        else{
            blueWinFlag =@"(Winner)";
        }
        html=[html stringByReplacingOccurrencesOfString:@"%WinType%" withString:[NSString stringWithFormat:@"Win By:<span style='font-weight:bold'>%@</span>",[[Definition getWinTypeDesc:gameInfo.currentMatchInfo.winByType] stringByReplacingOccurrencesOfString:@"Win By " withString:@""]]];
    }
    else{
        html=[html stringByReplacingOccurrencesOfString:@"%WinType%" withString:@""];
    }
    html=[html stringByReplacingOccurrencesOfString:@"%EndTime%" withString:endDate];
    html=[html stringByReplacingOccurrencesOfString:@"%BlueWin%" withString:blueWinFlag];
    html=[html stringByReplacingOccurrencesOfString:@"%RedWin%" withString:redWinFlag];
    NSString *pathRow = [[NSBundle mainBundle] pathForResource:@"SummaryReportRow.html" ofType:nil];
    NSMutableString *logDetails=[[NSMutableString alloc] initWithCapacity:3000];
    NSString *rowFormat=[NSString stringWithContentsOfFile:pathRow encoding:NSUTF8StringEncoding error:nil];
    //每个回合处理
    for (RoundInfo *_roundInfo in [[BO_RoundInfo getInstance] queryListByMatchId:gameInfo.currentMatchInfo.matchId]) {
        RoundInfo *roundInfo=_roundInfo;
        if(roundInfo.endTime==nil){
            roundInfo = [self recalcRoundInfo:roundInfo];
        }
        NSString *sbRow=rowFormat;
        sbRow = [sbRow stringByReplacingOccurrencesOfString:@"%Blue_Deduction%" withString:[nf stringFromNumber:[NSNumber numberWithFloat:(float)roundInfo.blueWarnming/2]]];
        sbRow = [sbRow stringByReplacingOccurrencesOfString:@"%RowGapDisplay%" withString:@""];
        sbRow = [sbRow stringByReplacingOccurrencesOfString:@"%Blue_Score%" withString:[NSString stringWithFormat:@"%i",roundInfo.blueScore]];
        sbRow = [sbRow stringByReplacingOccurrencesOfString:@"%Round%" withString:[NSString stringWithFormat:@"%i",roundInfo.round]];
        sbRow = [sbRow stringByReplacingOccurrencesOfString:@"%Red_Score%" withString:[NSString stringWithFormat:@"%i",roundInfo.redScore]];
        sbRow =  [sbRow stringByReplacingOccurrencesOfString:@"%Red_Deduction%" withString:[nf stringFromNumber:[NSNumber numberWithFloat:(float)roundInfo.redWarnming/2]]];
        NSArray *array = [[BO_ScoreInfo getInstance] queryScoreStaticByGameId:gameInfo.gameId matchId:gameInfo.currentMatchInfo.matchId roundSeq:roundInfo.round];
        NSString *scoreCountHolder;
        for (int point=1; point<=4; point++) {
            for (int side=0; side<=1; side++) {
                for (int judge=1; judge<=4; judge++) {
                    scoreCountHolder=[NSString stringWithFormat:@"%%%@_PT_%i_JUDGE_%i%%",
                                      side==0?@"Blue":@"Red",point,judge];
                    int scoreCount=0;//给的分数合计次数
                    if(array!=nil){                        
                        for (NSArray *scoreInfo in array) {
                            int score=[[scoreInfo objectAtIndex:0] intValue];
                            int redSide=[[scoreInfo objectAtIndex:1] intValue];
                            int judgeSeqence=[[scoreInfo objectAtIndex:2] intValue];
                            int totalCount=[[scoreInfo objectAtIndex:3] intValue];
                            if(score==point &&redSide==side && judge==judgeSeqence){
                                scoreCount=totalCount;
                                break;
                            }
                        }
                    }
                    sbRow =  [sbRow stringByReplacingOccurrencesOfString:scoreCountHolder withString:scoreCount==0?@"":[NSString stringWithFormat:@"%i",scoreCount]];
                }
            }
        }
        [logDetails appendString:sbRow];
    }
    
    NSDictionary * roundInfo=[[BO_SubmitedScoreInfo getInstance] querySideScoreOfRoundSeq:0 matchId:gameInfo.currentMatchInfo.matchId];
    NSString *sbRow=rowFormat;
    sbRow = [sbRow stringByReplacingOccurrencesOfString:@"%Blue_Deduction%" withString:[nf stringFromNumber:[NSNumber numberWithFloat:[[roundInfo objectForKey:@"BLUE_WARMNING"] floatValue]/2]]];
    sbRow = [sbRow stringByReplacingOccurrencesOfString:@"%RowGapDisplay%" withString:@"display:none;"];
    sbRow = [sbRow stringByReplacingOccurrencesOfString:@"%Blue_Score%" withString:[NSString stringWithFormat:@"%i",[[roundInfo objectForKey:@"BLUE_SCORE"] intValue]]];
    sbRow = [sbRow stringByReplacingOccurrencesOfString:@"%Round%" withString:@"Total"];
    sbRow = [sbRow stringByReplacingOccurrencesOfString:@"%Red_Score%" withString:[NSString stringWithFormat:@"%i",[[roundInfo objectForKey:@"RED_SCORE"] intValue]]];
    sbRow =  [sbRow stringByReplacingOccurrencesOfString:@"%Red_Deduction%" withString:[nf stringFromNumber:[NSNumber numberWithFloat:[[roundInfo objectForKey:@"RED_WARMNING"] floatValue]/2]]];
    NSArray *array = [[BO_ScoreInfo getInstance] queryScoreStaticByGameId:gameInfo.gameId matchId:gameInfo.currentMatchInfo.matchId roundSeq:0];
    NSString *scoreCountHolder;
    for (int point=1; point<=4; point++) {
        for (int side=0; side<=1; side++) {
            for (int judge=1; judge<=4; judge++) {
                scoreCountHolder=[NSString stringWithFormat:@"%%%@_PT_%i_JUDGE_%i%%",
                                  side==0?@"Blue":@"Red",point,judge];
                int scoreCount=0;//给的分数合计次数
                if(array!=nil){                        
                    for (NSArray *scoreInfo in array) {
                        int score=[[scoreInfo objectAtIndex:0] intValue];
                        int redSide=[[scoreInfo objectAtIndex:1] intValue];
                        int judgeSeqence=[[scoreInfo objectAtIndex:2] intValue];
                        int totalCount=[[scoreInfo objectAtIndex:3] intValue];
                        if(score==point &&redSide==side && judge==judgeSeqence){
                            scoreCount=totalCount;
                            break;
                        }
                    }
                }
                sbRow =  [sbRow stringByReplacingOccurrencesOfString:scoreCountHolder withString:scoreCount==0?@"":[NSString stringWithFormat:@"%i",scoreCount]];
            }
        }
    }
    [logDetails appendString:sbRow];
    
    //计算合计项
    
    html=[html stringByReplacingOccurrencesOfString:@"%LogDetailList%" withString:logDetails];
    return html;
}

- (void)viewDidUnload
{
    [self setViewReportView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return [AppConfig shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (IBAction)backToParentView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

-(NSString *)displayFoString:(NSString *)str{
    if(str==nil)
        return @"";
    else
        return str;
}

-(RoundInfo *)recalcRoundInfo:(RoundInfo *)roundDetail{
    if(roundDetail!=nil){
        NSDictionary * roundInfo=[[BO_SubmitedScoreInfo getInstance] querySideScoreOfRoundSeq:gameInfo.currentMatchInfo.currentRoundInfo.round matchId:gameInfo.currentMatchInfo.matchId];
        roundDetail.blueScore=[[roundInfo objectForKey:@"BLUE_SCORE"] intValue];
        roundDetail.blueWarnming=[[roundInfo objectForKey:@"BLUE_WARMNING"] intValue];
        roundDetail.redScore=[[roundInfo objectForKey:@"RED_SCORE"] intValue];
        roundDetail.redWarnming=[[roundInfo objectForKey:@"RED_WARMNING"] intValue];
    }
    return roundDetail;
}

@end
