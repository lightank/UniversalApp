//
//  NSObject+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/13.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LTAdd)

/**
 * 返回对象中属性的class类型,如果你用NSClassFromString()返回了nil,请检查是否把相应类加入了target,或者有无实现@implementation
 * @return NSString 返回属性的类型
 **/
+ (nullable NSString *)lt_classNameForProperty:(NSString *_Nonnull)propertyName;
- (nullable NSString *)lt_classNameForProperty:(NSString *_Nonnull)propertyName;


@end
