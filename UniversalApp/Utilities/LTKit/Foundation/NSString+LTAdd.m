//
//  NSString+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "NSString+LTAdd.h"

@implementation NSString (LTAdd)


- (NSString *)lt_phoneSeparatedTo344
{
    return [self lt_phoneSeparatedTo344UseStarOnMiddle:NO];
}

- (NSString *)lt_phoneSeparatedTo344UseStarOnMiddle:(BOOL)useStar
{
    NSString *string = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (string.length == 11 && useStar)
    {
        string = [string stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    NSMutableString *tempStr = [NSMutableString stringWithString:string];
    if ([string length] > 3 &&[string length] <= 7) {
        [tempStr insertString:@" " atIndex:3];
    } else if ([string length] > 7) {
        [tempStr insertString:@" " atIndex:3];
        [tempStr insertString:@" " atIndex:8];
    }
    return tempStr;
}


- (NSString *)lt_numbersToChinese
{
    return [NSString lt_numbersToChinese:self.doubleValue];
}

- (NSDictionary *)lt_dictionary
{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
    if (![dict isKindOfClass:[NSDictionary class]]) dict = nil;
    return dict;
}

- (void)lt_copyToPasteboard
{
    if (self)
    {
        [UIPasteboard generalPasteboard].string = self;
    }
}

+ (NSString *)lt_numbersToChinese:(double)number
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

#pragma mark - 创建二维码/条形码
//引用自:http://www.jianshu.com/p/e8f7a257b612
//引用自:https://github.com/MxABC/LBXScan
- (UIImage *)lt_QRCodeImageWithSize:(CGSize)size
{
    NSData *stringData = [self dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *qrImage = qrFilter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

- (UIImage *)lt_QRCodeImageWithSize:(CGSize)size
                              color:(UIColor*)QRCodeColor
                    backgroundColor:(UIColor*)backgroundColor
{
    NSData *stringData = [self dataUsingEncoding: NSUTF8StringEncoding];
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:QRCodeColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:backgroundColor.CGColor],
                             nil];
    CIImage *qrImage = colorFilter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

//绘制条形码
- (UIImage *)lt_BarCodeImageWithSize:(CGSize)size
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *qrImage = filter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}


- (UIImage *)lt_BarCodeImageWithSize:(CGSize)size
                               color:(UIColor*)barCodeColor
                     backgroundColor:(UIColor*)backgroundColor
{
    NSData *stringData = [self dataUsingEncoding: NSUTF8StringEncoding];
    //生成
    CIFilter *barFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [barFilter setValue:stringData forKey:@"inputMessage"];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",barFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:barCodeColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:backgroundColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

#pragma mark - 高精度的数字加减乘除
- (NSString *)lt_decimalNumberByAdding:(NSString *)decimalNumber
{
    NSDecimalNumber *ANumber = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *BNumber = [NSDecimalNumber decimalNumberWithString:decimalNumber];
    NSDecimalNumber *product = [ANumber decimalNumberByAdding:BNumber];
    return [product stringValue];
}
- (NSString *)lt_decimalNumberBySubtracting:(NSString *)decimalNumber
{
    NSDecimalNumber *ANumber = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *BNumber = [NSDecimalNumber decimalNumberWithString:decimalNumber];
    NSDecimalNumber *product = [ANumber decimalNumberBySubtracting:BNumber];
    return [product stringValue];
}
- (NSString *)lt_decimalNumberByMultiplyingBy:(NSString *)decimalNumber
{
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:decimalNumber];
    NSDecimalNumber *product = [multiplicandNumber decimalNumberByMultiplyingBy:multiplierNumber];
    return [product stringValue];
}
- (NSString *)lt_decimalNumberByDividingBy:(NSString *)decimalNumber
{
    if ([self doubleValue] == 0) return @"0";
    NSDecimalNumber *molecularNumber = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *denominatorNumber = [NSDecimalNumber decimalNumberWithString:decimalNumber];
    NSDecimalNumber *product = [molecularNumber decimalNumberByDividingBy:denominatorNumber];
    return [product stringValue];
}

#pragma mark - 数字
+ (instancetype)lt_stringWithCGFloat:(CGFloat)floatValue decimal:(NSUInteger)decimal
{
    NSString *formatString = [NSString stringWithFormat:@"%%.%@f", @(decimal)];
    return [NSString stringWithFormat:formatString, floatValue];
}

+ (NSString *)lt_decimalNumberWithNSNumber:(NSNumber *)number
                          significantDigit:(NSUInteger)digit
{
    NSString *format = [NSString stringWithFormat:@"%%.%lulf", (unsigned long)digit];
    NSString *amount = [NSString stringWithFormat:format, number.doubleValue];
    NSString *result = [NSDecimalNumber decimalNumberWithString:amount].stringValue;
    return result;
}

#pragma mark - Regular
- (NSRange)lt_firstRangeByReuglarWithPattern:(NSString *)pattern
{
    NSTextCheckingResult *result = [self lt_firstMatchWithPattern:pattern];
    if (result == nil) {
        return NSMakeRange(0, 0);
    }
    
    return result.range;
}

- (NSString *)lt_firstStringByRegularWithPattern:(NSString *)pattern
{
    NSTextCheckingResult *result = [self lt_firstMatchWithPattern:pattern];
    if (result == nil) {
        return nil;
    }
    
    return [self substringWithRange:result.range];
}

- (NSTextCheckingResult *)lt_firstMatchWithPattern:(NSString *)pattern
{
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error)
    {
        return nil;
    }
    
    NSTextCheckingResult *result = [regular firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return result;
}



@end
