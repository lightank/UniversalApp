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

@end

NS_ASSUME_NONNULL_END
