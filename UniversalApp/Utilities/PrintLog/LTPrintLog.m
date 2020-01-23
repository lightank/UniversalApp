//
//  LTPrintLog.m
//  UniversalApp
//
//  Created by huanyu.li on 2020/1/23.
//  Copyright © 2020 huanyu.li. All rights reserved.
//  将 NSDictionary 和 NSArray 以 JSON 格式字符串输出到控制台（控制台可正常输出中文），直接将这个文件拖到工程中即可生效

#import "LTPrintLog.h"

@implementation NSObject (LTPrintLog)

- (NSString *)lt_convertToJsonString {
    //先判断是否能转化为 JSON 格式
    if (![NSJSONSerialization isValidJSONObject:self])  return nil;
    NSError *error = nil;
    
    NSJSONWritingOptions jsonOptions = NSJSONWritingPrettyPrinted;
    if (@available(iOS 11.0, *)) {
        //11.0之后，可以将 JSON 按照 key 排列后输出，看起来会更舒服
        jsonOptions = NSJSONWritingPrettyPrinted | NSJSONWritingSortedKeys ;
    }
    // 字典转化为有格式输出的JSON字符串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error || !jsonData) return nil;
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end

@implementation NSDictionary (LTPrintLog)

- (NSString *)debugDescription {
    return [self lt_printDictionary];
}

- (NSString *)descriptionWithLocale:(id)locale {
    return [self lt_printDictionary];
}

- (NSString *)descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [self lt_printDictionary];
}

- (NSString *)lt_printDictionary {
    NSMutableString *str = [[self lt_convertToJsonString] mutableCopy];
    if (str) {
        return [str copy];
    } else {
        str = [NSMutableString string];
    }
    
    [str appendString:@"{\n"];
    
    // 遍历字典的所有键值对
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id objDescrition = [obj lt_convertToJsonString] ? : obj;
        [str appendFormat:@"\t%@ = %@,\n", key, objDescrition];
    }];
    [str appendString:@"}"];
    
    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    
    return str;
}

@end

@implementation NSArray (LTPrintLog)

- (NSString *)debugDescription {
    return [self lt_printArray];
}

- (NSString *)descriptionWithLocale:(id)locale {
    return [self lt_printArray];
}

- (NSString *)descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level {
    return [self lt_printArray];
}

- (NSString *)lt_printArray {
    NSMutableString *str = [[self lt_convertToJsonString] mutableCopy];
    if (str) {
        return [str copy];
    } else {
        str = [NSMutableString string];
    }
    
    [str appendString:@"[\n"];
    
    // 遍历数组的所有元素
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [str appendFormat:@"%@,\n", obj];
    }];
    [str appendString:@"]"];
    
    // 查出最后一个,的范围
    NSRange range = [str rangeOfString:@"," options:NSBackwardsSearch];
    if (range.length) {
        // 删掉最后一个,
        [str deleteCharactersInRange:range];
    }
    
    return str;
}

@end
