//
//  UIButton+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UIButton+LTAdd.h"

@implementation UIButton (LTAdd)


+ (instancetype)lt_buttonWithNormalImage:(UIImage *)normalImage
                             normalTitle:(NSString *)normalTitle
                                 andFont:(UIFont *)font
{
    return [UIButton lt_buttonWithNormalImage:normalImage highlightedImage:nil selectedImage:nil disabledImage:nil focusedImage:nil andNormalTitle:normalTitle highlightedTitle:nil selectedTitle:nil disabledTitle:nil focusedTitle:nil andFont:font];
}

+ (instancetype)lt_buttonWithNormalImage:(UIImage *)normalImage
                        highlightedImage:(UIImage *)highlightedImage
                           selectedImage:(UIImage *)selectedImage
                           disabledImage:(UIImage *)disabledImage
                            focusedImage:(UIImage *)focusedImage
                          andNormalTitle:(NSString *)normalTitle
                        highlightedTitle:(NSString *)highlightedTitle
                           selectedTitle:(NSString *)selectedTitle
                           disabledTitle:(NSString *)disabledTitle
                            focusedTitle:(NSString *)focusedTitle
                                 andFont:(UIFont *)font
{
    UIButton *button = [[UIButton alloc] init];
    //设置图片
    if (normalImage)
    {
        [button setImage:normalImage forState:UIControlStateNormal];
    }
    if (highlightedImage)
    {
        [button setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    if (selectedImage)
    {
        [button setImage:selectedImage forState:UIControlStateSelected];
    }
    if (disabledImage)
    {
        [button setImage:disabledImage forState:UIControlStateDisabled];
    }
    if (focusedImage)
    {
        if ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0)
        {
            if (@available(iOS 9.0, *))
            {
                [button setImage:focusedImage forState:UIControlStateFocused];
            }
        }
    }
    //设置文本
    if (normalTitle)
    {
        [button setTitle:normalTitle forState:UIControlStateNormal];
    }
    if (highlightedTitle)
    {
        [button setTitle:highlightedTitle forState:UIControlStateHighlighted];
    }
    if (selectedTitle)
    {
        [button setTitle:selectedTitle forState:UIControlStateSelected];
    }
    if (disabledTitle)
    {
        [button setTitle:disabledTitle forState:UIControlStateDisabled];
    }
    if (focusedTitle)
    {
        if ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0)
        {
            if (@available(iOS 9.0, *))
            {
                [button setTitle:focusedTitle forState:UIControlStateFocused];
            }
        }
    }
    //设置文字大小
    if (font)
    {
        [button.titleLabel setFont:font];
    }
    
    return button;
}


