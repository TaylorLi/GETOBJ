//
//  AFPickerView.h
//  PickerView
//
//  Created by Fraerman Arkady on 24.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SoundsPlayer.h"

@protocol AFPickerViewDataSource;
@protocol AFPickerViewDelegate;

@interface AFPickerView : UIView <UIScrollViewDelegate>
{
    __unsafe_unretained id <AFPickerViewDataSource> dataSource;
    __unsafe_unretained id <AFPickerViewDelegate> delegate;
    UIScrollView *contentView;
    UIImageView *glassImageView;
    
    int currentRow;
    int rowsCount; 
    
    CGPoint previousOffset;
    BOOL isScrollingUp;
    
    // recycling
    NSMutableSet *recycledViews;
    NSMutableSet *visibleViews;
    
    UIFont *_rowFont;
    CGFloat _rowIndent;
    SoundsPlayer *avPlayer;
}

@property (nonatomic, unsafe_unretained) id <AFPickerViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) id <AFPickerViewDelegate> delegate;
@property (nonatomic, unsafe_unretained) int selectedRow;
@property (nonatomic, strong) UIFont *rowFont;
@property (nonatomic, unsafe_unretained) CGFloat rowIndent;
@property (nonatomic) BOOL playSound;

- (void)setup;
- (void)reloadData;
- (void)determineCurrentRow;
- (void)didTap:(id)sender;
- (void)makeSteps:(int)steps;

// recycle queue
- (UIView *)dequeueRecycledView;
- (BOOL)isDisplayingViewForIndex:(NSUInteger)index;
- (void)tileViews;
- (void)configureView:(UIView *)view atIndex:(NSUInteger)index;

-(NSMutableSet *)visibleViews;
@end



@protocol AFPickerViewDataSource <NSObject>

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView;
- (void)pickerView:(AFPickerView *)pickerView prepareForCell:(UIView *) cellView rowAtIndex:(NSInteger)rowIndex;

@end



@protocol AFPickerViewDelegate <NSObject>

- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row;
- (void)pickerViewDidStartScroll:(AFPickerView *)pickerView;

- (CGFloat)pickerView:(AFPickerView *)pickerView heightForRowAtIndexPath:(NSInteger)rowIndex;

-(UIView *)pickerView:(AFPickerView *)pickerView cellForRowAtIndexPath:(NSInteger)rowIndex;
-(void)pickerView:(AFPickerView *)pickerView didTapCenter:(UITapGestureRecognizer *)recognizer;
- (float)pickerViewRowHeight:(AFPickerView *)pickerView;
@end