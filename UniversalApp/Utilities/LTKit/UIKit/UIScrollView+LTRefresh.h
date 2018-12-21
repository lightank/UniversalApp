//
//  UIScrollView+LTRefresh.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>
#if __has_include(<MJRefresh/MJRefresh.h>)
#import <MJRefresh/MJRefresh.h>
#else
#import "MJRefresh.h"
#endif

@interface UIScrollView (LTRefresh)

- (void)lt_addHeaderRefreshTarget:(id)target
                 refreshingAction:(SEL)action;
- (void)lt_addFooterRefreshTarget:(id)target
                 refreshingAction:(SEL)action;

- (void)lt_addHeaderRefresh:(void(^)(void))block;
- (void)lt_addFooterRefresh:(void(^)(void))block;

- (void)lt_setHeaderTitle:(NSString *)title
                 forState:(MJRefreshState)state;
- (void)lt_setFooterTitle:(NSString *)title
                 forState:(MJRefreshState)state;

- (void)lt_beginHeaderRefresh;
- (void)lt_endHeaderRefresh;

- (void)lt_beginFooterRefresh;
- (void)lt_endFooterRefresh;

- (void)lt_endRefresh;

/**  是否展示:已经全部加载完毕  */
@property (nonatomic, assign, getter=isLt_NoMoreData) BOOL lt_noMoreData;

@end

@interface UIScrollView (LTAdd)


@end


