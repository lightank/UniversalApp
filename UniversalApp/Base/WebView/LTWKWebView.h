//
//  LTWKWebView.h
//  UniversalApp
//
//  Created by lihuanyu on 2018/12/21.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LTWKWebViewDelegate <WKUIDelegate, WKNavigationDelegate>

@optional


@end

@interface LTWKWebView : WKWebView

/**  代理  */
@property(nonatomic, weak) id<LTWKWebViewDelegate> delegate;
/**  首页URL  */
@property (nonatomic, copy) NSString *homeURL;
/**  当前显示的URL  */
@property (nonatomic, readonly) NSString *currentURL;
/**  进度条  */
@property (nonatomic, weak) UIProgressView *progressView;
/**  进展池  */
@property (nonatomic, strong) WKProcessPool *processPool;
/** JavaScriptMethodName */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *jsMethodsDictionary;
/**  cookie字典  */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *cookieDictionary;

@end

NS_ASSUME_NONNULL_END
