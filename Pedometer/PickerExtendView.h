//
//  PickerExtendView.h
//
//  Created by Taylor Li on 27/03/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerExtendView;

@protocol PickerExtendViewDelegate <NSObject>

@optional
- (void)pickerViewDidChangeValue:(PickerExtendView*)pickerView;

- (void)pickerViewDidChangeValue:(PickerExtendView *)pickerView seletedRowIndex:(NSInteger)rowIndex atComponentIndex:(NSInteger)componentIndex;

//- (CGFloat)heightForPickerView:(PickerExtendView *) pickerView;

- (CGSize)sizeForPickerView: (PickerExtendView *) pickerView; //default [30.0f, 20.0f]

//- (CGSize)sizeForRowInPickerView:(PickerExtendView *) pickerView;

//- (CGFloat)widthForPickerView:(PickerExtendView *) pickerView;

- (CGFloat)paddingForComponents:(PickerExtendView *) pickerView;

- (UIImage *)backgroundImageForPickerView:(PickerExtendView *) pickerView;

- (UIImage *)backgroundImageForShadeRow:(PickerExtendView *) pickerView;

- (CGFloat)alphaForShadeRow:(PickerExtendView *) pickerView;

- (NSInteger)rowNumberForShadeRow:(PickerExtendView *) pickerView;

//- (UIImage *)backgroundImageForSelectRowInPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex;

- (UIColor *)backgroundColorForPickerView:(PickerExtendView *) pickerView;

//- (UIColor *)backgroundColorForSelectRowInPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex;

- (UITextAlignment)textAlignmentForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex;

- (UIColor *)textColorForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex;

- (UIFont *)textFontForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex;

@end

@protocol PickerExtendViewDataSource <NSObject>

@required

//- (UIScrollView *)pickerView:(PickerExtendView *)pickerView subViewForRowAtPickerIndex:(NSInteger)pickerIndex;
- (NSString *)pickerView:(PickerExtendView *)pickerView titleForRow:(NSInteger)rowIndex forComponent:(NSInteger)componentIndex;


@optional

- (NSInteger)numberOfComponentsInPickerView:(PickerExtendView *)pickerView;              // Default 1 

- (NSInteger)numberOfRowsToShowForPickerView:(PickerExtendView *) pickerView;  // Default 1 
//- (NSInteger)numberOfRowsToShowForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex;  // Default 1 

- (NSInteger)maxNumberOfRowsForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex;  // Default 1

- (NSInteger)defaultSeletRowForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex;

@end

@interface PickerExtendView : UIView <UIScrollViewDelegate>
@property (nonatomic) NSInteger numberOfComponents;
@property (nonatomic) NSInteger maxNumberOfRowsToShowInComponent;


@property (nonatomic, weak) IBOutlet id <PickerExtendViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet id <PickerExtendViewDataSource> datasource;

- (void) reloadData;
- (NSInteger) selectRowIndexWithComponent:(NSInteger) componentIndex;

@end
