//
//  LTBaseRequest.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/20.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTBaseRequest.h"

@implementation LTBaseRequest

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.arguments = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setArgument:(id)value forKey:(NSString*)key
{
    if (value == NULL || [value isKindOfClass:[NSNull class]] || key == NULL || [key isKindOfClass:[NSNull class]])
    {
        NSLog(@"--401-->setArgument:key: 参数为空,检测调用代码块...");
        return;
    }
    
    self.arguments[key] = value;
}

/** 请求头部设置 */
- (NSDictionary *)requestHeaderFieldValueDictionary
{
    NSDictionary *headerDictionary=@{
                                     @"uuid": @"uuid", //把value自行替换为设备uuid
                                     @"version": @"version", //把value自行替换为app版本号
                                     };
    return headerDictionary;
}

/** 请求参数 */
- (nullable id)requestArgument
{
    return self.arguments;
}

/** 请求方式,默认为post */
- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

/** 定义返回数据格式，若是加密要用HTTP接受 */
-(YTKResponseSerializerType)responseSerializerType
{
    if (self.isAESEncrypted)
    {
        return YTKResponseSerializerTypeHTTP;
    }
    return YTKResponseSerializerTypeJSON;
}

/** 请求超时时间 */
- (NSTimeInterval)requestTimeoutInterval
{
    return 20; //秒
}

/** 请求成功过滤器 */
- (void)requestCompleteFilter
{
    self.responseModel = [LTBaseResponse modelWithJSON:self.responseJSONObject];
    if (!self.responseModel) return;
    if (self.responseModel.isSuccess)
    {
        if (self.isAESEncrypted)
        {
            // 进行内容解密
        }
    }
}

/** 请求失败过滤器 */
- (void)requestFailedFilter
{
    //当前请求失效时要做的事
    
}

- (BOOL)statusCodeValidator
{
    return YES;
}

@end


@implementation LTBaseResponse

- (BOOL)isSuccess
{
    // 跟后台约定的ok状态码
    return self.code.integerValue == 200;
}

@end
