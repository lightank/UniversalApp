//
//  LTListTableViewController.h
//  UniversalApp
//
//  Created by 李桓宇 on 2018/12/14.
//  Copyright © 2018 huanyu.li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTListTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;


- (void)addCell:(NSString *)title class:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
