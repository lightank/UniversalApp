//
//  NSObject+LTKVO.h
//  UniversalApp
//
//  Created by huanyu.li on 2021/5/13.
//  Copyright © 2021 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTObserverInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LTKVO)

/// 添加KVO
- (void)lt_addObserver:(NSObject *)observer forKey:(NSString *)key options:(LTKeyValueObservingOptions)options;
/// 监听KVO
- (void)lt_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change;
/// 删除KVO
- (void)lt_removeObserver:(NSObject *)observer forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
