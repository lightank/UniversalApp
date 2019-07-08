//
//  NSString+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (LTAdd)

/**  把手机号码转为334  */
- (NSString *)lt_phoneSeparatedTo344;
/**  把手机号码转为334,如果是11位则把中间4位转为*  */
- (NSString *)lt_phoneSeparatedTo344UseStarOnMiddle:(BOOL)useStar;

/**  阿拉伯数字转中文  */
- (NSString *)lt_numbersToChinese;
+ (NSString *)lt_numbersToChinese:(double)number;
/**  中文转拼音  */
- (NSString *)lt_transformToPinyin;

- (NSDictionary *)lt_dictionary;

- (void)lt_copyToPasteboard;

#pragma mark - UITextField/UITextView 字符过滤
/**  输入框保留两位小数  */
+ (BOOL)keepTwoDecimalsNumberWithCurrentText:(NSString *)content
               shouldChangeCharactersInRange:(NSRange)range
                           replacementString:(NSString *)string;

#pragma mark - 二维码/条形码
/**
 生成二维码【白底黑色】

 @param size 生成图片的大小
 @return UIImage图片对象
 */
- (UIImage *)lt_QRCodeImageWithSize:(CGSize)size;

/**
 生成二维码【自定义颜色】

 @param size 生成图片的大小
 @param QRCodeColor 二维码颜色
 @param backgroundColor 背景色
 @return UIImage图片对象
 */
- (UIImage *)lt_QRCodeImageWithSize:(CGSize)size
                              color:(UIColor*)QRCodeColor
                    backgroundColor:(UIColor*)backgroundColor;

/**
 生成条形码【白底黑色】

 @param size 生成条码图片的大小
 @return UIImage图片对象
 */
- (UIImage *)lt_BarCodeImageWithSize:(CGSize)size;

/**
 生成条形码【自定义颜色】

 @param size 生成条形码图片的大小
 @param barCodeColor 条形码颜色
 @param backgroundColor 背景色
 @return UIImage图片对象
 */
- (UIImage *)lt_BarCodeImageWithSize:(CGSize)size
                               color:(UIColor*)barCodeColor
                     backgroundColor:(UIColor*)backgroundColor;

#pragma mark - 高精度的数字加减乘除
/**  加法:self + decimalNumber  */
- (NSString *)lt_decimalNumberByAdding:(NSString *)decimalNumber;
/**  减法:self - decimalNumber  */
- (NSString *)lt_decimalNumberBySubtracting:(NSString *)decimalNumber;
/**  乘法:self * decimalNumber  */
- (NSString *)lt_decimalNumberByMultiplyingBy:(NSString *)decimalNumber;
/**  除法:self / decimalNumber  */
- (NSString *)lt_decimalNumberByDividingBy:(NSString *)decimalNumber;

#pragma mark - 数字
+ (instancetype)lt_stringWithCGFloat:(CGFloat)floatValue
                             decimal:(NSUInteger)decimal;

+ (NSString *)lt_decimalNumberWithNSNumber:(NSNumber *)number
                          significantDigit:(NSUInteger)digit;


#pragma mark - Regular
/**  根据正则语句, 返回第一个匹配的结果的范围  */
- (NSRange)lt_firstRangeByReuglarWithPattern:(NSString *)pattern;
/**  根据正则语句, 返回第一个匹配的字符串  */
- (NSString *)lt_firstStringByRegularWithPattern:(NSString *)pattern;


@end
