//
//  LTPickerView.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/7/8.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTPickerView.h"

@interface LTPickViewItemCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineLayer;

- (void)setTitle:(NSString *)title select:(BOOL)select;

@end

@implementation LTPickViewItemCell

- (void)setTitle:(NSString *)title select:(BOOL)select
{
    self.titleLabel.text = title;
    self.textLabel.textColor = select ? UIColorHex(659FFC): UIColorHex(666666);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.lineLayer];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    self.titleLabel.textColor = UIColorHex(666666);
    self.lineLayer.backgroundColor = UIColorHex(eeeeee);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
    self.lineLayer.frame = CGRectMake(0, 0, self.width, 0.5);
}

#pragma mark - setter and getter
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UIView *)lineLayer
{
    if (!_lineLayer)
    {
        _lineLayer = [[UIView alloc] init];
    }
    return _lineLayer;
}

@end

static CGFloat const  kViewItemH = 48.0f;
static CGFloat const  kHeadHeight = 48.0f;
static CGFloat const  kHeadHeightMargin = 48.0f;

@interface LTPickerView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSArray <NSString *> *datas;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) LTPickerViewCancelHandler cancelHandler;
@property (nonatomic, copy) LTPickerViewSubimtHandler confirmHandler;

@end

@implementation LTPickerView

+ (void)showPickerViewWith:(NSString *)title
                      data:(NSArray<NSString *> *)datas
               selectIndex:(NSInteger)index
                    cancel:(LTPickerViewCancelHandler)cancel
                   confirm:(LTPickerViewSubimtHandler)confirmHandler
{
    LTPickerView *pickerView = [[LTPickerView alloc] init];
    pickerView.datas = datas;
    pickerView.selectIndex = index;
    pickerView.titleLabel.text = title;
    
    pickerView.cancelHandler  = cancel;
    pickerView.confirmHandler = confirmHandler;
    
    CGSize pickViewSize =  [pickerView sizeThatFits:CGSizeMake(kScreenWidth, kScreenHeight)];
    pickerView.frame = CGRectMake(0, 0, pickViewSize.width, pickViewSize.height);
    
    UIButton *bgView = [[UIButton alloc] init];
    bgView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.7f];
    bgView.frame = kKeyWindow.bounds;
    [kKeyWindow addSubview:bgView];
    [bgView addTarget:pickerView action:@selector(bgTapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat topY = kKeyWindow.height - pickerView.height;
    pickerView.top = topY;
    pickerView.left = (kKeyWindow.width - pickerView.width ) * 0.5;
    
    bgView.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        bgView.alpha = 1;
    }];
    
    [bgView addSubview:pickerView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"";
    self.titleLabel.font = [UIFont systemFontOfSize:15.f];
    self.titleLabel.textColor = UIColorHex(333333);
    [self addSubview:self.titleLabel];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.cancelButton setImage:[UIImage imageWithColor:UIColorRandom size:CGSizeMake(10.f, 10.f)] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(bgTapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    
    [self addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat titleMargin =  48.0f;
    self.titleLabel.frame = CGRectMake(titleMargin, kHeadHeightMargin, self.width - titleMargin *2,kHeadHeight  - 2* kHeadHeightMargin );
    self.cancelButton.frame = CGRectMake(self.width - titleMargin, 0, titleMargin, self.titleLabel.height);
    NSInteger tabCount =  MAX(2, MIN(4, self.datas.count));
    self.tableView.frame = CGRectMake(0, kHeadHeight, self.width, tabCount * kViewItemH);
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat height = kHeadHeight + MAX(2, MIN(4, self.datas.count)) * kViewItemH;
    return CGSizeMake(size.width,height);
}

#pragma mark -- UITableviewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LTPickViewItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(LTPickViewItemCell.class)];
    if (cell == nil) {
        cell = [[LTPickViewItemCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass(LTPickViewItemCell.class)];
    }
    [cell setTitle:self.datas[indexPath.row] select:self.selectIndex == indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.confirmHandler)
    {
        self.confirmHandler(self.datas[indexPath.row],indexPath.row);
        // LTTODO
        [self.superview removeFromSuperview];
        [self removeFromSuperview];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kViewItemH;
}


#pragma mark - 事件处理
- (void)bgTapAction:(UIButton *)sender
{
    if (self.cancelHandler)
    {
        self.cancelHandler();
        self.cancelHandler = nil;
    }
    
    [self removeAllSubviews];
    [self removeFromSuperview];
    [sender removeAllSubviews];
    [sender removeFromSuperview];
}


#pragma mark - setter and getter
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
    }
    return _tableView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [[UIButton alloc] init];
    }
    return _cancelButton;
}

@end

