//
//  LTLoginViewController.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/11/16.
//  Copyright © 2018 huanyu.li. All rights reserved.
//

#import "LTLoginViewController.h"

#define kTextFieldWidth [UIScreen mainScreen].bounds.size.width * 0.87
#define kTextFieldHeight 40
#define kTextLeftPadding [UIScreen mainScreen].bounds.size.width * 0.055
#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kForgetPwdBtnWidth [UIScreen mainScreen].bounds.size.width * 0.2375


@interface LTLoginViewController () <UIScrollViewDelegate>

// 容器 scrollView
@property (nonatomic, strong) UIScrollView *contentScrollView;
// 用户名
@property (nonatomic, strong) UITextField *nameTextField;
// 密码
@property (nonatomic, strong) UITextField *pwdTextField;

@end

@implementation LTLoginViewController

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"登录";
    [self setupUI];
}

#pragma mark - setupUI
- (void)setupUI
{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth , kScreenHeight)];
    _contentScrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    _contentScrollView.userInteractionEnabled =  YES;
    [self.view addSubview:_contentScrollView];
    
    kScrollViewDisableAdjustsInsets(_contentScrollView, self);
    
    // 1 此处做界面
    _nameTextField = [[UITextField alloc] init];
    _nameTextField.placeholder = @"手机号/邮箱";
    _nameTextField.font = [UIFont systemFontOfSize:16.0f];
    _nameTextField.borderStyle = UITextBorderStyleNone;
    [self.contentScrollView addSubview:_nameTextField];
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kTextFieldWidth);
        make.height.equalTo(kTextFieldHeight);
        make.left.equalTo(self.view.mas_left).offset(kTextLeftPadding);
        make.top.equalTo(self.contentScrollView.mas_top).equalTo(kForgetPwdBtnWidth);
        
    }];
    
    // 1.1 添加一个分割线
    UIView *sepView1 = [[UIView alloc] init];
    sepView1.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:sepView1];
    [sepView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kTextFieldWidth);
        make.height.equalTo(1.5);
        make.left.equalTo(self.nameTextField.mas_left).offset(0);
        make.top.equalTo(self.nameTextField.mas_bottom).equalTo(0);
        
    }];
    
    //2 此处做界面
    _pwdTextField = [[UITextField alloc] init];
    _pwdTextField.placeholder = @"密码";
    _pwdTextField.secureTextEntry = YES;
    _pwdTextField.font = [UIFont systemFontOfSize:16.0f];
    _pwdTextField.borderStyle = UITextBorderStyleNone;
    [self.contentScrollView addSubview:_pwdTextField];
    
    [_pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kTextFieldWidth);
        make.height.equalTo(kTextFieldHeight);
        make.left.equalTo(self.view.mas_left).offset(kTextLeftPadding);
        make.top.equalTo(sepView1.mas_bottom).equalTo(20);
    }];
    
    //2.1 添加一个分割线
    UIView *sepView2 = [[UIView alloc]init];
    sepView2.backgroundColor = [UIColor whiteColor];
    [self.contentScrollView addSubview:sepView2];
    [sepView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kTextFieldWidth);
        make.height.equalTo(1.5);
        make.left.equalTo(self.pwdTextField.mas_left).offset(0);
        make.top.equalTo(self.pwdTextField.mas_bottom).equalTo(0);
    }];
    
    // 3 按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = kRGBColor(24, 154, 204);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 3;
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentScrollView addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kTextFieldWidth);
        make.height.equalTo(kTextFieldHeight);
        make.left.equalTo(self.pwdTextField.mas_left).offset(0);
        make.top.equalTo(sepView2.mas_bottom).equalTo(30);
    }];
    
    // 4 忘记密码
    UIButton *forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPwdBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [forgetPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPwdBtn addTarget:self action:@selector(forgetPwdBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [forgetPwdBtn setTitleColor:kRGBColor(24, 154, 214) forState:UIControlStateNormal];
    [self.contentScrollView addSubview:forgetPwdBtn];
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kForgetPwdBtnWidth);
        make.height.equalTo(kTextFieldHeight);
        make.left.equalTo(self.pwdTextField.mas_left).offset(0);
        make.top.equalTo(loginBtn.mas_bottom).equalTo(10);
    }];
    
    // 5 新用户注册
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [registBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(registBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [registBtn setTitleColor:kRGBColor(24, 154, 214) forState:UIControlStateNormal];
    [self.contentScrollView addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kForgetPwdBtnWidth);
        make.height.equalTo(kTextFieldHeight);
        make.right.equalTo(self.pwdTextField.mas_right).offset(0);
        make.top.equalTo(loginBtn.mas_bottom).equalTo(10);
    }];
}

#pragma mark - 事件处理
- (void)loginBtnClick
{
    [LTUserManager hiddenLoginPageWithLoginStatus:YES];
}

- (void)registBtnClick
{
    
}
- (void)forgetPwdBtnClick
{
    
}

// 键盘取消事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
