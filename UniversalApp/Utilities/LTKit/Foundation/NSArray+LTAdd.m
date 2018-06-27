//
//  NSArray+LTAdd.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/20.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "NSArray+LTAdd.h"

@implementation NSArray (LTAdd)

- (nullable NSArray *)randomArray
{
    if (!self || self.count == 0 || ![self isKindOfClass:[NSArray class]]) return nil;
    
    NSMutableArray *tempArray = self.mutableCopy;
    uint32_t count = (uint32_t)tempArray.count;
    do
    {
        uint32_t index = arc4random_uniform(count);
        id value = tempArray[index];
        tempArray[index] = tempArray[count - 1];
        tempArray[count - 1] = value;
        count--;
    }while (count > 0);
    
    return tempArray.copy;
}

@end
