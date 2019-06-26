//
//  LTAuthID.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/4/27.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  TouchID/FaceID 状态
 */
typedef NS_ENUM(NSUInteger, LTAuthIDState){
    
    /**
     *  当前设备不支持TouchID/FaceID
     */
    LTAuthIDStateNotSupport = 0,
    /**
     *  TouchID/FaceID 验证成功
     */
    LTAuthIDStateSuccess = 1,
    
    /**
     *  TouchID/FaceID 验证失败
     */
    LTAuthIDStateFail = 2,
    /**
     *  TouchID/FaceID 被用户手动取消
     */
    LTAuthIDStateUserCancel = 3,
    /**
     *  用户不使用TouchID/FaceID,选择手动输入密码
     */
    LTAuthIDStateInputPassword = 4,
    /**
     *  TouchID/FaceID 被系统取消 (如遇到来电,锁屏,按了Home键等)
     */
    LTAuthIDStateSystemCancel = 5,
    /**
     *  TouchID/FaceID 无法启动,因为用户没有设置密码
     */
    LTAuthIDStatePasswordNotSet = 6,
    /**
     *  TouchID/FaceID 无法启动,因为用户没有设置TouchID/FaceID
     */
    LTAuthIDStateTouchIDNotSet = 7,
    /**
     *  TouchID/FaceID 无效
     */
    LTAuthIDStateTouchIDNotAvailable = 8,
    /**
     *  TouchID/FaceID 被锁定(连续多次验证TouchID/FaceID失败,系统需要用户手动输入密码)
     */
    LTAuthIDStateTouchIDLockout = 9,
    /**
     *  当前软件被挂起并取消了授权 (如App进入了后台等)
     */
    LTAuthIDStateAppCancel = 10,
    /**
     *  当前软件被挂起并取消了授权 (LAContext对象无效)
     */
    LTAuthIDStateInvalidContext = 11,
    /**
     *  系统版本不支持TouchID/FaceID (必须高于iOS 8.0才能使用)
     */
    LTAuthIDStateVersionNotSupport = 12
};

typedef void (^LTAuthIDStateBlock)(LTAuthIDState state,  NSError * _Nullable error);

@interface LTAuthID : NSObject

/**
 * 启动TouchID/FaceID进行验证
 * @param reason TouchID/FaceID显示的描述
 * @param fallbackTitle 2次认证失败后弹出的右边文字
 * @param block 回调状态的block
 */
+ (void)showAuthIDWithReason:(NSString *)reason
               fallbackTitle:(NSString *)fallbackTitle
                       block:(LTAuthIDStateBlock)block;

@end

NS_ASSUME_NONNULL_END
