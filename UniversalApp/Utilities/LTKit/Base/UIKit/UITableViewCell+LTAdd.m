//
//  UITableViewCell+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/8/28.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UITableViewCell+LTAdd.h"

@implementation UITableViewCell (LTAdd)

+ (NSString *)lt_reuseIdentifier
{
    return [NSString stringWithFormat:@"k%@_reuseIdentifier", NSStringFromClass(self)];
}

@end
