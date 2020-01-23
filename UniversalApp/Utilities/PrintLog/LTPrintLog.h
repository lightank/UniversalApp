//
//  LTPrintLog.h
//  UniversalApp
//
//  Created by huanyu.li on 2020/1/23.
//  Copyright © 2020 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LTPrintLog)

/// 将 obj 转换成 JSON 字符串。如果失败则返回nil.
- (NSString *)lt_convertToJsonString;

@end

@interface NSDictionary (LTPrintLog)

@end

@interface NSArray (LTPrintLog)

@end
