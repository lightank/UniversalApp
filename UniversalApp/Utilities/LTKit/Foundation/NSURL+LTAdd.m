//
//  NSURL+LTAdd.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/4/3.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "NSURL+LTAdd.h"

@implementation NSURL (LTAdd)

- (NSDictionary<NSString *, NSString *> *)lt_queryItems
{
    if (!self.absoluteString.length)
    {
        return nil;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:self.absoluteString];
    
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name) {
            [params setObject:obj.value ?: [NSNull null] forKey:obj.name];
        }
    }];
    return [params copy];
}

@end
