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

// 单例
extern LTUserManager *LTUserManagerInstance;

@interface LTUserManager : NSObject

/**  初始化登录模块  */
+ (void)initializeUserManager;

/**  当前用户  */
@property (nonatomic, strong) LTUser *currentUser;
/**  在.m里返回登录页面控制器  */
+ (UIViewController *)loginViewController;
/**  显示登录界面,会先清空登录用户相关信息  */
+ (void)showLoginPage;
/**  隐藏登录页面  */
+ (void)hiddenLoginPge;
/**  恢复用户数据  */
+ (void)restoreCurrentUserInfo;
/**  存储用户信息  */
+ (void)storageCurrentUserInfo;


@end
