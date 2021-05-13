//
//  LTURLRounterProtocl.h
//  UniversalApp
//
//  Created by huanyu.li on 2021/1/18.
//  Copyright © 2021 huanyu.li. All rights reserved.
//

#ifndef LTURLRounterProtocl_h
#define LTURLRounterProtocl_h


@protocol LTURLModuleProtocol <NSObject>

/// 当前模块名字
@property (nonatomic, copy) NSString *name;
/// 包含所有子模块的字典，key是模块名字，value是模块对象
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<LTURLModuleProtocol>> *handlerItemsDictionary;
/// 父模块
@property (nonatomic, weak, nullable) id<LTURLModuleProtocol> parentHander;


@end

#endif /* LTURLRounterProtocl_h */
