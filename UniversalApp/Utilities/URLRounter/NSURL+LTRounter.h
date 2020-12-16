//
//  NSURL+LTRounter.h
//  UniversalApp
//
//  Created by huanyu.li on 2020/12/16.
//  Copyright © 2020 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (LTRounter)

/// 返回 URL 参数对，相同key被覆盖
/// 例如：www.baidu.com?a=1&b=2&a=3
/// 结果为：{a:3,b:2}
- (NSDictionary<NSString *, NSString *> *)lt_queryComponents;

/// 返回 URL 参数对，保留所有key值
/// 例如：www.baidu.com?a=1&b=2&a=3
/// 结果为：{a:[1,3],b:[2]}
- (NSDictionary<NSString *, NSArray<NSString *> *> *)lt_standardQueryComponents;

/// 返回url的path数组
/// 默认pathComponents数组第一个是"/"，需要移除掉
- (NSArray<NSString *> *)lt_pathComponents;

@end

@interface NSString (LTRounter)

- (NSString *)lt_stringByDecodingURLFormat;
- (NSString *)lt_stringByEncodingURLFormat;

- (NSDictionary<NSString *,NSArray<NSString *> *> *)lt_dictionaryFromQueryComponents;
- (NSString *)lt_valueFromQueryComponentsWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
