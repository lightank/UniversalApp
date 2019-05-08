//
//  LTScreenshotCapture.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/5/8.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

/*
 SDScreenshotCapture: https://github.com/shinydevelopment/SDScreenshotCapture
 TYSnapshotScroll: https://github.com/TonyReet/TYSnapshotScroll
 */

#import "LTScreenshotCapture.h"

@implementation LTScreenshotCapture

+ (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) imageSize = [UIScreen mainScreen].bounds.size;
    else imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

+ (UIImage *)imageWithScreenshot
{
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

+ (void)takeScreenshotToActivityViewController
{
    if ([UIActivityViewController class] == nil) {
        NSLog(@"UIActivityViewController is not supported on iOS versions less than 6.0");
        return;
    }
    
    UIImage *image = [self imageWithScreenshot];
    UIViewController *topViewController = [self currentViewController];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[ image ] applicationActivities:nil];
    [topViewController presentViewController:controller animated:YES completion:nil];
}

+ (void)takeScreenshotToCameraRoll
{
    UIImage *image = [self imageWithScreenshot];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

+ (void)takeScreenshotToDocumentsDirectory
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    [self takeScreenshotToDirectoryAtPath:documentsPath];
}

+ (void)takeScreenshotToDirectoryAtPath:(NSString *)path
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"Y-MM-d HH-mm-ss-SSS"];
    }
    
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    NSString *imageFileName = [NSString stringWithFormat:@"%@.png", [dateFormatter stringFromDate:[NSDate date]]];
    NSString *imagePath = [path stringByAppendingPathComponent:imageFileName];
    [[NSFileManager defaultManager] createFileAtPath:imagePath contents:imageData attributes:nil];
}

+ (void)screenSnapshot:(UIView *)snapshotView finish:(void(^)(UIImage *snapShotImage))finishBlock;
{
    if (!finishBlock)
    {
        finishBlock(nil);
        return;
    }
    
    if (![snapshotView isKindOfClass:[UIView class]])
    {
        if (finishBlock)
        {
            finishBlock(nil);
            return;
        }
    }
        
    UIView *snapshotFinalView = snapshotView;
    if([snapshotView isKindOfClass:[WKWebView class]])
    {
        //WKWebView
        snapshotFinalView = (WKWebView *)snapshotView;
        [self WKWebViewSnapshot:(WKWebView *)snapshotFinalView finish:^(UIImage *snapShotImage) {
            if (snapShotImage != nil && finishBlock)
            {
                finishBlock(snapShotImage);
            }
        }];
    }
    else if([snapshotView isKindOfClass:[UIWebView class]])
    {
        //UIWebView
        UIWebView *webView = (UIWebView *)snapshotView;
        snapshotFinalView = webView.scrollView;
        [self UIScrollViewSnapshot:(UIScrollView *)snapshotFinalView finish:^(UIImage *snapShotImage) {
            if (snapShotImage && finishBlock)
            {
                finishBlock(snapShotImage);
            }
        }];
    }
    else if([snapshotView isKindOfClass:[UIScrollView class]] ||
             [snapshotView isKindOfClass:[UITableView class]] ||
             [snapshotView isKindOfClass:[UICollectionView class]])
    {
        //ScrollView
        snapshotFinalView = (UIScrollView *)snapshotView;
        [self UIScrollViewSnapshot:(UIScrollView *)snapshotFinalView finish:^(UIImage *snapShotImage) {
            if (snapShotImage && finishBlock)
            {
                finishBlock(snapShotImage);
            }
        }];
    }
    else if([snapshotView isKindOfClass:[UIView class]])
    {
        [self UIViewSnapshot:snapshotFinalView finish:^(UIImage *snapShotImage) {
            if (snapShotImage && finishBlock)
            {
                finishBlock(snapShotImage);
            }
        }];
    }
    else
    {
        NSLog(@"不支持的类型");
    }
}

