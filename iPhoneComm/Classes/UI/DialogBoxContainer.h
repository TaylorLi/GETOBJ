//
//  ShowWinnerBox.h
//  TKD Score
//
//  Created by Eagle Du on 12/8/18.
//  Copyright (c) 2012年 GET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UATitledModalPanel.h"
#import "UIHelper.h"

@protocol DialogBoxDelegate
@optional
- (void)actionByLoadedView:(UAModalPanel *)modalPanel subController:(id)controller eventType:(NSInteger) type eventArgs:(NSDictionary *)args;
@end


@interface DialogBoxContainer : UAModalPanel<FormBoxDelegate>
{
    
}
@property (nonatomic, strong) IBOutlet UIView *viewLoadedFromXib;
@property (nonatomic, strong) IBOutlet UIViewController *controllerLoadedFromXib;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title loadViewController:(UIViewController *)viewConroller withClossButton:(BOOL)showClose;
@property (nonatomic,unsafe_unretained) NSObject<DialogBoxDelegate> *formDelegate;

@end
