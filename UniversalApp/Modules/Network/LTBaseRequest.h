//
//  LTBaseRequest.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/20.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#if __has_include(<YTKNetwork/YTKNetwork.h>)
#import <YTKNetwork/YTKNetwork.h>
#else
#import "YTKNetwork.h"
#endif
#import "LTBaseRequestResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTKBaseRequest (PostMan)

// 提供url字符串,方法提供给后台调试
- (NSString *)postManString;

@end

@interface LTBaseRequest : YTKBaseRequest

/**  参数字典  */
@property (nonatomic, strong) NSMutableDictionary *argumentsDictionary;
/**  是否添加MAC,默认为YES,关于MAC可查看:https://baike.baidu.com/item/MAC/329741  */
@property (nonatomic, assign) BOOL shouldAddMACArguments;
/**  是否添加公共参数,默认为YES  */
@property (nonatomic, assign) BOOL shouldAddPublicArguments;


/**  添加请求参数  */
- (void)setArgument:(id)value forKey:(NSString*)key;
/**  请求后解析json后的对应的模型,可以是这个base的子类,建议不同的请求这个模型集成自LTBaseRequestResponse  */
- (NSString *)baseResopnesModelClassName;

#pragma mark - code处理
/**  在 isRequestSuccess 为 YES 的情况下会调用这个方法,默认什么都不做,子类可以重写这个  */
- (void)requestDidSuccess;
/**  在 isVersonInvalid 为 YES 的情况下会调用这个方法,默认什么都不做,子类可以重写这个  */
- (void)versonDidInvalid;
/**  在 isTokenInvalid 为 YES 的情况下会调用这个方法,默认什么都不做,子类可以重写这个  */
- (void)tokenDidInvalid;
/**  在 isServerNotResponse 为 YES 的情况下会调用这个方法,默认什么都不做,子类可以重写这个  */
- (void)serverDidNotResponse;

@end

NS_ASSUME_NONNULL_END
