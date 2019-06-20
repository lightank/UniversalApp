//
//  LTBaseRequestResponse.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/25.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LTBaseRequestResponse <NSObject>

@optional
/**  错误信息,在请求失败时的错误信息,如果后台返回的 msg 有值就返回值,没有值就返回一个默认值:抱歉，当前访问用户过多，请稍后重试  */
- (NSString *)errorMessage;
/**  是否请求成功,响应体里code是否为200  */
- (BOOL)isRequestSuccess;
/**  是否token失效,响应体里code是否为1000006  */
- (BOOL)isTokenInvalid;
/**  是否版本失效,响应体里code是否为10000061  */
- (BOOL)isVersonInvalid;
/**  是否服务器500错误,响应头里code是否为500  */
- (BOOL)isServerNotResponse;

@end

@interface LTBaseRequestResponse : NSObject <LTBaseRequestResponse>

/**  code  */
@property (nonatomic, copy) NSString *code;
/**  数据  */
@property (nonatomic, copy) id data;
/**  消息内容  */
@property (nonatomic, copy) NSString *message;


@end

NS_ASSUME_NONNULL_END
