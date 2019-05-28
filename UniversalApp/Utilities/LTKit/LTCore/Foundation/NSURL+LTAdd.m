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
    
    NSString *tempUrl = self.absoluteString.copy;
    NSString *tempParams = nil;
    NSRange tempRang = [tempUrl rangeOfString:@"?"];
    NSMutableDictionary *dict = @{}.mutableCopy;
    if (tempRang.length != 0)
    {
        tempParams = [[tempUrl substringFromIndex:tempRang.location] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    }
    
    if (tempParams.length != 0)
    {
        NSArray *tempArr = [tempParams componentsSeparatedByString:@"&"];
        [tempArr enumerateObjectsUsingBlock:^(NSString  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *para = [obj componentsSeparatedByString:@"="];
            dict[para.firstObject] = para.lastObject;
            NSLog(@"%@", para);
        }];
    }
    
    return dict;
}

@end
