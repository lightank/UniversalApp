//
//  LTLoanCalculationViewController.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/7/8.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTLoanCalculationViewController.h"
#import "LTButton.h"
#import "LTTextField.h"
#import "LTPickerView.h"
#import "LTLoanInfoTableViewCell.h"
#import <math.h>

@interface LTLoanCalculationViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

/**  借贷类型  */
@property(nonatomic, strong) NSMutableArray<UIButton *> *loanTypeButtons;
/**  是否已经计算过了  */
@property (nonatomic, assign, getter=isCalculated) BOOL calculated;
/**  计算类型:  */
@property(nonatomic, assign) LTLoanType loanType;
/**  金额输入框  */
@property(nonatomic, weak) UITextField *amountTextField;
/**  年利率输入框  */
@property(nonatomic, strong) UITextField *annualInterestTateTextField;
/**  tableview  */
@property(nonatomic, weak) UITableView *tableView;
/**  重新计算按钮  */
@property(nonatomic, weak)  LTButton *reloadButton;

@property (nonatomic, strong) UILabel *tipLabel;//计算前显示 贷款金额(元) 计算后共需还款(元)

/**  月份数组  */
@property(nonatomic, strong) NSArray<NSString *> *monthArray;

/**  贷款月份  */
@property (nonatomic, assign) NSInteger loanMonth;
/**  借款信息  */
@property(nonatomic, strong) LTloanInfo *loanInfo;

@end

@implementation LTLoanCalculationViewController

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //            [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        });
    });
}

- (instancetype)init{
    self = [super init];
    if (self)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        _calculated = NO;
        _loanTypeButtons = @[].mutableCopy;
        _loanMonth = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorHex(F8F8F8);
    self.title = @"贷款计算器";
    [self setupUI];
    
    self.calculated = NO;
}

- (void)setupUI
{
    UIView *loanTypeView = [self addLoanTypeView];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.bounces = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loanTypeView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[LTLoanInfoTableViewCell class] forCellReuseIdentifier:@"LTLoanInfoTableViewCell"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorColor = UIColorHex(e6e6e6);
}

