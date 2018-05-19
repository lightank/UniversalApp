//
//  UIView+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UIView+LTAdd.h"
//#import "IQUIView+Hierarchy.h"

@implementation UIView (LTAdd)
// ========== x ==========
- (CGFloat)lt_left
{
    return self.frame.origin.x;
}
- (void)setLt_left:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}
// ========== y ==========
- (CGFloat)lt_top
{
    return self.frame.origin.y;
}

- (void)setLt_top:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}
// ========== size ==========
- (CGSize)lt_size
{
    return self.frame.size;
}
- (void)setLt_size:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
// ========== origin ==========
- (CGPoint)lt_origin
{
    return self.frame.origin;
}
- (void)setLt_origin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
// ========== right ==========
- (CGFloat)lt_right
{
    return CGRectGetMaxX(self.frame);
}
- (void)setLt_right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    CGRectGetMaxX(CGRectZero);
    self.frame = frame;
}
// ========== bottom ==========
- (CGFloat)lt_bottom
{
    return CGRectGetMaxY(self.frame);
}
- (void)setLt_bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
// ========== 宽度 ==========
- (CGFloat)lt_width
{
    return self.frame.size.width;
}
- (void)setLt_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
// ========== 高度 ==========
- (CGFloat)lt_height
{
    return self.frame.size.height;
}
- (void)setLt_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
// ========== centerX ==========
- (CGFloat)lt_centerX
{
    return self.center.x;
}
- (void)setLt_centerX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}
// ========== centerY ==========
- (CGFloat)lt_centerY
{
    return self.center.y;
}

- (void)setLt_centerY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(LTOscillatoryAnimationType)type
{
    NSNumber *animationScale1 = type == LTOscillatoryAnimationToBigger ? @(1.15) : @(0.5);
    NSNumber *animationScale2 = type == LTOscillatoryAnimationToBigger ? @(0.92) : @(1.15);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}

- (UIView *)subviewOfClassType:(Class)classType
{
    __block UIView *subview = nil;
    
    NSArray<__kindof UIView *> *subviews = self.subviews;
    
    [subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:classType])
        {
            subview = obj;
            *stop = YES;
        }
        else
        {
            subview = [obj subviewOfClassType:classType];
            if (subview) *stop = YES;
        }
    }];

    return subview;
}

- (UIView*)duplicate
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

@end
