//
//  UIBarButtonItem+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/9/3.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UIBarButtonItem+LTAdd.h"

@implementation UIBarButtonItem (LTAdd)

+ (instancetype)lt_flexibleSpace
{
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
}

+ (instancetype)lt_fixedSpace:(CGFloat)space
{
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = space;
    return fixedSpace;
}


@end
