//
//  DetailReportViewController.m
//  TKD Score
//
//  Created by Eagle Du on 12/12/30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailReportViewController.h"

#import "RoundInfo.h"
#import "MatchLog.h"
#import "MatchInfo.h"
#import "GameInfo.h"
#import "BO_MatchLog.h"
#import "BO_RoundInfo.h"
#import "BO_SubmitedScoreInfo.h"
#import "GameInfo.h"
#import "ServerSetting.h"
#import "NSString+MD5Addition.h"

@interface DetailReportViewController ()

-(NSString *)genReportHTML;
-(NSString *)displayFoString:(NSString *)str;

@end

@implementation DetailReportViewController
@synthesize viewReportView;

@synthesize gameInfo,selRound;

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
   NSString *path = [[NSBundle mainBundle] pathForResource:@"DetailReport.html" ofType:nil];
   NSString *html= [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    RoundInfo *roundInfo=[[BO_RoundInfo getInstance] retreiveRoundByMatchId:gameInfo.currentMatchInfo.matchId andRoundSeq:selRound];
    NSLog(@"Round Info:%@",roundInfo);
    html=[html stringByReplacingOccurrencesOfStringIngoreNil:@"%Court%" withString:[NSString stringWithFormat:@"%@%03i",gameInfo.gameSetting.screeningArea,gameInfo.currentMatch]];
    html=[html stringByReplacingOccurrencesOfStringIngoreNil:@"%Round%" withString:[NSString stringWithFormat:@"%i",roundInfo.round]];
    html=[html stringByReplacingOccurrencesOfStringIngoreNil:@"%StartTime%" withString:[UtilHelper formateDate:roundInfo.startTime withFormate:@"dd MMM,yyyy(HH:mm:ss)"]];
    NSString *endDate=@"";
    NSString *blueWinFlag=@"";
    NSString *redWinFlag=@"";

    if(roundInfo.endTime!=nil){
        endDate =[NSString stringWithFormat:@"End Time: %@", [UtilHelper formateDate:roundInfo.endTime withFormate:@"dd MMM,yyyy(HH:mm:ss)"]];     
        if(roundInfo.roundWinnerisBlue){
            blueWinFlag =@"(W)";
        }
        else{
            redWinFlag=@"(W)";
        }
    }
    html=[html stringByReplacingOccurrencesOfStringIngoreNil:@"%EndTime%" withString:endDate];
    html=[html stringByReplacingOccurrencesOfStringIngoreNil:@"%BlueWin%" withString:blueWinFlag];
    html=[html stringByReplacingOccurrencesOfStringIngoreNil:@"%RedWin%" withString:redWinFlag];
    NSString *rowFormat=@"<tr style='background-color: White;'> \
    <td> \
    %i    \
    </td> \
    <td>  \
    %@  \
    </td> \
    <td style='text-align:right'>  \
    %@  \
    </td>  \
    <td style='text-align:right'>  \
    %@ \
    </td> \
    <td style='text-align:right'> \
    %@ \
    </td> \
    <td style='text-align:right'> \
    %@ \
    </td> \
    <td> \
    %@ \
    </td> \
    <td style='background-color: Black; width: 16px; height: 14px;'> \
    </td> \
    <td style='text-align:right'> \
    %@ \
    </td> \
    <td style='text-align:right'> \
    %@ \
    </td> \
    <td style='text-align:right'> \
    %@ \
    </td> \
    <td style='text-align:right'> \
    %@ \
    </td> \
    <td> \
    %@ \
    </td> \
    <td> \
    <span style='color:blue'>%@</span><span>%@</span><span style='color:red'>%@</span> \
    </td> \
    </tr> \
";
    NSMutableString *logDetails=[[NSMutableString alloc] initWithCapacity:1000];
    NSArray *matchLogs=[[BO_MatchLog getInstance] queryLogByMatchId:gameInfo.currentMatchInfo.matchId andRoundSeq:selRound];
    for (MatchLog *log in matchLogs) {
        [logDetails appendFormat:rowFormat,log.round,log.roundTime,[self displayFoString:log.blueScoreByJudge1],[self displayFoString:log.blueScoreByJudge2],[self displayFoString:log.blueScoreByJudge3],[self displayFoString:log.blueScoreByJudge4],[self displayFoString:log.blueEvents],[self displayFoString:log.redScoreByJudge1],[self displayFoString:log.redScoreByJudge2],[self displayFoString:log.redScoreByJudge3],[self displayFoString:log.redScoreByJudge4],[self displayFoString:log.redEvents],[self displayFoString:log.blueScore],log.redScore!=nil?@":":@"",[self displayFoString:log.redScore]];
    }
    html=[html stringByReplacingOccurrencesOfStringIngoreNil:@"%LogDetailList%" withString:logDetails];
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
	return YES;
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
@end
