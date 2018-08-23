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

+ (void)lt_openApplicationSettings
{
    if (@available(iOS 10.0, *))
    {
        // iOS 10 以后必须得有申请过一个权限才能打开app设置,不然打开的是系统设置
        //UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        //[[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end
