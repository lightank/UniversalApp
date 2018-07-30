//
//  UIButton+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//  这是UIButton关于图片与文字布局位置的分类

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ButtonEdgeInsetsStyle) {
    ButtonEdgeInsetsStyleTop,       //image在上，label在下
    ButtonEdgeInsetsStyleLeft,      //image在左，label在右
    ButtonEdgeInsetsStyleBottom,    //image在下，label在上
    ButtonEdgeInsetsStyleRight      //image在右，label在左
};

@interface UIButton (LTAdd)
// ========== 图片 ==========
/**  Normal下的图片  */
@property (nonatomic, strong) UIImage *lt_imageNoraml;
/**  Highlighted下的图片  */
@property (nonatomic, strong) UIImage *lt_imageHighlighted;
/**  Disabled下的图片  */
@property (nonatomic, strong) UIImage *lt_imageDisabled;
/**  Selected下的图片  */
@property (nonatomic, strong) UIImage *lt_imageSelected;
/**  Normal下的背景图片  */
@property (nonatomic, strong) UIImage *lt_backgroundImageNoraml;
/**  Highlighted下的背景图片  */
@property (nonatomic, strong) UIImage *lt_backgroundImageHighlighted;
/**  Disabled下的背景图片  */
@property (nonatomic, strong) UIImage *lt_backgroundImageDisabled;
/**  Selected下的背景图片  */
@property (nonatomic, strong) UIImage *lt_backgroundImageSelected;

// ========== title ==========
/**  Normal下title  */
@property (nonatomic, copy) NSString *lt_titleNoraml;
/**  Highlighted下title   */
@property (nonatomic, copy) NSString *lt_titleHighlighted;
/**  Disabled下title   */
@property (nonatomic, copy) NSString *lt_titleDisabled;
/**  Selected下title   */
@property (nonatomic, copy) NSString *lt_titleSelected;
/**  Normal下title颜色  */
@property (nonatomic, strong) UIColor *lt_titleColorNoraml;
/**  Highlighted下title颜色   */
@property (nonatomic, strong) UIColor *lt_titleColorHighlighted;
/**  Disabled下title颜色   */
@property (nonatomic, strong) UIColor *lt_titleColorDisabled;
/**  Selected下title颜色   */
@property (nonatomic, strong) UIColor *lt_titleColorSelected;

/**  字体大小  */
@property (nonatomic, strong) UIFont *lt_font;


/**  便利构造器  */
+ (instancetype)lt_buttonWithNormalImage:(UIImage *)normalImage normalTitle:(NSString *)normalTitle andFont:(UIFont *)font;


/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)lt_layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space;



@end