- (UIView *)addLoanTypeView
{
    UIView *loanTypeView = [[UIView alloc] init];
    [self.view addSubview:loanTypeView];
    loanTypeView.backgroundColor = UIColorHex(#FFFFFF);
    loanTypeView.width = kScreenWidth;
    CGFloat buttonHeight = 60.f;
    CGFloat buttonWidth = (kScreenWidth - 2 * kLeftMargin - 11.f) * 0.5f;
    loanTypeView.height = 20.f * 2 + buttonHeight;
    
    NSArray<LTloanType *> *loanTypes = [self loanTypes];
    [loanTypes enumerateObjectsUsingBlock:^(LTloanType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [self buttonWithTitle:obj.title subTitle:obj.subTitle size:CGSizeMake(buttonWidth, buttonHeight)];
        [loanTypeView addSubview:button];
        button.centerY = loanTypeView.centerY;
        button.left = kLeftMargin + idx * (buttonWidth + 11.f);
        button.top = 20.f;
        // 默认选择第一个
        button.selected = idx == 0;
        button.tag = idx;
        [button addTarget:self action:@selector(loanTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.loanTypeButtons addObject:button];
    }];
    
    
    UIView *lineView = [self lineViewWithColor:UIColorHex(F8F8F8) size:CGSizeMake(kScreenWidth, 8.f)];
    lineView.top = loanTypeView.subviews.lastObject.bottom + 20.f;
    [loanTypeView addSubview:lineView];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"贷款金额(元)贷款金额(元)";
    tipLabel.textColor = UIColorHex(1F2B5A);
    tipLabel.font = [UIFont systemFontOfSize:16.f];
    [tipLabel sizeToFit];
    tipLabel.text = @"贷款金额(元)";
    tipLabel.left = kLeftMargin;
    tipLabel.top = lineView.bottom + 13.f;
    self.tipLabel = tipLabel;
    [loanTypeView addSubview:tipLabel];
    
    LTButton *reloadButton = [[LTButton alloc] init];
    self.reloadButton = reloadButton;
    reloadButton.lt_titleNoraml = @"重新计算";
    reloadButton.lt_font = [UIFont systemFontOfSize:12.f];
    reloadButton.contentEdgeInsets = UIEdgeInsetsMake(0.f, 8.f, 0.f, 8.f);
    [reloadButton sizeToFit];
    reloadButton.height = 24.f;
    [loanTypeView addSubview:reloadButton];
    reloadButton.centerY = tipLabel.centerY;
    reloadButton.right = loanTypeView.right - kLeftMargin;
    reloadButton.layer.borderWidth = [LTDevice pixelOne];
    [reloadButton lt_setCornerRadius:12.f];
    reloadButton.lt_titleColorNoraml = UIColorHex(729BFF);
    reloadButton.layer.borderColor = reloadButton.lt_titleColorNoraml.CGColor;
    reloadButton.qmui_tapBlock = ^(__kindof UIControl *sender) {
        self.amountTextField.text = nil;
        self.calculated = NO;
    };
    
    UILabel *unitLabel = [[UILabel alloc] init];
    unitLabel.text = @"¥ ";
    unitLabel.font = [UIFont systemFontOfSize:30.f];
    unitLabel.textColor = UIColorHex(333333);
    [unitLabel sizeToFit];
    
    LTTextField *amountTextField = [[LTTextField alloc] init];
    amountTextField.placeholder = @"请输入贷款金额";
    amountTextField.canShowMenu = NO;
    amountTextField.font = unitLabel.font;
    amountTextField.size = CGSizeMake(kScreenWidth - 2 * kLeftMargin, 42.f);
    amountTextField.top = tipLabel.bottom + 13.f;
    amountTextField.left = tipLabel.left;
    amountTextField.leftView = unitLabel;
    amountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    amountTextField.keyboardType = UIKeyboardTypeNumberPad;
    amountTextField.leftViewMode = UITextFieldViewModeAlways;
    [loanTypeView addSubview:amountTextField];
    self.amountTextField = amountTextField;
    
    UIView *bottomLineView = [self lineViewWithColor:UIColorHex(e6e6e6) size:CGSizeMake(kScreenWidth, [LTDevice pixelOne])];
    bottomLineView.top = amountTextField.bottom + 6.f;
    [loanTypeView addSubview:bottomLineView];
    
    loanTypeView.height = loanTypeView.subviews.lastObject.bottom;
    return loanTypeView;
}


- (UIView *)lineViewWithColor:(UIColor *)color size:(CGSize)size
{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = color;
    lineView.size = size;
    
    return lineView;
}

- (UIButton *)buttonWithTitle:(NSString *)title subTitle:(NSString *)subTitle size:(CGSize)size
{
    LTButton *button = [[LTButton alloc] init];
    NSMutableAttributedString *attributedSelectedTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.f], NSForegroundColorAttributeName: UIColorHex(FFFFFF)}];
    NSMutableAttributedString *attributedSelectedSubTitle = [[NSMutableAttributedString alloc] initWithString:subTitle attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.f], NSForegroundColorAttributeName: UIColorHex(FFFFFF)}];
    [attributedSelectedTitle appendAttributedString:attributedSelectedSubTitle];
    [button setAttributedTitle:attributedSelectedTitle forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorHex(4E67FF)] forState:UIControlStateSelected];
    
    
    NSMutableAttributedString *attributedNormalTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.f], NSForegroundColorAttributeName: UIColorHex(66668A)}];
    NSMutableAttributedString *attributedNormalSubTitle = [[NSMutableAttributedString alloc] initWithString:subTitle attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.f], NSForegroundColorAttributeName: UIColorHex(66668A)}];
    [attributedNormalTitle appendAttributedString:attributedNormalSubTitle];
    [button setAttributedTitle:attributedNormalTitle forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorHex(FFFFFF)] forState:UIControlStateNormal];
    
    button.layer.borderColor = UIColorHex(4E67FF).CGColor;
    button.layer.borderWidth = 0.5;
    button.layer.cornerRadius = 6.f;
    button.layer.masksToBounds = YES;
    
    button.size = size;
    button.titleLabel.numberOfLines = 0;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.showsTouchWhenHighlighted = NO;
    return button;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.isCalculated ? 32.f : 48.f;
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (!self.isCalculated && indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [LTPickerView showPickerViewWith:@"贷款期限" data:self.monthArray selectIndex:0 cancel:^{
        } confirm:^(NSString * _Nullable obj, NSInteger index) {
            cell.detailTextLabel.text = obj;
            self.loanMonth = obj.integerValue;
        }];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if (!self.isCalculated)
    {
        numberOfRows = 2;
    }
    else
    {
        numberOfRows = self.loanInfo.infoArray.count;
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (!self.isCalculated)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16.f];
        cell.textLabel.textColor = UIColorHex(1F2B5A);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
        cell.detailTextLabel.textColor = UIColorHex(CCCCCC);
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"贷款期限";
            cell.detailTextLabel.text = @"请选择";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"年利率";
            cell.detailTextLabel.text = @"   ";
            LTTextField *annualInterestTateTextField = [[LTTextField alloc] init];
            annualInterestTateTextField.canShowMenu = NO;
            annualInterestTateTextField.font = cell.detailTextLabel.font;
            annualInterestTateTextField.placeholder = @"请输入年利率";
            annualInterestTateTextField.textColor = UIColorHex(666666);
            annualInterestTateTextField.textAlignment = NSTextAlignmentRight;
            UILabel *unitLabel = [[UILabel alloc] init];
            unitLabel.text = @" %" ;
            unitLabel.font = annualInterestTateTextField.font;
            unitLabel.textColor = annualInterestTateTextField.textColor;
            [unitLabel sizeToFit];
            annualInterestTateTextField.rightView = unitLabel;
            annualInterestTateTextField.rightViewMode = UITextFieldViewModeAlways;
            annualInterestTateTextField.keyboardType = UIKeyboardTypeDecimalPad;
            self.annualInterestTateTextField = annualInterestTateTextField;
            [cell.contentView addSubview:annualInterestTateTextField];
            [annualInterestTateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.detailTextLabel);
                make.top.bottom.equalTo(cell.contentView);
                make.width.equalTo(kScreenWidth * 0.5);
            }];
            annualInterestTateTextField.delegate = self;
        }
    }
    else
    {
        LTloanDetailInfo *info = self.loanInfo.infoArray[indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"LTLoanInfoTableViewCell"];
        if ([cell isKindOfClass:[LTLoanInfoTableViewCell class]])
        {
            [((LTLoanInfoTableViewCell *)cell) updateWithLoanInfo:info index:indexPath];
        }
    }
    return cell;
}

