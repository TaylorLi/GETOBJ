//
//  CustomerTabBarControllerViewController.m
//  CustomerTabBarController
//
//

#import "CustomerTabBarController.h"
#import "CustomerTabBar.h"


static CustomerTabBarController *customerTabBarController;

@implementation UIViewController (CustomerTabBarControllerSupport)

- (CustomerTabBarController *)CustomerTabBarController
{
	return customerTabBarController;
}

@end

@interface CustomerTabBarController (private)
- (void)displayViewAtIndex:(NSUInteger)index;
@end

@implementation CustomerTabBarController

@synthesize delegate;
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize preSelectedIndex=_preSelectedIndex;
@synthesize tabBarHidden = _tabBarHidden;
@synthesize animateDriect;
@synthesize kTabBarHeight;

#pragma mark -
#pragma mark lifecycle

- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr
{
    return [self initWithViewControllers:vcs imageArray:arr frames:[[UIScreen mainScreen] applicationFrame] tabBarHeight:64.0f];
}
- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr frames:(CGRect) frame tabBarHeight:(float)height
{
	self = [super init];
    kTabBarHeight = height;
	if (self != nil)
	{
		_viewControllers = [NSMutableArray arrayWithArray:vcs];
		
        CGRect availRect= [[UIScreen mainScreen] bounds];//从0像素开始算
        //CGRect availRect= [[UIScreen mainScreen] applicationFrame];//返回的是减去20个像素的位置
//       if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
//       {
//           availRect=CGRectMake(0, 20.0f, 320.0f, 460.0f);
//       }
		_containerView = [[UIView alloc] initWithFrame:availRect];
		
		_transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, _containerView.frame.size.height - kTabBarHeight)];
//		_transitionView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
		
		_tabBar = [[CustomerTabBar alloc] initWithFrame:CGRectMake(0, _containerView.frame.size.height - kTabBarHeight, 320.0f, kTabBarHeight) buttonImages:arr];
		_tabBar.delegate = self;
		
        customerTabBarController = self;
        animateDriect = 0;
        
        _preSelectedIndex=0;
        
	}
	return self;
}

- (void)loadView 
{
	[super loadView];
	
	[_containerView addSubview:_transitionView];
	[_containerView addSubview:_tabBar];
	self.view = _containerView;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	
//    self.selectedIndex = 0;
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
	_tabBar = nil;
	_viewControllers = nil;
}

#pragma mark - instant methods

- (CustomerTabBar *)tabBar
{
	return _tabBar;
}

- (BOOL)tabBarTransparent
{
	return _tabBarTransparent;
}

- (void)setTabBarTransparent:(BOOL)yesOrNo
{
	if (yesOrNo == YES)
	{
		_transitionView.frame = _containerView.bounds;
	}
	else
	{
		_transitionView.frame = CGRectMake(0, 0, 320.0f, _containerView.frame.size.height - kTabBarHeight);
	}
}




- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated
{
	if (yesOrNO == YES)
	{
		if (self.tabBar.frame.origin.y == self.view.frame.size.height)
		{
			return;
		}
	}
	else 
	{
		if (self.tabBar.frame.origin.y == self.view.frame.size.height - kTabBarHeight)
		{
			return;
		}
	}
	
	if (animated == YES)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		if (yesOrNO == YES)
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		else 
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		[UIView commitAnimations];
	}
	else 
	{
		if (yesOrNO == YES)
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		else 
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
	}
}

//- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated
//{
//    [self hidesTabBar:yesOrNO animated:animated driect:animateDriect];
//}
//
//- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated driect:(NSInteger)driect
//{
//    // driect: 0 -- 上下  1 -- 左右
//    
//    NSInteger kTabBarWidth = [[UIScreen mainScreen] applicationFrame].size.width;
//    
//	if (yesOrNO == YES)
//	{
//        if (driect == 0)
//        {
//            if (self.tabBar.frame.origin.y == self.view.frame.size.height)
//            {
//                return;
//            }
//        }
//        else
//        {
//            if (self.tabBar.frame.origin.x == 0 - kTabBarWidth)
//            {
//                return;
//            }
//        }
//	}
//	else 
//	{
//        if (driect == 0)
//        {
//            if (self.tabBar.frame.origin.y == self.view.frame.size.height - kTabBarHeight)
//            {
//                return;
//            }
//        }
//        else
//        {
//            if (self.tabBar.frame.origin.x == 0)
//            {
//                return;
//            }
//        }
//	}
//	
//	if (animated == YES)
//	{
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationDuration:0.3f];
//		if (yesOrNO == YES)
//		{
//            if (driect == 0)
//            {
//                self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//            else
//            {
//                self.tabBar.frame = CGRectMake(0 - kTabBarWidth, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//		}
//		else 
//		{
//            if (driect == 0)
//            {
//                self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//            else
//            {
//                self.tabBar.frame = CGRectMake(0, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//		}
//		[UIView commitAnimations];
//	}
//	else 
//	{
//		if (yesOrNO == YES)
//		{
//            if (driect == 0)
//            {
//                self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y + kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//            else
//            {
//                self.tabBar.frame = CGRectMake(0 - kTabBarWidth, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//		}
//		else 
//		{
//            if (driect == 0)
//            {
//                self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, self.tabBar.frame.origin.y - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//            else
//            {
//                self.tabBar.frame = CGRectMake(0, self.tabBar.frame.origin.y, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
//            }
//		}
//	}
//}
//
- (NSUInteger)selectedIndex
{
	return _selectedIndex;
}
- (UIViewController *)selectedViewController
{
    return [_viewControllers objectAtIndex:_selectedIndex];
}

-(void)setSelectedIndex:(NSUInteger)index
{
    [self displayViewAtIndex:index];
    [_tabBar selectTabAtIndex:index];
}

- (void)removeViewControllerAtIndex:(NSUInteger)index
{
    if (index >= [_viewControllers count])
    {
        return;
    }
    // Remove view from superview.
    [[(UIViewController *)[_viewControllers objectAtIndex:index] view] removeFromSuperview];
    // Remove viewcontroller in array.
    [_viewControllers removeObjectAtIndex:index];
    // Remove tab from tabbar.
    [_tabBar removeTabAtIndex:index];
}

- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    [_viewControllers insertObject:vc atIndex:index];
    [_tabBar insertTabWithImageDic:dict atIndex:index];
}


#pragma mark - Private methods
- (void)displayViewAtIndex:(NSUInteger)index
{
    // Before change index, ask the delegate should change the index.
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) 
    {
        if (![_delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]])
        {
            return;
        }
    }
    // If target index if equal to current index, do nothing.
    if (_selectedIndex == index && [[_transitionView subviews] count] != 0) 
    {
        return;
    }
    //NSLog(@"Display View.");
    _selectedIndex = index;
    
	UIViewController *selectedVC = [self.viewControllers objectAtIndex:index];
	
	selectedVC.view.frame = _transitionView.frame;
//	if ([selectedVC.view isDescendantOfView:_transitionView]) 
//	{
//		[_transitionView bringSubviewToFront:selectedVC.view];
//	}
//	else
//	{
//		[_transitionView addSubview:selectedVC.view];
//	}
    
    for (UIView *subView in _transitionView.subviews) {
        if(subView.superview!=nil){
            [subView removeFromSuperview];
        }
    }
    [_transitionView insertSubview:selectedVC.view atIndex:0];
    
    // Notify the delegate, the viewcontroller has been changed.
    if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController::)]) 
    {
        [_delegate tabBarController:self didSelectViewController:selectedVC];
    }

}

- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated driect:(NSInteger)driect{}

#pragma mark -
#pragma mark tabBar delegates
- (void)tabBar:(CustomerTabBar *)tabBar didSelectIndex:(NSInteger)index
{
    if(self.selectedIndex!=0)
        _preSelectedIndex=self.selectedIndex;
    if (self.selectedIndex == index) {
        UINavigationController *nav = [self.viewControllers objectAtIndex:index];
        [nav popToRootViewControllerAnimated:YES];
    }else {
        [self displayViewAtIndex:index];
    }
}
@end
