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

- (void)addHeaderRefreshTarget:(id)target refreshingAction:(SEL)action;
- (void)addFooterRefreshTarget:(id)target refreshingAction:(SEL)action;

- (void)addHeaderRefresh:(void(^)(void))block;
- (void)addFooterRefresh:(void(^)(void))block;

- (void)setHeaderTitle:(NSString *)title forState:(MJRefreshState)state;
- (void)setFooterTitle:(NSString *)title forState:(MJRefreshState)state;

- (void)beginHeaderRefresh;
- (void)endHeaderRefresh;

- (void)beginFooterRefresh;
- (void)endFooterRefresh;

- (void)endRefresh;

@end

@interface UIScrollView (LTAdd)

/**  是否自动调整scrollview的内间距  */
@property (nonatomic, assign, getter=isContentInsetAdjust) BOOL contentInsetAdjust;

@end


