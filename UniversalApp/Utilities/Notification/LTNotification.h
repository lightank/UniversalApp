//
//  LTNotification.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/7/19.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 通用回调
 
 @param success 状态
 @param error 返回信息
 */
typedef void (^LTLocalNotificationReslutBlock)(BOOL success, NSError * _Nullable error);

@interface LTLocalNotification : NSObject

/**  消息标题  */
@property (nonatomic, copy) NSString *title;
/**  消息副标题  */
@property (nonatomic, copy) NSString *subTitle;
/**  消息内容  */
@property (nonatomic, copy) NSString *content;
/**  UserInfo  */
@property (nonatomic, strong) NSDictionary *userInfo;
/**  消息唯一标识  */
@property (nonatomic, copy) NSString *identifier;

@end

@interface LTNotification : NSObject

+ (instancetype)sharedInstance;

#pragma mark 本地推送

/**
 发送本地推送消息
 
 @param messageTitle 消息标题
 @param messageSubTitle 消息副标题
 @param messageBody 消息体
 @param userInfo 消息相关信息
 @param messageIdentify 消息标记
 @param fireDate 消息发送时间
 @param reslutBlock  结果
 
 */
-(void)pushLocalNotificationWithMessageTitle:(NSString *)messageTitle andWithMessageSubTitle:(NSString *)messageSubTitle andWithMessageBody:(NSString *)messageBody andWithUserInfo:(NSDictionary *)userInfo andWithMessageIdentify:(NSString *)messageIdentify InFireDate:(NSDate *)fireDate andWithReslutBlock:(LTLocalNotificationReslutBlock)reslutBlock;

//取消本地推送

/**
 取消本地推送
 
 @param messageIdentify 本地推送标志位-根据userInfo中id_key字段判断
 */
-(void)cancelLocalNotificationWithMessageIdentify:(NSString *)messageIdentify;
/**
 取消所有本地通知
 */
-(void)cancelAllLocalNotification;


@end

NS_ASSUME_NONNULL_END
