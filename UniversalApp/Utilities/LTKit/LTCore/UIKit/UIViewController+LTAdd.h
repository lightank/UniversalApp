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

- (void)lt_moveToParentViewController:(UIViewController *)parentViewController;
- (void)lt_removeFromParentViewController:(UIViewController *)parentViewController;

@end

/*
 iOS7后，坐标(0, 0)从整个屏幕的左上顶点开始计算。
 
 一下几个属性影响self.view布局
 // 扩展边缘布局
 @property(nonatomic,assign) UIRectEdge edgesForExtendedLayout NS_AVAILABLE_IOS(7_0); // Defaults to UIRectEdgeAll
 // 在NavigationBar.translucent = NO;的情况下self.view会从导航栏下方开始布局,如果controller.extendedLayoutIncludesOpaqueBars = YES,那么还是会从原点开始布局
 @property(nonatomic,assign) BOOL extendedLayoutIncludesOpaqueBars NS_AVAILABLE_IOS(7_0); // Defaults to NO, but bars are translucent by default on 7_0.
 // 针对scrollview
 @property(nonatomic,assign) BOOL automaticallyAdjustsScrollViewInsets API_DEPRECATED("Use UIScrollView's contentInsetAdjustmentBehavior instead", ios(7.0,11.0),tvos(7.0,11.0)); // Defaults to YES
 
 // This controls whether this view controller takes over control of the status bar's appearance when presented non-full screen on another view controller. Defaults to NO.
 //  指定一个视图控制器是否出现非全屏，接管的状态栏从外观上呈现的视图控制器控制
 @property(nonatomic,assign) BOOL modalPresentationCapturesStatusBarAppearance NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
 
 
 子控制器：
 
 //添加一个 childViewController
 UIViewController *vc = [UIViewController new];//子控制器
 [self addChildViewController:vc];//添加到父控制器中
 vc.view.frame = CGRectMake( 0,0,100,100);//设置 frame
 [self.view addSubview:vc.view];//把子控制器的 view 添加到父控制器的 view 上面
 [vc didMoveToParentViewController:self];  //子控制器被通知有了一个父控制器

 //移除一个 childViewController
 [vc willMoveToParentViewController:nil];//子控制器被通知即将解除父子关系
 [vc.view removeFromSuperview];//把子控制器的 view 从到父控制器的 view 上面移除
 [vc removeFromParentViewController];//真正的解除关系,会自己调用 [vc didMoveToParentViewController:nil]
 
 */
