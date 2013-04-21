//
//  PickerExtendView.m
//
//  Created by Taylor Li on 27/03/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "PickerExtendView.h"

@interface PickerExtendView () 
{
    NSMutableArray *scrollViews;
    NSInteger padding4Components;
    CGSize pvSize;
    CGSize rowSize;
    NSMutableArray *selectRowArr;
//    NSMutableArray *maxNumberOfRowsInComponentArr;
}
-(void) initComponent;
-(CGFloat) paddingLeft4Component;
-(CGFloat) paddingTop4Component;

@end

@implementation PickerExtendView

@synthesize numberOfComponents, maxNumberOfRowsToShowInComponent;

@synthesize delegate = _delegate;
@synthesize datasource = _datasource;

- (PickerExtendView *) init{
    self = [super init];
    return self;
}

- (PickerExtendView *) initWithFrame:(CGRect) frame{
    self = [super initWithFrame:frame];
    return self;
}

-(CGFloat) paddingLeft4Component{
    return (pvSize.width - (numberOfComponents - 1) * padding4Components - numberOfComponents * rowSize.width)/2; 
}

-(CGFloat) paddingTop4Component{
    return (pvSize.height - maxNumberOfRowsToShowInComponent * rowSize.height) / 2;
}

-(void)panGestureHandler:(UIPanGestureRecognizer*) recognizer{
    
}

-(void) initComponent{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]  
                                                    initWithTarget:self  
                                                    action:@selector(panGestureHandler:)];      
    [self addGestureRecognizer:panGestureRecognizer]; 
    
    
    padding4Components = 0;
    rowSize = CGSizeMake(50.0f, 30.0f);
    numberOfComponents = 1;
    maxNumberOfRowsToShowInComponent = 1;
    if([self.delegate respondsToSelector:@selector(paddingForComponents:)]){
        padding4Components = [self.delegate paddingForComponents:self];
    }
    if([self.delegate respondsToSelector:@selector(sizeForRowInPickerView:)]){
        rowSize = [self.delegate sizeForRowInPickerView:self];
    }
    if([self.datasource respondsToSelector:@selector(numberOfComponentsInPickerView:)]){
        numberOfComponents = [self.datasource numberOfComponentsInPickerView:self];
    }
    if([self.datasource respondsToSelector:@selector(numberOfRowsToShowForPickerView:atComponentIndex:)]){
        for (int i=0; i<numberOfComponents; i++) {
            NSInteger numberOfRowsInComponent = [self.datasource numberOfRowsToShowForPickerView:self atComponentIndex:i];
            if(maxNumberOfRowsToShowInComponent < numberOfRowsInComponent){
                maxNumberOfRowsToShowInComponent = numberOfRowsInComponent;
            }
        }
    }
    if([self.delegate respondsToSelector:@selector(sizeForPickerView:)]){
        pvSize = [self.delegate sizeForPickerView:self];
    }else{
        pvSize = CGSizeMake(rowSize.width * numberOfComponents + (numberOfComponents - 1) * padding4Components, rowSize.height * maxNumberOfRowsToShowInComponent);
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, pvSize.width, pvSize.height);
    self.clipsToBounds = YES;
//    self.backgroundColor = [UIColor yellowColor];
//    NSLog(@"%f-%f-%f-%f", self.frame.origin.x, self.frame.origin.y, rowSize.width * numberOfComponents + (numberOfComponents - 1) * padding4Components, rowSize.height * maxNumberOfRowsToShowInComponent);
    if([self.delegate respondsToSelector:@selector(backgroundColorForPickerView:)]){
        self.backgroundColor = [self.delegate backgroundColorForPickerView:self];
    }
    
    if([self.delegate respondsToSelector:@selector(backgroundImageForPickerView:)]){
        UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        backgroundImageView.image = [self.delegate backgroundImageForPickerView:self];
        [self addSubview:backgroundImageView];
    }
    
    scrollViews = [[NSMutableArray alloc] init];
    selectRowArr = [[NSMutableArray alloc] initWithCapacity:numberOfComponents];
//    maxNumberOfRowsInComponentArr = [[NSMutableArray alloc]initWithCapacity:numberOfComponents];
    
    CGFloat x4Components = 0;
    for (int i=0; i<numberOfComponents; i++) {
        [selectRowArr addObject:[NSNumber  numberWithInt:0]]; 

//        [maxNumberOfRowsInComponentArr addObject:[NSNumber  numberWithInt:0]];
        
        NSInteger numberOfRowsInComponent = 1;
        if([self.datasource respondsToSelector:@selector(numberOfRowsToShowForPickerView:atComponentIndex:)]){
            numberOfRowsInComponent = [self.datasource numberOfRowsToShowForPickerView:self atComponentIndex:i];
        }
        UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake([self paddingLeft4Component] + x4Components, [self paddingTop4Component], rowSize.width, numberOfRowsInComponent * rowSize.height)];

        x4Components += (i== 0 ? [self paddingTop4Component] : 0) + rowSize.width + padding4Components;
        
        [scrollViews addObject:scrollView];
        scrollView.delegate = self;       
        [self addSubview:scrollView];
    }
    
    
}

