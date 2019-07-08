//
//  LTWKWebView.h
//  UniversalApp
//
//  Created by lihuanyu on 2018/12/21.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <WebKit/WebKit.h>
@class LTWKWebView;

NS_ASSUME_NONNULL_BEGIN

@protocol LTWKWebViewDelegate <WKUIDelegate, WKNavigationDelegate>

@optional
- (BOOL)webView:(LTWKWebView *)webView shouldLoadURL:(NSURL *)url;
/**  接收到JS传过来的消息  */
- (void)webView:(LTWKWebView *)webView didReceiveJavaScriptMethod:(WKScriptMessage *)message;

- (void)webView:(LTWKWebView *)webView titleDidChanged:(NSString *)title;

@end

@interface LTWKWebView : WKWebView

/**  代理  */
@property(nonatomic, weak) id<LTWKWebViewDelegate> delegate;
/**  是否使用公共进展池,默认是YES  */
@property (nonatomic, assign, getter=isUseSharedProcessPool) BOOL useSharedProcessPool;
/**  首页URL  */
@property (nonatomic, copy) NSString *homeURL;
/**  当前显示的URL  */
@property (nonatomic, readonly) NSString *currentURL;
/**  当前web的title  */
@property (nonatomic, copy) NSString *currentTitle;
/**  进度条  */
@property (nonatomic, weak) UIProgressView *progressView;
/**  进展池  */
@property (nonatomic, strong) WKProcessPool *processPool;
/**  cookie字典  */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *cookieDictionary;
/**  公共进展池  */
@property (nonatomic, readonly, class) WKProcessPool *sharedProcessPool;

- (instancetype)initWithHomeURL:(NSString *)url;

/**
 加载本地html文件,拖资源文件到xcode里的时候,请选择:Copy items if needed , Create folder references,这样导进来的文件是有文件目录的,html文件里引用js:./,如果是:/,是不能正确加载js的,可以用Safari浏览器测试一下,确认能正确加载js/css资源
 
 @param name 文件名,不包含html后缀
 @param folderName html所在文件夹名字
 */
- (void)loadLocalHTML:(NSString *)name folderName:(NSString *)folderName;

@end

NS_ASSUME_NONNULL_END