- (UIView *)tableFooterView
{
    UIView *tableFooterView = [[UIView alloc] init];
    tableFooterView.size = CGSizeMake(kScreenWidth, 40.f + 44.f);
    
    LTButton *button = [[LTButton alloc] init];
    button.size = CGSizeMake(kScreenWidth - 2 * kLeftMargin, 44.f);
    button.top = 40.f;
    button.left = kLeftMargin;
    button.lt_titleNoraml = @"计算";
    button.lt_titleColorNoraml = UIColor.whiteColor;
    button.lt_font = [UIFont systemFontOfSize:16.f];
    
    CALayer *layer = [CALayer lt_axialGradientLayerWithFromColor:UIColorHex(4E67FF) toColor:UIColorHex(729BFF) size:button.size direction:LTGradientLayerDirectionLeftToRight];
    [button.layer insertSublayer:layer atIndex:0];
    button.layer.cornerRadius = button.size.height * 0.5f;
    button.layer.masksToBounds = YES;
    [tableFooterView addSubview:button];
    [button addTarget:self action:@selector(calculationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return tableFooterView;
}

- (UIView *)tableHeaderView
{
    UIView *tableHeaderView = [[UIView alloc] init];
    tableHeaderView.size = CGSizeMake(kScreenWidth, 10.f * 2 + 70.f);
    UIView *bgView = [[UIView alloc] init];
    bgView.size = CGSizeMake(kScreenWidth - 2 * kLeftMargin, 70.f);
    bgView.backgroundColor = UIColorHex(E1E8FF);
    bgView.layer.cornerRadius = 4.f;
    bgView.layer.masksToBounds = YES;
    [tableHeaderView addSubview:bgView];
    
    [self.loanInfo.liteInfoArray enumerateObjectsUsingBlock:^(LTloanLiteInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [self liteInfoLabelWithTitle:obj.title subTitle:obj.content];
        label.numberOfLines = 0;
        label.adjustsFontSizeToFitWidth = YES;
        label.centerY = bgView.centerY;
        if (idx == 0)
        {
            label.left = kLeftMargin;
        }
        else if (idx == 1)
        {
            label.width = MIN(label.width, bgView.width * 0.5f);
            label.centerX = bgView.centerX;
        }
        else if (idx == 2)
        {
            label.right = bgView.right - kLeftMargin;
        }
        [bgView addSubview:label];
    }];
    
    
    bgView.subviews[0].width = bgView.subviews[1].left - bgView.subviews[0].left - 5;
    ((UILabel *)(bgView.subviews[0])).adjustsFontSizeToFitWidth = YES;
    
    if (bgView.subviews[2].left < bgView.subviews[1].right)
    {
        bgView.subviews[2].left = bgView.subviews[1].right + 5;
    }
    
    bgView.center = tableHeaderView.center;
    
    return tableHeaderView;
}

- (UILabel *)liteInfoLabelWithTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    UIColor *color = UIColorHex(4B5576);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3.f;
    
    NSMutableAttributedString *titleAttributed = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.f], NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: paragraphStyle}];
    NSMutableAttributedString *subTitleAttributed = [[NSMutableAttributedString alloc] initWithString:[@"\n" stringByAppendingString:subTitle] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.f], NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName: paragraphStyle}];
    [titleAttributed appendAttributedString:subTitleAttributed];
    
    label.attributedText = titleAttributed;
    [label sizeToFit];
    return label;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.annualInterestTateTextField)
    {
        return [NSString keepTwoDecimalsNumberWithCurrentText:textField.text shouldChangeCharactersInRange:range replacementString:string];
    }
    else if (textField == self.amountTextField)
    {
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField == self.amountTextField)
    {
        self.calculated = NO;
    }
    
    return YES;
}


