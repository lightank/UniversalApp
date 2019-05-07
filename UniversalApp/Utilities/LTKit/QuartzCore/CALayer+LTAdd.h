//
//  CALayer+LTAdd.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/4/18.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LTGradientLayerDirection) {
    LTGradientLayerDirectionTop,    //从上往下渐变,越往下颜色越深
    LTGradientLayerDirectionLeft,   //从左往右渐变,越往右颜色越深
    LTGradientLayerDirectionBottom, //从下往上渐变,越往上颜色越深
    LTGradientLayerDirectionRight,  //从右到左渐变,越往左颜色越深
};

@interface CALayer (LTAdd)

/**
 添加阴影

 @param shadowColor 阴影颜色
 @param shadowOffset 阴影偏移,x向右偏移，y向下偏移，默认(0, -3)
 @param shadowOpacity 阴影透明度
 @param shadowRadius 阴影半径,默认为3
 */
- (void)lt_addShadowWithColor:(UIColor *)shadowColor
                       offset:(CGSize)shadowOffset
                      opacity:(CGFloat)shadowOpacity
                       radius:(CGFloat)shadowRadius;

/**
 生成渐变layer

 @param fromColor 开始颜色
 @param toColor 结束颜色
 @param size 大小
 @param direction 渐变方向
 @return 渐变layer
 */
+ (CAGradientLayer *)lt_gradientLayerWithFromColor:(UIColor *)fromColor
                                           toColor:(UIColor *)toColor
                                              size:(CGSize)size
                                         direction:(LTGradientLayerDirection)direction;

/**
 生成渐变layer

 @param colorArray 颜色数组
 @param size 大小
 @param direction 渐变方向
 @return 渐变layer
 */
+ (CAGradientLayer *)lt_gradientLayerWithColorArray:(NSArray<UIColor *> *)colorArray
                                               size:(CGSize)size
                                          direction:(LTGradientLayerDirection)direction;

/**
 生成渐变layer

 @param colorArray 颜色数组
 @param size 大小
 @param startPoint 开始点
 @param endPoint 结束点
 @return 渐变layer
 */
+ (CAGradientLayer *)lt_gradientLayerWithColorArray:(NSArray<UIColor *> *)colorArray
                                               size:(CGSize)size
                                         startPoint:(CGPoint)startPoint
                                           endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
