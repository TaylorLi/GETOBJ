//
//  CustomerTabBarControllerViewController.h
//  CustomerTabBarController
//
//
//

#import <UIKit/UIKit.h>
#import "CustomerTabBar.h"

//#define kTabBarHeight 64.0f

@class UITabBarController;
@protocol CustomerTabBarControllerDelegate;
@interface CustomerTabBarController : UIViewController <CustomerTabBarDelegate>
{
	CustomerTabBar *_tabBar;
	UIView      *_containerView;
	UIView		*_transitionView;
	id<CustomerTabBarControllerDelegate> _delegate;
	NSMutableArray *_viewControllers;
	NSUInteger _selectedIndex;
	NSUInteger _preSelectedIndex;
    
	BOOL _tabBarTransparent;
	BOOL _tabBarHidden;
    
    NSInteger animateDriect;
}

@property(nonatomic, copy) NSMutableArray *viewControllers;

@property(nonatomic, readonly) UIViewController *selectedViewController;
@property(nonatomic) NSUInteger selectedIndex;
@property(nonatomic) NSUInteger preSelectedIndex;
// Apple is readonly
@property (nonatomic, readonly) CustomerTabBar *tabBar;
@property(nonatomic,assign) id<CustomerTabBarControllerDelegate> delegate;


// Default is NO, if set to YES, content will under tabbar
@property (nonatomic) BOOL tabBarTransparent;
@property (nonatomic) BOOL tabBarHidden;
@property (nonatomic) float kTabBarHeight;

@property(nonatomic,assign) NSInteger animateDriect;

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr;
- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr frames:(CGRect) frame tabBarHeight:(float)height;
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated driect:(NSInteger)driect;

// Remove the viewcontroller at index of viewControllers.
- (void)removeViewControllerAtIndex:(NSUInteger)index;

// Insert an viewcontroller at index of viewControllers.
- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;
@end


@protocol CustomerTabBarControllerDelegate <NSObject>
@optional
- (BOOL)tabBarController:(CustomerTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
- (void)tabBarController:(CustomerTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
@end

@interface UIViewController (CustomerTabBarControllerSupport)
@property(nonatomic, readonly) CustomerTabBarController *CustomerTabBarController;
@end

