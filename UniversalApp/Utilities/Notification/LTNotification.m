//
//  LTNotification.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/7/19.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTNotification.h"

#if __has_include(<UserNotifications/UserNotifications.h>)
#import <UserNotifications/UserNotifications.h>

#ifndef LTLoacalUserNotificationsAvailable
#define LTLoacalUserNotificationsAvailable
#endif

#endif

#define HGBMessageidentify @"messageIdentify"


@implementation LTLocalNotification


@end

@implementation LTNotification

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

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
-(void)pushLocalNotificationWithMessageTitle:(NSString *)messageTitle andWithMessageSubTitle:(NSString *)messageSubTitle andWithMessageBody:(NSString *)messageBody andWithUserInfo:(NSDictionary *)userInfo andWithMessageIdentify:(NSString *)messageIdentify InFireDate:(NSDate *)fireDate andWithReslutBlock:(LTLocalNotificationReslutBlock)reslutBlock{
#ifdef LTLoacalUserNotificationsAvailable
    if (@available(iOS 10.0, *)) {
        UNMutableNotificationContent *content=[[UNMutableNotificationContent alloc]init];
        if(messageTitle){
            content.title=messageTitle;
        }
        
        if(userInfo){
            content.userInfo=userInfo;
        }
        if(messageBody){
            content.body=messageBody;
        }
        if(messageSubTitle){
            content.subtitle= messageSubTitle;
        }
        content.sound=[UNNotificationSound defaultSound];
        content.badge = @([[UIApplication sharedApplication]applicationIconBadgeNumber]+1);
        
        NSTimeInterval interval=[fireDate timeIntervalSinceNow];
        
        //第三步：通知触发机制。（重复提醒，时间间隔要大于60s）
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.0 repeats:NO];
        
        NSString *requertIdentifier;
        //第四步：创建UNNotificationRequest通知请求对象
        if(messageIdentify){
            requertIdentifier = messageIdentify;
        }else{
            requertIdentifier=[self getSecondTimeStringSince1970];
        }
        
        NSMutableDictionary *userInfoMessage=[[NSMutableDictionary alloc]initWithDictionary:userInfo];
        if (userInfoMessage==nil) {
            userInfoMessage=[NSMutableDictionary dictionary];
        }
        [userInfoMessage setObject:requertIdentifier forKey:HGBMessageidentify];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requertIdentifier content:content trigger:trigger];
        
        //第五步：将通知加到通知中心
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if(error){
                if (reslutBlock) {
                    reslutBlock(NO, error);
                }
            }else{
                if (reslutBlock) {
                    reslutBlock(YES, nil);
                }
            }
        }];
    }
#else
    UILocalNotification *localNoti=[[UILocalNotification alloc]init];
    if(messageTitle){
        localNoti.alertTitle=messageTitle;
    }
    NSMutableDictionary *userInfoMessage=[[NSMutableDictionary alloc]initWithDictionary:userInfo];
    if (userInfoMessage==nil) {
        userInfoMessage=[NSMutableDictionary dictionary];
    }
    NSString *requertIdentifier;
    //第四步：创建UNNotificationRequest通知请求对象
    if(messageIdentify){
        requertIdentifier = messageIdentify;
    }else{
        requertIdentifier=[self getSecondTimeStringSince1970];
    }
    [userInfoMessage setObject:requertIdentifier forKey:HGBMessageidentify];
    localNoti.userInfo=userInfo;
    
    if(messageBody){
        localNoti.alertBody=messageBody;
    }
    localNoti.soundName= UILocalNotificationDefaultSoundName;
    
    localNoti.fireDate=fireDate;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    
    if (reslutBlock) {
        reslutBlock(YES, nil);
    }
#endif
    
}
//取消本地推送

/**
 取消本地推送
 
 @param messageIdentify 本地推送标志位-根据userInfo中id_key字段判断
 */
-(void)cancelLocalNotificationWithMessageIdentify:(NSString *)messageIdentify{
#ifdef __IPHONE_10_0
    UNUserNotificationCenter *center=[UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:@[messageIdentify]];
    [center removeDeliveredNotificationsWithIdentifiers:@[messageIdentify]];
#else
    NSArray *notis=[[UIApplication sharedApplication]scheduledLocalNotifications];
    for(UILocalNotification *noti in notis){
        if([[noti.userInfo objectForKey:HGBMessageidentify] isEqualToString:messageIdentify]){
            [[UIApplication sharedApplication]cancelLocalNotification:noti];
        }
    }
#endif
    
}
/**
 取消所有本地通知
 */
-(void)cancelAllLocalNotification{
#ifdef __IPHONE_10_0
    UNUserNotificationCenter *center=[UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
    [center removeAllPendingNotificationRequests];
#else
    NSArray *notis=[[UIApplication sharedApplication]scheduledLocalNotifications];
    for(UILocalNotification *noti in notis){
        [[UIApplication sharedApplication]cancelLocalNotification:noti];
    }
#endif
    
}

#pragma mark 获取时间
/**
 获取时间戳-秒级
 
 @return 秒级时间戳
 */
- (NSString *)getSecondTimeStringSince1970
{
    NSDate* date = [NSDate date];
    NSTimeInterval interval=[date timeIntervalSince1970];  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%f", interval]; //转为字符型
    NSString *timeStr = [NSString stringWithFormat:@"%lf",[timeString doubleValue]*1000000];
    
    if(timeStr.length>=16){
        return [timeStr substringToIndex:16];
    }else{
        return timeStr;
    }
}

@end
