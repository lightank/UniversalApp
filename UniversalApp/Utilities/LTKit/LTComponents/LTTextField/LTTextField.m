//
//  LTTextField.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/6/28.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTTextField.h"

@implementation LTTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _canShowMenu = YES;
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if(menuController && !self.canShowMenu)
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return self.canShowMenu;
}

@end
