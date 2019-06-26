//
//  UITextView+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/8/24.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UITextView+LTAdd.h"

@implementation UITextView (LTAdd)

/**
 设置textView placeholder
 
 @param text 文字
 @param font 字体
 */
- (void)lt_addPlaceholderWithText:(NSString *)text
                          font:(UIFont *)font
{
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = text;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = UIColor.blackColor;
    [placeHolderLabel sizeToFit];
    [self addSubview:placeHolderLabel];
    // same font
    placeHolderLabel.font = font;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3) {
        [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
}
/**
 设置textView placeholder
 
 @param text 文字
 @param textColor 颜色
 @param font 字体
 */
- (void)lt_addPlaceholderWithText:(NSString *)text
                     textColor:(UIColor *)textColor
                          font:(UIFont *)font
{
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = text;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = textColor;
    [placeHolderLabel sizeToFit];
    [self addSubview:placeHolderLabel];
    // same font
    placeHolderLabel.font = font;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3) {
        [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
}

@end
