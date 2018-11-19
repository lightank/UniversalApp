//
//  LTLanguageTableViewCell.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/11/19.
//  Copyright © 2018 huanyu.li. All rights reserved.
//

#import "LTLanguageTableViewCell.h"

@implementation LTLanguageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.accessoryType = selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

@end
