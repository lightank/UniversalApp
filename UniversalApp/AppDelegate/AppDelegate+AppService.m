//
//  AppDelegate+AppService.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import <objc/runtime.h>
#import "YYFPSLabel.h"
#import "LTTabBarControllerConfig.h"
#import "LTNetworkTools.h"

@implementation AppDelegate (AppService)

#pragma mark - 初始化及配置
/**  初始化Window及各类服务  */
- (void)initAppWithOptions:(NSDictionary *)launchOptions
{
    // 设置主窗口,并设置根控制器
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //记录启动次数跟版本信息
    [self recordStartupNumberAndVersion];
    //初始化服务
    [self initAppServiceWithOptions:launchOptions];
    //For Debug
    [self somethingForDebug];
}

/**  初始化服务  */
- (void)initAppServiceWithOptions:(NSDictionary *)launchOptions
{
    //网络管理配置 须配置在首位.
    [LTNetworkTools configureNetwork];
    // ========== 上方不能插入代码 ==========
    //设置IQKeyboard
//    [self configureBoardManager];
    //设置根控制器
    [self setupTabBarController];
}

- (void)recordStartupNumberAndVersion
{
    //启动次数
    NSString *AppStartupNumberKey = @"kAppStartupNumberKey";
    NSNumber *AppStartupNumber = [[NSUserDefaults standardUserDefaults] valueForKey:AppStartupNumberKey];
    if (!AppStartupNumber)
    {
        AppStartupNumber = @(1);
    }
    else
    {
        AppStartupNumber = @(AppStartupNumber.intValue + 1);
    }
    self.appStartupNumber = AppStartupNumber.unsignedIntegerValue;
    [[NSUserDefaults standardUserDefaults] setValue:AppStartupNumber forKey:AppStartupNumberKey];
    
    //是否新版本
    NSString *AppVersionKey = @"kAppVersionKey";
    NSString *localVersion = [[NSUserDefaults standardUserDefaults] valueForKey:AppVersionKey];
    NSString *latestVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    self.newVersion = ![localVersion isEqualToString:latestVersion];
    [[NSUserDefaults standardUserDefaults] setValue:latestVersion forKey:AppVersionKey];
}

//Debug模式下要做的事
- (void)somethingForDebug
{
#if DEBUG
    //展示FPS
    [self showFPS];
#endif
}

- (void)setupTabBarController
{
    LTTabBarControllerConfig *tabBarControllerConfig = [[LTTabBarControllerConfig alloc] init];
    CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
    [self.window setRootViewController:tabBarController];
}

// 设置app语言
- (void)setAppLanguage:(NSString *)language
{
    CYLTabBarController *currentTabBarController = (CYLTabBarController *)(self.window.rootViewController);
    if (![currentTabBarController isKindOfClass:[CYLTabBarController class]]) return;
    NSUInteger selectedIndex = currentTabBarController.selectedIndex;
    UINavigationController *currentNavigationController = currentTabBarController.selectedViewController;
    NSMutableArray *viewControllers = currentNavigationController.viewControllers.mutableCopy;
    
    LTTabBarControllerConfig *tabBarControllerConfig = [[LTTabBarControllerConfig alloc] init];
    CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
    tabBarController.selectedIndex = selectedIndex;
    UINavigationController *navigationController = currentTabBarController.selectedViewController;
    
    
    //解决奇怪的动画bug。异步执行
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window setRootViewController:tabBarController];
        navigationController.viewControllers = viewControllers;
        NSLog(@"已切换到语言");
    });
}

#pragma mark ————— FPS 监测 —————
- (void)showFPS
{
    static YYFPSLabel *_fpsLabel = nil;
    if (!_fpsLabel)
    {
        _fpsLabel = [[YYFPSLabel alloc] init];
        [_fpsLabel sizeToFit];
        _fpsLabel.bottom = kScreenHeight * 0.5;
        _fpsLabel.left = 0.f;
        [kKeyWindow addSubview:_fpsLabel];
        _fpsLabel.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [_fpsLabel addGestureRecognizer:panGestureRecognizer];
    }
    
    [kKeyWindow bringSubviewToFront:_fpsLabel];
}

- (void)panGestureAction:(UIPanGestureRecognizer*)recognizer
{
    //视图前置操作
    [recognizer.view.superview bringSubviewToFront:recognizer.view];
    //获取拖拽手势在父视图的拖拽姿态
    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    //改变panGestureRecognizer.view的中心点
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    //重置拖拽手势的姿态
    [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
}

#pragma mark - 属性相关
//appStartupNumber
static char kAssociatedObjectKey_appStartupNumber;
- (void)setAppStartupNumber:(NSUInteger)appStartupNumber
{
    objc_setAssociatedObject(self, &kAssociatedObjectKey_appStartupNumber, @(appStartupNumber), OBJC_ASSOCIATION_ASSIGN);
}
- (NSUInteger)appStartupNumber
{
    return [objc_getAssociatedObject(self, &kAssociatedObjectKey_appStartupNumber) floatValue];
}
//newVersion
static char kAssociatedObjectKey_newVersion;
- (void)setNewVersion:(BOOL)newVersion
{
    objc_setAssociatedObject(self, &kAssociatedObjectKey_newVersion, @(newVersion), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isNewVersion
{
    return [objc_getAssociatedObject(self, &kAssociatedObjectKey_newVersion) boolValue];
}

@end
