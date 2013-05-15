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

//滚筒滚动时触发
- (void)pickerViewDidChangeValue:(PickerExtendView *)pickerView seletedRowIndex:(NSInteger)rowIndex atComponentIndex:(NSInteger)componentIndex;

//设置整个控件的宽高，默认为[30.0f, 20.0f]
- (CGSize)sizeForPickerView: (PickerExtendView *) pickerView;

//设置滚筒之间的间隙宽度
- (CGFloat)paddingForComponents:(PickerExtendView *) pickerView;

//设置控件的背景图
- (UIImage *)backgroundImageForPickerView:(PickerExtendView *) pickerView;

//设置高亮选中行的背景图
- (UIImage *)backgroundImageForShadeRow:(PickerExtendView *) pickerView;

//设置高亮选中行背景的透明度，默认为0.5
- (CGFloat)alphaForShadeRow:(PickerExtendView *) pickerView;

//设置高亮选中行的在滚筒中的位置，默认为0，0代表第1行
- (NSInteger)rowIndexForShadeRow:(PickerExtendView *) pickerView;

//设置控件的前景颜色
- (UIColor *)backgroundColorForPickerView:(PickerExtendView *) pickerView;

//设置滚筒中文字的水平对齐方式，默认为左对齐
- (UITextAlignment)textAlignmentForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex;

//设置滚筒中文字的颜色，默认为black
- (UIColor *)textColorForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex;

//设置滚筒中文字的字体（包括字体大小），字体大小默认为12.0
- (UIFont *)textFontForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex;

@end

@protocol PickerExtendViewDataSource <NSObject>

@required

//设置滚筒中每一行的标题
- (NSString *)pickerView:(PickerExtendView *)pickerView titleForRow:(NSInteger)rowIndex forComponent:(NSInteger)componentIndex;

@optional
//设置控件中滚筒的数量，默认为1
- (NSInteger)numberOfComponentsInPickerView:(PickerExtendView *)pickerView;

//设置控件中展示的行的数量，默认为1
- (NSInteger)numberOfRowsToShowForPickerView:(PickerExtendView *) pickerView;

//设置滚筒中行的数量，默认为1
- (NSInteger)maxNumberOfRowsForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex;

//设置滚筒中默认滚动到哪一行
- (NSInteger)defaultSeletRowForPickerView:(PickerExtendView *) pickerView atComponentIndex:(NSInteger)componentIndex;

@end

@interface PickerExtendView : UIView <UIScrollViewDelegate>
//滚筒数量
@property (nonatomic) NSInteger numberOfComponents;
//滚筒展示的行数
@property (nonatomic) NSInteger numberOfRowsToShowInComponent;

@property (nonatomic, weak) IBOutlet id <PickerExtendViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet id <PickerExtendViewDataSource> datasource;

//重新加载数据
- (void) reloadData;
//获取滚筒中当前选中行的索引
- (NSInteger) selectRowIndexWithComponent:(NSInteger) componentIndex;

@end
