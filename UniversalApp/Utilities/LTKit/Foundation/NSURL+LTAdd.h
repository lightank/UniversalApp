//
//  NSURL+LTAdd.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/4/3.
//  Copyright © 2019 huanyu.li. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSURL (LTAdd)

/**
 *  获取当前 query 的参数列表。
 *
 *  @return query 参数列表，以字典返回。如果 absoluteString 为 nil 则返回 nil
 */
@property(nonatomic, copy, readonly) NSDictionary<NSString *, NSString *> *lt_queryItems;


@end

NS_ASSUME_NONNULL_END
