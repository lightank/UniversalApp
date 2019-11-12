//
//  LTMainThreadDetector.m
//  UniversalApp
//
//  Created by huanyu.li on 2019/11/6.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTMainThreadDetector.h"
#import <objc/runtime.h>

static inline void swizzling_exchangeMethod(Class clazz ,SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    
    BOOL success = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation LTMainThreadDetector

@end


@implementation UIView (LTMainThreadDetector)

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL needsLayoutOriginalSelector = @selector(setNeedsLayout);
        SEL needsLayoutSwizzleSelector  = @selector(guard_setNeedsLayout);
        swizzling_exchangeMethod(self, needsLayoutOriginalSelector,needsLayoutSwizzleSelector);
        
        SEL needsDisplaOriginalSelector = @selector(setNeedsDisplay);
        SEL needsDisplaSwizzleSelector  = @selector(guard_setNeedsDisplay);
        swizzling_exchangeMethod(self, needsDisplaOriginalSelector,needsDisplaSwizzleSelector);
        
        SEL needsDisplayInRectOriginalSelector = @selector(setNeedsDisplayInRect:);
        SEL needsDisplayInRectSwizzleSelector  = @selector(guard_setNeedsDisplayInRect:);
        swizzling_exchangeMethod(self, needsDisplayInRectOriginalSelector,needsDisplayInRectSwizzleSelector);
        
    });
}

- (void)guard_setNeedsLayout
{
    [self UIMainThreadCheck];
    [self guard_setNeedsLayout];
}

- (void)guard_setNeedsDisplay
{
    [self UIMainThreadCheck];
    [self guard_setNeedsDisplay];
}


- (void)guard_setNeedsDisplayInRect:(CGRect)rect
{
    [self UIMainThreadCheck];
    [self guard_setNeedsDisplayInRect:rect];
}

- (void)UIMainThreadCheck
{
#ifdef DEBUG
    NSString *desc = [NSString stringWithFormat:@"%@", self.class];
    NSAssert([NSThread isMainThread], desc);
#endif
}

@end
