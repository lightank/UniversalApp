//
//  UICollectionView+LTAdd.h
//  UniversalApp
//
//  Created by huanyu.li on 2020/4/28.
//  Copyright © 2020 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (LTAdd)

/// 去掉隐式动画的去刷新 -reloadData
- (void)lt_reloadDataWithoutAnimation;

@end

NS_ASSUME_NONNULL_END
