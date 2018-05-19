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
@property (nonatomic, strong) UIImage *imageNoraml;
/**  Highlighted下的图片  */
@property (nonatomic, strong) UIImage *imageHighlighted;
/**  Disabled下的图片  */
@property (nonatomic, strong) UIImage *imageDisabled;
/**  Selected下的图片  */
@property (nonatomic, strong) UIImage *imageSelected;
/**  Normal下的背景图片  */
@property (nonatomic, strong) UIImage *backgroundImageNoraml;
/**  Highlighted下的背景图片  */
@property (nonatomic, strong) UIImage *backgroundImageHighlighted;
/**  Disabled下的背景图片  */
@property (nonatomic, strong) UIImage *backgroundImageDisabled;
/**  Selected下的背景图片  */
@property (nonatomic, strong) UIImage *backgroundImageSelected;

// ========== title ==========
/**  Normal下title  */
@property (nonatomic, copy) NSString *titleNoraml;
/**  Highlighted下title   */
@property (nonatomic, copy) NSString *titleHighlighted;
/**  Disabled下title   */
@property (nonatomic, copy) NSString *titleDisabled;
/**  Selected下title   */
@property (nonatomic, copy) NSString *titleSelected;
/**  Normal下title颜色  */
@property (nonatomic, strong) UIColor *titleColorNoraml;
/**  Highlighted下title颜色   */
@property (nonatomic, strong) UIColor *titleColorHighlighted;
/**  Disabled下title颜色   */
@property (nonatomic, strong) UIColor *titleColorDisabled;
/**  Selected下title颜色   */
@property (nonatomic, strong) UIColor *titleColorSelected;

/**  字体大小  */
@property (nonatomic, strong) UIFont *font;


/**  便利构造器  */
+ (instancetype)buttonWithNormalImage:(UIImage *)normalImage normalTitle:(NSString *)normalTitle andFont:(UIFont *)font;


/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space;



@end
