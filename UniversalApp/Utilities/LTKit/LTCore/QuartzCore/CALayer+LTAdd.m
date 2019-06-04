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
    self.masksToBounds = NO;
    self.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius].CGPath;
}

+ (CAGradientLayer *)lt_axialGradientLayerWithFromColor:(UIColor *)fromColor
                                                toColor:(UIColor *)toColor
                                                   size:(CGSize)size
                                              direction:(LTGradientLayerDirection)direction
{
    if (!fromColor || !toColor) return nil;
    return [self lt_axialGradientLayerWithColorArray:@[fromColor, toColor] size:size direction:direction];
}

+ (CAGradientLayer *)lt_axialGradientLayerWithColorArray:(NSArray<UIColor *> *)colorArray
                                                    size:(CGSize)size
                                               direction:(LTGradientLayerDirection)direction
{
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    switch (direction)
    {
        case LTGradientLayerDirectionTopToBottom:
        {
            startPoint = CGPointMake(0.f, 0.f);
            endPoint = CGPointMake(0.f, 1.f);
        }
            break;
        case LTGradientLayerDirectionLeftToRight:
        {
            startPoint = CGPointMake(0.f, 0.f);
            endPoint = CGPointMake(1.f, 0.f);
        }
            break;
        case LTGradientLayerDirectionBottomToTop:
        {
            startPoint = CGPointMake(0.f, 1.f);
            endPoint = CGPointMake(0.f, 0.f);
        }
            break;
        case LTGradientLayerDirectionRightToLeft:
        {
            startPoint = CGPointMake(1.f, 0.f);
            endPoint = CGPointMake(0.f, 0.f);
        }
            break;
    }
    
    return [self lt_gradientLayerWithColorArray:colorArray size:size startPoint:startPoint endPoint:endPoint type:kCAGradientLayerAxial];
}

+ (CAGradientLayer *)lt_gradientLayerWithColorArray:(NSArray<UIColor *> *)colorArray
                                               size:(CGSize)size
                                         startPoint:(CGPoint)startPoint
                                           endPoint:(CGPoint)endPoint
                                               type:(CAGradientLayerType)type
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
    layer.type = type;
    return layer;
}

@end
