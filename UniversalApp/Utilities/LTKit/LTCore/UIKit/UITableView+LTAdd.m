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

- (void)lt_cleanTopAndBottomMargin
{
    if (!self.tableHeaderView) self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 0.00001f)];
    if (!self.tableFooterView) self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, 0.00001f)];
    self.sectionHeaderHeight = 0.f;
    self.sectionFooterHeight = 0.f;
}

- (void)lt_hiddenSeparatorLine
{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSIndexPath *)lt_firstFullVisibleCellIndexPath
{
    NSArray<NSIndexPath *> *indexPathsForVisibleRows = [self indexPathsForVisibleRows];
    NSIndexPath *selectedIndexPath = nil;
    if (indexPathsForVisibleRows.count <= 0)
    {
        return selectedIndexPath;
    }
    
    UIView *window = UIApplication.sharedApplication.delegate.window;
    CGRect tableViewReact = [self.superview convertRect:self.frame toView:window];
    CGFloat tableViewMixY = CGRectGetMinY(tableViewReact);
    
    for (NSIndexPath *indexPath in indexPathsForVisibleRows)
    {
        CGRect cellRect = [self rectForRowAtIndexPath:indexPath];
        CGRect cellRectOnWindow = [self convertRect:cellRect toView:window];
        CGFloat cellMixY = CGRectGetMinY(cellRectOnWindow);
        if (cellMixY >= tableViewMixY)
        {
            selectedIndexPath = indexPath;
            break;
        }
    }
    
    if (!selectedIndexPath)
    {
        selectedIndexPath = indexPathsForVisibleRows.firstObject;
    }
    
    return selectedIndexPath;
}

- (BOOL)lt_isVaildRangForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.numberOfSections) {
        return NO;
    }
    if (indexPath.row >= [self numberOfRowsInSection:indexPath.section]) {
        return NO;
    }
    return YES;
}

- (void)lt_scrollToIndexPath:(NSIndexPath *)indexPath topOffset:(CGFloat)topOffset animated:(BOOL)animated
{
    if (![self lt_isVaildRangForIndexPath:indexPath]) {
        return;
    }
    
    CGPoint point = [self rectForRowAtIndexPath:indexPath].origin;
    point = CGPointMake(point.x, point.y - topOffset);
    [self setContentOffset:point animated:animated];
}

@end
