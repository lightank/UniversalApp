//
//  AppDelegate+UMengAnalytics.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/2.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

/*
 使用cocoapods集成
 # UMeng Analytics iOS SDK Begin .......
 #依赖库
 pod 'UMCCommon'
 pod 'UMCSecurityPlugins'
 #统计 SDK
 pod 'UMCAnalytics'
 # UMeng Analytics iOS SDK End .......
 */

#import "AppDelegate+UMengAnalytics.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>

@implementation AppDelegate (UMengAnalytics)

- (void)initializeUMengAnalytics
{
    [UMConfigure initWithAppkey:@"appkey" channel:@"App Store"];
    
    //开启崩溃日志收集
    [MobClick setCrashReportEnabled:YES];
#if DEBUG
    [UMConfigure setLogEnabled:YES];
#endif
}

@end
