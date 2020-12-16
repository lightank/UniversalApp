//
//  NSURL+LTRounter.m
//  UniversalApp
//
//  Created by huanyu.li on 2020/12/16.
//  Copyright © 2020 huanyu.li. All rights reserved.
//

#import "NSURL+LTRounter.h"

@implementation NSURL (LTRounter)

- (NSDictionary<NSString *, NSString *> *)lt_queryComponents
{
    NSMutableDictionary *queryItems = [NSMutableDictionary new];
    NSURLComponents *component = [[NSURLComponents alloc] initWithString:self.absoluteString];
    
    for (NSURLQueryItem *queryItem in component.queryItems) {
        queryItems[queryItem.name] = queryItem.value;
    }
    
    return queryItems.copy;
}

- (NSDictionary<NSString *,NSArray<NSString *> *> *)lt_standardQueryComponents
{
    return [[self.query lt_dictionaryFromQueryComponents] copy];
}

- (NSArray<NSString *> *)lt_pathComponents
{
    NSMutableArray *components = [NSMutableArray array];
    if (self.pathComponents.count > 0) {
        [self.pathComponents enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isEqualToString:@"/"]) {
                [components addObject:obj];
            }
        }];
    }
    return [components copy];
}

@end

@implementation NSString (LTRounter)

- (NSString *)lt_stringByDecodingURLFormat
{
    NSString *result = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
//    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    result = [result stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    return result;
}

- (NSString *)lt_stringByEncodingURLFormat
{
    NSString *result = [self stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    result = [result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    result = [result stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    return result;
}

- (NSDictionary<NSString *, NSArray<NSString *> *> *)lt_dictionaryFromQueryComponents
{
    NSString *queryString = self;
    NSMutableDictionary *queryComponents = [NSMutableDictionary dictionary];
    NSRange questionCharRange = [queryString rangeOfString:@"?"];
    if (questionCharRange.location != NSNotFound) {
        NSUInteger index= questionCharRange.location+questionCharRange.length;
        queryString = [queryString substringFromIndex:index];
    }
    
    for(NSString *keyValuePairString in [queryString componentsSeparatedByString:@"&"])
    {
        NSArray *keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        if ([keyValuePairArray count] < 2) continue; // Verify that there is at least one key, and at least one value.  Ignore extra = signs
        NSString *key = [[keyValuePairArray objectAtIndex:0] lt_stringByDecodingURLFormat];
        NSString *value = [[keyValuePairArray objectAtIndex:1] lt_stringByDecodingURLFormat];
        NSMutableArray *results = [queryComponents objectForKey:key]; // URL spec says that multiple values are allowed per key
        if(!results) // First object
        {
            results = [NSMutableArray arrayWithCapacity:1];
            [queryComponents setValue:results forKey:key];
        }
        if (value) {
            [results addObject:value];
        }
    }
    return [queryComponents copy];
}

- (NSString *)lt_valueFromQueryComponentsWithKey:(NSString *)key
{
    NSMutableDictionary *queryComponents = [self.lt_dictionaryFromQueryComponents mutableCopy];
    
    if ([queryComponents objectForKey:key]) {
        NSArray *paramArray = queryComponents[key];
        return paramArray.firstObject;
    } else {
        return nil;
    }
}

@end
