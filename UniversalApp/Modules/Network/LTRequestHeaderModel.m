//
//  LTRequestHeaderModel.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/25.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTRequestHeaderModel.h"

@implementation LTRequestHeaderModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _token = @"";
        _appVersion = @"";
        _platform = @"iOS";
        _uuid = @"";
    }
    return self;
}

+ (NSDictionary *)requestHeaderDictionary
{
    LTRequestHeaderModel *model = [[LTRequestHeaderModel alloc] init];
    NSDictionary *modelDict = [model modelToJSONObject];
    return modelDict;
}

@end
