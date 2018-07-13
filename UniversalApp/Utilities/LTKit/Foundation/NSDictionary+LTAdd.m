//
//  NSDictionary+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/13.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "NSDictionary+LTAdd.h"

@implementation NSDictionary (LTAdd)

+ (NSDictionary *)dictionaryWithJSON:(id)json
{
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

@end
