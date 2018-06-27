//
//  LTBaseRequest.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/20.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#if __has_include(<YTKNetwork/YTKBaseRequest.h>)
#import <YTKNetwork/YTKBaseRequest.h>
#else
#import "YTKBaseRequest.h"
#endif

@interface LTBaseRequest : YTKBaseRequest

/**  后台返回的数据是否aes加密,默认为否  */
@property (nonatomic, assign) BOOL isAESEncrypted;
/**  是否请求成功,即状态码是否为200  */
@property (nonatomic, assign) BOOL isSuccess;
/**  服务器返回的数据,如果是aes加密的话,那么已解密  */
@property (nonatomic, strong) NSDictionary *result;
/**  请求头字段  */
@property (nonatomic, strong) NSMutableDictionary *arguments;

/*
 安全的设置arguments 字典内容.
 @param      value   字段数据 (NSString/NSNumber)
 @param      key     字段名称 (NSString)
 */
- (void)setArgument:(id)value forKey:(NSString*)key;


@end
