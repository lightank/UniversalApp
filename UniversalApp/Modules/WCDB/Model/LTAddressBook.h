//
//  LTAddressBook.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/4/29.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTContact.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTAddressBook : NSObject

/**  创建时间  */
@property (nonatomic, strong) NSDate *creationDate;

/**  全名称  */
@property (nonatomic, copy) NSString *fullName;

/**  电话号码  */
@property (nonatomic, copy) NSString *phoneNumber;

- (instancetype)initWithContact:(LTContact *)contact;

@end

NS_ASSUME_NONNULL_END
