//
//  LTLanuchViewController.m
//  UniversalApp
//
//  Created by 李桓宇 on 2019/8/30.
//  Copyright © 2019 huanyu.li. All rights reserved.
//

#import "LTLanuchViewController.h"
#import "Reachability.h"
#import "LTEncryptorTools.h"
#import "LTDevice.h"

@interface LTLanuchViewController ()

/**  emptyView  */
@property (nonatomic, strong) UIView *emptyView;

/**  转圈  */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation LTLanuchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
}

- (void)setupUI
{
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [logo sizeToFit];
    [self.view addSubview:logo];
    logo.center = self.view.center;
    logo.bottom = self.view.height - 28.f - 44.f - kLTHomeIndicatorHeight;
    
    // 发起请求
    [self request];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)request
{
    //检测网络
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    if (reachability.currentReachabilityStatus == NotReachable)
    {
        // 网络不可用
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(monitoringNetwork:)
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
        [reachability startNotifier];
        // 检测网络
        self.emptyView.hidden = NO;
    }
    else
    {
        // 本地检测
        BOOL local = [self.class isInChina];
        if (!local)
        {
            [self completWithStates:NO];
            return;
        }

        // 日期开关 2019-09-05
        BOOL time = [self.class showWithTime:@"vxlo1glVLBu4mMuXHUOyWQ=="];
        if (time)   // 展示A面
        {
            [self completWithStates:NO];
            return;
        }

        // 是否展示过B面
        BOOL isShow = [self.class isShow];
        if (isShow) // 展示过B面
        {
            [self completWithStates:YES];
            return;
        }
        
        // 请求服务器开关
        [self requestNetwork];
    }
}

- (void)requestNetwork
{
    [self.indicatorView startAnimating];
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            if (error)  // 请求失败
            {
                Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
                if (reachability.currentReachabilityStatus == NotReachable)
                {
                    // 网络不可用
                    [[NSNotificationCenter defaultCenter]addObserver:self
                                                            selector:@selector(monitoringNetwork:)
                                                                name:kReachabilityChangedNotification
                                                              object:nil];
                    [reachability startNotifier];
                    // 检测网络
                    self.emptyView.hidden = NO;
                }
                else
                {
                    // 网络可用
                    [self completWithStates:NO];
                }
            }
            else // 请求成功
            {
                [self completWithStates:YES];
                LTLanuchViewController.isShow = YES;
            }
        });
    }];
    [dataTask resume];
}

- (void)completWithStates:(BOOL)success
{
    [self.indicatorView stopAnimating];
    if ([NSThread isMainThread])
    {
        if (self.completionBlock)
        {
            self.completionBlock(success);
            self.completionBlock = nil;
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.completionBlock)
            {
                self.completionBlock(success);
                self.completionBlock = nil;
            }
        });
    }
}

- (void)monitoringNetwork:(NSNotification*)notification
{
    Reachability *reach = [notification object];
    switch (reach.currentReachabilityStatus)
    {
        case ReachableViaWiFi:
        case ReachableViaWWAN:
        {
            // 有网络了就请求
            [self request];
            self.emptyView.hidden = YES;
            [reach stopNotifier];
            
            break;
        }
        case NotReachable:{
            break;
        }
            
        default:
            break;
    }
}

+ (BOOL)isInChina
{
    BOOL isInChina = NO;
    
    // 系统语言:中文
    BOOL isChinese = NO;
    NSArray *languageArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    // Get the user's language
    NSString *language = languageArray.firstObject;
    isChinese = [language containsString:@"zh"];
    
    // 设备机型:iPhone
    BOOL isIPhone = NO;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) isIPhone = YES;
    
    // 当前系统时区:Asia/Hong_Kong、Asia/Shanghai、Asia/Harbin
    BOOL isChinaTimeZone = NO;
    NSString *systemTimeZoneName = [NSTimeZone systemTimeZone].name;
    static NSArray *ChinaTimeZone;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ChinaTimeZone = @[@"Asia/Hong_Kong", @"Asia/Shanghai", @"Asia/Harbin"];
    });
    isChinaTimeZone = [ChinaTimeZone containsObject:systemTimeZoneName];
    
    // 当前地区国家:zh_CN,其中zh代表语言,cn代表国家
    BOOL isChinaLocale = NO;
    NSString *country = [NSLocale currentLocale].localeIdentifier;
    isChinaLocale = [country.lowercaseString containsString:@"cn"];
    
    isInChina = isChinese && isIPhone && isChinaTimeZone && isChinaLocale;
    return isInChina;
}

/**
 时间开关

 @param time AES加密后的时间
 @return 是否展示A面
 */
+ (BOOL)showWithTime:(NSString *)time
{
    // 加密
    //NSString *encryptTime = [LTEncryptorTools AESEncryptString:@"2019-09-05" keyString:@"2WrOyjJxNfZc6xxG" iv:[@"M7hrljkSmAX1MLCb" dataUsingEncoding:NSUTF8StringEncoding]];
    // 解密
    NSString *decryptTime = [LTEncryptorTools AESDecryptString:time keyString:@"2WrOyjJxNfZc6xxG" iv:[@"M7hrljkSmAX1MLCb" dataUsingEncoding:NSUTF8StringEncoding]];
    
    BOOL show = NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:decryptTime];
    show = [date earlierDate:[NSDate date]] != date;
    return show;
}
    

- (UIView *)emptyView
{
    if (!_emptyView)
    {
        UIView *emptyView = [[UIView alloc] init];
        emptyView.frame = self.view.bounds;
        emptyView.backgroundColor = UIColor.whiteColor;
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColor.blackColor;
        label.font = [UIFont systemFontOfSize:17.f];
        label.text = @"请打开蜂窝网络移动数据或使用无线局域网来访问app";
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.width = self.view.width - 2 * 16.f;
        label.bottom = self.view.centerY - 15.f;
        label.left = 16.f;
        label.height = [label.text heightForFont:label.font width:label.width];
        [emptyView addSubview:label];
        
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"刷新" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        button.contentEdgeInsets = UIEdgeInsetsMake(5.f, 20.f, 5.f, 20.f);
        button.top = label.bottom + 30.f;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = UIColor.blackColor.CGColor;
        [button sizeToFit];
        button.centerX = emptyView.centerX;
        [emptyView addSubview:button];
        [button addTarget:self action:@selector(request) forControlEvents:UIControlEventTouchUpInside];
        
        _emptyView = emptyView;
        [self.view addSubview:emptyView];
    }
    return _emptyView;
}

+ (BOOL)isShow
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"iuhgtnbaoiueb45iutg4q35hg24"];
}

+ (void)setIsShow:(BOOL)isShow
{
    [[NSUserDefaults standardUserDefaults] setBool:isShow forKey:@"iuhgtnbaoiueb45iutg4q35hg24"];
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView)
    {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.view addSubview:_indicatorView];
        [self.view bringSubviewToFront:_indicatorView];
        _indicatorView.frame = CGRectMake(0.f, 0.f, 48.f, 48.f);
        _indicatorView.center = self.view.center;
        _indicatorView.hidesWhenStopped = YES;
    }
    return _indicatorView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
