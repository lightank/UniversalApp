//
//  UINavigationBar+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/30.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//  @see https://github.com/ltebean/LTNavigationBar

#import <UIKit/UIKit.h>

@interface UINavigationBar (LTAdd)


- (void)lt_setBackgroundColor:(UIColor *)backgroundColor;
- (void)lt_setTranslationY:(CGFloat)translationY;
- (void)lt_reset;

/**  隐藏导航栏底部那条线  */
- (void)lt_hiddenBottomLine;
/**  重置导航栏底部那条线  */
- (void)lt_resetBottomLine;
/**  设置导航栏底部那条线的颜色  */
- (void)lt_setBottomLineColor:(UIColor *)color;

@end
