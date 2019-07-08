//
//  LTSecondViewController.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/7/8.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTSecondViewController.h"
#import "LTWKWebView.h"

@interface LTSecondViewController () <LTWKWebViewDelegate>

@end

@implementation LTSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self loadLocalHTML:@"CustomProtocol" folderName:@""];
    LTWKWebView *webView = [[LTWKWebView alloc] init];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    webView.delegate = self;
    [webView loadLocalHTML:@"CustomProtocol" folderName:@""];
}

#pragma mark - LTWKWebViewDelegate
- (BOOL)webView:(LTWKWebView *)webView shouldLoadURL:(NSURL *)url
{
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
