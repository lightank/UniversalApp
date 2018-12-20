//
//  NSObject+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/13.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "NSObject+LTAdd.h"

@implementation NSObject (LTAdd)

//将obj转换成json字符串。如果失败则返回nil.
- (NSString *)lt_JSONString
{
    //先判断是否能转化为JSON格式
    if (![NSJSONSerialization isValidJSONObject:self])  return nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted  error:&error];
    if (error || !jsonData) return nil;
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end

static inline void LTSwizzleInstanceSelector(Class class, SEL originalSelector, SEL swizzledSelector) {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod)
    {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

// 将字典(NSDictionary)和数组(NSArray)打印的Log显示为Json格式 详见:https://github.com/shixueqian/PrintBeautifulLog
//DEBUG模式生效
#ifdef DEBUG

@implementation NSDictionary (LTJSONLog)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(descriptionWithLocale:),
            @selector(descriptionWithLocale:indent:),
            @selector(debugDescription)
        };
        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); index++)
        {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"lt_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            //ExchangeImplementations([self class], originalSelector, swizzledSelector);
            LTSwizzleInstanceSelector([self class], originalSelector, swizzledSelector);
        }
    });
}

//用此方法交换系统的 descriptionWithLocale: 方法。该方法在代码打印的时候调用。
- (NSString *)lt_descriptionWithLocale:(id)locale
{
    NSString *result = [self lt_JSONString];//转换成JSON格式字符串
    if (!result) return [self lt_descriptionWithLocale:locale];//如果无法转换，就使用原先的格式
    return result;
}
//用此方法交换系统的 descriptionWithLocale:indent:方法。功能同上。
- (NSString *)lt_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSString *result = [self lt_JSONString];
    if (!result) return [self lt_descriptionWithLocale:locale indent:level];
    return result;
}
//用此方法交换系统的 debugDescription 方法。该方法在控制台使用po打印的时候调用。
- (NSString *)lt_debugDescription
{
    NSString *result = [self lt_JSONString];
    if (!result) return [self lt_debugDescription];
    return result;
}


@end

@implementation NSArray (LTJSONLog)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(descriptionWithLocale:),
            @selector(descriptionWithLocale:indent:),
            @selector(debugDescription)
        };
        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); index++) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"lt_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            //ExchangeImplementations([self class], originalSelector, swizzledSelector);
            LTSwizzleInstanceSelector([self class], originalSelector, swizzledSelector);
        }
    });
}

//用此方法交换系统的 descriptionWithLocale: 方法。该方法在代码打印的时候调用。
- (NSString *)lt_descriptionWithLocale:(id)locale
{
    NSString *result = [self lt_JSONString];//转换成JSON格式字符串
    if (!result) return [self lt_descriptionWithLocale:locale];//如果无法转换，就使用原先的格式
    return result;
}
//用此方法交换系统的 descriptionWithLocale:indent:方法。功能同上。
- (NSString *)lt_descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSString *result = [self lt_JSONString];
    if (!result) return [self lt_descriptionWithLocale:locale indent:level];
    return result;
}
//用此方法交换系统的 debugDescription 方法。该方法在控制台使用po打印的时候调用。
- (NSString *)lt_debugDescription
{
    NSString *result = [self lt_JSONString];
    if (!result) return [self lt_debugDescription];
    return result;
}


@end

#endif
