//
//  UINavigationBar+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/30.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UINavigationBar+LTAdd.h"
#import "LTDevice.h"
#import <objc/runtime.h>

@implementation UINavigationBar (LTAdd)


static char kAssociatedObjectKey_navigationBarOverlayKey;
- (UIView *)lt_overlay
{
    return objc_getAssociatedObject(self, &kAssociatedObjectKey_navigationBarOverlayKey);
}

- (void)setLt_overlay:(UIView *)overlay
{
    objc_setAssociatedObject(self, &kAssociatedObjectKey_navigationBarOverlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lt_setBackgroundColor:(UIColor *)backgroundColor
{
    if (!self.lt_overlay)
    {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.lt_overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + kLTStatusBarHeight)];
        self.lt_overlay.userInteractionEnabled = NO;
        self.lt_overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth;    // Should not set `UIViewAutoresizingFlexibleHeight`
        [[self.subviews firstObject] insertSubview:self.lt_overlay atIndex:0];
    }
    self.lt_overlay.backgroundColor = backgroundColor;
}

- (void)lt_setTranslationY:(CGFloat)translationY
{
    self.transform = CGAffineTransformMakeTranslation(0, translationY);
}

- (void)lt_setAlpha:(CGFloat)alpha
{
    // 导航栏背景透明度设置
    UIView *barBackgroundView = [self subviews].firstObject;// _UIBarBackground
    UIImageView *backgroundImageView = [barBackgroundView subviews].firstObject;// UIImageView
    if (self.isTranslucent)
    {
        if (backgroundImageView != nil && [backgroundImageView isKindOfClass:[UIImageView class]] && backgroundImageView.image != nil)
        {
            barBackgroundView.alpha = alpha;
        }
        else
        {
            if (backgroundImageView.subviews.count >= 2)
            {
                UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
                if (backgroundEffectView != nil)
                {
                    backgroundEffectView.alpha = alpha;
                }
            }
        }
    }
    else
    {
        barBackgroundView.alpha = alpha;
    }
    
    // 对导航栏下面那条线做处理
    if (alpha == 0.0)
    {
        [self lt_hiddenBottomLine];
    }
    else
    {
        [self lt_resetBottomLine];
    }
}

- (void)lt_reset
{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.lt_overlay removeFromSuperview];
    self.lt_overlay = nil;
}


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
