//
//  LTDBManager.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/8/6.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTDBManager.h"

@interface LTDBManager ()

/**  数据库  */
@property (strong,nonatomic) WCTDatabase *dataBase;

@end

@implementation LTDBManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LTDBManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (WCTDatabase *)dataBase
{
    if (!_dataBase)
    {
        // 初始化数据库
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dbPath = [documentPath stringByAppendingString:@"com.huanyu.li.sqlite"];
        _dataBase = [[WCTDatabase alloc] initWithPath:dbPath];
        
        //创建表
        if (![_dataBase isTableExists:kDataBaseName_contactTable])
        {
            __unused BOOL isCreate = [_dataBase createTableAndIndexesOfName:kDataBaseName_contactTable withClass:LTContact.class];
        }
    }
    return _dataBase;
}

//增加一条数据
+ (BOOL)insertContact:(LTContact *)contact
{
    BOOL success = [[LTDBManager sharedInstance].dataBase insertObject:contact into:kDataBaseName_contactTable];
    return success;
}

//查找某张表中所有数据
+ (NSMutableArray<LTContact *> *)allContacts
{
    NSMutableArray<LTContact *> *allContacts = @[].mutableCopy;
    WCTTable *table = [[LTDBManager sharedInstance].dataBase getTableOfName:kDataBaseName_contactTable withClass:LTContact.class];
    NSArray<LTContact *> *arr = [table getAllObjects];
    [allContacts addObjectsFromArray:arr];
    return allContacts;
}

@end

NSString * const kDataBaseName_contactTable = @"kDataBaseName_contactTable";

@implementation LTContact (DB)

//使用 WCDB_IMPLEMENTATIO 宏在类文件定义绑定到数据库表的类
WCDB_IMPLEMENTATION(LTContact)
// 约束宏定义数据库的主键
WCDB_PRIMARY(LTContact, identifier)
/*
 WCDB_PRIMARY用于定义主键
 WCDB_INDEX用于定义索引
 WCDB_UNIQUE用于定义唯一约束
 WCDB_NOT_NULL用于定义非空约束
 */
//WCDB_INDEX(LTContact, "_index", creationDate)

//使用 WCDB_SYNTHESIZE 宏在类文件定义需要绑定到数据库表的字段。
//creationDate
WCDB_SYNTHESIZE(LTContact, creationDate)
// fullName
WCDB_SYNTHESIZE(LTContact, fullName)
//identifier
WCDB_SYNTHESIZE(LTContact, identifier)

@end
