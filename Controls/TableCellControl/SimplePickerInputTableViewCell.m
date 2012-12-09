//
//  SimplePickerInputTableViewCell.m
//  PickerCellDemo
//
//  Created by Tom Fewster on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SimplePickerInputTableViewCell.h"

@implementation SimplePickerInputTableViewCell

@synthesize delegate;
@synthesize value=_value;
@synthesize selectedIndex=_selectedIndex;

+ (void)initialize {
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
              title:(NSString *) title selectValue:(NSString *) selValue dataSource:(NSArray *) source
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        values=source;
        self.textLabel.text=title;        
		self.picker.delegate = self;
		self.picker.dataSource = self;
        [self setValue:selValue];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
		self.picker.delegate = self;
		self.picker.dataSource = self;
    }
    return self;
}

- (void)setValue:(NSString *)v {
    if(values==nil||values.count==0){
        return;
    }
    if(v==nil)
        _value=[values objectAtIndex:0];
	else{
        BOOL find=NO;
        for (NSString *str in values) {
            if([str isEqualToString:v])
            {
                find = YES;
                break;
            }
        }
        if(find)
        {                
            _value = v;
            
        }
        else{
            _value=[values objectAtIndex:0];
        }
	}
    self.detailTextLabel.text = _value;
    _selectedIndex=[values indexOfObject:_value];
	[self.picker selectRow:_selectedIndex inComponent:0 animated:YES];
}
-(void)setSelectedIndex:(NSInteger)v
{
    if(v==-1||v>[values count]-1)
        v=0;
    _selectedIndex=v;
    _value=[values objectAtIndex:v];
	[self.picker selectRow:v inComponent:0 animated:YES]; 
}
-(void) reloadPicker:(NSArray *)sources
{
    values=sources;
    [self.picker reloadComponent:0];
    [self setValue:_value];
}
#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [values count];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [values objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 44.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 300.0f; //pickerView.bounds.size.width - 20.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.value = [values objectAtIndex:row];
    
	if (delegate && [delegate respondsToSelector:@selector(tableViewCell:didEndEditingWithValue:)]) {
		[delegate tableViewCell:self didEndEditingWithValue:self.value];
	}
}

@end
