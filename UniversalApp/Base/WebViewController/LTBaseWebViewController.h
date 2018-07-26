//
//  LTBaseWebViewController.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/22.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//  此控制器仅适用加载网络h5页面,不适用本地h5

#import <UIKit/UIKit.h>
@import WebKit;

@interface LTBaseWebViewController : UIViewController

/**  滚动视图  */
@property (nonatomic, weak) UIScrollView *scrollView;
/**  内容视图  */
@property (nonatomic, weak) UIView *contentView;
/**  webView  */
@property(nonatomic, weak) WKWebView *webView;
/**  进度条  */
@property (nonatomic, weak) UIProgressView *progressView;
/**  进展池  */
@property (nonatomic, strong) WKProcessPool *processPool;
/**  当前显示的URL  */
@property (nonatomic, copy) NSString *currentURL;
/**  当前web的title  */
@property (nonatomic, copy) NSString *webTitle;
/** JavaScriptMethodName */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *jsMethodsDictionary;
/**  cookie字典  */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *cookieDictionary;


/**  首页URL,如果是请求链接,可带baseURL,也可不带  */
@property (nonatomic, copy) NSString *homeURL;
/**  h5的全路径  */
- (NSString *)HTML5FullPath;
/**  设置导航栏按钮,默认什么都不干  */
- (void)setupNavigationBarButtonItem;
/**  添加js方法到数组中  */
- (void)addJavaScriptMethod;
/**  添加cookie  */
- (void)addCookie;

@end
