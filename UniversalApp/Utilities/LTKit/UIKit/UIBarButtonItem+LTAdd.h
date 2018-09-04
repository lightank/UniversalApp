//
//  UIBarButtonItem+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/9/3.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LTAdd)

+ (instancetype)lt_flexibleSpace;
+ (instancetype)lt_fixedSpace:(CGFloat)space;

@end
