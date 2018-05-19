//
//  UIScrollView+LTRefresh.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UIScrollView+LTRefresh.h"

@implementation UIScrollView (LTRefresh)

- (void)addHeaderRefreshTarget:(id)target refreshingAction:(SEL)action
{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
}

- (void)addFooterRefreshTarget:(id)target refreshingAction:(SEL)action
{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
}

- (void)addHeaderRefresh:(void (^)(void))block
{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
}

- (void)addFooterRefresh:(void (^)(void))block
{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:block];
}

- (void)setHeaderTitle:(NSString *)title forState:(MJRefreshState)state
{
    if ([self.mj_header isKindOfClass:[MJRefreshStateHeader class]])
    {
        [((MJRefreshStateHeader *)self.mj_header) setTitle:title forState:state];
    }
}

- (void)setFooterTitle:(NSString *)title forState:(MJRefreshState)state
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

- (void)beginHeaderRefresh
{
    [self.mj_header beginRefreshing];
}

- (void)endHeaderRefresh
{
    [self.mj_header endRefreshing];
}

- (void)beginFooterRefresh
{
    [self.mj_footer beginRefreshing];
}

- (void)endFooterRefresh
{
    [self.mj_footer endRefreshing];
}

- (void)endRefresh
{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

@end


@implementation UIScrollView (LTAdd)

//contentInsetAdjust
static char kAssociatedObjectKey_contentInsetAdjust;
- (void)setContentInsetAdjust:(BOOL)contentInsetAdjust
{
    objc_setAssociatedObject(self, &kAssociatedObjectKey_contentInsetAdjust, @(contentInsetAdjust), OBJC_ASSOCIATION_ASSIGN);
    self.viewController.automaticallyAdjustsScrollViewInsets = contentInsetAdjust;
    if (@available(iOS 11.0, *))
    {
        self.contentInsetAdjustmentBehavior = contentInsetAdjust ? : UIScrollViewContentInsetAdjustmentNever;
    }
}
- (BOOL)isContentInsetAdjust
{
    return ((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_contentInsetAdjust)).boolValue;
}

@end
