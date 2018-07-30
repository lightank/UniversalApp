//
//  UINavigationBar+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/30.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UINavigationBar+LTAdd.h"

@implementation UINavigationBar (LTAdd)

- (void)lt_hiddenBottomLine
{
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]];
    //下面这个方法也可以
    //self.clipsToBounds = YES;
}

- (void)lt_resetBottomLine
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:nil];
}

- (void)lt_setBottomLineColor:(UIColor *)color
{
    [self setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage imageWithColor:color]];
}


@end
