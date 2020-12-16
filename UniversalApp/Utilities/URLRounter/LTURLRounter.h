//
//  LTURLRounter.h
//  UniversalApp
//
//  Created by huanyu.li on 2020/12/16.
//  Copyright © 2020 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTURLHandlerItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTURLRounter : NSObject

@property (class, nonatomic, strong, readonly) LTURLRounter *sharedInstance;
@property (nonatomic, strong, readonly) LTURLHandlerItem *rootHandler;

/// 找到最适合处理这个url的模块，如果没有就返回nil
/// @param url url
- (nullable LTURLHandlerItem *)bestHandlerForURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
