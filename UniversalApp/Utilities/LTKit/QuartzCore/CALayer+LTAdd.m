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

@end