- (void)lt_layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style
                           imageTitleSpace:(CGFloat)space
{
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
    {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    }
    else
    {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style)
    {
        case ButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case ButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case ButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case ButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

#pragma mark - setter and getter
// ========== 图片 ==========
- (void)setLt_imageNoraml:(UIImage *)lt_imageNoraml
{
    [self setImage:lt_imageNoraml forState:UIControlStateNormal];
}
- (UIImage *)lt_imageNoraml
{
    return [self imageForState:UIControlStateNormal];
}
- (void)setLt_imageHighlighted:(UIImage *)lt_imageHighlighted
{
    [self setImage:lt_imageHighlighted forState:UIControlStateHighlighted];
}
- (UIImage *)lt_imageHighlighted
{
    return [self imageForState:UIControlStateHighlighted];
}
- (void)setLt_imageDisabled:(UIImage *)lt_imageDisabled
{
    [self setImage:lt_imageDisabled forState:UIControlStateDisabled];
}
- (UIImage *)lt_imageDisabled
{
    return [self imageForState:UIControlStateDisabled];
}
- (void)setLt_imageSelected:(UIImage *)lt_imageSelected
{
    [self setImage:lt_imageSelected forState:UIControlStateSelected];
}
- (UIImage *)lt_imageSelected
{
    return [self imageForState:UIControlStateSelected];
}
- (void)setLt_backgroundImageNoraml:(UIImage *)lt_backgroundImageNoraml
{
    [self setBackgroundImage:lt_backgroundImageNoraml forState:UIControlStateNormal];
}
- (UIImage *)lt_backgroundImageNoraml
{
    return [self backgroundImageForState:UIControlStateNormal];
}
- (void)setLt_backgroundImageHighlighted:(UIImage *)lt_backgroundImageHighlighted
{
    [self setBackgroundImage:lt_backgroundImageHighlighted forState:UIControlStateHighlighted];
}
- (UIImage *)lt_backgroundImageHighlighted
{
    return [self backgroundImageForState:UIControlStateHighlighted];
}
- (void)setLt_backgroundImageDisabled:(UIImage *)lt_backgroundImageDisabled
{
    [self setBackgroundImage:lt_backgroundImageDisabled forState:UIControlStateDisabled];
}
- (UIImage *)lt_backgroundImageDisabled
{
    return [self backgroundImageForState:UIControlStateDisabled];
}
- (void)setLt_backgroundImageSelected:(UIImage *)lt_backgroundImageSelected
{
    [self setBackgroundImage:lt_backgroundImageSelected forState:UIControlStateSelected];
}
- (UIImage *)lt_backgroundImageSelected
{
    return [self backgroundImageForState:UIControlStateSelected];
}

// ========== title ==========
- (void)setLt_titleNoraml:(NSString *)lt_titleNoraml
{
    [self setTitle:lt_titleNoraml forState:UIControlStateNormal];
}
- (NSString *)lt_titleNoraml
{
    return [self titleForState:UIControlStateNormal];
}
- (void)setLt_titleHighlighted:(NSString *)lt_titleHighlighted
{
    [self setTitle:lt_titleHighlighted forState:UIControlStateHighlighted];
}
- (NSString *)lt_titleHighlighted
{
    return [self titleForState:UIControlStateHighlighted];
}
- (void)setLt_titleDisabled:(NSString *)lt_titleDisabled
{
    [self setTitle:lt_titleDisabled forState:UIControlStateDisabled];
}
- (NSString *)lt_titleDisabled
{
    return [self titleForState:UIControlStateDisabled];
}
- (void)setLt_titleSelected:(NSString *)lt_titleSelected
{
    [self setTitle:lt_titleSelected forState:UIControlStateSelected];
}
- (NSString *)lt_titleSelected
{
    return [self titleForState:UIControlStateSelected];
}
- (void)setLt_titleColorNoraml:(UIColor *)lt_titleColorNoraml
{
    [self setTitleColor:lt_titleColorNoraml forState:UIControlStateNormal];
}
- (UIColor *)lt_titleColorNoraml
{
    return [self titleColorForState:UIControlStateNormal];
}
- (void)setLt_titleColorHighlighted:(UIColor *)lt_titleColorHighlighted
{
    [self setTitleColor:lt_titleColorHighlighted forState:UIControlStateHighlighted];
}
- (UIColor *)lt_titleColorHighlighted
{
    return [self titleColorForState:UIControlStateHighlighted];
}
- (void)setLt_titleColorDisabled:(UIColor *)lt_titleColorDisabled
{
    [self setTitleColor:lt_titleColorDisabled forState:UIControlStateDisabled];
}
- (UIColor *)lt_titleColorDisabled
{
    return [self titleColorForState:UIControlStateDisabled];
}
- (void)setLt_titleColorSelected:(UIColor *)lt_titleColorSelected
{
    [self setTitleColor:lt_titleColorSelected forState:UIControlStateSelected];
}
- (UIColor *)lt_titleColorSelected
{
    return [self titleColorForState:UIControlStateSelected];
}
// ========== 字体大小 ==========
- (void)setLt_font:(UIFont *)lt_font
{
    self.titleLabel.font = lt_font;
}
- (UIFont *)lt_font
{
    return self.titleLabel.font;
}

@end
