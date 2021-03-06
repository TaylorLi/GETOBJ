//
//  AFPickerView.m
//  PickerView
//
//  Created by Fraerman Arkady on 24.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AFPickerView.h"

#define AFPicker_Row_Spacing 0

@implementation AFPickerView

#pragma mark - Synthesization

@synthesize dataSource;
@synthesize delegate;
@synthesize selectedRow = currentRow;
@synthesize rowFont = _rowFont;
@synthesize rowIndent = _rowIndent;
@synthesize playSound;



#pragma mark - Custom getters/setters

- (void)setSelectedRow:(int)selectedRow
{
    if (selectedRow >= rowsCount)
        return;
    
    currentRow = selectedRow;
    [contentView setContentOffset:CGPointMake(0.0,[delegate pickerViewRowHeight:self] * currentRow) animated:NO];
}




- (void)setRowFont:(UIFont *)rowFont
{
    _rowFont = rowFont;
    
    for (UILabel *aLabel in visibleViews) 
    {
        aLabel.font = _rowFont;
    }
    
    for (UILabel *aLabel in recycledViews) 
    {
        aLabel.font = _rowFont;
    }
}




- (void)setRowIndent:(CGFloat)rowIndent
{
    _rowIndent = rowIndent;
    
    for (UILabel *aLabel in visibleViews) 
    {
        CGRect frame = aLabel.frame;
        frame.origin.x = _rowIndent;
        frame.size.width = self.frame.size.width - _rowIndent;
        aLabel.frame = frame;
    }
    
    for (UILabel *aLabel in recycledViews) 
    {
        CGRect frame = aLabel.frame;
        frame.origin.x = _rowIndent;
        frame.size.width = self.frame.size.width - _rowIndent;
        aLabel.frame = frame;
    }
}




#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // setup
        [self setup];
        
        /*
        // backgound
        UIImageView *bacground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pickerBackground.png"]];
        [self addSubview:bacground];
        */
        
        // content
        contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        contentView.showsHorizontalScrollIndicator = NO;
        contentView.showsVerticalScrollIndicator = NO;
        contentView.delegate = self;
        [self addSubview:contentView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        tapRecognizer.numberOfTouchesRequired=1;
        tapRecognizer.numberOfTapsRequired=1;
        [contentView addGestureRecognizer:tapRecognizer];
        
        UITapGestureRecognizer *tapRecognizerDouble = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapDouble:)];
        tapRecognizerDouble.numberOfTouchesRequired=1;
        tapRecognizerDouble.numberOfTapsRequired=2;
        [contentView addGestureRecognizer:tapRecognizerDouble];
        
        /*
        // shadows
        UIImageView *shadows = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pickerShadows.png"]];
        [self addSubview:shadows];
        
        
        // glass
        UIImage *glassImage = [UIImage imageNamed:@"pickerGlass.png"];
        glassImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, [delegate pickerViewRowHeight:self], glassImage.size.width, glassImage.size.height)];
        glassImageView.image = glassImage;
        [self addSubview:glassImageView];
        */
        playSound=YES;
        avPlayer=[[SoundsPlayer alloc] init];
        //avPlayer.fullLoopInterval = 1;
        avPlayer.repeatCount = 6;
    }
    return self;
}




- (void)setup
{
    _rowFont = [UIFont boldSystemFontOfSize:15.0];
    _rowIndent = 0.0;
    
    currentRow = 0;
    rowsCount = 0;
    visibleViews = [[NSMutableSet alloc] init];
    recycledViews = [[NSMutableSet alloc] init];
}




#pragma mark - Buisness

