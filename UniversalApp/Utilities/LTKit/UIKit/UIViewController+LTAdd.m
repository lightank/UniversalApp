//
//  UIViewController+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+LTAdd.h"
#import "UINavigationController+LTAdd.h"

@implementation UIViewController (LTAdd)

//navigationBarBackgroundAlpha
static char kAssociatedObjectKey_navigationBarBackgroundAlpha;
- (void)setNavigationBarBackgroundAlpha:(CGFloat)navigationBarBackgroundAlpha
{
    objc_setAssociatedObject(self, &kAssociatedObjectKey_navigationBarBackgroundAlpha, @(navigationBarBackgroundAlpha), OBJC_ASSOCIATION_ASSIGN);
    // 设置导航栏透明度（利用Category自己添加的方法）
    [self.navigationController setNeedsNavigationBackground:navigationBarBackgroundAlpha];
}
- (CGFloat)navigationBarBackgroundAlpha
{
    return ((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_navigationBarBackgroundAlpha)).floatValue;
}

//tabBarTitleColorNormal
static char kAssociatedObjectKey_tabBarTitleColorNormal;
- (void)setTabBarTitleColorNormal:(UIColor *)tabBarTitleColorNormal
{
    objc_setAssociatedObject(self, &kAssociatedObjectKey_tabBarTitleColorNormal, tabBarTitleColorNormal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.tabBarItem setTitleTextAttributes:@{
                                              NSForegroundColorAttributeName : tabBarTitleColorNormal,
                                              } forState:UIControlStateNormal];
}
- (UIColor *)tabBarTitleColorNormal
{
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_tabBarTitleColorNormal);
}

//tabBarTitleColorSelected
static char kAssociatedObjectKey_tabBarTitleColorSelected;
- (void)setTabBarTitleColorSelected:(UIColor *)tabBarTitleColorSelected
{
    objc_setAssociatedObject(self, &kAssociatedObjectKey_tabBarTitleColorSelected, tabBarTitleColorSelected, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.tabBarItem setTitleTextAttributes:@{
                                              NSForegroundColorAttributeName : tabBarTitleColorSelected,
                                              } forState:UIControlStateSelected];
}
- (UIColor *)tabBarTitleColorSelected
{
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_tabBarTitleColorSelected);
}

@end
