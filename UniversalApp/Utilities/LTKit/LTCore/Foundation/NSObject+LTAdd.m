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
+ (nullable NSDictionary<NSString *, NSString *> *)lt_classNameForProperty:(NSString *)propertyName
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
    NSMutableDictionary *propertyDictionary = cacheDictionary[key];
    if (propertyDictionary)
    {
        return [propertyDictionary isKindOfClass:[NSNull class]] ? nil : propertyDictionary;
    }
    
    propertyDictionary = @{}.mutableCopy;
    NSString *className = [NSObject lt_allPropertyDictionaryOf:self][propertyName];
    if (className)
    {
        propertyDictionary[className] = propertyName;
    }
    else
    {
        propertyDictionary = nil;
    }
    
    cacheDictionary[key] = propertyDictionary ? : [NSNull null];
    
    return propertyDictionary;
}

+ (nullable NSDictionary<NSString *, NSString *> *)lt_propertyNameForClass:(Class _Nonnull)className
{
    __block NSString *propertyName = nil;
    __block NSString *propertyClassName = nil;
    Class class = self;
    if (!class)
    {
        return nil;
    }
    
    static dispatch_once_t onceToken;
    static NSMutableDictionary *cacheDictionary = nil;
    dispatch_once(&onceToken,^{
        cacheDictionary = @{}.mutableCopy;
    });
    
    NSString *key = [NSString stringWithFormat:@"%@_%@", NSStringFromClass(self.class), className];
    __block NSMutableDictionary *propertyDictionary = cacheDictionary[key];
    if (propertyDictionary)
    {
        return [propertyDictionary isKindOfClass:[NSNull class]] ? nil : propertyDictionary;
    }
    
    propertyDictionary = @{}.mutableCopy;
    Class superClass = self;
    while (superClass && !propertyName)
    {
        NSDictionary<NSString *, NSString *> *propertyDictionary = [NSObject lt_propertyDictionaryOf:superClass];
        BOOL haveClassKey = [propertyDictionary.allValues containsObject:NSStringFromClass(className)];

        [propertyDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            if (haveClassKey)
            {
                if ([obj isEqualToString:NSStringFromClass(className)])
                {
                    *stop = YES;
                    propertyName = key;
                    propertyClassName = obj;
                }
            }
            else
            {
                NSArray *superClasees = [NSObject lt_superClassOf:NSClassFromString(obj)];
                if ([superClasees containsObject:NSStringFromClass(className)])
                {
                    *stop = YES;
                    propertyName = key;
                    propertyClassName = obj;
                }
            }
        }];
        superClass = class_getSuperclass(superClass);
    }
    
    if (propertyClassName)
    {
        propertyDictionary[propertyClassName] = propertyName;
    }
    else
    {
        propertyDictionary = nil;
    }
    cacheDictionary[key] = propertyDictionary ? : [NSNull null];

    return propertyDictionary;
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

