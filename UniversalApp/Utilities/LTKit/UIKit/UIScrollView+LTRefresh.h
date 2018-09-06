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

@end

@interface UIScrollView (LTAdd)

/**  是否自动调整scrollview的内间距  */
@property (nonatomic, assign, getter=isContentInsetAdjust) BOOL lt_contentInsetAdjust;

- (void)lt_disableAdjustContentInset;

@end


