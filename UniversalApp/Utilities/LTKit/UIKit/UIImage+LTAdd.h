//
//  UIImage+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LTGradientColorImageDirection) {
    LTGradientColorImageDirectionTop,
    LTGradientColorImageDirectionLeft,
    LTGradientColorImageDirectionBottom,
    LTGradientColorImageDirectionRight,
};

@interface UIImage (LTAdd)

/**
 生成一张一个颜色往透明渐变的图片

 @param color 颜色
 @param size 图片大小
 @param direction 方向
 @return 图片
 */
+ (UIImage *)lt_imageWithColor:(UIColor *)color size:(CGSize)size direction:(LTGradientColorImageDirection)direction;

/**
 生成一张一个颜色数组渐变的图片

 @param colorArray 颜色数组
 @param size 图片大小
 @param direction 方向
 @return 图片
 */
+ (UIImage *)lt_imageWithColorArray:(NSArray *)colorArray size:(CGSize)size direction:(LTGradientColorImageDirection)direction;

/**
 生成一张一从fromColor颜色到toColor颜色的渐变图片

 @param fromColor 开始颜色
 @param toColor 结束颜色
 @param size 图片大小
 @param direction 方向
 @return 图片
 */
+ (UIImage *)lt_imageWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)size direction:(LTGradientColorImageDirection)direction;

/**
 生成一张size为(1.f, 1.f)大小的纯色背景

 @param color 纯色
 @return 图片
 */
+ (UIImage *)lt_imageWithColor:(UIColor *)color;


@end
