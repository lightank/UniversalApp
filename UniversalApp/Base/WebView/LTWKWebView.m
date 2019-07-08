//
//  LTWKWebView.m
//  UniversalApp
//
//  Created by lihuanyu on 2018/12/21.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTWKWebView.h"

@interface LTJavaScripTarget : NSObject

@property(nonatomic, strong) id target;
@property (nonatomic, copy) NSString *JavaScriptMethod;
@property(nonatomic, copy) NSString *selector;

- (instancetype)initWithTarget:(id)target JavaScriptMethod:(NSString *)JavaScriptMethod selector:(NSString *)selector;

@end

@implementation LTJavaScripTarget

- (instancetype)initWithTarget:(id)target JavaScriptMethod:(NSString *)JavaScriptMethod selector:(NSString *)selector
{
    if (self = [super init])
    {
        _target = target;
        _JavaScriptMethod = JavaScriptMethod.copy;
        _selector = selector.copy;
    }
    return self;
}

@end

@interface LTProtocolTarget : NSObject

@property(nonatomic, strong) id target;
@property (nonatomic, copy) NSString *scheme;
@property (nonatomic, copy) NSString *host;
@property(nonatomic, copy) NSString *selector;
@property(nonatomic, copy, readonly) NSString *identifier;

- (instancetype)initWithTarget:(id)target scheme:(NSString *)scheme host:(NSString *)host selector:(NSString *)selector;

@end

@implementation LTProtocolTarget

- (instancetype)initWithTarget:(id)target scheme:(NSString *)scheme host:(NSString *)host selector:(NSString *)selector
{
    if (self = [super init])
    {
        _target = target;
        _scheme = scheme.copy;
        _host = scheme.copy;
        _selector = selector.copy;
    }
    return self;
}

- (NSString *)identifier
{
    return [NSString stringWithFormat:@"%@://%@", self.scheme, self.host];
}

@end

/**  上下文  */
static void *LTObserverWebViewContext = &LTObserverWebViewContext;
typedef NSString * LTObserverKey;
static LTObserverKey const kEstimatedProgressKey = @"estimatedProgress";
static LTObserverKey const kTitleKey = @"title";
static LTObserverKey const kContentSize = @"contentSize";

@interface LTWKWebView () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

/** JSCallbackHandlers */
@property (nonatomic, strong) NSMutableArray<LTJavaScripTarget *> *JSCallbackHandlers;
/**  JS回调对象字典  */
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *JSCallbackDictonary;
/**  JS回调对象字典  */
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *protocolHandleDictonary;

@end

@implementation LTWKWebView

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
    self = [super initWithFrame:frame configuration:configuration];
    if (self)
    {
        _useSharedProcessPool = YES;
        _JSCallbackDictonary = [[NSMutableDictionary alloc] init];
        _JSCallbackHandlers = [[NSMutableArray alloc] init];
        _cookieDictionary = [[NSMutableDictionary alloc] init];
        _protocolHandleDictonary = [[NSMutableDictionary alloc] init];
        
        if (@available(iOS 9, *))
        {
            self.allowsLinkPreview = YES; //允许链接3D Touch
            //self.webView.customUserAgent = @"MOLWebView/1.0.0"; //自定义UA
        }
        
        WKWebViewConfiguration *config = configuration ? : [[WKWebViewConfiguration alloc] init];
        config.processPool = self.processPool;
        
        // 添加js方法
        [self addJavaScriptMethod];
        
        //添加观察webView的进度与标题
        [self addObserver:self forKeyPath:kEstimatedProgressKey options:NSKeyValueObservingOptionNew context:LTObserverWebViewContext];
        [self addObserver:self forKeyPath:kTitleKey options:NSKeyValueObservingOptionNew context:LTObserverWebViewContext];
        [self.scrollView addObserver:self forKeyPath:kContentSize options:NSKeyValueObservingOptionNew context:LTObserverWebViewContext];
        
        
        self.navigationDelegate = self;
        self.UIDelegate = self;
    }
    return self;
}

- (instancetype)initWithHomeURL:(NSString *)url
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    if (self = [self initWithFrame:CGRectZero configuration:config])
    {
        _homeURL = url.copy;
    }
    return self;
}

