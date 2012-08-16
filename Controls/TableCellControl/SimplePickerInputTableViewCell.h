//
//  SimplePickerInputTableViewCell.h
//  PickerCellDemo
//
//  Created by Tom Fewster on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerInputTableViewCell.h"

@class SimplePickerInputTableViewCell;

@protocol SimplePickerInputTableViewCellDelegate <NSObject>
@optional
- (void)tableViewCell:(SimplePickerInputTableViewCell *)cell didEndEditingWithValue:(NSString *)value;
@end

@interface SimplePickerInputTableViewCell : PickerInputTableViewCell <UIPickerViewDataSource, UIPickerViewDelegate> {
	NSString *_value;
    __strong NSArray *values;
    NSInteger _selectedIndex;
}

@property (nonatomic, strong) NSString *value;
@property (weak) IBOutlet id <SimplePickerInputTableViewCellDelegate> delegate;
@property (nonatomic,assign) NSInteger selectedIndex;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
              title:(NSString *) title selectValue:(NSString *) selValue dataSource:(NSArray *) source;
-(void) reloadPicker:(NSArray *)sources;    

@end
