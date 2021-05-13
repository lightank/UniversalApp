//
//  LTKVOExample.m
//  UniversalApp
//
//  Created by huanyu.li on 2021/5/13.
//  Copyright © 2021 huanyu.li. All rights reserved.
//

#import "LTKVOExample.h"
#import "NSObject+LTKVO.h"

@implementation LTKVOExample

- (void)lt_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    NSLog(@"属性%@变化之前的值为：%@", keyPath, change[NSKeyValueChangeOldKey]);
    NSLog(@"属性%@变化之后的值为：%@", keyPath, change[NSKeyValueChangeNewKey]);
}

@end
