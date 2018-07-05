//
//  LTBaseRequest.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/20.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTBaseRequest.h"

//后台返回的通用表示状态码的字段
#define kStatusKey @"status"
//后台返回的通用表示消息的字段
#define kMessageKey @"message"

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
    
    [self.arguments setObject:value forKey:key];
}

/** 请求头部设置 */
- (NSDictionary *)requestHeaderFieldValueDictionary
{
    //uuid   => 设备ID值
    //version => app当前版本
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
    NSDictionary *info = self.responseJSONObject;
    //NSString *status= ((NSNumber *)info[kStatusKey]).stringValue;  //status为与后台商定好的状态码key
    NSString *status= info[kStatusKey];  //status为与后台商定好的状态码key
    if ([status isEqualToString:@"200"])
    {
        self.isSuccess = YES;
        if (self.isAESEncrypted)
        {
            //把返回的结果aes解密
            
        }
        else
        {
            self.result = self.responseJSONObject;
        }
    }
    else
    {
        self.message = info[kMessageKey];
        if ([status integerValue] == 9999)   //与后台协商好的,当前用户登录状态实现时的状态码456
        {
            //当前用户登录失效时要做的事
        }
        else
        {
            
        }
    }
}

/** 请求失败过滤器 */
- (void)requestFailedFilter
{
    //当前请求失效时要做的事
    
}

@end
