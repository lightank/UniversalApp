//
//  LTBaseWebViewController.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/22.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTBaseWebViewController.h"
#import "LTDeviceInfo.h"
#import "LTNetworkTools.h"

typedef NSString * LTObserverKey;
static LTObserverKey const kEstimatedProgressKey = @"estimatedProgress";
static LTObserverKey const kTitleKey = @"title";
static LTObserverKey const kContentSize = @"contentSize";

@interface LTBaseWebViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, UIScrollViewDelegate>

@end

@implementation LTBaseWebViewController

#pragma mark - 构造器
- (instancetype)init
{
    self = [super init];
    if (self) {
        _jsMethodsDictionary = [[NSMutableDictionary alloc] init];
        _cookieDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - 生命周期
- (void)loadView
{
    [super loadView];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:kKeyWindow.bounds];
    _scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:kKeyWindow.bounds];
    _contentView = contentView;
    self.contentView.backgroundColor = UIColorHex(F4F5F6);
    [scrollView addSubview:contentView];
    
    self.navigationController.navigationBar.tintColor = UIColorHex(050505);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];
    //加载HTML
    [self loadHomeURL];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 移除js
    if (_webView)
    {
        [self webViewRemoveJavaScriptMethod:_webView];
        [self webViewRemoveAllUserScripts:_webView];
    }
    // 移除kvo
    [self removeObserverWebView];
    
    [self.progressView removeFromSuperview];
}

#pragma mark - NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == LTObserverWebViewContext)
    {
        if (object == self.webView)
        {
            if ([keyPath isEqualToString:kEstimatedProgressKey])
            {
                [self.progressView setAlpha:1.0f];
                [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
                
                if (self.webView.estimatedProgress >= 1.0f)
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
                self.webTitle = self.webView.title;
                return;
            }
        }
        else if (object == self.webView.scrollView)
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

#pragma mark - UI处理
- (void)setupUI
{
    [self setupWebView];
    [self setupProgressView];
    [self setupNavigationBarButtonItem];
}
/**  上下文  */
static void *LTObserverWebViewContext = &LTObserverWebViewContext;
- (void)setupWebView
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.processPool = self.processPool;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    webView.frame = self.contentView.bounds;
    webView.height = [self contentViewHeight];
    if (@available(iOS 9, *))
    {
        self.webView.allowsLinkPreview = YES; //允许链接3D Touch
        //self.webView.customUserAgent = @"MOLWebView/1.0.0"; //自定义UA
    }
    self.webView = webView;
    
    // 添加js方法
    [self addJavaScriptMethod];
    [self webViewAddJavaScriptMethod:webView];
    
    // 添加cookie
    [self addCookie];
    [self webViewAddCookie:webView];
    
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    //webView.scrollView.delegate = self;
    [self.contentView addSubview:webView];
    
    [webView.scrollView addHeaderRefreshTarget:self refreshingAction:@selector(reload)];
    
    
    //添加观察webView的进度与标题
    [webView addObserver:self forKeyPath:kEstimatedProgressKey options:NSKeyValueObservingOptionNew context:LTObserverWebViewContext];
    [webView addObserver:self forKeyPath:kTitleKey options:NSKeyValueObservingOptionNew context:LTObserverWebViewContext];
    [webView.scrollView addObserver:self forKeyPath:kContentSize options:NSKeyValueObservingOptionNew context:LTObserverWebViewContext];
}

- (void)setupProgressView
{
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    self.progressView = progressView;
    [self.contentView addSubview:progressView];
    progressView.tintColor = [UIColor blueColor];
    progressView.trackTintColor = [UIColor whiteColor];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(3.f);
    }];
}

- (CGFloat)contentViewHeight
{
    CGFloat height = self.navigationController.navigationBar.isHidden ? kStatusBarHeight : (kNavigationToTopHeight);
    return kScreenHeight - height;
}

- (void)setupNavigationBarButtonItem
{
    
}

#pragma mark - 事件处理
- (void)loadHomeURL
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.HTML5FullPath]];
//    [req setValue:@"0" forHTTPHeaderField:@"type"];
//    [req setValue:kAppStringPlaceholder forHTTPHeaderField:@"type"];
//    [req setValue:kAppStringPlaceholder forHTTPHeaderField:@"isH5"];
    NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    //Cookies数组转换为requestHeaderFields
    NSDictionary *requestHeaderFields = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    //设置请求头
    request.allHTTPHeaderFields = requestHeaderFields;
    [self.webView loadRequest:request];
}
/**  刷新页面  */
- (void)reload
{
    if (![LTNetworkTools isNetworkReachable])
    {
        [LTNetworkTools handleNetWorkCannotAccessEvent];
        [self.webView.scrollView endHeaderRefresh];
        return;
    }
    
    if (self.webView.URL)
    {
        [self.webView reload];
    }
    else
    {
        [self loadHomeURL];
    }
}

