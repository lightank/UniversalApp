//
//  NSArray+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/20.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LTAdd)

/**  打乱数组元素顺序  */
- (nullable NSArray *)lt_randomArray;
/**  从yymodel里copy出来的  */
+ (nullable NSArray *)lt_arrayWithJSON:(id _Nonnull )json;

@end
