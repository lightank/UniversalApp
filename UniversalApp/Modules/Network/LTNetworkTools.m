//
//  LTNetworkTools.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTNetworkTools.h"
#import <AFNetworking/AFNetworking.h>
#if __has_include(<YTKNetwork/YTKNetwork.h>)
#import <YTKNetwork/YTKNetwork.h>
#else
#import "YTKNetwork.h"
#endif

//0:生产 1:dev 2:sit 3:uat 4:开发人员1的名字
#if DEBUG
static BOOL kShowEnvironmentViewController = NO;
static NSInteger kDefaultNetworkType = 1;
#else
static BOOL kShowEnvironmentViewController = NO;
static NSInteger kDefaultNetworkType = 0;
#endif

LTNetworkTools *LTNetworkToolsInstance = nil;

@interface LTNetworkTools ()

/**  环境数组  */
@property (nonatomic, strong) NSArray<LTConnectPort *> *environmentArray;
/**  环境数组中下标  */
@property (nonatomic, assign) NSUInteger environmentType;

@end

@implementation LTNetworkTools

+ (void)initialize
{
    if (self == [LTNetworkTools class])
    {
        [self sharedInstance];
    }
}

/**  拼接URL路径  */
+ (NSString *)URL:(NSString *)urlString
{
    return [NSURL URLWithString:urlString relativeToURL:[NSURL URLWithString:LTNetworkToolsInstance.connectPort.requestBaseURL]].absoluteString;
}

/**  拼接H5 URL路径  */
+ (NSString *)HTML5URL:(NSString *)urlString
{
    return [NSURL URLWithString:urlString relativeToURL:[NSURL URLWithString:LTNetworkToolsInstance.connectPort.webBaseURL]].absoluteString;
}
/**  拼接图片 URL路径  */
+ (NSURL *)imageURL:(NSString *)urlString
{
    return [NSURL URLWithString:urlString relativeToURL:[NSURL URLWithString:LTNetworkToolsInstance.connectPort.resourceBaseURL]];
}
#pragma mark - 网络监听
/**  网络库配置  */
+ (void)configureNetwork
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
 #if DEBUG
        //是否展示环境选择器
        if (kShowEnvironmentViewController)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showNetworkOption];
            });
        }
 #endif
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    });
}

/**  显示网络显示选项  */
+ (void)showNetworkOption
{
    [kCurrentViewController presentViewController:[self alertControllerForNetwork] animated:YES completion:^{
        
    }];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self addNetworkWindowTapGesture];
    });
}

+ (void)addNetworkWindowTapGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(networkWindowTapGestureAction)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 3;
    [[UIApplication sharedApplication].keyWindow addGestureRecognizer:tap];
}

+ (void)networkWindowTapGestureAction
{
    if (![kCurrentViewController isKindOfClass:[UITapGestureRecognizer class]])
    {
        [kCurrentViewController presentViewController:[self alertControllerForNetwork] animated:YES completion:^{
            
        }];
    }
}

+ (UIAlertController *)alertControllerForNetwork
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSString *diyTitle = [NSString stringWithFormat:@"版本[%@]",[NSBundle mainBundle].infoDictionary[@"CFBundleVersion"]];
    UIAlertAction *diyAction = [UIAlertAction actionWithTitle:diyTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:diyAction];
    
    [LTNetworkToolsInstance.environmentArray enumerateObjectsUsingBlock:^(LTConnectPort * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *titleName = obj.name;
        titleName = titleName ? titleName : @"无名称，联系开发";
        UIAlertAction *action = [UIAlertAction actionWithTitle:titleName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSUInteger index = idx;
            LTNetworkToolsInstance.environmentType = index;
        }];
        [alertController addAction:action];
    }];
    return alertController;
}

