//
//  LTLanuchViewController.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/8/30.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 回调

 @param success 如果为YES则显示B面,如果为NO则显示A面
 */
typedef void(^LTLaunchCompletion)(BOOL success);

@interface LTLanuchViewController : UIViewController

@property(nonatomic, copy, nullable) LTLaunchCompletion completionBlock;

/**  是否在中国:
 系统语言:中文
 设备机型:iPhone
 当前系统时区:Asia/Hong_Kong、Asia/Shanghai、Asia/Harbin
 当前地区国家:zh_CN
 */
@property (class, nonatomic, readonly) BOOL isInChina;

/**  是否展示过B面  */
@property (class, nonatomic) BOOL isShow;

+ (BOOL)showWithTime:(NSString *)time;

@end

NS_ASSUME_NONNULL_END
