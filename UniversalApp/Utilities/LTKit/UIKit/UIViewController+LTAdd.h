//
//  UIViewController+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LTAdd)

/**  普通状态下的文字颜色  */
@property (nonatomic, strong) UIColor *lt_tabBarTitleColorNormal;
/**  选中状态下的文字颜色  */
@property (nonatomic, strong) UIColor *lt_tabBarTitleColorSelected;

/**  在当前控制器为子控制器的时候,通过修改edgesForExtendedLayout为none,来把self.view当safeArea  */
- (void)lt_setSafeArea;

@end
