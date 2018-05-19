//
//  NSString+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LTAdd)

/**  是否是http/https链接  */
- (BOOL)isHTTPScheme;
/**  是否是本地file链接  */
- (BOOL)isLocalFileScheme;

/**  阿拉伯数字转中文  */
- (NSString *)numbersToChinese;
+ (NSString *)numbersToChinese:(double)number;

@end