- (void) reloadData{
    for (int i=0; i<numberOfComponents; i++) {
        UIScrollView *scrollView = [scrollViews objectAtIndex:i];
        for (UIView *v in scrollView.subviews) {
            [v removeFromSuperview];
        }
        if([self.datasource respondsToSelector:@selector(defaultSeletRowForPickerView:atComponentIndex:)]){
            [selectRowArr replaceObjectAtIndex:i withObject:[NSNumber  numberWithInt:[self.datasource defaultSeletRowForPickerView:self atComponentIndex:i]]];
        }
        NSInteger maxNumberOfRowsInComponent = 1;
        if([self.datasource respondsToSelector:@selector(maxNumberOfRowsForPickerView:atComponentIndex:)]){
            maxNumberOfRowsInComponent = [self.datasource maxNumberOfRowsForPickerView:self atComponentIndex:i];
        }
//        [maxNumberOfRowsInComponentArr replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:maxNumberOfRowsInComponent]];
        
        if([[selectRowArr objectAtIndex:i] intValue] >= maxNumberOfRowsInComponent){
            [selectRowArr replaceObjectAtIndex:i withObject:[NSNumber numberWithInt: maxNumberOfRowsInComponent -1]];
        }

        for (int j=0; j<maxNumberOfRowsInComponent; j++) {
            NSString *title = [self.datasource pickerView:self titleForRow:j forComponent:i];
            UILabel* label = [[UILabel alloc] initWithFrame:scrollView.bounds];
            label.backgroundColor = [UIColor clearColor];
            if([self.delegate respondsToSelector:@selector(textColorForPickerView:atComponentIndex:)]){
                label.textColor = [self.delegate textColorForPickerView:self atComponentIndex:i];
            }else{
                label.textColor = [UIColor blackColor];
            }
            if([self.delegate respondsToSelector:@selector(textFontForPickerView:atComponentIndex:)]){
                label.font = [self.delegate textFontForPickerView:self atComponentIndex:i];
            }else{
                label.font = [UIFont systemFontOfSize:12.0];
            }
            if([self.delegate respondsToSelector:@selector(textAlignmentForPickerView:atComponentIndex:)]){
                label.textAlignment = [self.delegate textAlignmentForPickerView:self atComponentIndex:i];
            }else{
                label.textAlignment = UITextAlignmentLeft;
            }
            label.text = title;
            
            CGRect frame = label.frame;
            frame.origin.y = rowSize.height * j;
            //frame.size.width -= 2;
            label.frame = frame;
            [scrollView addSubview:label];
        }
        
        scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height*maxNumberOfRowsInComponent);
        scrollView.pagingEnabled = YES;
        scrollView.clipsToBounds = YES;
        scrollView.scrollEnabled = YES;
        scrollView.delegate = self;
        
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, [[selectRowArr objectAtIndex:i] intValue] * rowSize.height);
//        if([self.delegate respondsToSelector:@selector(backgroundImageForSelectRowInPickerView:atComponentIndex:)]){
//            UIView *rowBackgroundView = [[UIView alloc] initWithFrame:scrollView.bounds];
//            rowBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[self.delegate backgroundImageForSelectRowInPickerView:self atComponentIndex:i]];
//            [scrollView addSubview:rowBackgroundView];
//        }
    }
}

//- (void)awakeFromNib {
//    [self initComponent];
//    [self reloadData];
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.y / scrollView.bounds.size.height;
    NSInteger componentIndex = -1;
    for (int i=0; i<numberOfComponents; i++) {
        UIScrollView *baseScrollView = [scrollViews objectAtIndex:i];
        if(baseScrollView == scrollView){
            componentIndex = i;
            break;
        }
    }
    [selectRowArr replaceObjectAtIndex:componentIndex withObject:[NSNumber numberWithInt:page]];

    if([self.delegate respondsToSelector:@selector(pickerViewDidChangeValue:seletedRowIndex:atComponentIndex:)]){
        [self.delegate pickerViewDidChangeValue:self seletedRowIndex:page atComponentIndex:componentIndex];
    }
    
    if([self.delegate respondsToSelector:@selector(pickerViewDidChangeValue:)]){
        [self.delegate pickerViewDidChangeValue:self];
    }
}

- (NSInteger) selectRowIndexWithComponent:(NSInteger) componentIndex{
    if(selectRowArr){
        return [[selectRowArr objectAtIndex:componentIndex] intValue];
    }else{
        return -1;
    }
}

- (id<PickerExtendViewDelegate>)delegate {
    return _delegate;
}

- (void)setDelegate:(id<PickerExtendViewDelegate>)delegate {
    _delegate = delegate;
    if(_datasource){
        [self initComponent];
        [self reloadData];
    }
}

- (id<PickerExtendViewDataSource>)datasource {
    return _datasource;
}

- (void)setDatasource:(id<PickerExtendViewDataSource>)datasource {
    _datasource = datasource;
    if(_delegate){
        [self initComponent];
        [self reloadData];
    }
}
@end
