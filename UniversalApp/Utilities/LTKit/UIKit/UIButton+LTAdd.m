//
//  UIButton+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UIButton+LTAdd.h"

@implementation UIButton (LTAdd)


+ (instancetype)buttonWithNormalImage:(UIImage *)normalImage normalTitle:(NSString *)normalTitle andFont:(UIFont *)font
{
    return [UIButton buttonWithNormalImage:normalImage highlightedImage:nil selectedImage:nil disabledImage:nil focusedImage:nil andNormalTitle:normalTitle highlightedTitle:nil selectedTitle:nil disabledTitle:nil focusedTitle:nil andFont:font];
}

+ (instancetype)buttonWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage selectedImage:(UIImage *)selectedImage  disabledImage:(UIImage *)disabledImage focusedImage:(UIImage *)focusedImage andNormalTitle:(NSString *)normalTitle highlightedTitle:(NSString *)highlightedTitle selectedTitle:(NSString *)selectedTitle disabledTitle:(NSString *)disabledTitle focusedTitle:(NSString *)focusedTitle andFont:(UIFont *)font
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
        [button setImage:focusedImage forState:UIControlStateFocused];
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
        [button setTitle:focusedTitle forState:UIControlStateFocused];
    }
    //设置文字大小
    if (font)
    {
        [button.titleLabel setFont:font];
    }
    
    return button;
}


- (void)layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space
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
- (void)setImageNoraml:(UIImage *)imageNoraml
{
    [self setImage:imageNoraml forState:UIControlStateNormal];
}
- (UIImage *)imageNoraml
{
    return [self imageForState:UIControlStateNormal];
}
- (void)setImageHighlighted:(UIImage *)imageHighlighted
{
    [self setImage:imageHighlighted forState:UIControlStateHighlighted];
}
- (UIImage *)imageHighlighted
{
    return [self imageForState:UIControlStateHighlighted];
}
- (void)setImageDisabled:(UIImage *)imageDisabled
{
    [self setImage:imageDisabled forState:UIControlStateDisabled];
}
- (UIImage *)imageDisabled
{
    return [self imageForState:UIControlStateDisabled];
}
- (void)setImageSelected:(UIImage *)imageSelected
{
    [self setImage:imageSelected forState:UIControlStateSelected];
}
- (UIImage *)imageSelected
{
    return [self imageForState:UIControlStateSelected];
}
- (void)setBackgroundImageNoraml:(UIImage *)backgroundImageNoraml
{
    [self setBackgroundImage:backgroundImageNoraml forState:UIControlStateNormal];
}
- (UIImage *)backgroundImageNoraml
{
    return [self backgroundImageForState:UIControlStateNormal];
}
- (void)setBackgroundImageHighlighted:(UIImage *)backgroundImageHighlighted
{
    [self setBackgroundImage:backgroundImageHighlighted forState:UIControlStateHighlighted];
}
- (UIImage *)backgroundImageHighlighted
{
    return [self backgroundImageForState:UIControlStateHighlighted];
}
- (void)setBackgroundImageDisabled:(UIImage *)backgroundImageDisabled
{
    [self setBackgroundImage:backgroundImageDisabled forState:UIControlStateDisabled];
}
- (UIImage *)backgroundImageDisabled
{
    return [self backgroundImageForState:UIControlStateDisabled];
}
- (void)setBackgroundImageSelected:(UIImage *)backgroundImageSelected
{
    [self setBackgroundImage:backgroundImageSelected forState:UIControlStateSelected];
}
- (UIImage *)backgroundImageSelected
{
    return [self backgroundImageForState:UIControlStateSelected];
}

// ========== title ==========
- (void)setTitleNoraml:(NSString *)titleNoraml
{
    [self setTitle:titleNoraml forState:UIControlStateNormal];
}
- (NSString *)titleNoraml
{
    return [self titleForState:UIControlStateNormal];
}
- (void)setTitleHighlighted:(NSString *)titleHighlighted
{
    [self setTitle:titleHighlighted forState:UIControlStateHighlighted];
}
- (NSString *)titleHighlighted
{
    return [self titleForState:UIControlStateHighlighted];
}
- (void)setTitleDisabled:(NSString *)titleDisabled
{
    [self setTitle:titleDisabled forState:UIControlStateDisabled];
}
- (NSString *)titleDisabled
{
    return [self titleForState:UIControlStateDisabled];
}
- (void)setTitleSelected:(NSString *)titleSelected
{
    [self setTitle:titleSelected forState:UIControlStateSelected];
}
- (NSString *)titleSelected
{
    return [self titleForState:UIControlStateSelected];
}
- (void)setTitleColorNoraml:(UIColor *)titleColorNoraml
{
    [self setTitleColor:titleColorNoraml forState:UIControlStateNormal];
}
- (UIColor *)titleColorNoraml
{
    return [self titleColorForState:UIControlStateNormal];
}
- (void)setTitleColorHighlighted:(UIColor *)titleColorHighlighted
{
    [self setTitleColor:titleColorHighlighted forState:UIControlStateHighlighted];
}
- (UIColor *)titleColorHighlighted
{
    return [self titleColorForState:UIControlStateHighlighted];
}
- (void)setTitleColorDisabled:(UIColor *)titleColorDisabled
{
    [self setTitleColor:titleColorDisabled forState:UIControlStateDisabled];
}
- (UIColor *)titleColorDisabled
{
    return [self titleColorForState:UIControlStateDisabled];
}
- (void)setTitleColorSelected:(UIColor *)titleColorSelected
{
    [self setTitleColor:titleColorSelected forState:UIControlStateSelected];
}
- (UIColor *)titleColorSelected
{
    return [self titleColorForState:UIControlStateSelected];
}
// ========== 字体大小 ==========
- (void)setFont:(UIFont *)font
{
    self.titleLabel.font = font;
}
- (UIFont *)font
{
    return self.titleLabel.font;
}

@end
