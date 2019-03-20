//
//  LTURLTool.m
//  UniversalApp
//
//  Created by lihuanyu on 2019/3/20.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTURLTool.h"

@implementation LTURLTool

- (NSDictionary *)queryDictionary
{
    NSMutableDictionary *queryDictionary = @{}.mutableCopy;
    for (NSURLQueryItem *queryItem in self.queryItems)
    {
        queryDictionary[queryItem.name] = queryItem.value;
    }
    return queryDictionary;
}

@end
