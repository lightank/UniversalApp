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
    }
    return self;
}

#pragma mark - 生命周期
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
    if (!IOS11_OR_LATER)
    {
        [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(self.navigationController.navigationBar.hidden ? 0 : kNavigationToTopHeight);
        }];
    }
}

- (void)dealloc
{
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 移除js
    if (_webView)
    {
        [self webViewRemoveJavaScriptMethod:_webView];
    }
    // 移除kvo
    [self removeObserverWebView];
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
    
    WKUserScript *cookieInScript = [[WKUserScript alloc] initWithSource:[self getSetCookieJSCodeForceOverride:YES] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [config.userContentController addUserScript:cookieInScript];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.webView = webView;
    
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    //    webView.scrollView.delegate = self;
    
    [self.view addSubview:webView];
    
    [webView.scrollView addHeaderRefreshTarget:self refreshingAction:@selector(reload)];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        BOOL ios11 = IOS11_OR_LATER;
        //        if (IOS11_OR_LATER)
        //        {
        //            IF_IOS_11(
        //                      make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        //                      make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        //                      make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        //                      make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        //                      );
        //        }
        //        else
        //        {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        //        }
        
    }];
    
    
    //添加观察webView的进度与标题
    [webView addObserver:self forKeyPath:kEstimatedProgressKey options:NSKeyValueObservingOptionNew context:LTObserverWebViewContext];
    [webView addObserver:self forKeyPath:kTitleKey options:NSKeyValueObservingOptionNew context:LTObserverWebViewContext];
    [webView.scrollView addObserver:self forKeyPath:kContentSize options:NSKeyValueObservingOptionNew context:LTObserverWebViewContext];
}

- (void)setupProgressView
{
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    self.progressView = progressView;
    [self.view addSubview:progressView];
    progressView.tintColor = [UIColor blueColor];
    progressView.trackTintColor = [UIColor whiteColor];
    [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.webView);
        if (IOS11_OR_LATER)
        {
            if (@available(iOS 11.0, *))
            {
                make.top.equalTo(self.webView.mas_safeAreaLayoutGuideTop);
            }
        }
        else
        {
            make.top.equalTo(self.view).offset(self.navigationController.navigationBarHidden ? 0 : kNavigationToTopHeight);
        }
        make.height.equalTo(3.f);
    }];
}

- (void)setupNavigationBarButtonItem
{
    
}

#pragma mark - 事件处理
- (void)loadHomeURL
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.HTML5FullPath]];
    [req setValue:@"0" forHTTPHeaderField:@"type"];
    [req setValue:kAppStringPlaceholder forHTTPHeaderField:@"type"];
    [req setValue:kAppStringPlaceholder forHTTPHeaderField:@"isH5"];
    [self.webView loadRequest:req];
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

/**  检测是否开启pop手势  */
- (void)checkPopGesture
{
    
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
- (NSString *)getSetCookieJSCodeForceOverride:(BOOL)forceOverride {
    
    //取出cookie
    //js函数,如果需要比较，不进行强制覆盖cookie，使用注释掉的js函数
    NSString *JSFuncString;
    if (forceOverride)
    {
        JSFuncString = @"";
    }
    else
    {
        JSFuncString =
        @"\
        \n var cookieNames = document.cookie.split('; ').map(function(cookie) {\
        \n     return cookie.split('=')[0] \
        \n });\
        \n";
    }
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    //拼凑js字符串
    NSMutableString *JSCode = [JSFuncString mutableCopy];
    for (NSHTTPCookie *cookie in cookies)
    {
        NSMutableString *string = [NSMutableString stringWithFormat:@"%@=%@;domain=%@;path=%@",
                                   cookie.name,
                                   cookie.value,
                                   cookie.domain,
                                   cookie.path ?: @"/"];
        
        if (cookie.secure)
        {
            [string appendString:@";secure=true"];
        }
        
        NSString *setCookieString = nil;
        if (forceOverride)
        {
            setCookieString = [NSString stringWithFormat:
                               @"\
                               \n document.cookie='%@';\
                               \n", string];
        }
        else
        {
            setCookieString = [NSString stringWithFormat:
                               @"\
                               \n if (cookieNames.indexOf('%@') == -1) {\
                               \n     document.cookie='%@';\
                               \n };\
                               \n", cookie.name, string];
        }
        [JSCode appendString:setCookieString];
    }
    
    return JSCode;
}

- (void)getHTMLCookie
{
    [self.webView evaluateJavaScript:@"document.cookie" completionHandler:^(id _Nullable cookies, NSError * _Nullable error) {
        NSLog(@"调用evaluateJavaScript异步获取cookie：%@", cookies);
    }];
}

- (void)resetCookieForceOverride:(BOOL)forceOverride
{
    [self.webView evaluateJavaScript:[self getSetCookieJSCodeForceOverride:forceOverride] completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        if(error)
        {
            NSLog(@"Cookie注入失败： %@",error);
        }
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
    //    NSString *urlString = navigationAction.request.URL.absoluteString;
    //    WKNavigationType type = navigationAction.navigationType;
    
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
    
    [self checkPopGesture];
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
    [self checkPopGesture];
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
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
//{
//
//}
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
    [webView evaluateJavaScript:@"fromApp()" completionHandler:nil];
    [webView evaluateJavaScript:@"fromIOSApp()" completionHandler:nil];
    
    [self checkPopGesture];
    
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
/**  此方法建议在开始加载页面(WKNavigationDelegate中的:webView:didStartProvisionalNavigation:方法)时及之前执行,建议在初始化webview的时候调用  */
- (void)webViewAddJavaScriptMethod:(WKWebView *)webView
{
    [self.jsMethodsDictionary addEntriesFromDictionary:@{
                                                         @"testJSToOC" : @"testJSToOC:",
                                                         }];
    
    for (NSString *name in self.jsMethodsDictionary.allKeys)
    {
        /*
         在H5的JS中这样写代码调用:window.webkit.messageHandlers.<name>.postMessage(<要传的信息>);
         有调用addScriptMessageHandler就必须调用removeScriptMessageHandlerForName,不然会
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

- (void)testJSToOC:(WKScriptMessage *)message
{
    
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
//// 9.0后可使用,关闭WKWebView
//- (void)webViewDidClose:(WKWebView *)webView
//{
//
//}
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
