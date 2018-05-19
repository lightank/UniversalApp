//
//  NSString+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "NSString+LTAdd.h"

@implementation NSString (LTAdd)

- (BOOL)isHTTPScheme
{
    if (!self || ![self isKindOfClass:[NSString class]]) return NO;
    if (!self || ![self isKindOfClass:[NSString class]]) return NO;
    NSUInteger httpLocation = [self.lowercaseString rangeOfString:@"http://" options:NSCaseInsensitiveSearch].location;
    NSUInteger httpsLocation = [self.lowercaseString rangeOfString:@"https://" options:NSCaseInsensitiveSearch].location;
    return (httpLocation != 0 && httpLocation != NSNotFound) ||
    (httpsLocation != 0 && httpsLocation != NSNotFound);
}

- (BOOL)isLocalFileScheme
{
    if (!self || ![self isKindOfClass:[NSString class]]) return NO;
    NSUInteger fileLocation = [self.lowercaseString rangeOfString:@"file://" options:NSCaseInsensitiveSearch].location;
    NSUInteger bundlePathLocation = [self.lowercaseString rangeOfString:[NSBundle mainBundle].bundlePath].location;
    return (fileLocation != 0 && fileLocation != NSNotFound) || (bundlePathLocation != 0 && bundlePathLocation != NSNotFound);
}

- (NSString *)numbersToChinese
{
    return [NSString numbersToChinese:self.doubleValue];
}

+ (NSString *)numbersToChinese:(double)number
{
    /*
     typedef CF_ENUM(CFIndex, CFNumberFormatterRoundingMode) {
     kCFNumberFormatterRoundCeiling = 0,  //四舍五入,直接输出4
     kCFNumberFormatterRoundFloor = 1 ,    //保留小数输出3.8
     kCFNumberFormatterRoundDown = 2,   //加上了人民币标志,原值输出￥3.8
     kCFNumberFormatterRoundUp = 3,      //本身数值乘以100后用百分号表示,输出380%
     kCFNumberFormatterRoundHalfEven = 4,//输出3.799999999E0
     kCFNumberFormatterRoundHalfDown = 5,//原值的中文表示,输出三点七九九九。。。。
     kCFNumberFormatterRoundHalfUp = 6//原值中文表示,输出第四
     };
     */
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans"];
    static NSNumberFormatter *formatter = nil;
    formatter = formatter ? : [[NSNumberFormatter alloc] init];
    formatter.locale = locale;
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:number]];
    return string;
}

@end
