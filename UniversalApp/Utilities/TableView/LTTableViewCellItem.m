//
//  LTTableViewCellItem.m
//  UniversalApp
//
//  Created by huanyu.li on 2020/5/8.
//  Copyright © 2020 huanyu.li. All rights reserved.
//

#import "LTTableViewCellItem.h"

@implementation LTTableViewCellItem

+ (instancetype)itemWithCellClass:(Class)cellClass
                 cellSettingBlock:(nullable LTTableViewCellItemBlock)cellSettingBlock
                cellSelectedBlock:(nullable LTTableViewCellItemBlock)cellSelectedBlock {
    return [[self alloc] initWithCellClass:cellClass cellSettingBlock:cellSettingBlock cellSelectedBlock:cellSelectedBlock];
}

+ (instancetype)itemWithCellClass:(Class)cellClass
                 cellSettingBlock:(nullable LTTableViewCellItemBlock)cellSettingBlock {
    return [self itemWithCellClass:cellClass cellSettingBlock:cellSettingBlock cellSelectedBlock:nil];
}

+ (instancetype)itemWithCellClass:(Class)cellClass {
    return [self itemWithCellClass:cellClass cellSettingBlock:nil cellSelectedBlock:nil];
}

- (instancetype)initWithCellClass:(Class)cellClass
                 cellSettingBlock:(nullable LTTableViewCellItemBlock)cellSettingBlock
                cellSelectedBlock:(nullable LTTableViewCellItemBlock)cellSelectedBlock {
    if (self = [self initWithCellClass:cellClass]) {
        self.cellSettingBlock = cellSettingBlock;
        self.cellSelectedBlock = cellSelectedBlock;
    }
    return self;
}

- (instancetype)initWithCellClass:(Class)cellClass
                 cellSettingBlock:(nullable LTTableViewCellItemBlock)cellSettingBlock {
    if (self = [self initWithCellClass:cellClass]) {
        self.cellSettingBlock = cellSettingBlock;
    }
    return self;
}

- (instancetype)initWithCellClass:(Class)cellClass {
    if (self = [super init]) {
        _cellHeight = -1.f;
        _cellClass = cellClass;
    }
    return self;
}

@end
