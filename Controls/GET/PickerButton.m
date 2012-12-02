//
//  PickerInputTableViewCell.m
//  ShootStudio
//
//  Created by Tom Fewster on 18/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerButton.h"

@interface PickerButton ()
-(void)btnPressed:(id)sender;
@end

@implementation PickerButton

@synthesize delegate;
@synthesize value=_value;
@synthesize selectedIndex=_selectedIndex;
@synthesize picker;

- (id)initWithFrame:(CGRect)frame selectValue:(NSString *) selValue dataSource:(NSArray *) source
{
    self = [self initWithFrame:frame];
    if (self) {
        self.titleLabel.textColor=[UIColor whiteColor];
        self.titleLabel.textAlignment=UITextAlignmentCenter;
        [self.titleLabel setFont:[UIFont fontWithName:@"System Bold" size:20]];
        // Initialization code
        values=source;
        [self setButtonTitle:selValue]; 
        [self setValue:selValue];
    }
    return self;
}

- (void)initalizeInputView {
	self.picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
	self.picker.showsSelectionIndicator = YES;
	self.picker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		UIViewController *popoverContent = [[UIViewController alloc] init];
		popoverContent.view = self.picker;
		popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
		popoverController.delegate = self;
	}
    self.picker.delegate = self;
    self.picker.dataSource = self;
    [self addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];  
}
-(void)btnPressed:(id)sender{  
    //UIButton* btn = (UIButton*)sender;  
    //开始写你自己的动作
    //self.titleLabel.text=self.value;
    [self becomeFirstResponder];
}  

-(void)setButtonTitle:(NSString *)t
{
    [self setTitle:t forState:UIControlStateNormal];
    [self setTitle:t forState:UIControlStateSelected];
    [self setTitle: t forState:UIControlStateHighlighted];
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self initalizeInputView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		[self initalizeInputView];
    }
    return self;
}

- (UIView *)inputView {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return nil;
	} else {
		return self.picker;
	}
}

- (UIView *)inputAccessoryView {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return nil;
	} else {
		if (!inputAccessoryView) {
			inputAccessoryView = [[UIToolbar alloc] init];
			inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
			inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
			[inputAccessoryView sizeToFit];
			CGRect frame = inputAccessoryView.frame;
			frame.size.height = 44.0f;
			inputAccessoryView.frame = frame;
			
			UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
			UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
			
			NSArray *array = [NSArray arrayWithObjects:flexibleSpaceLeft, doneBtn, nil];
			[inputAccessoryView setItems:array];
		}
		return inputAccessoryView;
	}
}

- (void)done:(id)sender {
	[self resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		CGSize pickerSize = [self.picker sizeThatFits:CGSizeZero];
		CGRect frame = self.picker.frame;
		frame.size = pickerSize;
		self.picker.frame = frame;
		popoverController.popoverContentSize = pickerSize;
		[popoverController presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		// resign the current first responder
		for (UIView *subview in self.superview.subviews) {
			if ([subview isFirstResponder]) {
				[subview resignFirstResponder];
			}
		}
		return NO;
	} else {
		[self.picker setNeedsLayout];
	}
	return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	return [super resignFirstResponder];
}

- (void)deviceDidRotate:(NSNotification*)notification {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		// we should only get this call if the popover is visible
		[popoverController presentPopoverFromRect:self.frame inView:self.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	} else {
		[self.picker setNeedsLayout];
	}
}

#pragma mark -
#pragma mark Respond to touch and become first responder.

- (BOOL)canBecomeFirstResponder {
	return YES;
}

#pragma mark -
#pragma mark UIKeyInput Protocol Methods

- (BOOL)hasText {
	return YES;
}

- (void)insertText:(NSString *)theText {
}

- (void)deleteBackward {
}

#pragma mark -
#pragma mark UIPopoverControllerDelegate Protocol Methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	[self resignFirstResponder];
}


- (void)setSelectedValue:(NSString *)v {
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
    [self setButtonTitle:_value];
    _selectedIndex=[values indexOfObject:_value];
	[self.picker selectRow:_selectedIndex inComponent:0 animated:YES];
}

-(void)setSelectedIndex:(NSInteger)v
{
    if(v==-1||v>[values count]-1)
        v=0;
    _selectedIndex=v;
    _value=[values objectAtIndex:v];
    self.titleLabel.text = _value;
	[self.picker selectRow:v inComponent:0 animated:YES]; 
}
-(void) reloadPicker:(NSArray *)sources
{
    values=sources;
    [self.picker reloadComponent:0];
    [self setSelectedValue:_value];
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
	return 250.0f; //pickerView.bounds.size.width - 20.0f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.value = [values objectAtIndex:row];
    [self setButtonTitle:self.value]; 
	if (delegate && [delegate respondsToSelector:@selector(tableViewCell:didEndEditingWithValue:)]) {
		[delegate buttonPikcerDidSelectedRow:self didEndEditingWithValue:self.value andSelectedIndex:self.selectedIndex];
	}
}

@end
