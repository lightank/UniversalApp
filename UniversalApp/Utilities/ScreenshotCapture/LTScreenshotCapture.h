//
//  LTScreenshotCapture.h
//  UniversalApp
//
//  Created by 李桓宇 on 2019/5/8.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <WebKit/WKWebView.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTScreenshotCapture : NSObject

+ (void)screenSnapshot:(UIView *)snapshotView finish:(void(^)(UIImage *snapShotImage))finish;

@end

NS_ASSUME_NONNULL_END
