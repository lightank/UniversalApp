//
//  LTExampleCode.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/11/8.
//  Copyright © 2018 huanyu.li. All rights reserved.
//

#import "LTExampleCode.h"

@implementation LTExampleCode


- (void)attributedString
{
    
    {
        __unused NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"欢迎使用App" attributes:@{NSForegroundColorAttributeName : UIColorHex(161819), }];
    }
    
    {
        NSMutableAttributedString *welcome = [[NSMutableAttributedString alloc] initWithString:@"欢迎使用App"];
        [welcome addAttributes:@{
                                 NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:20.f],
                                 } range:NSMakeRange(0, welcome.length)];
    }

}

@end
