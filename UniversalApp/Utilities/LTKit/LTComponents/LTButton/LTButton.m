//
//  LTButton.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/5/14.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTButton.h"
#import "YYTimer.h"

@interface LTButton ()

@property(nonatomic, assign) NSUInteger second;
@property(nonatomic, assign) NSUInteger totalSecond;
/**  timer  */
@property (nonatomic, strong) YYTimer *timer;

@end

@implementation LTButton

///开始倒计时
- (void)startCountDownWithSecond:(NSUInteger)totalSecond
{
    self.totalSecond = totalSecond;
    self.second = totalSecond;
    [self.timer fire];
}


- (void)fireTimer:(YYTimer *)timer
{
    self.second--;
    if (self.second <= 0)
    {
        [self stopCountDown];
        self.second = self.totalSecond;
    }
    else
    {
        if (self.countDownChanging)
        {
            __weak __typeof(self)weakSelf = self;
            self.countDownChanging(weakSelf, weakSelf.second);
        }
    }
}

///停止倒计时
- (void)stopCountDown
{
    [self.timer invalidate];
    self.timer = nil;
    if (self.countDownFinished)
    {
        __weak __typeof(self)weakSelf = self;
        self.countDownFinished(weakSelf, weakSelf.second);
    }
}

#pragma mark - override super method
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    //如果 button 边界值无变化  失效 隐藏 或者透明 直接返回
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitEdgeInsets, UIEdgeInsetsZero) || !self.enabled || self.hidden || self.alpha == 0)
    {
        return [super pointInside:point withEvent:event];
    }
    else
    {
        CGRect relativeFrame = self.bounds;
        CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitEdgeInsets);
        return CGRectContainsPoint(hitFrame, point);
    }
}

#pragma mark - setter and getter
- (YYTimer *)timer
{
    if (!_timer)
    {
        _timer = [YYTimer timerWithTimeInterval:1 target:self selector:@selector(fireTimer:) repeats:YES];
    }
    return _timer;
}

@end