- (void)loadLocalHTML:(NSString *)name folderName:(NSString *)folderName
{
    NSString *html = [NSString stringWithFormat:@"%@/%@", folderName, name];
    NSString *folder = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], folderName];
    NSURL *folderURL = [NSURL fileURLWithPath:folder isDirectory:YES];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:html ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:NULL];
    [self loadHTMLString:htmlString baseURL:folderURL];
}

- (void)addJavaScriptMethod
{
    // 例如
    
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self reloadWebView];
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeAllJS];
    // 移除kvo
    [self removeObserverWebView];
}

/**  移除监听WebView  */
- (void)removeObserverWebView
{
    //为了避免取消订阅时造成的crash，可以把取消订阅代码放在@try-@catch语句
    @try {
        [self removeObserver:self forKeyPath:kEstimatedProgressKey context:LTObserverWebViewContext];
        [self removeObserver:self forKeyPath:kTitleKey context:LTObserverWebViewContext];
        [self.scrollView removeObserver:self forKeyPath:kContentSize context:LTObserverWebViewContext];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

#pragma mark - 事件处理
- (void)loadHomeURL
{
    [self loadWithURL:self.homeURL];
}

- (void)loadWithURL:(NSString *)url
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //[request setValue:@"0" forHTTPHeaderField:@"type"];
    //[request setValue:kAppStringPlaceholder forHTTPHeaderField:@"type"];
    //[request setValue:kAppStringPlaceholder forHTTPHeaderField:@"isH5"];
    NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    //Cookies数组转换为requestHeaderFields
    NSDictionary *requestHeaderFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //设置请求头
    request.allHTTPHeaderFields = requestHeaderFields;
    [self loadRequest:request];
}

/**  刷新页面  */
- (void)reloadWebView
{
    if (self.URL)
    {
        [self reload];
    }
    else
    {
        [self loadHomeURL];
    }
}


- (void)getHTMLCookie
{
    [self evaluateJavaScript:@"document.cookie" completionHandler:^(id _Nullable cookies, NSError * _Nullable error) {
        NSLog(@"调用evaluateJavaScript异步获取cookie：%@", cookies);
    }];
}

#pragma mark - NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == LTObserverWebViewContext)
    {
        if (object == self)
        {
            if ([keyPath isEqualToString:kEstimatedProgressKey])
            {
                [self.progressView setAlpha:1.0f];
                [self.progressView setProgress:self.estimatedProgress animated:YES];
                
                if (self.estimatedProgress >= 1.0f)
                {
                    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        [self.progressView setAlpha:0.0f];
                    } completion:^(BOOL finished) {
                        [self.progressView setProgress:0.0f animated:NO];
                    }];
                }
                return;
            }
            else if ([keyPath isEqualToString:kTitleKey])
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(webView:titleDidChanged:)])
                {
                    [self.delegate webView:self titleDidChanged:self.title];
                }
                return;
            }
        }
        else if (object == self.scrollView)
        {
            if ([keyPath isEqualToString:kContentSize])
            {
                //跟document.body.scrollHeight的值一致
                //CGFloat height = self.webView.scrollView.contentSize.height;
                //                NSLog(@"%@", NSStringFromValue(height));
                return;
            }
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


#pragma mark - 自定义协议处理
//- (void)addTarget:(id)target protocolScheme:(NSString *)scheme host:(NSString *)host responseSelector:(SEL)selector
//{
//    if (target && scheme && host && selector)
//    {
//        /*
//         在H5的JS中这样写代码调用:window.webkit.messageHandlers.<name>.postMessage(<要传的信息>);
//         有调用addScriptMessageHandler就必须调用removeScriptMessageHandlerForName,不然会崩溃
//         */
//        LTProtocolTarget *protocolTarget = [[LTProtocolTarget alloc] initWithTarget:target scheme:scheme host:host selector:NSStringFromSelector(selector)];
//        self.protocolHandleDictonary[protocolTarget.identifier] = protocolTarget;
//    }
//}


#pragma mark - JS消息添加/移除与处理
/**  此方法建议在开始加载页面(WKNavigationDelegate中的:webView:didStartProvisionalNavigation:方法)时及之前执行,建议在初始化webview的时候调用  */
- (void)addTarget:(id)target JavaScriptMethod:(NSString *)JavaScriptMethod responseSelector:(SEL)selector
{
    if (target && JavaScriptMethod && selector)
    {
        /*
         在H5的JS中这样写代码调用:window.webkit.messageHandlers.<name>.postMessage(<要传的信息>);
         有调用addScriptMessageHandler就必须调用removeScriptMessageHandlerForName,不然会崩溃
         */
        LTJavaScripTarget *JavaScripTarget = [[LTJavaScripTarget alloc] initWithTarget:target JavaScriptMethod:JavaScriptMethod selector:NSStringFromSelector(selector)];
        [self.JSCallbackHandlers addObject:JavaScripTarget];
        self.JSCallbackDictonary[JavaScriptMethod] = JavaScripTarget;
        [self.configuration.userContentController addScriptMessageHandler:self name:NSStringFromSelector(selector)];
    }
}

- (void)removeAllJS
{
    [self removeJavaScriptMethod];
    [self removeAllUserScripts];
}

/**  在控制器销毁的地方移除js  */
- (void)removeJavaScriptMethod
{
    for (NSString *name in self.JSCallbackDictonary.allKeys)
    {
        [self.configuration.userContentController removeScriptMessageHandlerForName:name];
    }
}
/**  移除UserScripts  */
- (void)removeAllUserScripts
{
    [self.configuration.userContentController removeAllUserScripts];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark - WKNavigationDelegate
#pragma mark - --导航监听--
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //请求的链接
    //NSString *urlString = navigationAction.request.URL.absoluteString;
    //WKNavigationType type = navigationAction.navigationType;
    NSURL *url = navigationAction.request.URL;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:shouldLoadURL:)])
    {
        BOOL shouldLoad = [self.delegate webView:self shouldLoadURL:url];
        WKNavigationActionPolicy navigationActionPolicy = shouldLoad ? WKNavigationActionPolicyAllow : WKNavigationActionPolicyCancel;
        decisionHandler(navigationActionPolicy);
        return;
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    if ([url.scheme isEqualToString:@"tel"] && [app canOpenURL:url])
    {
        [app openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    else if ([url.absoluteString containsString:@"itunes.apple.com"] && [app canOpenURL:url])
    {
        [app openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}

// 对于HTTPS的都会触发此代理，如果不要求验证，传默认就行
// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(nonnull NSURLAuthenticationChallenge *)challenge completionHandler:(nonnull void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    //    NSLog(@"%s", __FUNCTION__);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    if (/* DISABLES CODE */ (0))
    {
        // 1.从服务器返回的受保护空间中拿到证书的类型
        // 2.判断服务器返回的证书是否是服务器信任的
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            NSLog(@"是服务器信任的证书");
            // 3.根据服务器返回的受保护空间创建一个证书
            // void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *)
            // 代理方法的completionHandler block接收两个参数:
            // 第一个参数: 代表如何处理证书
            // 第二个参数: 代表需要处理哪个证书
            //创建证书
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            // 4.安装证书
            completionHandler(NSURLSessionAuthChallengeUseCredential , credential);
        }
    }
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    //    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    
}
//WKNavigation导航错误之后调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
}
// 9.0才能使用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    // 出现白屏就刷新
    [webView reload];
}
#pragma mark - --网页监听--
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //可以在页面加载完成后发送消息给JS
    // 通知 h5 是 app登录
    //    [webView evaluateJavaScript:@"fromApp()" completionHandler:nil];
    //    [webView evaluateJavaScript:@"fromIOSApp()" completionHandler:nil];
    //[self.webView.scrollView lt_endHeaderRefresh];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(webView:didReceiveJavaScriptMethod:)])
    {
        [self.delegate webView:self didReceiveJavaScriptMethod:message];
    }
}

#pragma mark - setter and getter
- (NSString *)currentURL
{
    return self.URL.absoluteString;
}

- (WKProcessPool *)processPool
{
    if (!_processPool)
    {
        _processPool = self.isUseSharedProcessPool ? [self.class sharedProcessPool] : [[WKProcessPool alloc] init];
    }
    return _processPool;
}

+ (WKProcessPool *)sharedProcessPool
{
    static WKProcessPool *processPool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        processPool = [[WKProcessPool alloc] init];
    });
    return processPool;
}


@end