#pragma mark - 事件处理
- (void)loanTypeButtonAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self.loanTypeButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL selected = sender == obj;
        obj.selected = selected;
        if (selected)
        {
            self.loanType = idx;
        }
    }];
}

- (void)calculationButtonAction:(UIButton *)sender
{
    // 借款金额
    NSInteger loanAmount = self.amountTextField.text.integerValue;
    // 借款月份
    NSInteger loanMonth = self.loanMonth;
    // 接口年利率
    CGFloat annualInterestRate = self.annualInterestTateTextField.text.floatValue;
    
    if (loanAmount < 500 || loanAmount > 9999999)
    {
        NSString *tip = loanAmount == 0 ? @"贷款金额不能为空" : @"贷款金额必须为500——9999999之间的数值";
        [QMUITips showWithText:tip inView:self.view hideAfterDelay:3.f];
        return;
    }
    
    if (loanMonth == 0)
    {
        NSString *tip = @"请选择贷款期限";
        [QMUITips showWithText:tip inView:self.view hideAfterDelay:3.f];
        return;
    }
    
    if (annualInterestRate <= 0 || annualInterestRate >= 36)
    {
        NSString *tip = annualInterestRate == 0 ? @"年利率不能为空" : @"年利率必须为大于0且小于36，且不超过两位小数的数值";
        [QMUITips showWithText:tip inView:self.view hideAfterDelay:3.f];
        return;
    }
    
    
    LTloanInfo *loanInfo = [[LTloanInfo alloc] initWithLTLoanType:self.loanType loanAmount:loanAmount loanMonth:loanMonth annualInterestRate:annualInterestRate];
    self.loanInfo = loanInfo;
    self.calculated = YES;
    
    
    [self reloadTableView];
}

