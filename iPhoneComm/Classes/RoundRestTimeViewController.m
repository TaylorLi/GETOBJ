//
//  RoundRestTimeViewController.m
//  TKD Score
//
//  Created by Eagle Du on 12/7/24.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "RoundRestTimeViewController.h"
#import "AppConfig.h"

#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@interface RoundRestTimeViewController ()

-(void) updateTime;

@end

@implementation RoundRestTimeViewController


@synthesize viewLoadedFromXib;
@synthesize btnStart;
@synthesize lblTime;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title andRestTime:(NSTimeInterval) _restTime {
	if ((self = [super initWithFrame:frame])) {
		restTime=_restTime;
		CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		[self.titleBar setColorComponents:colors];
		self.headerLabel.text = title;
        self.closeButton.hidden=YES;
		self.margin = UIEdgeInsetsMake(20.0f,20.0f,20.0f,20.0f);
        
        // Margin between edge of panel and the content area. Default = {20.0, 20.0, 20.0, 20.0}
        self.padding=UIEdgeInsetsMake(20.0f,20.0f,20.0f,20.0f);
        self.titleBarHeight = 30.0f;        
        // The header label, a UILabel with the same frame as the titleBar
        self.headerLabel.font = [UIFont boldSystemFontOfSize:20];
        
        [[NSBundle mainBundle] loadNibNamed:@"RoundRestTimeView" owner:self options:nil];
        //NSLog(@"%f,%f",self.bounds.size.width,self.bounds.size.height);
        int min = restTime/60;
        int sec=fmod(restTime,60);
        lblTime.hidden=NO;
        btnStart.hidden=YES;
        lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
        if(timer==nil){
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        }
        
        [self.contentView addSubview:viewLoadedFromXib];
        viewLoadedFromXib.center=[self.contentView center];
//        lblTime.frame=CGRectMake(([[UIScreen mainScreen] bounds].size.width -lblTime.superview.frame.size.width )/2.0, ([[UIScreen mainScreen] bounds].size.height - lblTime.superview.frame.size.height)/2.0, viewLoadedFromXib.frame.size.width, 0);
//        btnStart.frame=CGRectMake(([[UIScreen mainScreen] bounds].size.width-lblTime.superview.frame.size.width )/2.0, ([[UIScreen mainScreen] bounds].size.height - lblTime.superview.frame.size.height)/2.0, lblTime.superview.frame.size.width, 0);
	}	
	return self;
}


-(void) viewDidLoad
{
    
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[viewLoadedFromXib setFrame:self.contentView.bounds];
}

-(void) updateTime
{
    restTime--;
	int min = restTime/60;
    int sec=fmod(restTime,60);
	lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    if(restTime==0){   
        btnStart.hidden=NO;
        lblTime.hidden=YES;
        [UIView animateWithDuration:0.5 
						 animations:^{
                             btnStart.frame = CGRectMake(10.0f, 7.0f, btnStart.frame.size.width/2, btnStart.frame.size.height/2);
						 }];
        [UIView animateWithDuration:0.5 
						 animations:^{
                             btnStart.frame = CGRectMake(10.0f, 7.0f, btnStart.frame.size.width*2, btnStart.frame.size.height*2);
						 }];
    }
}

- (void)dealloc {
    if(timer!=nil)
    {
        [timer invalidate];
        timer=nil;
    }
	[viewLoadedFromXib release];
    [lblTime release];
    [btnStart release];
    [super dealloc];
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
        [delegate performSelector:@selector(resetTimeEnd:) withObject:nil];
    }]; 
}
@end