//
//  LTAuthID.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/4/27.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTAuthID.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation LTAuthID

+ (void)showAuthIDWithReason:(NSString *)reason fallbackTitle:(NSString *)fallbackTitle block:(LTAuthIDStateBlock)block
{
    NSString *localizedReason = @"请验证信息";
    NSString *localizedFallbackTitle = @"输入密码";
    
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"系统版本不支持TouchID/FaceID (必须高于iOS 8.0才能使用)");
            block(LTAuthIDStateVersionNotSupport, nil);
        });
        return;
    }
    
    LAContext *context = [[LAContext alloc] init];
    // iOS 10 以后可以设置取消的title,不能为空字符串
    //context.localizedCancelTitle = @"取消";
    // 认证失败提示信息，不能为空字符串
    //context.localizedFallbackTitle = localizedFallbackTitle;
    
    NSError *error = nil;
    // LAPolicyDeviceOwnerAuthenticationWithBiometrics: 用TouchID/FaceID验证
    // LAPolicyDeviceOwnerAuthentication: 用TouchID/FaceID或密码验证, 默认是错误两次或锁定后, 弹出输入密码界面（本案例使用）
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:localizedReason reply:^(BOOL success, NSError * _Nullable error) {
            LTAuthIDState state = LTAuthIDStateNotSupport;
            if (success)
            {
                state = LTAuthIDStateSuccess;
            }
            
            if (error)
            {
                switch (error.code)
                {
                    case LAErrorAuthenticationFailed:
                    {
                        NSLog(@"TouchID/FaceID 验证失败");
                        state = LTAuthIDStateFail;
                    }
                        break;
                    case LAErrorUserCancel:
                    {
                        NSLog(@"TouchID/FaceID 被用户手动取消");
                        state = LTAuthIDStateUserCancel;
                    }
                        break;
                    case LAErrorUserFallback:
                    {
                        NSLog(@"用户不使用TouchID/FaceID,选择手动输入密码");
                        state = LTAuthIDStateInputPassword;
                    }
                        break;
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"TouchID/FaceID 被系统取消 (如遇到来电,锁屏,按了Home键等)");
                        state = LTAuthIDStateSystemCancel;
                    }
                        break;
                    case LAErrorPasscodeNotSet:
                    {
                        NSLog(@"TouchID/FaceID 无法启动,因为用户没有设置密码");
                        state = LTAuthIDStatePasswordNotSet;
                    }
                        break;
                    case LAErrorTouchIDNotEnrolled:
                    //case LAErrorBiometryNotEnrolled:
                    {
                        NSLog(@"TouchID/FaceID 无法启动,因为用户没有设置TouchID/FaceID");
                        state = LTAuthIDStateTouchIDNotSet;
                    }
                        break;
                    case LAErrorTouchIDNotAvailable:
                    //case LAErrorBiometryNotAvailable:
                    {
                        NSLog(@"TouchID/FaceID 无效");
                        state = LTAuthIDStateTouchIDNotAvailable;
                    }
                        break;
                    case LAErrorTouchIDLockout:
                    //case LAErrorBiometryLockout:
                    {
                        NSLog(@"TouchID/FaceID 被锁定(连续多次验证TouchID/FaceID失败,系统需要用户手动输入密码)");
                        state = LTAuthIDStateTouchIDLockout;
                    }
                        break;
                    case LAErrorAppCancel:
                    {
                        NSLog(@"当前软件被挂起并取消了授权 (如App进入了后台等)");
                        state = LTAuthIDStateAppCancel;
                    }
                        break;
                    case LAErrorInvalidContext:
                    {
                        NSLog(@"当前软件被挂起并取消了授权 (LAContext对象无效)");
                        state = LTAuthIDStateInvalidContext;
                    }
                        break;
                    default:
                        break;
                }
            }
            
            if (block)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(state, error);
                });
            }
        }];
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"当前设备不支持TouchID/FaceID");
            block(LTAuthIDStateNotSupport, error);
        });
    }
}


@end
