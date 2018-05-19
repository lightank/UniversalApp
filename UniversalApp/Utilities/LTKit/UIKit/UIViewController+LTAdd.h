//
//  UIViewController+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LTAdd)

/**  背景透明度  */
@property (nonatomic, assign) CGFloat navigationBarBackgroundAlpha;
/**  普通状态下的文字颜色  */
@property (nonatomic, strong) UIColor *tabBarTitleColorNormal;
/**  选中状态下的文字颜色  */
@property (nonatomic, strong) UIColor *tabBarTitleColorSelected;

@end
