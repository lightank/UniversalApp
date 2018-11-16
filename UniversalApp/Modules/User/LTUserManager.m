//
//  LTUserManager.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/20.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTUserManager.h"

LTUserManager *LTUserManagerInstance = nil;

@interface LTUserManager ()

/**  导航控制器  */
@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation LTUserManager

+ (void)initializeUserManager
{
    [self sharedInstance];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        LTUserManagerInstance = [[super allocWithZone:NULL] init];
    });
    return LTUserManagerInstance;
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
        _currentUser = _currentUser ? : [[LTUser alloc] init];
    }
    return self;
}

+ (UIViewController *)loginViewController
{
    return [[NSClassFromString(@"LTLoginViewController") alloc] init];
}

+ (void)showLoginPage
{
    static NSString *title = @"lt_login_page_navigation_controller_title";
    // 先清空登录用户相关信息
    [self signOutCurrentUser];
    // 如果当前页面就是登录页面就不用跳转了
    if (kCurrentViewController.navigationController.title == title)
    {
        return;
    }
    
    UIViewController *loginController = [self loginViewController];
    NSAssert([loginController isKindOfClass:[UIViewController class]], @"尚未设置登录界面");
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[self loginViewController]];
    navigationController.title = title;
    LTUserManagerInstance.navigationController = navigationController;
    [kCurrentViewController presentViewController:navigationController animated:YES completion:^{
        
    }];
}

+ (void)hiddenLoginPge
{
    [LTUserManagerInstance.navigationController dismissViewControllerAnimated:YES completion:^{
        LTUserManagerInstance.navigationController = nil;
    }];
}

#pragma mark - 用户管理
+ (void)restoreCurrentUserInfo
{
    return [LTUserManagerInstance restoreCurrentUserInfo];
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
    return [LTUserManagerInstance storageCurrentUserInfo];
}

- (void)storageCurrentUserInfo
{
    NSString *userInfo = [self.currentUser modelToJSONString];
    [[self userInfoCache] setObject:userInfo forKey:@"userInfo"];
}

/**  当前账号退出登录  */
+ (BOOL)signOutCurrentUser
{
    LTUserManagerInstance.currentUser = nil;
    [LTUserManagerInstance storageCurrentUserInfo];
    
    return YES;
}


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
