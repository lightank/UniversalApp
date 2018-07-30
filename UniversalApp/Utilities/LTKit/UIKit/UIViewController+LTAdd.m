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


@end
