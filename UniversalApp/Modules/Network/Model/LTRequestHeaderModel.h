//
//  LTRequestHeaderModel.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/7/25.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTRequestHeaderModel : NSObject

/**  token  */
@property (nonatomic, copy) NSString *token;
/**  app版本  */
@property (nonatomic, copy) NSString *appVersion;
/**  app版本  */
@property (nonatomic, copy) NSString *platform;
/**  设备唯一标识码  */
@property (nonatomic, copy) NSString *uuid;

/**  字典形式  */
+ (NSDictionary *)requestHeaderDictionary;

@end