/**  网络是否可用  */
+ (BOOL)isNetworkReachable
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
/**  监听网络状态改变  */
+ (void)monitorNetworkStatus
{
    AFNetworkReachabilityManager *networkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [networkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:LTNetWorkCannotAccessNotification object:nil];
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:LTNetWorkCannotAccessNotification object:nil];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:LTNetWorkChangedToWiFiNotification object:nil];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:LTNetWorkChangedToWWANNotification object:nil];
            }
                break;
        }
    }];
    
    [([NSNotificationCenter defaultCenter]) addObserver:self selector:@selector(handleNetWorkCannotAccessEvent) name:LTNetWorkCannotAccessNotification object:nil];
    [([NSNotificationCenter defaultCenter]) addObserver:self selector:@selector(handleNetWorAccessEvent) name:LTNetWorkChangedToWiFiNotification object:nil];
    [([NSNotificationCenter defaultCenter]) addObserver:self selector:@selector(handleNetWorAccessEvent) name:LTNetWorkChangedToWWANNotification object:nil];
}
/**  处理无网络事件  */
+ (void)handleNetWorkCannotAccessEvent
{
    
}
/**  处理有网络事件  */
+ (void)handleNetWorAccessEvent
{
    
}

/**  单例  */
+ (LTNetworkTools *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LTNetworkToolsInstance = [[LTNetworkTools alloc] init];
        LTNetworkToolsInstance.environmentType = kDefaultNetworkType;
    });
    return LTNetworkToolsInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        LTConnectPort *release = [[LTConnectPort alloc] init];
        release.name = @"生产环境";
        release.requestBaseURL = @"https://127.0.0.1/";
        release.webBaseURL = @"https://127.0.0.1/";
        release.resourceBaseURL = @"https://127.0.0.1/";
        
        LTConnectPort *dev = [[LTConnectPort alloc] init];
        dev.name = @"DEV开发环境";
        dev.requestBaseURL = @"https://127.0.0.2/";
        dev.webBaseURL = @"https://127.0.0.2/";
        dev.resourceBaseURL = @"https://127.0.0.2/";
        
        LTConnectPort *sit = [[LTConnectPort alloc] init];
        sit.name = @"SIT开发环境";
        sit.requestBaseURL = @"https://127.0.0.3/";
        sit.webBaseURL = @"https://127.0.0.3/";
        sit.resourceBaseURL = @"https://127.0.0.3/";
        
        LTConnectPort *uat = [[LTConnectPort alloc] init];
        uat.name = @"UAT预生产";
        uat.requestBaseURL = @"https://127.0.0.4/";
        uat.webBaseURL = @"https://127.0.0.4/";
        uat.resourceBaseURL = @"https://127.0.0.4/";
        
        LTConnectPort *javaer1 = [[LTConnectPort alloc] init];
        javaer1.name = @"开发人员1的名字";
        javaer1.requestBaseURL = @"https://127.0.0.5/";
        javaer1.webBaseURL = @"https://127.0.0.5/";
        javaer1.resourceBaseURL = @"https://127.0.0.5/";
        
        _environmentArray = @[
                              //0 第一个位置（也就是下标为0的位置）必须为生产环境，不可以为其他环境！
                              release,
                              dev,
                              sit,
                              uat,
                              javaer1,
                              ];
    }
    return self;
}

- (void)setEnvironmentType:(NSUInteger)environmentType
{
    _environmentType = environmentType;
    self.connectPort = self.environmentArray[environmentType];
}

#pragma mark - setter and getter
- (void)setConnectPort:(LTConnectPort *)connectPort
{
    _connectPort = connectPort;
    [YTKNetworkConfig sharedConfig].baseUrl = LTNetworkToolsInstance.connectPort.requestBaseURL;
}

@end


@implementation LTConnectPort


@end

//无法访问网络
NSString * const LTNetWorkCannotAccessNotification = @"LTNetWorkCannotAccessNotification";
//网络切换到WiFi
NSString * const LTNetWorkChangedToWiFiNotification = @"LTNetWorkChangedToWiFiNotification";
//网络切换到移动网络
NSString * const LTNetWorkChangedToWWANNotification = @"LTNetWorkChangedToWWANNotification";
