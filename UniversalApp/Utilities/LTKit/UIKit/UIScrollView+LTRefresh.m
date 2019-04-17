//
//  UIScrollView+LTRefresh.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UIScrollView+LTRefresh.h"

@implementation UIScrollView (LTRefresh)

- (void)lt_addHeaderRefreshTarget:(id)target
                 refreshingAction:(SEL)action
{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
}

- (void)lt_addFooterRefreshTarget:(id)target
                 refreshingAction:(SEL)action
{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
}

- (void)lt_addHeaderRefresh:(void (^)(void))block
{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
}

- (void)lt_addFooterRefresh:(void (^)(void))block
{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:block];
}

- (void)lt_setHeaderTitle:(NSString *)title
                 forState:(MJRefreshState)state
{
    if ([self.mj_header isKindOfClass:[MJRefreshStateHeader class]])
    {
        [((MJRefreshStateHeader *)self.mj_header) setTitle:title forState:state];
    }
}

- (void)lt_setFooterTitle:(NSString *)title
                 forState:(MJRefreshState)state
{
    if ([self.mj_footer isKindOfClass:[MJRefreshAutoStateFooter class]])
    {
        [((MJRefreshAutoStateFooter *)self.mj_footer) setTitle:title forState:state];
    }
    else if ([self.mj_footer isKindOfClass:[MJRefreshBackStateFooter class]])
    {
        [((MJRefreshBackStateFooter *)self.mj_footer) setTitle:title forState:state];
    }
}

- (void)lt_beginHeaderRefresh
{
    [self.mj_header beginRefreshing];
}

- (void)lt_endHeaderRefresh
{
    [self.mj_header endRefreshing];
}

- (void)lt_beginFooterRefresh
{
    [self.mj_footer beginRefreshing];
}

- (void)lt_endFooterRefresh
{
    [self.mj_footer endRefreshing];
}

- (void)lt_endRefresh
{
    if (self.mj_header.isRefreshing) [self.mj_header endRefreshing];
    if (self.mj_footer.isRefreshing) [self.mj_footer endRefreshing];
}

- (void)setLt_noMoreData:(BOOL)lt_noMoreData
{
    if (lt_noMoreData)
    {
        [self lt_endRefresh];
        self.mj_footer.state = MJRefreshStateNoMoreData;
    }
    else
    {
        [self.mj_footer resetNoMoreData];
    }
}

- (BOOL)isLt_NoMoreData
{
    return self.mj_footer.state == MJRefreshStateNoMoreData;
}

@end


@implementation UIScrollView (LTAdd)

- (void)lt_disableContentInsetAdjustment
{
    if (@available(iOS 11.0, *))
    {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

@end
