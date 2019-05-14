//
//  UIApplication+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/5.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface UIApplication (LTAdd)

+ (void)lt_openSafari:(NSString *)url;
+ (void)lt_openSafariInApplication:(NSString *)url API_AVAILABLE(ios(9.0));

+ (void)lt_openApplicationSettings;

+ (void)lt_openURL:(NSString*)url;
+ (BOOL)lt_canOpen:(NSString*)url;

+ (void)lt_openMessageWithPhoneNumber:(NSString *)phoneNumber
                              content:(NSString *)content;

@end

