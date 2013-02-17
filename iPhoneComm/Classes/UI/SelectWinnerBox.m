                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              //
//  WinnnerBox.m
//  TKD Score
//
//  Created by Eagle Du on 12/8/18.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "SelectWinnerBox.h"
#import "AppConfig.h"
#import "ShowWinnerBox.h"
#import "MatchInfo.h"
//#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@implementation SelectWinnerBox

@synthesize viewLoadedFromXib;
@synthesize gameInfo;
@synthesize selectWinTypeButton,selectWinTypeButtonRed;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
		//CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		//[self.titleBar setColorComponents:colors];
		//self.headerLabel.text = title;
        //self.closeButton.hidden=YES;
		//self.margin = UIEdgeInsetsMake(111.0f,109.0f,111.0f,109.0f);
        self.borderWidth=0;
        // Margin between edge of panel and the content area. Default = {20.0, 20.0, 20.0, 20.0}
        self.padding=UIEdgeInsetsMake(0.0f,0.0f,0.0f,0.0f);
        //self.titleBarHeight = 30.0f;        
        // The header label, a UILabel with the same frame as the titleBar
        //self.headerLabel.font = [UIFont boldSystemFontOfSize:20];        
        viewLoadedFromXib= [[[NSBundle mainBundle] loadNibNamed:@"SelectWinnerBox" owner:self options:nil] objectAtIndex:0];
        winTypes=[[OrderedDictionary alloc] initWithCapacity:3];
        for (int i=kWinByPoint; i<=kWinByByWarning; i++) {
            [winTypes appendObject:[Definition getWinTypeDesc:i] forKey:[UtilHelper stringWithInt:i]];
        }    
        //横向时，宽度与高度互换
        CGSize mainScreenSize =CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        CGSize contentViewSize=viewLoadedFromXib.bounds.size;
        //以屏幕宽度作为大小时自适应处理
        self.margin = UIEdgeInsetsMake((mainScreenSize.height-contentViewSize.height)/2,(mainScreenSize.width-contentViewSize.width)/2,(mainScreenSize.height-contentViewSize.height)/2,(mainScreenSize.width-contentViewSize.width)/2);
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.1]];
        [self.contentView addSubview:viewLoadedFromXib];           
    }
    return self;
}


/*计算胜利方及获胜方式*/
-(void)calcWinTypeByGameInfo
{
    if(gameInfo.currentMatchInfo.blueSideWarning==gameInfo.gameSetting.maxWarningCount||gameInfo.currentMatchInfo.redSideWarning==gameInfo.gameSetting.maxWarningCount)
    {
        currentWinType=kWinByByWarning;
        rebPlayerWin=gameInfo.currentMatchInfo.blueSideWarning==gameInfo.gameSetting.maxWarningCount;
    }
    else  if(gameInfo.currentMatchInfo.pointGapReached)
    {
        currentWinType=kWinByPointGap;
        rebPlayerWin=gameInfo.currentMatchInfo.redSideScore>gameInfo.currentMatchInfo.blueSideScore;
    }
    else{
        currentWinType=kWinByPoint;
        rebPlayerWin=gameInfo.currentMatchInfo.redSideScore>gameInfo.currentMatchInfo.blueSideScore;
    }   
}
-(void)bindByGameInfo
{
    [self calcWinTypeByGameInfo];    
    if(rebPlayerWin){        
        [selectWinTypeButtonRed reloadPicker:winTypes];
        [selectWinTypeButtonRed setSelectedValue:[NSString stringWithFormat:@"%i",currentWinType]];
        selectWinTypeButton.hidden=YES;
        selectWinTypeButtonRed.hidden=NO;
    }
    else{        
        [selectWinTypeButton reloadPicker:winTypes];
        [selectWinTypeButton setSelectedValue:[NSString stringWithFormat:@"%i",currentWinType]];
        selectWinTypeButton.hidden=NO;
        selectWinTypeButtonRed.hidden=YES;
    }    
     
}
- (void)layoutSubviews {
	[super layoutSubviews];    
    /*以屏幕宽度作为大小时自适应处理
     [viewLoadedFromXib setFrame:self.contentView.bounds];
     */ 
    CGRect f = [self roundedRectFrame];
    
    self.closeButton.frame = CGRectMake(f.origin.x+f.size.width - floor(closeButton.frame.size.width*0.5),
                                        f.origin.y - floor(closeButton.frame.size.height*0.5),
                                        closeButton.frame.size.width,
                                        closeButton.frame.size.height);
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [AppConfig shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (IBAction)selectRedToWinner:(id)sender {
    [self showWinner:YES];
}

- (IBAction)selectBlueToWinner:(id)sender {
    [self showWinner:NO];
}

-(void)showWinner:(BOOL)red
{
    if(selectWinTypeButton.hidden==NO)
        currentWinType=[selectWinTypeButton.value intValue];
    else if(selectWinTypeButtonRed.hidden==NO)
        currentWinType=[selectWinTypeButtonRed.value intValue];
    [self hideWithOnComplete:^(BOOL finished) {
        if ([delegate respondsToSelector:@selector(selectedWinnerEnd:)]) {
            [self removeFromSuperview];            
            [delegate performSelector:@selector(selectedWinnerEnd:) withObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithBool:red],[NSNumber numberWithInt:currentWinType],nil]];
        }  
    }]; 
}

@end
