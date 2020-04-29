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
/**  隐藏分割线  */
- (void)lt_hiddenSeparatorLine;
/// 给定的 indexPath 是否合法
/// @param indexPath indexPath
- (BOOL)lt_isVaildRangForIndexPath:(NSIndexPath *)indexPath;
/// 滚动到指定的 indexPath，默认滚动到tableview的顶部(不包含 contentInset 的 top 值)，如果需要滚动后再把视图往下移，请给 topOffset 设置值
/// @param indexPath indexPath
/// @param topOffset 顶部移动距离，如果 >0，视图将下移，如果 <= 0，视图将上移
/// @param animated 是否动画
- (void)lt_scrollToIndexPath:(NSIndexPath *)indexPath topOffset:(CGFloat)topOffset animated:(BOOL)animated;

@end
