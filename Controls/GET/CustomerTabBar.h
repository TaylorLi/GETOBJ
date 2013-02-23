//
//  CustomerTabBar.h
//  CustomerTabBarController
//
//
//

#import <UIKit/UIKit.h>

@protocol CustomerTabBarDelegate;

@interface CustomerTabBar : UIView
{
	UIImageView *_backgroundView;
	id<CustomerTabBarDelegate> _delegate;
	NSMutableArray *_buttons;
}
@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, assign) id<CustomerTabBarDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *buttons;


- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray;
- (void)selectTabAtIndex:(NSInteger)index;
- (void)removeTabAtIndex:(NSInteger)index;
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;
- (void)setBackgroundImage:(UIImage *)img;

@end
@protocol CustomerTabBarDelegate<NSObject>
@optional
- (void)tabBar:(CustomerTabBar *)tabBar didSelectIndex:(NSInteger)index; 
@end
