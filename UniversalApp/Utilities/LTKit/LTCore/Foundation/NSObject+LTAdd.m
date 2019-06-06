//
//  NSObject+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/13.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "NSObject+LTAdd.h"
#import <objc/runtime.h>

@implementation NSObject (LTAdd)

+ (NSArray<NSString *> *)lt_subClassOf:(Class)defaultClass includeSelf:(BOOL)include
{
    NSMutableArray *output = [[NSMutableArray alloc] init];
    if (include) [output addObject:NSStringFromClass(defaultClass)];
    int count = objc_getClassList(NULL, 0);
    if (count <= 0 || !defaultClass)
    {
        return output;
    }
    Class *classes = (Class *) malloc(sizeof(Class) * count);
    objc_getClassList(classes, count);
    for (int i = 0; i < count; ++i)
    {
        if (defaultClass == class_getSuperclass(classes[i]))//子类
        {
            [output addObject:NSStringFromClass(classes[i])];
        }
    }
    free(classes);
    return [NSArray arrayWithArray:output];
}

+ (NSArray *)lt_allSubClassOf:(Class)defaultClass includeSelf:(BOOL)include
{
    NSMutableArray *output = [[NSMutableArray alloc] init];
    if (include) [output addObject:NSStringFromClass(defaultClass)];
    int count = objc_getClassList(NULL, 0);
    if (count <= 0 || !defaultClass)
    {
        return output;
    }
    Class *classes = (Class *) malloc(sizeof(Class) * count);
    objc_getClassList(classes, count);
    for (int i = 0; i < count; ++i)
    {
        NSArray<NSString *> *superClasses = [NSObject lt_superClassOf:classes[i]];
        if ([superClasses containsObject:NSStringFromClass(defaultClass)])//子类
        {
            [output addObject:NSStringFromClass(classes[i])];
        }
    }
    free(classes);
    return [NSArray arrayWithArray:output];
}

+ (NSArray<NSString *> *)lt_superClassOf:(Class)defaultClass
{
    __block NSMutableArray *allClassContainArray = [[NSMutableArray alloc] init];
    Class superClass = class_getSuperclass(defaultClass);
    while (superClass)
    {
        [allClassContainArray addObject:NSStringFromClass(superClass)];
        superClass = class_getSuperclass(superClass);
    }
    return allClassContainArray;
}

/**
 * 返回对象中属性的类型
 * @return NSString 返回属性的类型
 **/
+ (nullable NSString *)lt_classNameForProperty:(NSString *)propertyName
{
    if (!propertyName)
    {
        return nil;
    }
    
    static dispatch_once_t onceToken;
    static NSMutableDictionary *cacheDictionary = nil;
    dispatch_once(&onceToken,^{
        cacheDictionary = @{}.mutableCopy;
    });
    
    NSString *key = [NSString stringWithFormat:@"%@_%@", NSStringFromClass(self.class), propertyName];
    NSString *className = cacheDictionary[key];
    if (className)
    {
        return [className isKindOfClass:[NSNull class]] ? nil : className;
    }
    
    className = [NSObject lt_allPropertyDictionaryOf:self][propertyName];
    cacheDictionary[key] = className ? : [NSNull null];
    
    return className;
}

+ (nullable NSString *)lt_propertyNameForClass:(Class _Nonnull)className
{
    __block NSString *propertyName = nil;
    Class class = self;
    if (!class)
    {
        return propertyName;
    }
    
    static dispatch_once_t onceToken;
    static NSMutableDictionary *cacheDictionary = nil;
    dispatch_once(&onceToken,^{
        cacheDictionary = @{}.mutableCopy;
    });
    
    NSString *key = [NSString stringWithFormat:@"%@_%@", NSStringFromClass(self.class), className];
    propertyName = cacheDictionary[key];
    if (propertyName)
    {
        return [propertyName isKindOfClass:[NSNull class]] ? nil : propertyName;
    }
    
    Class superClass = self;
    while (superClass && !propertyName)
    {
        NSDictionary<NSString *, NSString *> *propertyDictionary = [NSObject lt_propertyDictionaryOf:superClass];
        [propertyDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            NSArray *superClasees = [NSObject lt_superClassOf:NSClassFromString(obj)];
            if ([superClasees containsObject:NSStringFromClass(className)])
            {
                *stop = YES;
                propertyName = key;
            }
        }];
        superClass = class_getSuperclass(superClass);
    }
    
    cacheDictionary[key] = propertyName ? : [NSNull null];
    
    return propertyName;
}

+ (nullable NSDictionary<NSString *, NSString *> *)lt_allPropertyDictionaryOf:(Class _Nonnull)defaultClass
{
    NSMutableDictionary *dictionary = @{}.mutableCopy;
    Class superClass = defaultClass;
    while (superClass)
    {
        NSDictionary<NSString *, NSString *> *propertyDictionary = [NSObject lt_propertyDictionaryOf:superClass];
        [dictionary addEntriesFromDictionary:propertyDictionary];
        superClass = class_getSuperclass(superClass);
    }
    return dictionary;
}

+ (nullable NSDictionary<NSString *, NSString *> *)lt_propertyDictionaryOf:(Class _Nonnull)defaultClass
{
    NSMutableDictionary *dictionary = @{}.mutableCopy;
    
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList([defaultClass class], &propertyCount);
    for (int i = 0; i < propertyCount; i++)
    {
        objc_property_t property = properties[i];
        //属性名称
        const char *propertyNameChar = property_getName(property);
        NSString *propertyNameStr = [NSString stringWithUTF8String:propertyNameChar];
        
        //属性对应的类型名字
        char *typeEncoding = property_copyAttributeValue(property,"T");
        NSString *typeEncodingStr = [NSString stringWithUTF8String:typeEncoding];
        typeEncodingStr = [typeEncodingStr stringByReplacingOccurrencesOfString:@"@" withString:@""];
        typeEncodingStr = [typeEncodingStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        typeEncodingStr = [typeEncodingStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        
        dictionary[propertyNameStr] = typeEncodingStr;
    }
    free(properties);
    
    return dictionary;
}


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
