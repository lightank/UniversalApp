//
//  LTObserverInfo.m
//  UniversalApp
//
//  Created by huanyu.li on 2021/5/13.
//  Copyright © 2021 huanyu.li. All rights reserved.
//

#import "LTObserverInfo.h"

@implementation LTObserverInfo

- (instancetype)initWithObserver:(id)observer withKey:(NSString *)key withOptions:(LTKeyValueObservingOptions)options {
    if (self = [super init]) {
        self.observer = observer;
        self.key = key;
        self.options = options;
    }
    return self;
}

@end