#pragma mark - UIView
+ (void)UIViewSnapshot:(UIView *)snapshotView finish:(void(^)(UIImage *snapShotImage))finishBlock
{
    if (!finishBlock)
    {
        finishBlock(nil);
        return;
    }
    UIImage *snapshotImage = nil;
    UIGraphicsBeginImageContextWithOptions(snapshotView.bounds.size,NO,[UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [snapshotView.layer renderInContext:context];
    snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    finishBlock(snapshotImage);
}

#pragma mark - WKWebView
+ (void)WKWebViewSnapshot:(WKWebView *)snapshotView finish:(void(^)(UIImage *snapShotImage))finishBlock
{
    if (!finishBlock)
    {
        finishBlock(nil);
        return;
    }
    
    WKWebView *webView = snapshotView;
    //获取父view
    UIView *superview;
    UIViewController *currentViewController = [self currentViewController];
    if (currentViewController)
    {
        superview = currentViewController.view;
    }
    else
    {
        superview = webView.superview;
    }
    
    //添加遮盖
    UIView *snapShotView = [superview snapshotViewAfterScreenUpdates:YES];
    snapShotView.frame = CGRectMake(superview.frame.origin.x, superview.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height);
    
    [superview addSubview:snapShotView];
    
    //保存原始信息
    CGRect oldFrame = webView.frame;
    CGSize contentSize = webView.scrollView.contentSize;
    CGPoint oldOffset = webView.scrollView.contentOffset;
    
    //计算快照屏幕数
    NSUInteger snapshotScreenCount = floorf(contentSize.height / webView.scrollView.bounds.size.height);
    
    //设置frame为contentSize
    webView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    webView.scrollView.contentOffset = CGPointZero;
    
    UIGraphicsBeginImageContextWithOptions(contentSize, NO, [UIScreen mainScreen].scale);
    
    __weak typeof(webView) weakWebView = webView;
    //截取完所有图片
    [self WKWebView:webView scrollToDraw:0 maxIndex:(NSInteger )snapshotScreenCount finishBlock:^{
        [snapShotView removeFromSuperview];
        UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        weakWebView.frame = oldFrame;
        weakWebView.scrollView.contentOffset = oldOffset;
        finishBlock(snapshotImage);
    }];
}

//滑动画了再截图
+ (void)WKWebView:(WKWebView *)wkWebView scrollToDraw:(NSInteger )index maxIndex:(NSInteger )maxIndex finishBlock:(void(^)(void))finishBlock
{
    if (!finishBlock)
    {
        return;
    }
    
    UIView *snapshotView = wkWebView.superview;
    
    //截取的frame
    CGRect snapshotFrame = CGRectMake(0, (float)index * snapshotView.bounds.size.height, snapshotView.bounds.size.width, snapshotView.bounds.size.height);
    
    // set up webview originY
    CGRect myFrame = wkWebView.frame;
    myFrame.origin.y = -((index) * snapshotView.frame.size.height);
    wkWebView.frame = myFrame;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [snapshotView drawViewHierarchyInRect:snapshotFrame afterScreenUpdates:YES];
        if(index < maxIndex)
        {
            [self WKWebView:wkWebView scrollToDraw:index + 1 maxIndex:maxIndex finishBlock:finishBlock];
        }
        else
        {
            if (finishBlock)
            {
                finishBlock();
            }
        }
    });
}

#pragma mark - UIScrollView
+ (void)UIScrollViewSnapshot:(UIScrollView *)snapshotView finish:(void(^)(UIImage *snapShotImage))finishBlock
{
    if (!finishBlock)
    {
        finishBlock(nil);
        return;
    }
    
    __block UIImage* snapshotImage = nil;
    
    //保存offset
    CGPoint oldContentOffset = snapshotView.contentOffset;
    //保存frame
    CGRect oldFrame = snapshotView.frame;
    
    if (snapshotView.contentSize.height > snapshotView.frame.size.height) {
        snapshotView.contentOffset = CGPointMake(0, snapshotView.contentSize.height - snapshotView.frame.size.height);
    }
    snapshotView.frame = CGRectMake(0, 0, snapshotView.contentSize.width, snapshotView.contentSize.height);
    
    //延迟0.3秒，避免有时候渲染不出来的情况
    [NSThread sleepForTimeInterval:0.3];
    
    snapshotView.contentOffset = CGPointZero;
    @autoreleasepool
    {
        UIGraphicsBeginImageContextWithOptions(snapshotView.bounds.size,NO,[UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [snapshotView.layer renderInContext:context];
        //        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
        snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    snapshotView.frame = oldFrame;
    //还原
    snapshotView.contentOffset = oldContentOffset;
    finishBlock(snapshotImage ? : nil);
}



+ (UIViewController *)currentViewController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow ? : [UIApplication sharedApplication].delegate.window;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController)
    {
        vc = vc.presentedViewController;
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            vc = [(UINavigationController *)vc visibleViewController];
        }
        else if ([vc isKindOfClass:[UITabBarController class]])
        {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}


@end
