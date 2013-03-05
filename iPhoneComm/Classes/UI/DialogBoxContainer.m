//
//  ShowWinnerBox.m
//  TKD Score
//
//  Created by Eagle Du on 12/8/18.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import "DialogBoxContainer.h"

//#define BLACK_BAR_COMPONENTS				{ 0.22, 0.22, 0.22, 1.0, 0.07, 0.07, 0.07, 1.0 }

@implementation DialogBoxContainer


@synthesize viewLoadedFromXib,controllerLoadedFromXib,formDelegate;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title loadViewController:(UIViewController *)viewConroller withClossButton:(BOOL)showClose
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
        //self.titleBarHeight = 50.0f;        
        // The header label, a UILabel with the same frame as the titleBar
        //self.headerLabel.font = [UIFont boldSystemFontOfSize:35];
        [viewConroller setValue:self forKey:@"delegate"];
        controllerLoadedFromXib = viewConroller;
        viewLoadedFromXib=viewConroller.view;
        //viewLoadedFromXib= [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] objectAtIndex:0];
        //横向时，宽度与高度互换
        CGSize mainScreenSize =CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        CGSize contentViewSize=viewLoadedFromXib.bounds.size;
        //以屏幕宽度作为大小时自适应处理
        self.margin = UIEdgeInsetsMake((mainScreenSize.height-contentViewSize.height)/2,(mainScreenSize.width-contentViewSize.width)/2,(mainScreenSize.height-contentViewSize.height)/2,(mainScreenSize.width-contentViewSize.width)/2);
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.1]];
        [self.contentView addSubview:viewLoadedFromXib];  
        if(!showClose){
            self.closeButton.hidden=YES;
        }
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    //NSLog(@"%@",NSStringFromCGRect(self.contentView.bounds));
    //[viewLoadedFromXib setFrame:self.contentView.bounds];
    /*
     self.closeButton.imageView.autoresizingMask=YES;
     [self.closeButton setFrame:CGRectMake(self.closeButton.frame.origin.x, self.closeButton.frame.origin.y, 70.0f, 70.0f)];     
     self.closeButton.imageView.image=[UIImage imageNamed:@"game_close_btn.png"];
     NSLog(@"%@",NSStringFromCGRect(self.closeButton.frame));   
     */
    CGRect f = [self roundedRectFrame];
    
    self.closeButton.frame = CGRectMake(f.origin.x+f.size.width - floor(closeButton.frame.size.width*0.5),
                                        f.origin.y - floor(closeButton.frame.size.height*0.5),
                                        closeButton.frame.size.width,
                                        closeButton.frame.size.height);
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)actionByView:(id)controller eventType:(NSInteger) type eventArgs:(NSDictionary *)args
{
    if([formDelegate respondsToSelector:@selector(actionByLoadedView:subController:eventType:eventArgs:)]){
        [formDelegate actionByLoadedView:self subController:controller eventType:type eventArgs:args];
    }
}

@end
