//
//  LTURLHandlerItem.h
//  UniversalApp
//
//  Created by huanyu.li on 2020/12/16.
//  Copyright © 2020 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTURLHandlerItem : NSObject

/// 当前模块名字
@property (nonatomic, copy) NSString *name;
/// 包含所有子模块的字典，key是模块名字，value是模块对象
@property (nonatomic, strong) NSMutableDictionary<NSString *, LTURLHandlerItem *> *handlerItemsDictionary;
/// 父模块
@property (nonatomic, weak, nullable) LTURLHandlerItem *parentHander;
/// 如果不想子类化，可以设置这个block来实现返回
@property(nonatomic, copy, nullable) BOOL (^canHandleURLBlock)(NSURL *url);
/// 如果不想子类化，可以设置这个block来实现返回
@property(nonatomic, copy, nullable) void (^handleURLBlock)(NSURL *url);

- (void)registerHandler:(LTURLHandlerItem *)handlerItem;
- (void)unregisterHandler:(LTURLHandlerItem *)handlerItem;
- (void)unregisterHandlerWithName:(NSString *)handlerItemName;

/// 当前模块是否解析这个URL
/// @param url 解析的URL
- (BOOL)canHandleURL:(NSURL *)url;
/// 当前模块链是否解析这个URL，如果当前模块解析不了，会一层一层找自己的父模块，直到能解析或者父模块为空
/// @param url 解析的URL
- (BOOL)canHandleChainHandleURL:(NSURL *)url;
/// 处理这个URL，如果当前模块解析不了，直接返回
/// @param url 解析的URL
- (void)handleURL:(NSURL *)url;
/// 模块链处理这个URL这个URL，如果当前模块处理不了，直到找到能处理的模块去处理，如果没有就丢弃
/// @param url 解析的URL
- (void)handleChainHandleURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
