//
//  SimplePickerInputTableViewCell.h
//  PickerCellDemo
//
//  Created by Tom Fewster on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerInputTableViewCell.h"

@class TimePickerTableViewCell;

@protocol TimePickerTableViewCellDelegate <NSObject>
@optional
- (void)tableViewCell:(TimePickerTableViewCell *)cell didEndEditingWithInterval:(NSTimeInterval)value;
@end

@interface TimePickerTableViewCell : PickerInputTableViewCell <UIPickerViewDataSource, UIPickerViewDelegate> {
	NSTimeInterval value;
    NSTimeInterval _maxTime;
    NSTimeInterval _minTime;
    NSTimeInterval _interval;
    NSInteger secs;
    NSInteger mins;
}

@property (nonatomic,assign) NSTimeInterval value;
@property (weak) IBOutlet id <TimePickerTableViewCellDelegate> delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
              title:(NSString *) title selectValue:(NSTimeInterval) selValue maxTime:(NSTimeInterval) maxTime minTime:(NSTimeInterval) minTime interval:(NSTimeInterval) interval;

-(NSTimeInterval)reloadPickerWithselectValue:(NSTimeInterval) selValue maxTime:(NSTimeInterval) maxTime minTime:(NSTimeInterval) minTime interval:(NSTimeInterval) interval;
@end
