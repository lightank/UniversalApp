//
//  AppDelegate+OpenInstallSDK.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/2.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "AppDelegate+OpenInstallSDK.h"
#import "OpenInstallSDK.h"

@implementation AppDelegate (OpenInstallSDK)

- (void)initializeOpenInstallWithDelegate:(id)delegate
{
    [OpenInstallSDK initWithDelegate:delegate];
    [self getInstallParamsImmediately];
}

- (void)getInstallParamsImmediately
{
    //用户注册成功后调用
    //    [OpenInstallSDK reportRegister];
    //渠道效果统计
    //    [[OpenInstallSDK defaultManager] reportEffectPoint:@"效果点ID" effectValue:100];//value为整型,如果是人民币金额，请以分为计量单位
    
    [[OpenInstallSDK defaultManager] getInstallParmsCompleted:^(OpeninstallData*_Nullable appData) {
        
        if (appData.data)
        {   //(动态安装参数)
            //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
            // OpenInstallSDK 支持多参数,直接对字典取值就好
            
            // 邀请码
            NSString *invitationCode = appData.data[@"invitationCode"];
            if (invitationCode)
            {
                
            }
            
            // 对方id
            NSString *invitationID = appData.data[@"invitationID"];
            if (invitationID)
            {
            }
            
            if (appData.channelCode)
            {//(通过渠道链接或二维码安装会返回渠道编号)
                //e.g.可自己统计渠道相关数据等
                
            }
        }
        
        //弹出提示框(便于调试，调试完成后删除此代码)
#if DEBUG
        if (NO) // 打印传过来的信息
        {
            NSString *getData;
            if (appData.data) {
                //中文转换，方便看数据
                getData = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:appData.data options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            }
            NSString *parameter = [NSString stringWithFormat:@"如果没有任何参数返回，请确认：\n"
                                   @"1、新应用是否上传安装包(是否集成完毕)  "
                                   @"2、是否正确配置appKey  "
                                   @"3、是否通过含有动态参数的分享链接(或二维码)安装的app\n\n动态参数：\n%@\n渠道编号：%@",
                                   getData,appData.channelCode];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"安装参数(示例1)" message:parameter preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
        }
#endif
    }];
}

//通过OpenInstall获取已经安装App被唤醒时的参数（如果是通过渠道页面唤醒App时，会返回渠道编号）
- (void)getWakeUpParams:(OpeninstallData *)appData{
    
    if (appData.data) {//(动态唤醒参数)
        //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
    }
    if (appData.channelCode) {//(通过渠道链接或二维码安装会返回渠道编号)
        //e.g.可自己统计渠道相关数据等
    }
    
    //弹出提示框(便于调试，调试完成后删除此代码)
    if (NO)
    {
        NSLog(@"OpenInstallSDK:\n动态参数：%@;\n渠道编号：%@",appData.data,appData.channelCode);
        NSString *getData;
        if (appData.data) {
            //如果有中文，转换一下方便展示
            getData = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:appData.data options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        }
        NSString *parameter = [NSString stringWithFormat:@"如果没有任何参数返回，请确认：\n"
                               @"是否通过含有动态参数的分享链接(或二维码)安装的app\n\n动态参数：\n%@\n渠道编号：%@",
                               getData,appData.channelCode];
        UIAlertController *testAlert = [UIAlertController alertControllerWithTitle:@"唤醒参数" message:parameter preferredStyle:UIAlertControllerStyleAlert];
        [testAlert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:testAlert animated:true completion:nil];
    }
}


@end
