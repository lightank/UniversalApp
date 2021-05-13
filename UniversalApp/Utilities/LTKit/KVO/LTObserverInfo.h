//
//  LTObserverInfo.h
//  UniversalApp
//
//  Created by huanyu.li on 2021/5/13.
//  Copyright © 2021 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, LTKeyValueObservingOptions) {
    LTKeyValueObservingOptionsNew = 1 << 0, //01
    LTKeyValueObservingOptionsOld = 1 << 1, //10
};

@interface LTObserverInfo : NSObject

/// 监听者
@property (nonatomic, strong) id observer;
/// 被监听的key
@property (nonatomic, copy) NSString *key;
/// 监听策略
@property (nonatomic, assign) LTKeyValueObservingOptions options;

- (instancetype)initWithObserver:(id)observer withKey:(NSString *)key withOptions:(LTKeyValueObservingOptions)options;

@end

NS_ASSUME_NONNULL_END
