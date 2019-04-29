//
//  LTAddressBook.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/4/29.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTAddressBook.h"
//#import <WCDB/WCDB.h>

@interface LTAddressBook ()

@end

@implementation LTAddressBook


//WCDB_IMPLEMENTATION(LTAddressBook)
//WCDB_SYNTHESIZE(LTAddressBook, creationDate)
//WCDB_SYNTHESIZE(LTAddressBook, fullName)
//WCDB_SYNTHESIZE(LTAddressBook, phoneNumber)
- (instancetype)initWithContact:(LTContact *)contact
{
    if (self = [super init])
    {
        _creationDate = contact.creationDate;
        _fullName = contact.fullName.copy;
        _phoneNumber = contact.phones.lastObject.phone.copy;
    }
    return self;
}

@end
