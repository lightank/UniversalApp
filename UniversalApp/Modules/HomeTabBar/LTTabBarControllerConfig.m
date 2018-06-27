//
//  LTTabBarControllerConfig.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTTabBarControllerConfig.h"
#import "LTNavigationController.h"
#import "LTFirstViewController.h"

@interface LTTabBarControllerConfig () <UITabBarControllerDelegate>

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;

@end

@implementation LTTabBarControllerConfig

/**
 *  lazy load tabBarController
 *
 *  @return CYLTabBarController
 */
- (CYLTabBarController *)tabBarController
{
    if (_tabBarController == nil) {
        CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:[self viewControllers] tabBarItemsAttributes:[self tabBarItemsAttributesForController]];
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}

- (NSArray *)viewControllers
{
    UIViewController *firstViewController = [[LTFirstViewController alloc] init];
    firstViewController.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *firstNavigationController = [[LTNavigationController alloc] initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [[UIViewController alloc] init];
    secondViewController.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *secondNavigationController = [[LTNavigationController alloc] initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [[UIViewController alloc] init];
    thirdViewController.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *thirdNavigationController = [[LTNavigationController alloc] initWithRootViewController:thirdViewController];
    
    UIViewController *fourthViewController = [[UIViewController alloc] init];
    fourthViewController.view.backgroundColor = [UIColor whiteColor];
    UINavigationController *fourthNavigationController = [[LTNavigationController alloc] initWithRootViewController:fourthViewController];
    
    NSArray *viewControllers = @[
                                 firstNavigationController,
                                 secondNavigationController,
                                 thirdNavigationController,
                                 fourthNavigationController
                                 ];
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController
{
    NSDictionary *firstTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"第一个",
                                                 CYLTabBarItemImage : @"image1",  /* NSString and UIImage are supported*/
                                                 CYLTabBarItemSelectedImage : @"image1_sel", /* NSString and UIImage are supported*/
                                                 };
    NSDictionary *secondTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"第二个",
                                                  CYLTabBarItemImage : @"image2",
                                                  CYLTabBarItemSelectedImage : @"image2_sel",
                                                  };
    NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"第三个",
                                                 CYLTabBarItemImage : @"image3",
                                                 CYLTabBarItemSelectedImage : @"image3_sel",
                                                 };
    NSDictionary *fourthTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"第四个",
                                                  CYLTabBarItemImage : @"image4",
                                                  CYLTabBarItemSelectedImage : @"image4_sel"
                                                  };
    NSArray *tabBarItemsAttributes = @[
                                       firstTabBarItemsAttributes,
                                       secondTabBarItemsAttributes,
                                       thirdTabBarItemsAttributes,
                                       fourthTabBarItemsAttributes
                                       ];
    return tabBarItemsAttributes;
}

@end

