//
//  RoundRestTimeViewController.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/24.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "RoundRestTimeViewController.h"
#import "AppConfig.h"

//#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@interface RoundRestTimeViewController ()

-(void) updateTime;

@end

@implementation RoundRestTimeViewController


@synthesize viewLoadedFromXib;
@synthesize btnStart;
@synthesize imgBackground;
@synthesize lblTime;
@synthesize relatedData;
@synthesize imgTimeMin;
@synthesize imgTimeSecTen;
@synthesize imgTimeSecSin;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title andRestTime:(NSTimeInterval) _restTime {
	if ((self = [super initWithFrame:frame])) {
        if(timeFlags==nil)
        {
            timeFlags=[[NSMutableArray alloc] initWithCapacity:10];
            for (int i=0; i<10; i++) {
                [timeFlags addObject:[UIImage imageNamed:[NSString stringWithFormat:@"rest_%i",i]]];
            }
        }
		restTime=_restTime;
		//CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		//[self.titleBar setColorComponents:colors];
		//self.headerLabel.text = title;
        //self.closeButton.hidden=YES;        
        self.borderWidth=0;        
        // Margin between edge of panel and the content area. Default = {20.0, 20.0, 20.0, 20.0}
        self.padding=UIEdgeInsetsMake(0.0f,0.0f,0.0f,0.0f);
        //self.titleBarHeight = 30.0f;        
        // The header label, a UILabel with the same frame as the titleBar
        //self.headerLabel.font = [UIFont boldSystemFontOfSize:20];
        
        viewLoadedFromXib= [[[NSBundle mainBundle] loadNibNamed:@"RoundRestTimeView" owner:self options:nil] objectAtIndex:0];
        //NSLog(@"%f,%f",self.bounds.size.width,self.bounds.size.height);
       
        //横向时，宽度与高度互换
        CGSize mainScreenSize =CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        CGSize contentViewSize=viewLoadedFromXib.bounds.size;
		/*以屏幕宽度作为大小时自适应处理
        self.margin = UIEdgeInsetsMake((mainScreenSize.height-contentViewSize.height)/2,(mainScreenSize.width-contentViewSize.width)/2,(mainScreenSize.height-contentViewSize.height)/2,(mainScreenSize.width-contentViewSize.width)/2);
        */
        //以显示内容为实际大小使背景可操作处理
        //去除灰色背景
        //[self setBackgroundColor:[UIColor clearColor]];
        //与实际内容适应,并使底部层可操作处理
        [self setFrame:CGRectMake((mainScreenSize.width-contentViewSize.width)/2,(mainScreenSize.height-contentViewSize.height)/2, contentViewSize.width, contentViewSize.height)];
 
        self.margin=UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        
        int min = restTime/60;
        int sec=fmod(restTime,60);
        lblTime.hidden=NO;
        btnStart.hidden=YES;
        lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
        [self drawTime:restTime];
        [self setTimerStop:NO];
        
        imgBackground.image=[UIImage imageNamed:@"game_rest_time"];
        [self.contentView addSubview:viewLoadedFromXib];        
        startGifView=[[UIGifView alloc] initWithImagePrefiex:@"game_rest_time_continue_btn_" imgLowIndex:1 imgHightIndex:6 andDstView:btnStart andInterval:1];
	}	
	return self;
}


-(void) viewDidLoad
{
    
}

- (void)layoutSubviews {
	[super layoutSubviews];
    [self.contentView setFrame:CGRectMake(0.0f,0.0f,self.contentView.frame.size.width,self.contentView.frame.size.height)];
    [self.roundedRect setFrame:CGRectMake(0.0f,0.0f,self.roundedRect.frame.size.width,self.roundedRect.frame.size.height)];
    [self.closeButton setFrame:CGRectMake(0.0f,0.0f,self.closeButton.frame.size.width,self.closeButton.frame.size.height)];
    
    [closeButton setFrame:CGRectMake(closeButton.frame.origin.x-closeButton.frame.size.width/4, closeButton.frame.origin.y-closeButton.frame.size.height/4, closeButton.frame.size.width, closeButton.frame.size.height)];
    
    /*以屏幕宽度作为大小时自适应处理
    [viewLoadedFromXib setFrame:self.contentView.bounds];
   
    
     [closeButton setFrame:CGRectMake(closeButton.frame.origin.x+closeButton.frame.size.width/4, closeButton.frame.origin.y+closeButton.frame.size.height/4, closeButton.frame.size.width/2, closeButton.frame.size.height/2)];
     */
     
}

-(void) updateTime
{
    restTime--;
	int min = restTime/60;
    int sec=fmod(restTime,60);
	lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    [self drawTime:restTime];
    if(restTime<=0){   
        [self setTimerStop:YES];
        btnStart.hidden=NO;
        lblTime.hidden=YES;
        imgBackground.image=[UIImage imageNamed:@"game_rest_time_start"];
        
        [UIView animateWithDuration:0.5 
						 animations:^{
                             btnStart.frame = CGRectMake(btnStart.frame.origin.x, btnStart.frame.origin.y, btnStart.frame.size.width/2, btnStart.frame.size.height/2);
						 } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.5 
                                              animations:^{
                                                  btnStart.frame = CGRectMake(btnStart.frame.origin.x, btnStart.frame.origin.y, btnStart.frame.size.width*2, btnStart.frame.size.height*2);
                                              } completion:^(BOOL finished) {
                                                  [startGifView startAnimate];
                                              }];
                         }];
       
    }
}

- (void)dealloc {
    if(timer!=nil)
    {
        [timer invalidate];
        timer=nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [AppConfig shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (IBAction)startRound:(id)sender {
    [self hideWithOnComplete:^(BOOL finished) {
        if ([delegate respondsToSelector:@selector(resetTimeEnd:)]) {
            [self removeFromSuperview];
        }  
        [delegate performSelector:@selector(resetTimeEnd:) withObject:relatedData];
    }]; 
}

-(void)setTimerStop:(BOOL) stop;
{
    if(stop){
        if(timer!=nil){
            [timer invalidate];
            timer=nil;
        }
    }
    else{        
        if (restTime>0 && timer==nil) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];            
        }
    }
}
-(void)drawTime:(NSTimeInterval)time
{    
    int min = time/60;
    int sec=(int)time%60;
    int secSin=sec%10;
    int secTen=sec/10;
    lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec]; 
    imgTimeMin.image=[timeFlags objectAtIndex:min];
    imgTimeSecTen.image=[timeFlags objectAtIndex:secTen];
    imgTimeSecSin.image=[timeFlags objectAtIndex:secSin];
    imgTimeMin.hidden=time<=0;
    imgTimeSecTen.hidden=time<=0;
    imgTimeSecSin.hidden=time<=0;
}
@end
