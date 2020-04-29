//
//  UICollectionView+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2020/4/28.
//  Copyright © 2020 huanyu.li. All rights reserved.
//

#import "UICollectionView+LTAdd.h"

@implementation UICollectionView (LTAdd)

- (void)lt_reloadDataWithoutAnimation {
    [self performBatchUpdates:^{
        [self reloadData];
    } completion:^(BOOL finished) {
        
    }];
}

@end
