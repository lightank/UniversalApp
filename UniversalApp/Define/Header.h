//
//  Header.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#pragma mark - 系统库
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

#pragma mark - 常用工具
#import "LTKit.h"
#import "LTUserManager.h"
#import "LTLocalizations.h"

#pragma mark - 全局定义
#import "LTMacros.h"
#import "ColorMacros.h"
#import "URLString.h"

#pragma mark - --------- 第三方框架 ---------
#pragma mark - IQKeyboardManager中分类
#if __has_include(<IQKeyboardManager/IQKeyboardManager.h>)
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <IQKeyboardManager/IQUIView+Hierarchy.h>
#import <IQKeyboardManager/IQTextView.h>
#else
#import "IQKeyboardManager.h"
#import "IQUIView+Hierarchy.h"
#import "IQTextView.h"
#endif

#pragma mark - Masonry
#define MAS_SHORTHAND_GLOBALS //定义这个常量，就可以让Masonry帮我们自动把基础数据类型的数据，自动装箱为对象类型
//#define MAS_SHORTHAND //使用全局宏定义, 可以在调用masonry方法的时候不使用mas_前缀
#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

#pragma mark - SDWebImage
#if __has_include(<SDWebImage/SDWebImageManager.h>)
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>
#else
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#endif

#pragma mark - YYKit
#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYKit.h>
#else
#import "YYKit.h"
#endif

#pragma mark - FCUUID
#if __has_include(<FCUUID/UIDevice+FCUUID.h>)
#import <FCUUID/UIDevice+FCUUID.h>
#else
#import "UIDevice+FCUUID.h"
#endif

#pragma mark - QMUIKit
#if __has_include(<QMUIKit/QMUIKit.h>)
#import <QMUIKit/QMUIKit.h>
#else
#import "QMUIKit.h"
#endif

#pragma mark - ReactiveObjC
#if __has_include(<ReactiveObjC/ReactiveObjC.h>)
#import <ReactiveObjC/ReactiveObjC.h>
#else
#import "ReactiveObjC.h"
#endif
