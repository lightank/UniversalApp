//
//  LTNavigationController.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTNavigationController.h"

@interface LTNavigationController ()

@end

@implementation LTNavigationController

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated
{
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull viewController, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0)
        {
            //隐藏tabbar导航
            viewController.hidesBottomBarWhenPushed = YES;
        }
    }];
    [super setViewControllers:viewControllers animated:animated];
    
    [self adapteTabBarFrame];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
    [self adapteTabBarFrame];
}

- (void)adapteTabBarFrame
{
    if (self.viewControllers.count == 0)
    {
        // 修改tabBra的frame
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        self.tabBarController.tabBar.frame = frame;
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if ([viewController isKindOfClass:[LTBaseViewController class]])
//    {
//        [navigationController setNavigationBarHidden:((LTBaseViewController *)viewController).isHiddenNavigationBar animated:animated];
//    }
}

@end
