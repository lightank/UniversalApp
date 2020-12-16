//
//  LTURLHandlerItem.m
//  UniversalApp
//
//  Created by huanyu.li on 2020/12/16.
//  Copyright © 2020 huanyu.li. All rights reserved.
//

#import "LTURLHandlerItem.h"

@implementation LTURLHandlerItem

- (void)registerHandler:(LTURLHandlerItem *)handlerItem {
    NSString *des = [NSString stringWithFormat:@"注册的 LTURLHandlerItem:%@ 名字不能为空", [handlerItem class]];
    NSAssert(handlerItem.name.length > 0, des);
    self.handlerItemsDictionary[handlerItem.name] = handlerItem;
    handlerItem.parentHander = self;
}

- (void)unregisterHandlerWithName:(NSString *)handlerItemName {
    self.handlerItemsDictionary[handlerItemName] = nil;
}

- (void)unregisterHandler:(LTURLHandlerItem *)handlerItem {
    NSString *des = [NSString stringWithFormat:@"注册的 LTURLHandlerItem:%@ 名字不能为空", [handlerItem class]];
    NSAssert(handlerItem.name.length > 0, des);
    [self unregisterHandlerWithName:handlerItem.name];
}

- (BOOL)canHandleURL:(NSURL *)url {
    // 这里可以先对URL的参数进行解析，进而得到自己模块一个独有的模型
    BOOL canHandle = NO;
    if (self.canHandleURLBlock) {
        canHandle = self.canHandleURLBlock(url);
    }
    
    return canHandle;
}

- (BOOL)canHandleChainHandleURL:(NSURL *)url {
    BOOL canHandle = [self canHandleURL:url];
    if (!canHandle) {
        LTURLHandlerItem *parentHander = self.parentHander;
        do {
            canHandle = [parentHander canHandleURL:url];
            if (canHandle) {
                break;
            }
        } while (parentHander);
    }
    
    return NO;
}

- (void)handleURL:(NSURL *)url {
    if ([self canHandleURL:url] && self.handleURLBlock) {
        self.handleURLBlock(url);
    }
}

- (void)handleChainHandleURL:(NSURL *)url {
    if ([self canHandleURL:url]) {
        [self handleURL:url];
    } else if ([self canHandleChainHandleURL:url]) {
        BOOL canHandle = NO;
        LTURLHandlerItem *parentHander = self.parentHander;
        do {
            canHandle = [parentHander canHandleURL:url];
            if (canHandle) {
                [parentHander handleURL:url];
                break;
            }
        } while (parentHander);
    }
}

#pragma mark - Getter

- (NSMutableDictionary<NSString *,LTURLHandlerItem *> *)handlerItemsDictionary {
    if (!_handlerItemsDictionary) {
        _handlerItemsDictionary = [NSMutableDictionary dictionary];
    }
    return _handlerItemsDictionary;
}

@end
