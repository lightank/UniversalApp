//
//  LTBaseRequestResponse.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/25.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTBaseRequestResponse.h"

//*********************** 状态码,这个是跟后台讨论的 ***********************
typedef NSString *LTResponseCode NS_EXTENSIBLE_STRING_ENUM;
// 请求成功 code
static LTResponseCode const kPublicResponseSuccessCode = @"200";
// token失效 code
static LTResponseCode const kPublicResponseTokenInvalidCode = @"111111";
// 版本失效 code
static LTResponseCode const kPublicResponseVersonInvalidCode = @"222222";
// 服务器500错误
static LTResponseCode const kPublicResponseServerNotResponseCode = @"500";

@implementation LTBaseRequestResponse

/**  错误信息,在请求失败时的错误信息,如果后台返回的 msg 有值就返回值,没有值就返回一个默认值:抱歉，当前访问用户过多，请稍后重试  */
- (NSString *)errorMessage
{
    NSString *errorMessage = nil;
    if ([self isRequestSuccess])
    {
        errorMessage = nil;
    }
    else if ([self isTokenInvalid])
    {
        errorMessage = self.message;
    }
    else if ([self isVersonInvalid])
    {
        errorMessage = self.message;
    }
    else if ([self isServerNotResponse])
    {
        errorMessage = self.message ? : @"当前用户过多,请稍后重试";
    }
    
    return errorMessage;
}
/**  是否请求成功  */
- (BOOL)isRequestSuccess
{
    return [self.message isEqualToString:kPublicResponseSuccessCode];
}
/**  是否token失效  */
- (BOOL)isTokenInvalid
{
    return [self.message isEqualToString:kPublicResponseTokenInvalidCode];
}
/**  是否版本失效  */
- (BOOL)isVersonInvalid
{
    return [self.message isEqualToString:kPublicResponseTokenInvalidCode];
}
/**  是否服务器500错误  */
- (BOOL)isServerNotResponse
{
    return [self.message isEqualToString:kPublicResponseServerNotResponseCode];
}

@end
