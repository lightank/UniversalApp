//
//  UIWindow+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//  该文件从IQKeyboardManager复制而来

#import <UIKit/UIKit.h>

#define kCurrentViewController ((([UIApplication sharedApplication].keyWindow) ? : ([UIApplication sharedApplication].delegate.window)).lt_currentViewController)

@interface UIWindow (LTAdd)

///----------------------
/// @name viewControllers
///----------------------

/**
 Returns the current Top Most ViewController in hierarchy.
 */
@property (nullable, nonatomic, readonly, strong) UIViewController *lt_topMostWindowController;

/**
 Returns the topViewController in stack of topMostWindowController.
 */
@property (nullable, nonatomic, readonly, strong) UIViewController *lt_currentViewController;


@end
