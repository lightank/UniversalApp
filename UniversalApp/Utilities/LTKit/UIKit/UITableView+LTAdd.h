//
//  UITableView+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/8/24.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (LTAdd)

/**  设置section之间间距,如果tableHeaderView没有值的话,会给它赋值一个margin高度的空视图  */
- (void)lt_setSectionMargin:(CGFloat)margin;
/**  通过设置tableHeaderView,tableFooterView,sectionHeaderHeight,sectionFooterHeight的高度为0,来消除tableview上下的间距  */
- (void)lt_cleanTopAndBottomMargin;

@end
