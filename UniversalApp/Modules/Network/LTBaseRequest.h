//
//  LTBaseRequest.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/20.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#if __has_include(<YTKNetwork/YTKBaseRequest.h>)
#import <YTKNetwork/YTKNetwork.h>
#else
#import "YTKNetwork.h"
#endif

@class LTBaseResponse;

@interface LTBaseRequest : YTKBaseRequest

/**  响应内容  */
@property (nonatomic, strong) LTBaseResponse *responseModel;
/**  后台返回的数据是否aes加密,默认为否  */
@property (nonatomic, assign, getter=isAESEncrypted) BOOL AESEncrypted;
/**  请求头字段  */
@property (nonatomic, strong) NSMutableDictionary *arguments;

/*
 安全的设置arguments 字典内容.
 @param      value   字段数据 (NSString/NSNumber)
 @param      key     字段名称 (NSString)
 */
- (void)setArgument:(id)value forKey:(NSString*)key;

@end

@interface LTBaseResponse : NSObject

/**  code  */
@property (nonatomic, copy) NSString *code;
/**  数据  */
@property (nonatomic, copy) id data;
/**  消息内容  */
@property (nonatomic, copy) NSString *message;

/**  状态码是是否为200  */
@property (nonatomic, assign, getter=isSuccess) BOOL success;

@end
