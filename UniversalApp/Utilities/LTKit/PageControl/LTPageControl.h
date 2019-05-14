//
//  LTPageControl.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/5/13.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LTPageControlDelegate;

@interface LTPageControl : UIControl

/**
 *  UIImage to represent a dot.
 */
@property (nonatomic) UIImage *dotImage;


/**
 *  UIImage to represent current page dot.
 */
@property (nonatomic) UIImage *currentDotImage;

/**
 *  Spacing between two dot views. Default is 8.
 */
@property (nonatomic) CGFloat spacingBetweenDots;

/**
 *  Number of pages for control. Default is 0.
 */
@property (nonatomic) NSInteger numberOfPages;

/**
 *  Current page on which control is active. Default is 0.
 */
@property (nonatomic) NSInteger currentPage;

/**
 *  Hide the control if there is only one page. Default is NO.
 */
@property (nonatomic) BOOL hidesForSinglePage;

/**
 *  Let the control know if should grow bigger by keeping center, or just get longer (right side expanding). By default YES.
 */
@property (nonatomic) BOOL shouldResizeFromCenter;

/**
 *  Return the minimum size required to display control properly for the given page count.
 *
 *  @param pageCount Number of dots that will require display
 *
 *  @return The CGSize being the minimum size required.
 */
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

/**
 * Delegate for TAPageControl
 */
@property(nonatomic,assign) id<LTPageControlDelegate> delegate;


@end


@protocol LTPageControlDelegate <NSObject>

@optional
- (void)LTPageControl:(LTPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