- (void)reloadData
{
    // empry views
    currentRow = 0;
    rowsCount = 0;
    
    for (UIView *aView in visibleViews) 
        [aView removeFromSuperview];
    
    for (UIView *aView in recycledViews)
        [aView removeFromSuperview];
    
    visibleViews = [[NSMutableSet alloc] init];
    recycledViews = [[NSMutableSet alloc] init];
    
    rowsCount = [dataSource numberOfRowsInPickerView:self];
    [contentView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
    contentView.contentSize = CGSizeMake(contentView.frame.size.width, [delegate pickerViewRowHeight:self] * rowsCount + AFPicker_Row_Spacing * 2 * [delegate pickerViewRowHeight:self]);
    [self tileViews];
}

-(NSMutableSet *)visibleViews
{
    return visibleViews;
}


- (void)determineCurrentRow
{
    CGFloat delta = contentView.contentOffset.y;
    int position = round(delta / [delegate pickerViewRowHeight:self]);
    currentRow = position;
    [contentView setContentOffset:CGPointMake(0.0, [delegate pickerViewRowHeight:self] * position) animated:YES];
    [delegate pickerView:self didSelectRow:currentRow];
}



-(void)didTapDouble:(id)sender
{
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    CGPoint point = [tapRecognizer locationInView:self];
    int steps = floor(point.y / [delegate pickerViewRowHeight:self]) - AFPicker_Row_Spacing;
    if(steps==0){
        [delegate pickerView:self didTapCenter:tapRecognizer];
    }else{
        [self makeSteps:steps];
    }
}

- (void)didTap:(id)sender
{
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    CGPoint point = [tapRecognizer locationInView:self];
    int steps = floor(point.y / [delegate pickerViewRowHeight:self]) - AFPicker_Row_Spacing;    
    [delegate pickerView:self didTapCenter:tapRecognizer inStep:steps];
    if(steps==0 &&tapRecognizer.numberOfTouches==2){
        [delegate pickerView:self didTapCenter:tapRecognizer];
    }else{
        [self makeSteps:steps];
    }
}



- (void)makeSteps:(int)steps
{
    if(AFPicker_Row_Spacing>0)
        {
    if (steps == 0 || steps > AFPicker_Row_Spacing || steps < -AFPicker_Row_Spacing)
        return;
    }
    [contentView setContentOffset:CGPointMake(0.0, [delegate pickerViewRowHeight:self] * currentRow) animated:NO];
    
    int newRow = currentRow + steps;
    if (newRow < 0 || newRow >= rowsCount)
    {
        /*
        if (steps == -AFPicker_Row_Spacing)
            [self makeSteps:-1];
        else if (steps == AFPicker_Row_Spacing)
            [self makeSteps:1];
        */
        return;
    }
    
    currentRow = currentRow + steps;
    [contentView setContentOffset:CGPointMake(0.0, [delegate pickerViewRowHeight:self] * currentRow) animated:YES];
    [delegate pickerView:self didSelectRow:currentRow];
}




#pragma mark - recycle queue

- (UIView *)dequeueRecycledView
{
	UIView *aView = [recycledViews anyObject];
	
    if (aView) 
        [recycledViews removeObject:aView];
    return aView;
}



- (BOOL)isDisplayingViewForIndex:(NSUInteger)index
{
	BOOL foundPage = NO;
    for (UIView *aView in visibleViews) 
	{
        int viewIndex = aView.frame.origin.y / [delegate pickerViewRowHeight:self] - AFPicker_Row_Spacing;
        if (viewIndex == index) 
		{
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}




- (void)tileViews
{
    // Calculate which pages are visible
    CGRect visibleBounds = contentView.bounds;
    int firstNeededViewIndex = floorf(CGRectGetMinY(visibleBounds) / [delegate pickerViewRowHeight:self]) - AFPicker_Row_Spacing;
    int lastNeededViewIndex  = floorf((CGRectGetMaxY(visibleBounds) / [delegate pickerViewRowHeight:self])) - AFPicker_Row_Spacing;
    firstNeededViewIndex = MAX(firstNeededViewIndex, 0);
    lastNeededViewIndex  = MIN(lastNeededViewIndex, rowsCount - 1);
	
    // Recycle no-longer-visible pages 
	for (UIView *aView in visibleViews) 
    {
        int viewIndex = aView.frame.origin.y / [delegate pickerViewRowHeight:self] - AFPicker_Row_Spacing;
        if (viewIndex < firstNeededViewIndex || viewIndex > lastNeededViewIndex) 
        {
            [recycledViews addObject:aView];
            [aView removeFromSuperview];
        }
    }
    
    [visibleViews minusSet:recycledViews];
    
    // add missing pages
	for (int index = firstNeededViewIndex; index <= lastNeededViewIndex; index++) 
	{
        if (![self isDisplayingViewForIndex:index]) 
		{
            //UILabel *label = (UILabel *)[self dequeueRecycledView];
            /*
			if (label == nil)
            {
				label = [[UILabel alloc] initWithFrame:CGRectMake(_rowIndent, 0, self.frame.size.width - _rowIndent, [delegate pickerViewRowHeight:self])];
                label.backgroundColor = [UIColor clearColor];
                label.font = self.rowFont;
                label.textColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
            }*/
            UIView *label=[self dequeueRecycledView];
            if(label==nil){
                label=[delegate pickerView:self cellForRowAtIndexPath:index];
            }            
            [self configureView:label atIndex:index];
            [contentView addSubview:label];
            [visibleViews addObject:label];
        }
    }
}




- (void)configureView:(UIView *)view atIndex:(NSUInteger)index
{
    UIView *label = view;
    [dataSource pickerView:self prepareForCell:label rowAtIndex:index];
    CGRect frame = label.frame;
    frame.origin.y = [delegate pickerViewRowHeight:self] * index + [delegate pickerViewRowHeight:self] * AFPicker_Row_Spacing;
    label.frame = frame;
}




#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(playSound)
        [avPlayer playSoundWithFullPath:@"scrollerClick.wav"];
    [delegate pickerViewDidStartScroll:self];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tileViews];
}




- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
        [self determineCurrentRow];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self determineCurrentRow];
    if(playSound){
        [avPlayer stop];
    }  
}

@end
