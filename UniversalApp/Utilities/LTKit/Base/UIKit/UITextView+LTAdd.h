//
//  UITextView+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/8/24.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (LTAdd)

/**
 设置textView placeholder
 
 @param text 文字
 @param font 字体
 */
- (void)lt_addPlaceholderWithText:(NSString *)text
                          font:(UIFont *)font;

/**
 设置textView placeholder
 
 @param text 文字
 @param textColor 颜色
 @param font 字体
 */
- (void)lt_addPlaceholderWithText:(NSString *)text
                     textColor:(UIColor *)textColor
                          font:(UIFont *)font;

@end
