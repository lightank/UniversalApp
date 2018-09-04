//
//  UITableView+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/8/24.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UITableView+LTAdd.h"

@implementation UITableView (LTAdd)

- (void)lt_setSectionMargin:(CGFloat)margin
{
    self.sectionHeaderHeight = margin * 0.5f;
    self.sectionFooterHeight = margin * 0.5f;
    if (!self.tableHeaderView)
    {
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, margin * 0.5f)];
    }
}

@end
