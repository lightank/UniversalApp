//
//  AppDelegate+OpenInstallSDK.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/2.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (OpenInstallSDK)

/**  初始化OpenInstallSDK  */
- (void)initializeOpenInstallWithDelegate:(id)delegate;
/**  立即获取OpenInstallSDK参数  */
- (void)getInstallParamsImmediately;

@end
