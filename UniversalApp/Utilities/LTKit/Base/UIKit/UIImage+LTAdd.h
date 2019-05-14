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
 将layer内容导出为图片

 @param layer layer
 @return 图片
 */
+ (UIImage *)lt_imageWithLayer:(CALayer *)layer;

/**
 生成一张size为(1.f, 1.f)大小的纯色背景

 @param color 纯色
 @return 图片
 */
+ (UIImage *)lt_imageWithColor:(UIColor *)color;

/**
 更改网络下载的图片大小,一般后台下发的图片scale是1,如果直接取图片的scale是有可能出现锯齿的

 @param size 压缩后图片大小
 @return 压缩后图片
 */
- (UIImage *)lt_webImageByResizeToSize:(CGSize)size;

@end
