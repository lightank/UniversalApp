//
//  UIImage+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LTAdd)

/**
 返回指定大小的渐变颜色图片

 @param beginColor 开始颜色
 @param endColor 结束颜色
 @param size 图片大小
 @return 图片
 */
+ (instancetype)gradientColorImageFromColor:(UIColor *)beginColor toColor:(UIColor *)endColor size:(CGSize)size;

@end
