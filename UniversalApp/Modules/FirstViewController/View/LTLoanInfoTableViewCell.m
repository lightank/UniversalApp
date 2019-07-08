//
//  LTLoanInfoTableViewCell.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/7/8.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTLoanInfoTableViewCell.h"
#import "LTLoanCalculationViewController.h"

@interface LTLoanInfoTableViewCell ()

@property(nonatomic, strong) NSMutableArray<UILabel *> *labels;
@property(nonatomic, strong) UIView *bgView;

@end

@implementation LTLoanInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _labels = @[].mutableCopy;
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI
{
    NSInteger count = 4;
    UIView *bgView = [[UIView alloc] init];
    _bgView = bgView;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kLeftMargin);
        make.right.equalTo(self.contentView).offset(-kLeftMargin);
    }];
    CGFloat width = (kScreenWidth - 2 * kLeftMargin) / count;
    CGFloat height = 32.f;
    
    for (int i = 0; i < count; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorHex(999999);
        label.adjustsFontSizeToFitWidth = YES;
        [self.bgView addSubview:label];
        [self.labels addObject:label];
        
        label.size = CGSizeMake(width, height);
        label.left = i * width;
    }
}

- (void)updateWithLoanInfo:(LTloanDetailInfo *)info index:(NSIndexPath *)index
{
    [self.labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0)
        {
            obj.text = info.title1;
        }
        else if (idx == 1)
        {
            obj.text = info.title2;
        }
        else if (idx == 2)
        {
            obj.text = info.title3;
        }
        else if (idx == 3)
        {
            obj.text = info.title4;
        }
    }];
    
    NSInteger row = index.row;
    self.bgView.backgroundColor = (row % 2 == 0) ? UIColorHex(F8F8F8) : UIColorHex(FFFFFF);
    
    [self.labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.textColor = (row % 2 == 0) ? UIColorHex(999999) : UIColorHex(666666);
    }];
    
    if (row == 0)
    {
        self.bgView.layer.cornerRadius = 4.f;
        self.bgView.layer.qmui_maskedCorners = QMUILayerMinXMinYCorner | QMUILayerMaxXMinYCorner;
    }
    else
    {
        self.bgView.layer.cornerRadius = 0.f;
    }
}


@end
