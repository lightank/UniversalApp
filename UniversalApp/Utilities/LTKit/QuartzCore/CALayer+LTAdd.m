//
//  CALayer+LTAdd.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/4/18.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "CALayer+LTAdd.h"

@implementation CALayer (LTAdd)

- (void)lt_addShadowWithColor:(UIColor *)shadowColor
                       offset:(CGSize)shadowOffset
                      opacity:(CGFloat)shadowOpacity
                       radius:(CGFloat)shadowRadius
{
    self.shadowColor = shadowColor.CGColor;
    self.shadowOffset = shadowOffset;
    self.shadowOpacity = shadowOpacity;
    self.shadowRadius = shadowRadius;
}

+ (CAGradientLayer *)lt_gradientLayerWithFromColor:(UIColor *)fromColor
                                           toColor:(UIColor *)toColor
                                              size:(CGSize)size
                                         direction:(LTGradientLayerDirection)direction
{
    if (!fromColor || !toColor) return nil;
    return [self lt_gradientLayerWithColorArray:@[fromColor, toColor] size:size direction:direction];
}

+ (CAGradientLayer *)lt_gradientLayerWithColorArray:(NSArray<UIColor *> *)colorArray
                                               size:(CGSize)size
                                          direction:(LTGradientLayerDirection)direction
{
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    switch (direction)
    {
        case LTGradientLayerDirectionTop:
        {
            startPoint = CGPointMake(0.5f, 1.f);
            endPoint = CGPointMake(0.5f, .0f);
        }
            break;
        case LTGradientLayerDirectionLeft:
        {
            startPoint = CGPointMake(1.f, 0.5f);
            endPoint = CGPointMake(0.f, 0.5f);
        }
            break;
        case LTGradientLayerDirectionBottom:
        {
            startPoint = CGPointMake(0.5f, .0f);
            endPoint = CGPointMake(0.5f, 1.f);
        }
            break;
        case LTGradientLayerDirectionRight:
        {
            startPoint = CGPointMake(0.f, 0.5f);
            endPoint = CGPointMake(1.f, 0.5f);
        }
            break;
    }
    
    return [self lt_gradientLayerWithColorArray:colorArray size:size startPoint:startPoint endPoint:endPoint];
}

+ (CAGradientLayer *)lt_gradientLayerWithColorArray:(NSArray<UIColor *> *)colorArray
                                               size:(CGSize)size
                                         startPoint:(CGPoint)startPoint
                                           endPoint:(CGPoint)endPoint
{
    if (!colorArray || colorArray.count == 0) return nil;
    CGSize layerSize = (size.width <= 0 || size.height <= 0) ? CGSizeMake(1.f, 1.f) : size;
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.frame = CGRectMake(0.f, 0.f, layerSize.width, layerSize.height);
    NSMutableArray *cgColorArray = [[NSMutableArray alloc] init];
    for (UIColor *color in colorArray)
    {
        [cgColorArray addObject:(__bridge id)color.CGColor];
    }
    layer.colors = cgColorArray;
    layer.startPoint = startPoint;
    layer.endPoint = endPoint;
    return layer;
}

@end
