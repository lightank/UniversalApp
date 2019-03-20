//
//  LTWKWebView.m
//  UniversalApp
//
//  Created by lihuanyu on 2018/12/21.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTWKWebView.h"

@implementation LTWKWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _useSharedProcessPool = YES;
    }
    return self;
}

#pragma mark - setter and getter
- (NSString *)currentURL
{
    return self.URL.absoluteString;
}

- (WKProcessPool *)processPool
{
    if (!_processPool)
    {
        _processPool = self.isUseSharedProcessPool ? [self.class sharedProcessPool] : [[WKProcessPool alloc] init];
    }
    return _processPool;
}

+ (WKProcessPool *)sharedProcessPool
{
    static WKProcessPool *processPool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        processPool = [[WKProcessPool alloc] init];
    });
    return processPool;
}


@end
