//
//  LTPageControl.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/5/13.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTPageControl.h"

@interface LTPageControl ()

@property(nonatomic, assign) CGSize dotDotSize;
@property(nonatomic, assign) CGSize currentDotSize;

/**
 *  Array of dot views for reusability and touch events.
 */
@property (strong, nonatomic) NSMutableArray<UIImageView *> *dots;

@end

@implementation LTPageControl

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self)
    {
        [self initialization];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialization];
    }
    return self;
}

/**
 *  Default setup when initiating control
 */
- (void)initialization
{
    self.spacingBetweenDots = 8;
    self.numberOfPages = 0;
    self.currentPage = 0;
    self.hidesForSinglePage = NO;
    self.shouldResizeFromCenter = YES;
}

#pragma mark - Touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view != self)
    {
        NSInteger index = [self.dots indexOfObject:(UIImageView *)touch.view];
        if ([self.delegate respondsToSelector:@selector(LTPageControl:didSelectPageAtIndex:)])
        {
            [self.delegate LTPageControl:self didSelectPageAtIndex:index];
        }
    }
}

#pragma mark - Layout


/**
 *  Resizes and moves the receiver view so it just encloses its subviews.
 */
- (void)sizeToFit
{
    [self updateFrame:YES];
}


- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    CGFloat width = 0;
    CGFloat height = 0;
    if (pageCount > 0 && self.dotImage && self.currentDotImage)
    {
        width = self.currentDotImage.size.width + (self.spacingBetweenDots + self.dotImage.size.width) * (pageCount - 1);
        height = MAX(self.currentDotImage.size.height, self.dotImage.size.height);
    }
    return CGSizeMake(width, height);
}

/**
 *  Will update dots display and frame. Reuse existing views or instantiate one if required. Update their position in case frame changed.
 */
- (void)updateDots
{
    if (self.numberOfPages == 0 || !self.currentDotImage || !self.dotImage)
    {
        return;
    }
    
    for (NSInteger i = 0; i < self.numberOfPages; i++)
    {
        UIImageView *dot;
        if (i < self.dots.count)
        {
            dot = [self.dots objectAtIndex:i];
        }
        else
        {
            dot = [self generateDotView];
        }
        
        [self updateDotFrame:dot atIndex:i];
    }

    [self hideForSinglePage];
}

/**
 *  Update frame control to fit current number of pages. It will apply required size if authorize and required.
 *
 *  @param overrideExistingFrame BOOL to allow frame to be overriden. Meaning the required size will be apply no mattter what.
 */
- (void)updateFrame:(BOOL)overrideExistingFrame
{
    CGPoint center = self.center;
    CGSize requiredSize = [self sizeForNumberOfPages:self.numberOfPages];
    
    // We apply requiredSize only if authorize to and necessary
    if (overrideExistingFrame || ((CGRectGetWidth(self.frame) < requiredSize.width || CGRectGetHeight(self.frame) < requiredSize.height) && !overrideExistingFrame))
    {
        self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), requiredSize.width, requiredSize.height);
        if (self.shouldResizeFromCenter)
        {
            self.center = center;
        }
    }
    
    [self resetDotViews];
}

/**
 *  Update the frame of a specific dot at a specific index
 *
 *  @param dot   Dot view
 *  @param index Page index of dot
 */
- (void)updateDotFrame:(UIImageView *)dot atIndex:(NSInteger)index
{
    // Dots are always centered within view
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = 0;
    CGFloat height = 0;
    if (index == self.currentPage)
    {
        x = index * (self.dotImage.size.width + self.spacingBetweenDots);
        y = ABS((self.bounds.size.height - self.currentDotImage.size.height) * 0.5f);
        width = self.currentDotImage.size.width;
        height = self.currentDotImage.size.height;
        dot.image = self.currentDotImage;
    }
    else
    {
        if (index < self.currentPage)
        {
            x = (index) * (self.dotImage.size.width + self.spacingBetweenDots);
        }
        else
        {
            CGFloat currentWidth = (self.currentDotImage.size.width + self.spacingBetweenDots);
            CGFloat normalWidth = (index - 1) * (self.dotImage.size.width + self.spacingBetweenDots);
            x =  currentWidth + normalWidth;
        }
        y = ABS((self.bounds.size.height - self.dotImage.size.height) * 0.5f);
        width = self.dotImage.size.width;
        height = self.dotImage.size.height;
        dot.image = self.dotImage;
    }
    
    dot.frame = CGRectMake(x, y, width, height);
}

#pragma mark - Utils


/**
 *  Generate a dot view and add it to the collection
 *
 *  @return The UIView object representing a dot
 */
- (UIImageView *)generateDotView
{
    UIImageView *dotView;
    
    dotView = [[UIImageView alloc] initWithImage:self.dotImage];
    dotView.frame = CGRectMake(0, 0, self.dotImage.size.width, self.dotImage.size.height);
    
    if (dotView) {
        [self addSubview:dotView];
        [self.dots addObject:dotView];
    }
    
    dotView.userInteractionEnabled = YES;
    return dotView;
}

- (void)resetDotViews
{
    for (UIImageView *dotView in self.dots)
    {
        [dotView removeFromSuperview];
    }
    
    [self.dots removeAllObjects];
    [self updateDots];
}


- (void)hideForSinglePage
{
    if (self.dots.count == 1 && self.hidesForSinglePage) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}

#pragma mark - setter and getter
- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = numberOfPages;
    
    // Update dot position to fit new number of pages
    [self resetDotViews];
}


- (void)setSpacingBetweenDots:(CGFloat)spacingBetweenDots
{
    _spacingBetweenDots = spacingBetweenDots;
    
    [self resetDotViews];
}


- (void)setCurrentPage:(NSInteger)currentPage
{
    // If no pages, no current page to treat.
    if (self.numberOfPages == 0 || currentPage == _currentPage)
    {
        _currentPage = currentPage;
        return;
    }

    _currentPage = currentPage;
    [self updateDots];
}


- (void)setDotImage:(UIImage *)dotImage
{
    _dotImage = dotImage;
    [self resetDotViews];
}


- (void)setCurrentDotImage:(UIImage *)currentDotimage
{
    _currentDotImage = currentDotimage;
    [self resetDotViews];
}

- (NSMutableArray *)dots
{
    if (!_dots)
    {
        _dots = [[NSMutableArray alloc] init];
    }
    
    return _dots;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateDots];
}

@end
