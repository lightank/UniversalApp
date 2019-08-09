//
//  LTUserManager.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/20.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LTUserManager;
#import "LTUser.h"

typedef void(^LTUserManagerCompletionBlock)(BOOL isLoginSuccess);

@interface LTUserManager : NSObject

/* Methods for creating shared instances. */
@property (class, readonly, strong) LTUserManager *sharedInstance;

/**  当前用户  */
@property (nonatomic, strong) LTUser *currentUser;
/**  在.m里返回登录页面控制器  */
+ (UIViewController *)loginViewController;
/**  显示登录界面,会先清空登录用户相关信息,这个一般是由除登录页面以外的页面调用  */
+ (void)showLoginPageWithCompletion:(LTUserManagerCompletionBlock)completionBlock;
/**  显示登录界面,会先清空登录用户相关信息,回调为nil  */
+ (void)showLoginPage;
/**  隐藏登录页面,这个一般由登录页面调用  */
+ (void)hiddenLoginPageWithLoginStatus:(BOOL)isLoginSuccess;
/**  恢复用户数据  */
+ (void)restoreCurrentUserInfo;
/**  存储用户信息  */
+ (void)storageCurrentUserInfo;

@end

// 用户登录成功通知
extern NSString * const LTUserDidLoginSuccessNotification;
// 用户退出登录成功通知
extern NSString * const LTUserDidSignOutSuccessNotification;
