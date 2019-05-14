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
    // 轴向
    LTGradientLayerDirectionTopToBottom,    //从上往下渐变,A → C
    LTGradientLayerDirectionLeftToRight,   //从左往右渐变,A → B
    LTGradientLayerDirectionBottomToTop, //从下往上渐变,C → A
    LTGradientLayerDirectionRightToLeft,  //从右到左渐变,B → A
};

//   (0,0)        (1,0)
//     A  _________ B
//      |         |
//      |         |
//    C  ---------  D
//  (0,1)         (1,1)

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
 生成轴向渐变layer

 @param fromColor 开始颜色
 @param toColor 结束颜色
 @param size 大小
 @param direction 渐变方向
 @return 轴向渐变layer
 */
+ (CAGradientLayer *)lt_axialGradientLayerWithFromColor:(UIColor *)fromColor
                                           toColor:(UIColor *)toColor
                                              size:(CGSize)size
                                         direction:(LTGradientLayerDirection)direction;

/**
 生成轴向渐变layer

 @param colorArray 颜色数组
 @param size 大小
 @param direction 渐变方向
 @return 轴向渐变layer
 */
+ (CAGradientLayer *)lt_axialGradientLayerWithColorArray:(NSArray<UIColor *> *)colorArray
                                               size:(CGSize)size
                                          direction:(LTGradientLayerDirection)direction;

/**
 生成渐变layer

 @param colorArray 颜色数组
 @param size 大小
 @param startPoint 开始点
 @param endPoint 结束点
  @param type iOS 12 以下支持 kCAGradientLayerAxial(轴向) kCAGradientLayerRadial(径向), iOS 12 以后支持 kCAGradientLayerConic(锥)
 @return 渐变layer
 */
+ (CAGradientLayer *)lt_gradientLayerWithColorArray:(NSArray<UIColor *> *)colorArray
                                               size:(CGSize)size
                                         startPoint:(CGPoint)startPoint
                                           endPoint:(CGPoint)endPoint
                                               type:(CAGradientLayerType)type;

@end

NS_ASSUME_NONNULL_END
