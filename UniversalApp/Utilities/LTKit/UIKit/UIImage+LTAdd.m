//
//  UIImage+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UIImage+LTAdd.h"

@implementation UIImage (LTAdd)

+ (UIImage *)lt_imageWithColor:(UIColor *)color size:(CGSize)size direction:(LTGradientImageDirection)direction
{
    if (!color) return nil;
    return [UIImage lt_imageWithColorArray:@[color, [color colorWithAlphaComponent:0.f]] size:size direction:direction];
}

+ (UIImage *)lt_imageWithFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)size direction:(LTGradientImageDirection)direction
{
    if (!fromColor || !toColor) return nil;
    return [UIImage lt_imageWithColorArray:@[fromColor, toColor] size:size direction:direction];
}

+ (UIImage *)lt_imageWithColorArray:(NSArray *)colorArray size:(CGSize)size direction:(LTGradientImageDirection)direction
{
    if (!colorArray || colorArray.count == 0) return nil;
    CGSize layerSize = (size.width <= 0 || size.height <= 0) ? CGSizeMake(1.f, 1.f) : size;
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.frame = CGRectMake(0.f, 0.f, layerSize.width, layerSize.height);
    NSMutableArray *cgColorArray = [[NSMutableArray alloc] init];
    for (UIColor *color in colorArray) {
        [cgColorArray addObject:(__bridge id)color.CGColor];
    }
    layer.colors = cgColorArray;
    switch (direction) {
        case LTGradientImageDirectionTop:
        {
            layer.startPoint = CGPointMake(0.5f, 1.f);
            layer.endPoint = CGPointMake(0.5f, .0f);
        }
            break;
        case LTGradientImageDirectionLeft:
        {
            layer.startPoint = CGPointMake(1.f, 0.5f);
            layer.endPoint = CGPointMake(.0f, 0.5f);
        }
            break;
        case LTGradientImageDirectionBottom:
        {
            layer.startPoint = CGPointMake(0.5f, .0f);
            layer.endPoint = CGPointMake(0.5f, 1.f);
        }
            break;
        case LTGradientImageDirectionRight:
        {
            layer.startPoint = CGPointMake(.0f, 0.5f);
            layer.endPoint = CGPointMake(1.f, 0.5f);
        }
            break;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, layer.opaque, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

+ (UIImage *)lt_imageWithColor:(UIColor *)color
{
    if (!color) return nil;
    CGRect rect = CGRectMake(.0f, .0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)lt_imageWithGradientAlphaDirection:(LTGradientImageDirection)alphaDirection
{
    CGSize imageSize = self.size;
    UIImage *whiteImage = [UIImage lt_imageWithColor:[UIColor whiteColor] size:imageSize direction:alphaDirection];
    
    UIImage *imageIn = self;
    UIImage *imageOut = nil;
//    UIGraphicsBeginImageContextWithOptions(imageIn.size, self.qmui_opaque, imageIn.scale);
    UIGraphicsBeginImageContext(imageSize);
    [imageIn drawInRect:CGRectMakeWithSize(imageIn.size)];
    [whiteImage drawAtPoint:CGPointZero];
    imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOut;
}

@end
