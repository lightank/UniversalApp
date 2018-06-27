//
//  UIViewController+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UIViewController+LTAdd.h"

@implementation UIViewController (LTAdd)

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
