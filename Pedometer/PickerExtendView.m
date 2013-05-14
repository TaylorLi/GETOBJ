//
//  PickerExtendView.m
//
//  Created by Taylor Li on 27/03/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "PickerExtendView.h"

@interface PickerExtendView () 
{
    //滚筒视图
    NSMutableArray *scrollViews;
    //滚筒间间隙宽度
    NSInteger padding4Components;
    //控件宽高
    CGSize pvSize;
    //滚筒中行的宽高
    CGSize rowSize;
    //滚筒中当前选中行的索引集
    NSMutableArray *selectRowArr;
//    NSMutableArray *numberOfRowsToShowArr;
    //高亮选中行的索引
    NSInteger shadeRowIndex;
//    NSMutableArray *maxNumberOfRowsInComponentArr;
}

//初始化控件
-(void) initComponent;
////控件相对于滚筒的左部间隙
//-(CGFloat) paddingLeft4Component;
////控件相对于滚筒的顶部间隙
//-(CGFloat) paddingTop4Component;

@end

@implementation PickerExtendView

@synthesize numberOfComponents, numberOfRowsToShowInComponent;

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

//-(CGFloat) paddingLeft4Component{
//    return (pvSize.width - (numberOfComponents - 1) * padding4Components - numberOfComponents * rowSize.width)/2; 
//}
//
//-(CGFloat) paddingTop4Component{
//    return (pvSize.height - numberOfRowsToShowInComponent * rowSize.height) / 2;
//}

-(void) initComponent{    
    padding4Components = 0;
    pvSize = CGSizeMake(30.0f, 20.0f);
    numberOfComponents = 1;
    numberOfRowsToShowInComponent = 1;
    shadeRowIndex = 0;
    if([self.delegate respondsToSelector:@selector(paddingForComponents:)]){
        padding4Components = [self.delegate paddingForComponents:self];
    }
    if([self.datasource respondsToSelector:@selector(numberOfComponentsInPickerView:)]){
        numberOfComponents = [self.datasource numberOfComponentsInPickerView:self];
    }
    
    if([self.datasource respondsToSelector:@selector(numberOfRowsToShowForPickerView:)]){
                numberOfRowsToShowInComponent = [self.datasource numberOfRowsToShowForPickerView:self];
    }
    if([self.delegate respondsToSelector:@selector(sizeForPickerView:)]){
        pvSize = [self.delegate sizeForPickerView:self];
    }
    rowSize = CGSizeMake((pvSize.width - (numberOfComponents - 1) * padding4Components) / numberOfComponents, pvSize.height / numberOfRowsToShowInComponent);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, pvSize.width, pvSize.height);
    self.clipsToBounds = NO;

    if([self.delegate respondsToSelector:@selector(backgroundColorForPickerView:)]){
        self.backgroundColor = [self.delegate backgroundColorForPickerView:self];
    }
    
    if([self.delegate respondsToSelector:@selector(backgroundImageForPickerView:)]){
        UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        backgroundImageView.image = [self.delegate backgroundImageForPickerView:self];
        [self addSubview:backgroundImageView];
    }
    
    if([self.delegate respondsToSelector:@selector(rowIndexForShadeRow:)]){
        shadeRowIndex = [self.delegate rowIndexForShadeRow:self];
    }
    
    if(shadeRowIndex >= numberOfRowsToShowInComponent){
        shadeRowIndex = numberOfRowsToShowInComponent - 1;
    }
    
    scrollViews = [[NSMutableArray alloc] init];
    selectRowArr = [[NSMutableArray alloc] initWithCapacity:numberOfComponents];
    
    CGFloat x4Components = 0;
    for (int i=0; i<numberOfComponents; i++) {
        [selectRowArr addObject:[NSNumber  numberWithInt:0]]; 
        
        UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x4Components, 0, rowSize.width, pvSize.height)];

        x4Components += rowSize.width + padding4Components;
        
        [scrollViews addObject:scrollView];
        scrollView.delegate = self;       
        [self addSubview:scrollView];
    }
    
    if([self.delegate respondsToSelector:@selector(backgroundImageForShadeRow:)]){
        UIImageView *selectBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, shadeRowIndex * rowSize.height, pvSize.width, rowSize.height)];
        selectBG.image = [self.delegate backgroundImageForShadeRow:self];
        if([self.delegate respondsToSelector:@selector(alphaForShadeRow:)]){
            selectBG.alpha = [self.delegate alphaForShadeRow:self];
        }else{
            selectBG.alpha = 0.5;
        }
        [self addSubview:selectBG];
    }
}