- (void)reloadTableView
{
    self.amountTextField.userInteractionEnabled = !self.isCalculated;
    
    if (!self.isCalculated)
    {
        self.tableView.tableHeaderView = [UIView new];
        self.tableView.tableFooterView = [self tableFooterView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    else
    {
        self.tableView.tableHeaderView = [self tableHeaderView];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        CGFloat needPayBackAmount=      (self.loanType ==  LTLoanTypeEqualPrincipal) ?self.loanInfo.equalPrincipalPayMoneyAmount :self.loanInfo.equalInterestPayMoneyAmount;
        self.amountTextField.text = [NSString stringWithFormat:@"%0.2f",needPayBackAmount];
    }
    
    [self.tableView reloadData];
}

#pragma mark - setter and getter
- (NSArray<LTloanType *> *)loanTypes
{
    NSMutableArray *loanTypes = @[].mutableCopy;
    LTloanType *equalInterest = [[LTloanType alloc] initWithTitle:@"等额本息" subTitle:@"\n每月还款总额相同"];
    LTloanType *equalPrincipal = [[LTloanType alloc] initWithTitle:@"等额本金" subTitle:@"\n每月还款本金相同"];
    [loanTypes addObject:equalInterest];
    [loanTypes addObject:equalPrincipal];
    return loanTypes;
}

- (NSArray<NSString *> *)monthArray
{
    if (!_monthArray)
    {
        NSMutableArray *mArr = @[].mutableCopy;
        for (int i = 1; i < 37; i++)
        {
            NSString *month = [NSString stringWithFormat:@"%d个月", i];
            [mArr addObject:month];
        }
        _monthArray = mArr;
    }
    return _monthArray;
}

- (void)setLoanType:(LTLoanType)loanType
{
    _loanType = loanType;
    if (self.calculated)
    {
        self.loanInfo.loanType = loanType;
        [self reloadTableView];
    }
}

- (void)setCalculated:(BOOL)calculated
{
    _calculated = calculated;
    self.reloadButton.hidden = !calculated;
    self.tipLabel.text = calculated ? @"共需还款(元)" : @"贷款金额(元)";
    [self reloadTableView];
}

@end

@implementation LTloanType

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    self = [super init];
    if (self)
    {
        _title = title.copy;
        _subTitle = subTitle.copy;
    }
    return self;
}

@end



@implementation LTloanDetailInfo

- (instancetype)initWithTitle1:(NSString *)title1
                        title2:(NSString *)title2
                        title3:(NSString *)title3
                        title4:(NSString *)title4
{
    self = [super init];
    if (self)
    {
        _title1 = title1.copy;
        _title2 = title2.copy;
        _title3 = title3.copy;
        _title4 = title4.copy;
    }
    return self;
}

@end

@implementation LTloanLiteInfo


- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content
{
    self = [super init];
    if (self)
    {
        _title = title.copy;
        _content = content.copy;
    }
    return self;
}

@end

@interface LTloanInfo ()

/**  借款金额  */
@property (nonatomic, assign) NSInteger loanAmount;
/**  贷款月份  */
@property (nonatomic, assign) NSInteger loanMonth;
/**  年利率  */
@property (nonatomic, assign) CGFloat annualInterestRate;

/**  等额本金需要还款总额  */
@property (nonatomic, assign) CGFloat equalPrincipalPayMoneyAmount;
/**  额本息需要还款总额  */
@property (nonatomic, assign) CGFloat equalInterestPayMoneyAmount;

/**  等额本息的简介信息数组  */
@property (nonatomic, strong) NSArray<LTloanLiteInfo *> *equalInterestLiteInfoArray;
/**  等额本金的简介信息数组  */
@property (nonatomic, strong) NSArray<LTloanLiteInfo *> *equalPrincipalLiteInfoArray;

/**  等额本息的详情信息数组  */
@property(nonatomic, strong) NSArray<LTloanDetailInfo *> *equalInterestDetailInfoArray;
/**  等额本金的详情信息数组  */
@property(nonatomic, strong) NSArray<LTloanDetailInfo *> *equalPrincipalDetailInfoArray;;

@end

@implementation LTloanInfo

- (instancetype)initWithLTLoanType:(LTLoanType)type
                         loanAmount:(NSInteger)loanAmount
                          loanMonth:(NSInteger)loanMonth
                 annualInterestRate:(CGFloat)annualInterestRate;
{
    self = [super init];
    if (self)
    {
        _loanType = type;
        _loanAmount = loanAmount;
        _loanMonth = loanMonth;
        _annualInterestRate = annualInterestRate;
        [self calculate];
    }
    return self;
}

- (void)calculate
{
    // 计算等额本息
    [self calculatEqualInterest];
    // 计算等额本金
    [self calculatEqualPrincipal];
}

// 计算等额本息:还款期内，每月偿还同等数额的贷款(本金+利息)
- (void)calculatEqualInterest
{
    // 贷款本金
    double P = self.loanAmount;
    // 月利率
    double R = self.annualInterestRate * 0.01 / 12.0;
    // 还款期数
    double N = self.loanMonth;
    // 每月固定还款数额
    double perMonthAmount = P * (R * pow(1 + R, N)) / (pow(1 + R, N) - 1);
    
    {
        // 总利息
        double totalInterest = N * perMonthAmount - P;
        
        self.equalInterestPayMoneyAmount  = [self roundFloat:(totalInterest + self.loanAmount)];
        totalInterest = [self roundFloat:totalInterest];
        // 简介信息
        LTloanLiteInfo *liteInfo1 = [[LTloanLiteInfo alloc] initWithTitle:@"总利息(元)" content:[NSString stringWithFormat:@"%.2lf", totalInterest]];
        LTloanLiteInfo *liteInfo2 = [[LTloanLiteInfo alloc] initWithTitle:@"每月还款总额(元)" content:[NSString stringWithFormat:@"%.2lf", perMonthAmount]];
        LTloanLiteInfo *liteInfo3 = [[LTloanLiteInfo alloc] initWithTitle:@"总期数(月)" content:@(self.loanMonth).stringValue];
        NSMutableArray<LTloanLiteInfo *> *equalInterestLiteInfoArray = @[].mutableCopy;
        [equalInterestLiteInfoArray addObject:liteInfo1];
        [equalInterestLiteInfoArray addObject:liteInfo2];
        [equalInterestLiteInfoArray addObject:liteInfo3];
        self.equalInterestLiteInfoArray = equalInterestLiteInfoArray;
    }
    
    {
        // 详细信息
        NSMutableArray<LTloanDetailInfo *> *equalInterestDetailInfoArray = @[].mutableCopy;
        LTloanDetailInfo *titleInfo = [[LTloanDetailInfo alloc] initWithTitle1:@"期数" title2:@"本金(元)" title3:@"利息(元)" title4:@"总计(元)"];
        [equalInterestDetailInfoArray addObject:titleInfo];
        for (int i = 0; i < self.loanMonth; i++)
        {
            // 每一期的利息
            double perMonthInterest = P * R;
            // 这一期的本金
            double perMonthMoney = perMonthAmount - perMonthInterest;
            //
            
            P -= perMonthMoney;
            //四舍五入
            perMonthInterest = [self roundFloat:perMonthInterest];
            perMonthMoney = [self roundFloat:perMonthMoney];
            // 期数   本金(元)   利息(元)   总计(元)
            LTloanDetailInfo *info1 = [[LTloanDetailInfo alloc] initWithTitle1:@(i + 1).stringValue title2:[NSString stringWithFormat:@"%.2lf", perMonthMoney] title3:[NSString stringWithFormat:@"%.2lf", perMonthInterest] title4:[NSString stringWithFormat:@"%.2lf", perMonthAmount]];
            [equalInterestDetailInfoArray addObject:info1];
        }
        self.equalInterestDetailInfoArray = equalInterestDetailInfoArray;
    }
}

// 计算等额本金:每个月还的本金是固定的，但利息不固定，所以每个月的还款额（本金+利息）就不固定
- (void)calculatEqualPrincipal
{
    
    // 贷款本金
    double P = self.loanAmount;
    // 月利率
    double R = self.annualInterestRate * 0.01 / 12.0;
    // 还款期数
    double N = self.loanMonth;
    //每月本金=总本金/还款月数
    double perMonthAmount = P / N;
    
    {
        // 总利息
        double totalInterest = (N + 1) * P * R * 0.5;
        totalInterest = [self roundFloat:totalInterest];
        self.equalPrincipalPayMoneyAmount = [self roundFloat:(totalInterest + self.loanAmount)] ;
        
        // 简介信息
        LTloanLiteInfo *liteInfo1 = [[LTloanLiteInfo alloc] initWithTitle:@"总利息(元)" content:[NSString stringWithFormat:@"%.2lf", totalInterest]];
        LTloanLiteInfo *liteInfo2 = [[LTloanLiteInfo alloc] initWithTitle:@"每月还款本金(元)" content:[NSString stringWithFormat:@"%.2lf", perMonthAmount]];
        LTloanLiteInfo *liteInfo3 = [[LTloanLiteInfo alloc] initWithTitle:@"总期数(月)" content:@(self.loanMonth).stringValue];
        NSMutableArray<LTloanLiteInfo *> *equalPrincipalLiteInfoArray = @[].mutableCopy;
        [equalPrincipalLiteInfoArray addObject:liteInfo1];
        [equalPrincipalLiteInfoArray addObject:liteInfo2];
        [equalPrincipalLiteInfoArray addObject:liteInfo3];
        self.equalPrincipalLiteInfoArray = equalPrincipalLiteInfoArray;
    }
    
    
    {
        // 详细信息
        NSMutableArray<LTloanDetailInfo *> *equalPrincipalDetailInfoArray = @[].mutableCopy;
        LTloanDetailInfo *titleInfo = [[LTloanDetailInfo alloc] initWithTitle1:@"期数" title2:@"本金(元)" title3:@"利息(元)" title4:@"总计(元)"];
        [equalPrincipalDetailInfoArray addObject:titleInfo];
        for (int i = 0; i < self.loanMonth; i++)
        {
            // 每一期的利息
            double perMonthInterest = P * R;
            // 这一期的本金
            double perMonthMoney = perMonthAmount;
            //四舍五入
            perMonthInterest = [self roundFloat:perMonthInterest];
            perMonthMoney = [self roundFloat:perMonthMoney];
            
            P -= perMonthMoney;
            
            // 期数   本金(元)   利息(元)   总计(元)
            LTloanDetailInfo *info1 = [[LTloanDetailInfo alloc] initWithTitle1:@(i + 1).stringValue title2:[NSString stringWithFormat:@"%.2lf", perMonthMoney] title3:[NSString stringWithFormat:@"%.2lf", perMonthInterest] title4:[NSString stringWithFormat:@"%.2lf", perMonthAmount + perMonthInterest]];
            [equalPrincipalDetailInfoArray addObject:info1];
        }
        self.equalPrincipalDetailInfoArray = equalPrincipalDetailInfoArray;
    }
}

#pragma mark - setter and getter
- (NSArray<LTloanLiteInfo *> *)liteInfoArray
{
    NSArray *arr = nil;
    switch (self.loanType)
    {
        case LTLoanTypeEqualInterest:
        {
            arr = self.equalInterestLiteInfoArray;
        }
            break;
            
        case LTLoanTypeEqualPrincipal:
        {
            arr = self.equalPrincipalLiteInfoArray;
        }
            break;
    }
    
    return arr;
}

- (NSArray<LTloanDetailInfo *> *)infoArray
{
    NSArray *arr = nil;
    switch (self.loanType)
    {
        case LTLoanTypeEqualInterest:
        {
            arr = self.equalInterestDetailInfoArray;
        }
            break;
            
        case LTLoanTypeEqualPrincipal:
        {
            arr = self.equalPrincipalDetailInfoArray;
        }
            break;
    }
    
    return arr;
}


//四舍五入
-(float)roundFloat:(float)price{
    
    return roundf(price*100)/100;
    
}


@end

