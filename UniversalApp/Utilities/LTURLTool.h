//
//  LTURLTool.h
//  UniversalApp
//
//  Created by lihuanyu on 2019/3/20.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTURLTool : NSURLComponents

@property (nullable, readonly) NSDictionary *queryDictionary;

@end

NS_ASSUME_NONNULL_END
