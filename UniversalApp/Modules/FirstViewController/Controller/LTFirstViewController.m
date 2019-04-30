//
//  LTFirstViewController.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/25.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTFirstViewController.h"

@interface LTFirstViewController ()

@end

@implementation LTFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Universal Example";
    [self addCell:@"Objective-C" class:@"LTObjcViewController"];
    [self addCell:@"Feed List Demo" class:@"YYFeedListExample"];
}

@end
