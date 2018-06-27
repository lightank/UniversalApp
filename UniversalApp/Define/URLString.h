//
//  URLString.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#ifndef URLString_h
#define URLString_h
//UIKIT_EXTERN

#pragma mark - 网络请求Api接口url
typedef NSString * URLString;
static URLString const loginURL = @"user/login.do";


#pragma mark - H5的url
typedef NSString * H5URLString;
static H5URLString const loginH5URL = @"app/login.html";

#pragma mark - image的url
typedef NSString * ImageURLString;
static ImageURLString const avatarImageURL = @"user/avatar.png";


#endif /* URLString_h */
