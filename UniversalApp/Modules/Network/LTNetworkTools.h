//
//  LTNetworkTools.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LTNetworkTools, LTConnectPort;
extern LTNetworkTools *LTNetworkToolsInstance;

@interface LTNetworkTools : NSObject

/**  当前连接url对象  */
@property (nonatomic, strong) LTConnectPort *connectPort;

/**  拼接URL路径  */
+ (NSString *)URL:(NSString *)urlString;
/**  拼接H5 URL路径  */
+ (NSString *)HTML5URL:(NSString *)urlString;
/**  拼接图片 URL路径  */
+ (NSURL *)imageURL:(NSString *)urlString;
/**  手动设置网络跟H5的baseURL  */
+ (void)DIYBaseURL:(NSString *)baseURL H5BaseURL:(NSString *)H5BaseURL;

/**  网络库配置,必须调用  */
+ (void)configureNetwork;
/**  网络是否可用  */
+ (BOOL)isNetworkReachable;
/**  处理无网络事件  */
+ (void)handleNetWorkCannotAccessEvent;
/**  处理有网络事件  */
+ (void)handleNetWorAccessEvent;

@end


@interface LTConnectPort : NSObject

/**  中文名字  */
@property (nonatomic, copy) NSString *name;
/**  网络请求 baseURL  */
@property (nonatomic, copy) NSString *requestBaseURL;
/**  网页 H5 baseURL  */
@property (nonatomic, copy) NSString *webBaseURL;
/**  资源（如：图片等） baseURL  */
@property (nonatomic, copy) NSString *resourceBaseURL;

@end

#pragma mark - 网络通知
//无法访问网络
extern NSString * const LTNetWorkCannotAccessNotification;
//网络切换到WiFi
extern NSString * const LTNetWorkChangedToWiFiNotification;
//网络切换到移动网络
extern NSString * const LTNetWorkChangedToWWANNotification;
