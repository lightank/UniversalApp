//
//  LTDBManager.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/8/6.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTContact.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTDBManager : NSObject


//增加一条数据
+ (BOOL)insertContact:(LTContact *)contact;
//查找某张表中所有数据
+ (NSMutableArray<LTContact *> *)allContacts;

@end

extern NSString * const kDataBaseName_contactTable;

// 定义该类遵循WCTTableCoding协议。可以在类声明上定义，也可以通过文件模版在category内定义。
@interface LTContact (DB) <WCTTableCoding>

//使用 WCDB_PROPERTY 宏在头文件声明需要绑定到数据库表的字段，在.mm中绑定
WCDB_PROPERTY(creationDate)
WCDB_PROPERTY(fullName)
WCDB_PROPERTY(identifier)

@end

@interface LTPhone (DB) <WCTTableCoding>

WCDB_PROPERTY(identifier)
WCDB_PROPERTY(phone)
WCDB_PROPERTY(label)

@end

NS_ASSUME_NONNULL_END
