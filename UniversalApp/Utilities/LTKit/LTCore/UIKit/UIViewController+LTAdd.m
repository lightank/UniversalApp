//
//  UIViewController+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UIViewController+LTAdd.h"
#import <objc/runtime.h>

@implementation UIViewController (LTAdd)

//tabBarTitleColorNormal
static char kAssociatedObjectKey_tabBarTitleColorNormal;
- (void)setLt_tabBarTitleColorNormal:(UIColor *)lt_tabBarTitleColorNormal
{
    objc_setAssociatedObject(self, &kAssociatedObjectKey_tabBarTitleColorNormal, lt_tabBarTitleColorNormal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.tabBarItem setTitleTextAttributes:@{
                                              NSForegroundColorAttributeName : lt_tabBarTitleColorNormal,
                                              } forState:UIControlStateNormal];
}
- (UIColor *)lt_tabBarTitleColorNormal
{
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_tabBarTitleColorNormal);
}

//tabBarTitleColorSelected
static char kAssociatedObjectKey_tabBarTitleColorSelected;
- (void)setLt_tabBarTitleColorSelected:(UIColor *)lt_tabBarTitleColorSelected
{
    objc_setAssociatedObject(self, &kAssociatedObjectKey_tabBarTitleColorSelected, lt_tabBarTitleColorSelected, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.tabBarItem setTitleTextAttributes:@{
                                              NSForegroundColorAttributeName : lt_tabBarTitleColorSelected,
                                              } forState:UIControlStateSelected];
}
- (UIColor *)lt_tabBarTitleColorSelected
{
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_tabBarTitleColorSelected);
}

- (void)lt_setSafeArea
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

/*
 1）调用容器视图控制器的addChildViewController:，此方法是将子视图控制器添加到容器视图控制器，告诉UIKit父视图控制器现在要管理子视图控制器和它的视图。
 2）调用 addSubview: 方法，将子视图控制器的根视图加在父视图控制器的视图层级上。这里需要设置子视图控制器中根视图的位置和大小。
 3）布局子视图控制器的根视图。
 4）调用 didMoveToParentViewController:，告诉子视图控制器其根视图的被持有情况。也就是需要先把子视图控制器的根视图添加在父视图中的视图层级中。

 在调用 addChildViewController: 时，系统会先调用 willMoveToParentViewController:
 然后再将子视图控制器添加到父视图控制器中。
 但是系统不会自动调用 didMoveToParentViewController: 方法需要手动调用,为何呢？
 视图控制器是有转场动画的，动画完成后才应该去调用 didMoveToParentViewController: 方法。
 */
- (void)lt_moveToParentViewController:(UIViewController *)parentViewController
{
    if (!parentViewController) return;
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:self.view];
    [self didMoveToParentViewController:parentViewController];
}

/*
 1）调用子视图控制器的willMoveToParentViewController:，参数为 nil，让子视图做好被移除的准备。
 2）移除子视图控制器的根视图在添加时所作的任何的约束布局。
 3）调用 removeFromSuperview 将子视图控制器的根视图从视图层次结构中移除。
 4）调用 removeFromParentViewController 来告知结束父子关系。
 5）在调用 removeFromParentViewController 时会自动调用子视图控制器的 didMoveToParentViewController: 方法，参数为 nil。
 */
- (void)lt_removeFromParentViewController:(UIViewController *)parentViewController
{
    if (!parentViewController) return;
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
