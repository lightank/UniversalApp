//
//  UIView+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "UIView+LTAdd.h"
//#import "IQUIView+Hierarchy.h"

@implementation UIView (LTAdd)
// ========== x ==========
- (CGFloat)lt_left
{
    return self.frame.origin.x;
}
- (void)setLt_left:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}
// ========== y ==========
- (CGFloat)lt_top
{
    return self.frame.origin.y;
}

- (void)setLt_top:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}
// ========== size ==========
- (CGSize)lt_size
{
    return self.frame.size;
}
- (void)setLt_size:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
// ========== origin ==========
- (CGPoint)lt_origin
{
    return self.frame.origin;
}
- (void)setLt_origin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
// ========== right ==========
- (CGFloat)lt_right
{
    return CGRectGetMaxX(self.frame);
}
- (void)setLt_right:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    CGRectGetMaxX(CGRectZero);
    self.frame = frame;
}
// ========== bottom ==========
- (CGFloat)lt_bottom
{
    return CGRectGetMaxY(self.frame);
}
- (void)setLt_bottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
// ========== 宽度 ==========
- (CGFloat)lt_width
{
    return self.frame.size.width;
}
- (void)setLt_width:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
// ========== 高度 ==========
- (CGFloat)lt_height
{
    return self.frame.size.height;
}
- (void)setLt_height:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
// ========== centerX ==========
- (CGFloat)lt_centerX
{
    return self.center.x;
}
- (void)setLt_centerX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}
// ========== centerY ==========
- (CGFloat)lt_centerY
{
    return self.center.y;
}

- (void)setLt_centerY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

+ (void)lt_showOscillatoryAnimationWithLayer:(CALayer *)layer
                                        type:(LTOscillatoryAnimationType)type
{
    NSNumber *animationScale1 = type == LTOscillatoryAnimationToBigger ? @(1.15) : @(0.5);
    NSNumber *animationScale2 = type == LTOscillatoryAnimationToBigger ? @(0.92) : @(1.15);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}

// @see https://www.jianshu.com/p/8b0d27f93619
- (void)lt_printSubviewsWithIndentation:(int)indentation
{
    NSArray *subviews = [self subviews];
    
    for (int i = 0; i < [subviews count]; i++)
    {
        
        UIView *currentSubview = [subviews objectAtIndex:i];
        NSMutableString *currentViewDescription = [[NSMutableString alloc] init];
        
        for (int j = 0; j <= indentation; j++)
        {
            [currentViewDescription appendString:@"   "];
        }
        
        [currentViewDescription appendFormat:@"[%d]: class: '%@', frame=(%.1f, %.1f, %.1f, %.1f), opaque=%i, hidden=%i, userInterfaction=%i", i, NSStringFromClass([currentSubview class]), currentSubview.frame.origin.x, currentSubview.frame.origin.y, currentSubview.frame.size.width, currentSubview.frame.size.height, currentSubview.opaque, currentSubview.hidden, currentSubview.userInteractionEnabled];

        fprintf(stderr,"%s\n", [currentViewDescription UTF8String]);
        
        [currentSubview lt_printSubviewsWithIndentation:indentation+1];
    }
}

- (UIView *)lt_subviewOfClassType:(Class)classType
{
    __block UIView *subview = nil;
    
    NSArray<__kindof UIView *> *subviews = self.subviews;
    
    [subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:classType])
        {
            subview = obj;
            *stop = YES;
        }
        else
        {
            subview = [obj lt_subviewOfClassType:classType];
            if (subview) *stop = YES;
        }
    }];

    return subview;
}

- (UIView *)lt_superviewOfClassType:(Class)classType
{
    UIView *superview = self.superview;
    
    while (superview)
    {
        if ([superview isKindOfClass:classType])
        {
            //If it's UIScrollView, then validating for special cases
            if ([superview isKindOfClass:[UIScrollView class]])
            {
                NSString *classNameString = NSStringFromClass([superview class]);
                
                //  If it's not UITableViewWrapperView class, this is internal class which is actually manage in UITableview. The speciality of this class is that it's superview is UITableView.
                //  If it's not UITableViewCellScrollView class, this is internal class which is actually manage in UITableviewCell. The speciality of this class is that it's superview is UITableViewCell.
                //If it's not _UIQueuingScrollView class, actually we validate for _ prefix which usually used by Apple internal classes
                if ([superview.superview isKindOfClass:[UITableView class]] == NO &&
                    [superview.superview isKindOfClass:[UITableViewCell class]] == NO &&
                    [classNameString hasPrefix:@"_"] == NO)
                {
                    return superview;
                }
            }
            else
            {
                return superview;
            }
        }
        superview = superview.superview;
    }
    return nil;
}

- (UIViewController *)lt_viewController {
    for (UIView *view = self; view; view = view.superview)
    {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (UIViewController *)lt_topMostController
{
    NSMutableArray<UIViewController*> *controllersHierarchy = [[NSMutableArray alloc] init];
    
    UIViewController *topController = self.window.rootViewController;
    
    if (topController)
    {
        [controllersHierarchy addObject:topController];
    }
    
    while ([topController presentedViewController]) {
        
        topController = [topController presentedViewController];
        [controllersHierarchy addObject:topController];
    }
    
    UIViewController *matchController = [self lt_viewContainingController];
    
    while (matchController && [controllersHierarchy containsObject:matchController] == NO)
    {
        do
        {
            matchController = (UIViewController*)[matchController nextResponder];
            
        } while (matchController && [matchController isKindOfClass:[UIViewController class]] == NO);
    }
    
    return matchController;
}

- (UIViewController*)lt_viewContainingController
{
    UIResponder *nextResponder =  self;
    
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder);
    
    return nil;
}

- (UIViewController *)lt_parentContainerViewController
{
    UIViewController *matchController = [self lt_viewContainingController];
    
    if (matchController.navigationController)
    {
        UINavigationController *navController = matchController.navigationController;
        
        while (navController.navigationController) {
            navController = navController.navigationController;
        }
        
        UIViewController *parentController = navController;
        
        UIViewController *parentParentController = parentController.parentViewController;
        
        while (parentParentController &&
               ([parentParentController isKindOfClass:[UINavigationController class]] == NO &&
                [parentParentController isKindOfClass:[UITabBarController class]] == NO &&
                [parentParentController isKindOfClass:[UISplitViewController class]] == NO))
        {
            parentController = parentParentController;
            parentParentController = parentController.parentViewController;
        }
        
        if (navController == parentController)
        {
            return navController.topViewController;
        }
        else
        {
            return parentController;
        }
    }
    else if (matchController.tabBarController)
    {
        if ([matchController.tabBarController.selectedViewController isKindOfClass:[UINavigationController class]])
        {
            return [(UINavigationController*)matchController.tabBarController.selectedViewController topViewController];
        }
        else
        {
            return matchController.tabBarController.selectedViewController;
        }
    }
    else
    {
        UIViewController *matchParentController = matchController.parentViewController;
        
        while (matchParentController &&
               ([matchParentController isKindOfClass:[UINavigationController class]] == NO &&
                [matchParentController isKindOfClass:[UITabBarController class]] == NO &&
                [matchParentController isKindOfClass:[UISplitViewController class]] == NO))
        {
            matchController = matchParentController;
            matchParentController = matchController.parentViewController;
        }
        
        return matchController;
    }
}

- (UIView*)lt_duplicate
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

@end
