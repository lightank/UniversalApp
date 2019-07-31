//
//  UILabel+LTAdd.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/5/23.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (LTAdd)

+ (instancetype)lt_labelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)textColor;

@end

NS_ASSUME_NONNULL_END
