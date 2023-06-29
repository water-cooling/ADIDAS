//
//  LeveyTabBarControllerViewController.m
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 VanillaTech. All rights reserved.
//

#import "LeveyTabBarController.h"
#import "LeveyTabBar.h"
#import "CommonDefine.h"
#import "CommonUtil.h"
#import "DateListViewController.h"
#define kTabBarHeight 44.0f

static LeveyTabBarController *leveyTabBarController;

@implementation UIViewController (LeveyTabBarControllerSupport)

- (LeveyTabBarController *)leveyTabBarController
{
	return leveyTabBarController;
}

@end

@interface LeveyTabBarController (private)
- (void)displayViewAtIndex:(NSUInteger)index;
@end

@implementation LeveyTabBarController
@synthesize delegate = _delegate;
@synthesize selectedViewController = _selectedViewController;
@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize tabBarHidden = _tabBarHidden;
@synthesize tabBar;

#pragma mark -
#pragma mark lifecycle
- (id)initWithViewControllers:(NSArray *)vcs imageArray:(NSArray *)arr;
{
	self = [super init];
	if (self != nil)
	{
		_viewControllers = [NSMutableArray arrayWithArray:vcs] ;
		
        if (IOSVersion>= 7.0)
        {
            _containerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
        else
        {
            _containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        }   

		
        if (IOSVersion>=7.0)
            _transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, PHONE_WIDTH, _containerView.frame.size.height - kTabBarHeight)];
        else
          _transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, _containerView.frame.size.height - kTabBarHeight)];
        
		_transitionView.backgroundColor =  [UIColor groupTableViewBackgroundColor];
		
        tabBar = [[LeveyTabBar alloc] initWithFrame:CGRectMake(0, _containerView.frame.size.height - kTabBarHeight, PHONE_WIDTH, 44) buttonImages:arr];
		self.tabBar.delegate = self;
		
        leveyTabBarController = self;
	}
	return self;
}

- (void)loadView 
{
	[super loadView];
    _transitionView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	[_containerView addSubview:_transitionView];
	[_containerView addSubview:tabBar];
	self.view = _containerView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    self.selectedIndex = 0;
}
- (void)viewDidUnload
{
	[super viewDidUnload];
	
	tabBar = nil;
	_viewControllers = nil;
}



#pragma mark - instant methods

- (LeveyTabBar *)tabBar
{
	return tabBar;
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
        if (IOSVersion>=7.0)
        {
            _transitionView.frame = CGRectMake(0, 20, DEWIDTH, _containerView.frame.size.height - kTabBarHeight);
        }
        else
        {
            _transitionView.frame = CGRectMake(0, 0, DEWIDTH, _containerView.frame.size.height - kTabBarHeight);

        }
    }
}
- (void)hidesTabBar:(BOOL)yesOrNO animated:(BOOL)animated;
{
	if (yesOrNO == YES)
	{
		if (self.tabBar.frame.origin.y >= MAX(DEHEIGHT, DEWIDTH))
		{
			return;
		}
	}
	else 
	{
		if (self.tabBar.frame.origin.y == DEHEIGHT - kTabBarHeight)
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
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, MAX(DEHEIGHT, DEWIDTH), self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		else 
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, DEHEIGHT - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		[UIView commitAnimations];
	}
	else 
	{
		if (yesOrNO == YES)
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, MAX(DEHEIGHT, DEWIDTH), self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
		else 
		{
			self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x, DEHEIGHT - kTabBarHeight, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
		}
	}
}

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
    [tabBar selectTabAtIndex:index];
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
    [tabBar removeTabAtIndex:index];
}

- (void)insertViewController:(UIViewController *)vc withImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    [_viewControllers insertObject:vc atIndex:index];
    [tabBar insertTabWithImageDic:dict atIndex:index];
}


#pragma mark - Private methods
- (void)displayViewAtIndex:(NSUInteger)index
{
    [self hidesTabBar:NO animated:YES];
    // Before changing index, ask the delegate should change the index.
    if ([_delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) 
    {
        if (![_delegate tabBarController:self shouldSelectViewController:[self.viewControllers objectAtIndex:index]])
        {
            return;
        }
    }
    
    UIViewController *targetViewController = [self.viewControllers objectAtIndex:index];
    [targetViewController viewWillAppear:YES];
    for (UIViewController *contro in targetViewController.childViewControllers) {
        
        if ([contro isKindOfClass:[DateListViewController class]]) {
            
            DateListViewController *dv = (DateListViewController *)contro ;
            [dv viewWillAppear:YES] ;
            break ;
        }
    }
    for (UIView* view in self.tabBar.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            if (view.tag == index*100 +1)
            {
                ((UILabel*)view).textColor = [UIColor whiteColor];
            }
            else
            {
                ((UILabel*)view).textColor = [UIColor whiteColor];
            }
        }
    }
    

    // If target index is equal to current index.
    if (_selectedIndex == index && [[_transitionView subviews] count] != 0) 
    {
        if ([targetViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController*)targetViewController popToRootViewControllerAnimated:YES];
        }
        return;
    }
 
    _selectedIndex = index;
    
	[_transitionView.subviews makeObjectsPerformSelector:@selector(setHidden:) withObject:@YES];
    targetViewController.view.hidden = NO;
	targetViewController.view.frame = _transitionView.frame;
	if ([targetViewController.view isDescendantOfView:_transitionView]) 
	{
		[_transitionView bringSubviewToFront:targetViewController.view];
	}
	else
	{
		[_transitionView addSubview:targetViewController.view];
	}
    
    // Notify the delegate, the viewcontroller has been changed.
    if ([_delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) 
    {
        [_delegate tabBarController:self didSelectViewController:targetViewController];
    }
}


#pragma mark tabBar delegates
- (void)tabBar:(LeveyTabBar *)tabBar didSelectIndex:(NSInteger)index
{
	[self displayViewAtIndex:index];
}


@end
