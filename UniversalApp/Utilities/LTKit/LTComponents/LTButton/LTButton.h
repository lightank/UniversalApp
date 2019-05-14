//
//  LTButton.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/5/14.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "QMUIButton.h"

NS_ASSUME_NONNULL_BEGIN

@class LTButton;
typedef void(^LTCountDownChanging)(LTButton *button, NSUInteger second);
typedef void(^LTCountDownFinished)(LTButton *button, NSUInteger second);

@interface LTButton : QMUIButton
//倒计时时间改变回调
@property(nonatomic, copy) LTCountDownChanging countDownChanging;
//倒计时结束回调
@property(nonatomic, copy) LTCountDownFinished countDownFinished;
///开始倒计时
- (void)startCountDownWithSecond:(NSUInteger)totalSecond;
///停止倒计时
- (void)stopCountDown;

@end

NS_ASSUME_NONNULL_END