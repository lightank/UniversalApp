//
//  AppDelegate+AppService.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (AppService)

/**  app 启动次数  */
@property (nonatomic, assign) NSUInteger appStartupNumber;
/**  是否是新版本  */
@property (nonatomic, assign, getter=isNewVersion) BOOL newVersion;

#pragma mark - 初始化及配置
/**  初始化Window及各类服务  */
- (void)initAppWithOptions:(NSDictionary *)launchOptions;

@end
