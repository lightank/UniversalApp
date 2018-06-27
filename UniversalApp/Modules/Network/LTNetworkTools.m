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
static BOOL showEnvironmentViewController = NO;
static NSInteger NetworkType = 1;
#else
static BOOL showEnvironmentViewController = NO;
static NSInteger NetworkType = 0;
#endif

static NSString *const kConnectPortName = @"name";
static NSString *const kConnectPortBaseURL = @"base_url_path";
static NSString *const kConnectPortBaseURLH5 = @"base_url_path_h5";
static NSString *const kConnectPortBaseURLImage = @"base_url_path_image";

LTNetworkTools *LTNetworkToolsInstance = nil;

@interface LTNetworkTools ()

/**  环境数组  */
@property (nonatomic, strong) NSArray<NSDictionary *> *environmentArray;
/**  环境数组中下标  */
@property (nonatomic, assign) NSUInteger environmentType;
/**  域名  */
@property (nonatomic, copy) NSString *baseURL;
/**  H5页面baseURL  */
@property (nonatomic, copy) NSString *H5BaseURL;
/**  图片的baseURL  */
@property (nonatomic, copy) NSString *imageBaseURL;

@end

@implementation LTNetworkTools

/**  拼接URL路径  */
+ (NSString *)URL:(NSString *)urlString
{
    return [NSURL URLWithString:urlString relativeToURL:[NSURL URLWithString:LTNetworkToolsInstance.baseURL]].absoluteString;
}

/**  拼接H5 URL路径  */
+ (NSString *)HTML5URL:(NSString *)urlString
{
    return [NSURL URLWithString:urlString relativeToURL:[NSURL URLWithString:LTNetworkToolsInstance.H5BaseURL]].absoluteString;
}
/**  拼接图片 URL路径  */
+ (NSURL *)imageURL:(NSString *)urlString
{
    return [NSURL URLWithString:urlString relativeToURL:[NSURL URLWithString:LTNetworkToolsInstance.H5BaseURL]];
}
#pragma mark - 网络监听
/**  网络库配置  */
+ (void)configureNetwork
{
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [LTNetworkTools sharedInstance];
        });
    }

#if DEBUG
    //是否展示环境选择器
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (showEnvironmentViewController)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showNetworkOption];
            });
        }
    });
#endif
}

+ (void)configureNetworkBaseURL
{
    [YTKNetworkConfig sharedConfig].baseUrl = LTNetworkToolsInstance.baseURL;
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
    
    [LTNetworkToolsInstance.environmentArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *titleName = obj[kConnectPortName];
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

/**  手动设置网络跟H5的baseURL  */
+ (void)DIYBaseURL:(NSString *)baseURL H5BaseURL:(NSString *)H5BaseURL
{
    LTNetworkToolsInstance.baseURL = baseURL;
    LTNetworkToolsInstance.H5BaseURL = H5BaseURL;
}

/**  单例  */
+ (LTNetworkTools *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LTNetworkToolsInstance = [[LTNetworkTools alloc] init];
        LTNetworkToolsInstance.environmentType = NetworkType;
    });
    return LTNetworkToolsInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _environmentArray = @[
                              @{//0 第一个位置（也就是下标为0的位置）必须为生产环境，不可以为其他环境！
                                  kConnectPortName : @"生产环境",
                                  kConnectPortBaseURL : @"https://127.0.0.1/",
                                  kConnectPortBaseURLH5   : @"https://127.0.0.1/",
                                  kConnectPortBaseURLImage : @"https://127.0.0.1/",
                                  },
                              @{//1
                                  kConnectPortName    : @"DEV开发环境",
                                  kConnectPortBaseURL : @"http://127.0.0.2/",
                                  kConnectPortBaseURLH5   : @"http://127.0.0.2/",
                                  kConnectPortBaseURLImage : @"https://127.0.0.2/",
                                  },
                              @{//2
                                  kConnectPortName    : @"SIT开发环境",
                                  kConnectPortBaseURL : @"https://127.0.0.3/",
                                  kConnectPortBaseURLH5   : @"https://127.0.0.3/",
                                  kConnectPortBaseURLImage : @"https://127.0.0.3/",
                                  },
                              @{//3
                                  kConnectPortName    : @"UAT预生产",
                                  kConnectPortBaseURL : @"https://127.0.0.4/",
                                  kConnectPortBaseURLH5   : @"https://127.0.0.4/",
                                  kConnectPortBaseURLImage : @"https://127.0.0.4/",
                                  },
                              @{//4
                                  kConnectPortName    : @"开发人员1的名字",
                                  kConnectPortBaseURL : @"http://127.0.0.5",
                                  kConnectPortBaseURLH5   : @"https://127.0.0.5/",
                                  kConnectPortBaseURLImage : @"https://127.0.0.5/",
                                  },
                              ];
    }
    return self;
}

- (void)setEnvironmentType:(NSUInteger)environmentType
{
    _environmentType = environmentType;
    NSDictionary *dict = [self.environmentArray objectAtIndex:environmentType];
    self.baseURL = dict[kConnectPortBaseURL];
    self.H5BaseURL = dict[kConnectPortBaseURLH5];
    self.imageBaseURL = dict[kConnectPortBaseURLImage];
    [LTNetworkTools configureNetworkBaseURL];
}

@end

//无法访问网络
NSString * const LTNetWorkCannotAccessNotification = @"LTNetWorkCannotAccessNotification";
//网络切换到WiFi
NSString * const LTNetWorkChangedToWiFiNotification = @"LTNetWorkChangedToWiFiNotification";
//网络切换到移动网络
NSString * const LTNetWorkChangedToWWANNotification = @"LTNetWorkChangedToWWANNotification";