- (void) reloadData{
    for (int i=0; i<numberOfComponents; i++) {
        UIScrollView *scrollView = [scrollViews objectAtIndex:i];
        for (UIView *v in scrollView.subviews) {
            [v removeFromSuperview];
        }
        if([self.datasource respondsToSelector:@selector(defaultSeletRowForPickerView:atComponentIndex:)]){
            [selectRowArr replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:[self.datasource defaultSeletRowForPickerView:self atComponentIndex:i]]];
        }
        NSInteger maxNumberOfRowsInComponent = 1;
        if([self.datasource respondsToSelector:@selector(maxNumberOfRowsForPickerView:atComponentIndex:)]){
            maxNumberOfRowsInComponent = [self.datasource maxNumberOfRowsForPickerView:self atComponentIndex:i];
        }
        
        if([[selectRowArr objectAtIndex:i] intValue] >= maxNumberOfRowsInComponent){
            [selectRowArr replaceObjectAtIndex:i withObject:[NSNumber numberWithInt: maxNumberOfRowsInComponent -1]];
        }

        NSInteger tempMaxNumberOfRowsInComponent = maxNumberOfRowsInComponent + (numberOfRowsToShowInComponent - 1);
        
        for (int j=0; j<tempMaxNumberOfRowsInComponent; j++) {
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rowSize.width, rowSize.height)];
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
            if(j>=shadeRowIndex && j<maxNumberOfRowsInComponent+shadeRowIndex){
                NSString *title = [self.datasource pickerView:self titleForRow:(j-shadeRowIndex) forComponent:i];
                label.text = title;
            }else{
                label.text = @"";
            }
            CGRect frame = label.frame;
            frame.origin.y = rowSize.height * j;
            //frame.size.width -= 2;
            label.frame = frame;
            [scrollView addSubview:label];
        }

        scrollView.contentSize = CGSizeMake(rowSize.width, rowSize.height * tempMaxNumberOfRowsInComponent);
        scrollView.pagingEnabled = NO;
        scrollView.clipsToBounds = YES;
        scrollView.scrollEnabled = YES;
        
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, [[selectRowArr objectAtIndex:i] intValue] * rowSize.height);
    }
}

//- (void)awakeFromNib {
//    [self initComponent];
//    [self reloadData];
//}

-(NSTimeInterval) round:(NSTimeInterval) num digit:(NSInteger)decimals
{
    return round(num *pow(10, decimals)) / pow(10, decimals);
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        NSTimeInterval distance = scrollView.contentOffset.y / rowSize.height;
        int page = (int)[self round:distance digit:0];
        if(page == distance){
            [self scrollViewDidEndDecelerating:scrollView];
        }else{
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, page * rowSize.height) animated:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger componentIndex = -1;
    for (int i=0; i<numberOfComponents; i++) {
        UIScrollView *baseScrollView = [scrollViews objectAtIndex:i];
        if(baseScrollView == scrollView){
            componentIndex = i;
            break;
        }
    }
    NSInteger page = scrollView.contentOffset.y / rowSize.height;
    [selectRowArr replaceObjectAtIndex:componentIndex withObject:[NSNumber numberWithInt:page]];

    if([self.delegate respondsToSelector:@selector(pickerViewDidChangeValue:seletedRowIndex:atComponentIndex:)]){
        [self.delegate pickerViewDidChangeValue:self seletedRowIndex:page atComponentIndex:componentIndex];
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
