//
//  UIApplication+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/5.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UIApplication+LTAdd.h"
@import SafariServices;

@implementation UIApplication (LTAdd)

+ (void)lt_openSafari:(NSString *)url
{
    NSURL *trueUrl = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:trueUrl];
}
+ (void)lt_openSafariInApplication:(NSString *)url API_AVAILABLE(ios(9.0))
{
    NSURL *trueUrl = [NSURL URLWithString:url];
    SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:trueUrl];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:safariViewController animated:YES completion:nil];
}

@end
