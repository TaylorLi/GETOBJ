//
//  SimplePickerInputTableViewCell.m
//  PickerCellDemo
//
//  Created by Tom Fewster on 10/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TimePickerTableViewCell.h"

@implementation TimePickerTableViewCell

@synthesize delegate;
@synthesize value;

+ (void)initialize {
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
              title:(NSString *) title selectValue:(NSTimeInterval) selValue maxTime:(NSTimeInterval) maxTime minTime:(NSTimeInterval) minTime interval:(NSTimeInterval) interval
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.text=title;       
		self.picker.delegate = self;
		self.picker.dataSource = self;
        _minTime=minTime;
        _maxTime=maxTime;
        _interval=interval;
        [self setValue:selValue];
    }
    return self;
}
-(NSTimeInterval)reloadPickerWithselectValue:(NSTimeInterval) selValue maxTime:(NSTimeInterval) maxTime minTime:(NSTimeInterval) minTime interval:(NSTimeInterval) interval
{
    _minTime=minTime;
    _maxTime=maxTime;
    _interval=interval;
    [self.picker reloadAllComponents];
    [self setValue:selValue];
    NSTimeInterval time=0;
   time= [self.detailTextLabel.text intValue]*60+ [[self.detailTextLabel.text substringFromIndex:[self.detailTextLabel.text rangeOfString:@"Mins"].location+4] intValue]; 
    return time;
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

- (void)setValue:(NSTimeInterval)v {
	value = v;
    secs=(int)v%60/_interval;
    mins=(int)v/60;
    [self.picker selectRow:secs inComponent:1 animated:YES];
    [self.picker selectRow:mins inComponent:0 animated:YES];
    
	self.detailTextLabel.text =[NSString stringWithFormat:@"%i Mins %i Seconds",(int)v/60,(int)v%60];
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0)
      return (_maxTime-_minTime)/60+1;
    else
      return  (60%(int)_interval==0)?60/_interval: 60/_interval+1;
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(component==0){
        return [NSString stringWithFormat:@"%i Mins",row];
    }    
    else
       return [NSString stringWithFormat:@"%i Secs",row *(int)_interval]; }

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 44.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 300.0f/2; //pickerView.bounds.size.width - 20.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {	
    if(component==0){
        mins=row;
        secs=0;
    }
    else
        secs=row*_interval;    
    NSTimeInterval time=secs+mins*60;
    if(time>_maxTime)
        time=_maxTime;
    if(time<_minTime)
        time=_minTime;
    [self setValue:time];
	if (delegate && [delegate respondsToSelector:@selector(tableViewCell:didEndEditingWithValue:)]) {
		[delegate tableViewCell:self didEndEditingWithInterval:time];
	}
}

@end
