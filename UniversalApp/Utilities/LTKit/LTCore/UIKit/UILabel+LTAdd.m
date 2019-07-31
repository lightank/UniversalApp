//
//  UILabel+LTAdd.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/5/23.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "UILabel+LTAdd.h"

@implementation UILabel (LTAdd)

+ (instancetype)lt_labelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)textColor
{
    UILabel *label = [[self alloc] init];
    label.textColor = textColor;
    label.font = font;
    label.text = text;
    [label sizeToFit];
    return label;
}

@end
