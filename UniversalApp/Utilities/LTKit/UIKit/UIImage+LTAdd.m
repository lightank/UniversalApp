//
//  UIImage+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UIImage+LTAdd.h"

@implementation UIImage (LTAdd)

+ (instancetype)lt_gradientColorImageFromColor:(UIColor *)beginColor toColor:(UIColor *)endColor size:(CGSize)size
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)beginColor.CGColor,(__bridge id)endColor.CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    //startPoint & endPoint设置为(0, 0),(1,0)代表水平方向渐变,(0,0)(0, 1)代表竖直方向渐变
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, NO, 0);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    if (!color) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
