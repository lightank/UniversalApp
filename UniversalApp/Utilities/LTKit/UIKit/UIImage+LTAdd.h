//
//  UIImage+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LTGradientImageDirection) {
    LTGradientImageDirectionTop,    //从上往下渐变,越往下颜色越深
    LTGradientImageDirectionLeft,   //从左往右渐变,越往右颜色越深
    LTGradientImageDirectionBottom, //从下往上渐变,越往上颜色越深
    LTGradientImageDirectionRight,  //从右到左渐变,越往左颜色越深
};

@interface UIImage (LTAdd)

/**
 生成一张一个颜色往透明渐变的图片

 @param color 颜色
 @param size 图片大小
 @param direction 方向
 @return 图片
 */
+ (UIImage *)lt_imageWithColor:(UIColor *)color
                          size:(CGSize)size
                     direction:(LTGradientImageDirection)direction;

/**
 生成一张一个颜色数组渐变的图片

 @param colorArray 颜色数组
 @param size 图片大小
 @param direction 方向
 @return 图片
 */
+ (UIImage *)lt_imageWithColorArray:(NSArray *)colorArray
                               size:(CGSize)size
                          direction:(LTGradientImageDirection)direction;

/**
 生成一张一从fromColor颜色到toColor颜色的渐变图片

 @param fromColor 开始颜色
 @param toColor 结束颜色
 @param size 图片大小
 @param direction 方向
 @return 图片
 */
+ (UIImage *)lt_imageWithFromColor:(UIColor *)fromColor
                           toColor:(UIColor *)toColor
                              size:(CGSize)size
                         direction:(LTGradientImageDirection)direction;

/**
 生成一张size为(1.f, 1.f)大小的纯色背景

 @param color 纯色
 @return 图片
 */
+ (UIImage *)lt_imageWithColor:(UIColor *)color;


/**
 通过在现有图片上叠加一张白色渐变图片来实现现有图片的alpha渐变

 @param alphaDirection alpha渐变方向
 @return 处理后的图片
 */
- (UIImage *)lt_imageWithGradientAlphaDirection:(LTGradientImageDirection)alphaDirection;

/**
 更改网络下载的图片大小,一般后台下发的图片scale是1,如果直接取图片的scale是有可能出现锯齿的

 @param size 压缩后图片大小
 @return 压缩后图片
 */
- (UIImage *)lt_webImageByResizeToSize:(CGSize)size;

@end
