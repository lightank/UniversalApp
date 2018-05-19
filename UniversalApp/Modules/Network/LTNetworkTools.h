//
//  LTNetworkTools.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LTNetworkTools;
extern LTNetworkTools *LTNetworkToolsInstance;

@interface LTNetworkTools : NSObject

/**  拼接URL路径  */
+ (NSString *)URL:(NSString *)urlString;
/**  拼接H5 URL路径  */
+ (NSString *)HTML5URL:(NSString *)urlString;
/**  拼接图片 URL路径  */
+ (NSURL *)imageURL:(NSString *)urlString;
/**  手动设置网络跟H5的baseURL  */
+ (void)DIYBaseURL:(NSString *)baseURL H5BaseURL:(NSString *)H5BaseURL;

/**  网络库配置  */
+ (void)configureNetwork;
/**  网络是否可用  */
+ (BOOL)isNetworkReachable;

@end

#pragma mark - 网络通知
//无法访问网络
extern NSString * const LTNetWorkCannotAccessNotification;
//网络切换到WiFi
extern NSString * const LTNetWorkChangedToWiFiNotification;
//网络切换到移动网络
extern NSString * const LTNetWorkChangedToWWANNotification;