/**  移除监听WebView  */
- (void)removeObserverWebView
{
    //为了避免取消订阅时造成的crash，可以把取消订阅代码放在@try-@catch语句
    @try {
        if (!_webView) return;
        [_webView removeObserver:self forKeyPath:kEstimatedProgressKey context:LTObserverWebViewContext];
        [_webView removeObserver:self forKeyPath:kTitleKey context:LTObserverWebViewContext];
        [_webView.scrollView removeObserver:self forKeyPath:kContentSize context:LTObserverWebViewContext];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
#pragma mark - cookie相关
- (void)addCookie
{
    // 例如
    // self.cookieDictionary[@"name"] = @"value";
}

/**  此方法建议在开始加载页面(WKNavigationDelegate中的:webView:didStartProvisionalNavigation:方法)时及之前执行,建议在初始化webview的时候调用  */
- (void)webViewAddCookie:(WKWebView *)webView
{
    NSMutableString *cookies = @"".mutableCopy;
    [self.cookieDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *cookie = [NSString stringWithFormat:@"document.cookie = '%@=%@;';", key, obj];
        [cookies appendString:cookie];
    }];
    //NSLog(@"%@", cookies);
    //注入Cookie
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookies injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [webView.configuration.userContentController addUserScript:cookieScript];
}

- (void)getHTMLCookie
{
    [self.webView evaluateJavaScript:@"document.cookie" completionHandler:^(id _Nullable cookies, NSError * _Nullable error) {
        NSLog(@"调用evaluateJavaScript异步获取cookie：%@", cookies);
    }];
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
    [self.webView.scrollView endHeaderRefresh];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}
#pragma mark - WKScriptMessageHandler   接收JS消息
// 接收到JS发送消息时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    SEL sel = NSSelectorFromString(self.jsMethodsDictionary[message.name]);
    if (sel && [self respondsToSelector:sel])
    {
        SuppressPerformSelectorLeakWarning(
                                           [self performSelector:sel withObject:message];
                                           );
    }
}

#pragma mark - JS消息添加/移除与处理

- (void)addJavaScriptMethod
{
    // 例如
    //self.cookieDictionary[@"name"] = @"selectorName";
}

/**  此方法建议在开始加载页面(WKNavigationDelegate中的:webView:didStartProvisionalNavigation:方法)时及之前执行,建议在初始化webview的时候调用  */
- (void)webViewAddJavaScriptMethod:(WKWebView *)webView
{
    for (NSString *name in self.jsMethodsDictionary.allKeys)
    {
        /*
         在H5的JS中这样写代码调用:window.webkit.messageHandlers.<name>.postMessage(<要传的信息>);
         有调用addScriptMessageHandler就必须调用removeScriptMessageHandlerForName,不然会崩溃
         */
        [webView.configuration.userContentController addScriptMessageHandler:self name:name];
    }
}

/**  在控制器销毁的地方移除js  */
- (void)webViewRemoveJavaScriptMethod:(WKWebView *)webView
{
    for (NSString *name in self.jsMethodsDictionary.allKeys)
    {
        [webView.configuration.userContentController removeScriptMessageHandlerForName:name];
    }
}
/**  移除UserScripts  */
- (void)webViewRemoveAllUserScripts:(WKWebView *)webView
{
    [webView.configuration.userContentController removeAllUserScripts];
}

#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    //当前页面加载
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
// 9.0后可使用,关闭WKWebView
- (void)webViewDidClose:(WKWebView *)webView
{

}
// 警告框
// 对应js的Alert方法
/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"%@",message);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:webView.title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                completionHandler();
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:webView.title
                                                                   message:prompt
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = defaultText;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle: @"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                NSString *input = ((UITextField *)alert.textFields.firstObject).text;
                                                completionHandler(input);
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle: @"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {
                                                completionHandler(nil);
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:webView.title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                completionHandler(YES);
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                completionHandler(NO);
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - setter and getter
- (NSString *)currentURL
{
    return self.webView.URL.absoluteString;
}
- (WKProcessPool *)processPool
{
    return [LTBaseWebViewController sharedProcessPool];
}
- (void)setWebTitle:(NSString *)webTitle
{
    _webTitle = webTitle.copy;
    self.title = webTitle.copy;
}
- (NSString *)HTML5FullPath
{
    if (!self.homeURL)
    {
        NSLog(@"WebView加载了一个nil路径");
    }
    BOOL isFullPath = [self.homeURL.lowercaseString hasPrefix:@"http://"] || [self.homeURL.lowercaseString hasPrefix:@"https://"];
    NSString *fullPath = isFullPath ? self.homeURL : [LTNetworkTools HTML5URL:self.homeURL];
    return fullPath;
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
