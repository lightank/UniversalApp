//
//  LTBaseLocalHTMLWebViewController.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/24.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTBaseLocalHTMLWebViewController.h"

@interface LTBaseLocalHTMLWebViewController () <WKNavigationDelegate, WKScriptMessageHandler>

/**  webView  */
@property(nonatomic, strong) WKWebView *webView;
/**  webView是否已经加载完成  */
@property (nonatomic, assign, getter=isWebViewLoaded) BOOL webViewLoaded;
/** JavaScriptMethod Name and sel */
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *jsMethodsDictionary;

@end

@implementation LTBaseLocalHTMLWebViewController

- (void)loadLocalHTML:(NSString *)name folderName:(NSString *)folderName
{
    NSString *html = [NSString stringWithFormat:@"%@/%@", folderName, name];
    NSString *folder = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], folderName];
    NSURL *folderURL = [NSURL fileURLWithPath:folder isDirectory:YES];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:html ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:NULL];
    [self.webView loadHTMLString:htmlString baseURL:folderURL];
}

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = self.view.bounds;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void)dealloc
{
    // 移除js
    if (_webView)
    {
        [self webViewRemoveJavaScriptMethod:_webView];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    //[self webViewAddJavaScriptMethod:webView];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    self.webViewLoaded = YES;
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    SEL sel = NSSelectorFromString(self.jsMethodsDictionary[message.name]);
    if (sel && [self respondsToSelector:sel])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:sel withObject:message];
#pragma clang diagnostic pop
    }
}

#pragma mark - JS消息添加与处理
/**  此方法建议在开始加载页面(WKNavigationDelegate中的:webView:didStartProvisionalNavigation:方法)时及之前执行,建议在初始化webview的时候调用  */
- (void)webViewAddJavaScriptMethod:(WKWebView *)webView
{
    [self.jsMethodsDictionary addEntriesFromDictionary:@{
                                                         // key: name, value:sel
                                                         @"testJSToOC" : @"testJSToOC:",
                                                         }];
    
    for (NSString *name in self.jsMethodsDictionary.allKeys)
    {
        /*
         在H5的JS中这样写代码调用:window.webkit.messageHandlers.<name>.postMessage(<要传的信息>);
         有调用addScriptMessageHandler就必须调用removeScriptMessageHandlerForName
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

#pragma mark - setter and getter
- (WKWebView *)webView
{
    if (!_webView)
    {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _webView.navigationDelegate = self;
        // 添加js方法
        [self webViewAddJavaScriptMethod:_webView];
    }
    return _webView;
}

- (NSMutableDictionary<NSString *,NSString *> *)jsMethodsDictionary
{
    if (!_jsMethodsDictionary)
    {
        _jsMethodsDictionary = [[NSMutableDictionary alloc] init];
    }
    return _jsMethodsDictionary;
}

@end
