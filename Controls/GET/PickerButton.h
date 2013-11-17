//
//  ShootStatusInputTableViewCell.h
//  ShootStudio
//
//  Created by Tom Fewster on 18/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderedDictionary.h"

@class PickerButton;

@protocol PickerButtonDelegate <NSObject>
@optional
- (void)buttonPikcerDidSelectedRow:(PickerButton *)button didEndEditingWithValue:(NSString *)value
andSelectedIndex:(NSInteger) index;
@end

@interface PickerButton : UIButton <UIKeyInput, UIPopoverControllerDelegate,UIPickerViewDataSource, UIPickerViewDelegate> {
	// For iPad
	UIPopoverController *popoverController;
	UIToolbar *inputAccessoryView;
    NSString *_value;
   __strong OrderedDictionary *values;
    NSInteger _selectedIndex;
}

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *text;
@property (weak) IBOutlet id <PickerButtonDelegate> delegate;
@property (nonatomic,assign) NSInteger selectedIndex;

- (id)initWithFrame:(CGRect)frame selectValue:(NSString *) selValue dataSource:(OrderedDictionary *) source;
-(void) reloadPicker:(OrderedDictionary *)sources;   
- (void)setSelectedValue:(NSString *)v;
-(void)setSelectedIndex:(NSInteger)v;
-(void)setButtonTitle:(NSString *)t;
@end
