//
//  UIApplication+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/5.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (LTAdd)

+ (void)openSafari:(NSString *)url;
+ (void)openSafariInApplicatio:(NSString *)url API_AVAILABLE(ios(9.0));

@end
