//
//  LTUserManager.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/20.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTUserManager.h"

@interface LTUserManager ()
{
    dispatch_semaphore_t _lock;
}

/**  导航控制器  */
@property (nonatomic, strong) UINavigationController *navigationController;
/**  完成回调  */
@property (nonatomic, copy) LTUserManagerCompletionBlock completionBlock;

@end

@implementation LTUserManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LTUserManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self restoreCurrentUserInfo];
        _lock = dispatch_semaphore_create(1);
        _currentUser = _currentUser ? : [[LTUser alloc] init];
    }
    return self;
}

+ (UIViewController *)loginViewController
{
    return [[NSClassFromString(@"LTLoginViewController") alloc] init];
}

+ (void)showLoginPageWithCompletion:(LTUserManagerCompletionBlock)completionBlock
{
    dispatch_semaphore_wait(LTUserManager.sharedInstance->_lock, DISPATCH_TIME_FOREVER);
    // 先清空登录用户相关信息
    [self signOutCurrentUser];
    // 如果当前页面就是登录页面就不用跳转了
    UIViewController *controller = kCurrentViewController.navigationController.viewControllers.firstObject;
    if ([controller isKindOfClass:[[self loginViewController] class]])
    {
        dispatch_semaphore_signal(LTUserManager.sharedInstance->_lock);
        return;
    }
    
    UIViewController *loginController = [self loginViewController];
    NSAssert([loginController isKindOfClass:[UIViewController class]], @"尚未设置登录界面");
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
    [kCurrentViewController presentViewController:navigationController animated:YES completion:^{
        
    }];
    
    LTUserManager.sharedInstance.navigationController = navigationController;
    LTUserManager.sharedInstance.completionBlock = completionBlock;
    dispatch_semaphore_signal(LTUserManager.sharedInstance->_lock);
}

+ (void)showLoginPage
{
    [self showLoginPageWithCompletion:nil];
}

+ (void)hiddenLoginPageWithLoginStatus:(BOOL)isLoginSuccess
{
    [LTUserManager.sharedInstance.navigationController dismissViewControllerAnimated:YES completion:^{
        LTUserManager.sharedInstance.navigationController = nil;
        if (LTUserManager.sharedInstance.completionBlock)
        {
            LTUserManager.sharedInstance.completionBlock(isLoginSuccess);
            LTUserManager.sharedInstance.completionBlock = nil;
        }
        if (isLoginSuccess)
        {
            [self postLoginSuccessNotification];
        }
    }];
}

#pragma mark - 用户管理
+ (void)restoreCurrentUserInfo
{
    return [LTUserManager.sharedInstance restoreCurrentUserInfo];
}

- (void)restoreCurrentUserInfo
{
    NSString *userInfo = (NSString *)[[self userInfoCache] objectForKey:@"userInfo"];
    if (userInfo)
    {
        self.currentUser = [LTUser modelWithJSON:userInfo];
    }
}

+ (void)storageCurrentUserInfo
{
    return [LTUserManager.sharedInstance storageCurrentUserInfo];
}

- (void)storageCurrentUserInfo
{
    NSString *userInfo = [self.currentUser modelToJSONString];
    [[self userInfoCache] setObject:userInfo forKey:@"userInfo"];
}

/**  当前账号退出登录  */
+ (BOOL)signOutCurrentUser
{
    LTUserManager.sharedInstance.currentUser = nil;
    [LTUserManager.sharedInstance storageCurrentUserInfo];
    // 发出退出登录通知
    [self postSignOutSuccessNotification];
    return YES;
}

#pragma mark - 登录/退出通知
+ (void)postLoginSuccessNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LTUserDidLoginSuccessNotification object:self];
}

+ (void)postSignOutSuccessNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LTUserDidSignOutSuccessNotification object:self];
}

#pragma mark - 数据库
- (YYCache *)userInfoCache
{
    return [[YYCache alloc] initWithPath:[self pathForUserInfo]];
}

- (NSString *)pathForUserInfo
{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [documentsPath stringByAppendingPathComponent:@"com.huanyu.li.user"];
    return path;
}

@end

// 登录成功
NSString * const LTUserDidLoginSuccessNotification = @"LTUserDidLoginSuccessNotification";
// 退出登录成功通知
NSString * const LTUserDidSignOutSuccessNotification = @"LTUserDidSignOutSuccessNotification";


