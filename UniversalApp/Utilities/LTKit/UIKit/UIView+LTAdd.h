//
//  UIView+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQKeyboardManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LTOscillatoryAnimationType) {
    LTOscillatoryAnimationToBigger,
    LTOscillatoryAnimationToSmaller,
};

// ========== frame相关 ==========
@interface UIView (LTAdd)

@property (nonatomic, assign) CGFloat lt_left;
@property (nonatomic, assign) CGFloat lt_top;
@property (nonatomic, assign) CGSize lt_size;
@property (nonatomic, assign) CGPoint lt_origin;
/**  在有宽度情况下,设置右边(最大x值)  */
@property (nonatomic, assign) CGFloat lt_right;
/**  在有高度情况下,设置底部(最大y值)  */
@property (nonatomic, assign) CGFloat lt_bottom;
/**  宽度  */
@property (nonatomic, assign) CGFloat lt_width;
/**  高度  */
@property (nonatomic, assign) CGFloat lt_height;
/**  centerX  */
@property (nonatomic, assign) CGFloat lt_centerX;     ///< Shortcut for center.x
/**  centerY  */
@property (nonatomic, assign) CGFloat lt_centerY;     ///< Shortcut for center.y

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(LTOscillatoryAnimationType)type;

- (UIView *)subviewOfClassType:(Class)classType;
/**  完全复制一个视图的内容.UIButton的Target.Action复制不过来  */
- (UIView*)duplicate;

@end

NS_ASSUME_NONNULL_END






