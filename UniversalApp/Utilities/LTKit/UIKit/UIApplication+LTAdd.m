//
//  UIApplication+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/5.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UIApplication+LTAdd.h"
#import "UIWindow+LTAdd.h"
@import SafariServices;
@import MessageUI;

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

+ (void)lt_openApplicationSettings
{
    NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingURL])
    {
        if (@available(iOS 10.0, *)) // iOS 10 以后必须得有申请过一个权限才能打开app设置,不然打开的是系统设置
        {
            [[UIApplication sharedApplication] openURL:settingURL options:@{} completionHandler:nil];
        }
        else
        {
            [[UIApplication sharedApplication] openURL:settingURL];
        }
    }
}

+ (void)lt_openMessageWithPhoneNumber:(NSString *)phoneNumber
                              content:(NSString *)content
{
    MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
    //设置短信内容
    vc.body = content;
    //设置收件人列表
    //vc.recipients = @[@"10010",@"10086"];
    //设置代理
    vc.messageComposeDelegate = [UIApplication sharedApplication];
    //显示控制器
    [kCurrentViewController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

+ (void)lt_openQQ
{
    if ([self lt_isQQInstalled])
    {
        [self lt_openURL:[self lt_QQURL]];
    }
}
+ (void)lt_openWeixin
{
    if ([self lt_isWeixinInstalled])
    {
        [self lt_openURL:[self lt_WeixinURL]];
    }
}
+ (void)lt_openWeibo
{
    if ([self lt_isWeiboInstalled])
    {
        [self lt_openURL:[self lt_WeiboURL]];
    }
}

+ (BOOL)lt_isQQInstalled
{
    return [self lt_canOpen:[self lt_QQURL]];
}
+ (BOOL)lt_isWeixinInstalled
{
    return [self lt_canOpen:[self lt_WeixinURL]];
}
+ (BOOL)lt_isWeiboInstalled
{
    return [self lt_canOpen:[self lt_WeiboURL]];
}
+ (BOOL)lt_isMessageInstalled
{
    return [self lt_canOpen:[self lt_messageURL]];
}

+ (NSString *)lt_QQURL
{
    return @"mqqapi://";
}

+ (NSString *)lt_WeixinURL
{
    return @"weixin://";
}

+ (NSString *)lt_WeiboURL
{
    return @"weibosdk://request";
}

+ (NSString *)lt_messageURL
{
    return @"sms://";
}

+ (void)lt_openURL:(NSString*)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
+ (BOOL)lt_canOpen:(NSString*)url
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
}


@end

/*
 在info.plist中添加一下常用的常用的白名单:
 qq登录绑定，qq支付，qq分享
 微信支付，微信登录绑定
 新浪登录绑定
 支付宝支付，支付宝登录绑定
 
 <key>LSApplicationQueriesSchemes</key>
 <array>
 <string>mqqOpensdkSSoLogin</string>
 <string>mqzone</string>
 <string>sinaweibo</string>
 <string>alipayauth</string>
 <string>alipay</string>
 <string>safepay</string>
 <string>mqq</string>
 <string>mqqapi</string>
 <string>mqqopensdkapiV3</string>
 <string>mqqopensdkapiV2</string>
 <string>mqqapiwallet</string>
 <string>mqqwpa</string>
 <string>mqqbrowser</string>
 <string>wtloginmqq2</string>
 <string>weixin</string>
 <string>wechat</string>
 </array>
 */

