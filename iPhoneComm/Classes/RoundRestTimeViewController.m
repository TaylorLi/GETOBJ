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
@synthesize relatedData;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title andRestTime:(NSTimeInterval) _restTime {
	if ((self = [super initWithFrame:frame])) {
		restTime=_restTime;
		CGFloat colors[8] = BLACK_BAR_COMPONENTS;
		[self.titleBar setColorComponents:colors];
		self.headerLabel.text = title;
        //self.closeButton.hidden=YES;
		self.margin = UIEdgeInsetsMake(20.0f,20.0f,20.0f,20.0f);
        
        // Margin between edge of panel and the content area. Default = {20.0, 20.0, 20.0, 20.0}
        self.padding=UIEdgeInsetsMake(20.0f,20.0f,20.0f,20.0f);
        self.titleBarHeight = 30.0f;        
        // The header label, a UILabel with the same frame as the titleBar
        self.headerLabel.font = [UIFont boldSystemFontOfSize:20];
        
        viewLoadedFromXib= [[[NSBundle mainBundle] loadNibNamed:@"RoundRestTimeView" owner:self options:nil] objectAtIndex:0];
        //NSLog(@"%f,%f",self.bounds.size.width,self.bounds.size.height);
        int min = restTime/60;
        int sec=fmod(restTime,60);
        lblTime.hidden=NO;
        btnStart.hidden=YES;
        lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
        [self setTimerStop:NO];
        
        [self.contentView addSubview:viewLoadedFromXib];        
	}	
	return self;
}


-(void) viewDidLoad
{
    
}

- (void)layoutSubviews {
	[super layoutSubviews];
    if([AppConfig getInstance].isIPAD){
        NSLog(@"%@",NSStringFromCGRect(self.contentView.bounds));
    }else{
        [viewLoadedFromXib setFrame:CGRectMake(70, 20, self.contentView.bounds.size.width, self.contentView.bounds.size.height)];
    }
}

-(void) updateTime
{
    restTime--;
	int min = restTime/60;
    int sec=fmod(restTime,60);
	lblTime.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    if(restTime<=0){   
        [self setTimerStop:YES];
        btnStart.hidden=NO;
        lblTime.hidden=YES;
        [UIView animateWithDuration:0.5 
						 animations:^{
                             btnStart.frame = CGRectMake(btnStart.frame.origin.x, btnStart.frame.origin.y, btnStart.frame.size.width/2, btnStart.frame.size.height/2);
						 }];
        [UIView animateWithDuration:0.5 
						 animations:^{
                             btnStart.frame = CGRectMake(btnStart.frame.origin.x, btnStart.frame.origin.y, btnStart.frame.size.width*2, btnStart.frame.size.height*2);
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
        if (timer==nil) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];            
        }
    }
}
@end
