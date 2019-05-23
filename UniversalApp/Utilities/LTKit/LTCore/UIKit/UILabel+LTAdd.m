//
//  UILabel+LTAdd.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/5/23.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "UILabel+LTAdd.h"

@implementation UILabel (LTAdd)

+ (UILabel *)lt_labelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = textColor;
    label.font = font;
    label.text = text;
    return label;
}

@end
