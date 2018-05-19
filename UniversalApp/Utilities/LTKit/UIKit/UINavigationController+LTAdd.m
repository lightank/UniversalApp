//
//  UINavigationController+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UINavigationController+LTAdd.h"

@implementation UINavigationController (LTAdd)

+ (void)initialize {
    if (self == [UINavigationController self]) {
        // 交换方法
//        SEL originalSelector = NSSelectorFromString(@"_updateInteractiveTransition:");
//        SEL swizzledSelector = NSSelectorFromString(@"lt_updateInteractiveTransition:");
//        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
//        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
//        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)setNeedsNavigationBackground:(CGFloat)alpha {
    // 导航栏背景透明度设置
    UIView *barBackgroundView = [[self.navigationBar subviews] firstObject];// _UIBarBackground
    UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
    barBackgroundView.alpha = alpha;
    backgroundEffectView.alpha = alpha;
    // 对导航栏下面那条线做处理
    self.navigationBar.clipsToBounds = alpha == 0.0;
}

// 交换的方法，监控滑动手势
- (void)lt_updateInteractiveTransition:(CGFloat)percentComplete {
    [self lt_updateInteractiveTransition:(percentComplete)];
    UIViewController *topVC = self.topViewController;
    if (topVC != nil) {
        id<UIViewControllerTransitionCoordinator> coor = topVC.transitionCoordinator;
        if (coor != nil) {
            // 随着滑动的过程设置导航栏透明度渐变
            CGFloat fromAlpha = [coor viewControllerForKey:UITransitionContextFromViewControllerKey].navigationBarBackgroundAlpha;
            CGFloat toAlpha = [coor viewControllerForKey:UITransitionContextToViewControllerKey].navigationBarBackgroundAlpha;
            CGFloat nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
            [self setNeedsNavigationBackground:nowAlpha];
        }
    }
}

@end
