//
//  LTFirstViewController.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/25.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTFirstViewController.h"
#import "LTPrivacyPermission.h"

@interface LTFirstViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *titleArray;

@end

@implementation LTFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}
#pragma mark - UI
- (void)initUI
{
    _titleArray = @[NSLocalizedString(@"打开相册权限", nil),
                    NSLocalizedString(@"打开相机权限", nil),
                    NSLocalizedString(@"打开媒体资料库权限", nil),
                    NSLocalizedString(@"打开麦克风权限", nil),
                    NSLocalizedString(@"打开位置权限", nil),
                    NSLocalizedString(@"打开推送权限", nil),
                    NSLocalizedString(@"打开语音识别权限", nil),
                    NSLocalizedString(@"打开日历权限", nil),
                    NSLocalizedString(@"打开通讯录权限", nil),
                    NSLocalizedString(@"打开提醒事项权限", nil),
                    NSLocalizedString(@"打开运动与健身权限", nil)
                    ];
    
    _tableView = [[UITableView alloc] init];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.scrollEnabled = YES;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.textAlignment = 0;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row)
    {
        case 0:
        {
            [LTPrivacyPermission.sharedPermission accessPrivacyPermissionWithType:LTPrivacyPermissionTypePhoto completion:^(BOOL authorized, LTPrivacyPermissionAuthorizationStatus status) {
                
            }];
        }
            break;
            
        case 1:
        {
            [LTPrivacyPermission.sharedPermission accessPrivacyPermissionWithType:LTPrivacyPermissionTypeCamera completion:^(BOOL authorized, LTPrivacyPermissionAuthorizationStatus status) {
                
            }];
        }
            break;
            
        case 2:
        {
            [LTPrivacyPermission.sharedPermission accessPrivacyPermissionWithType:LTPrivacyPermissionTypeMedia completion:^(BOOL authorized, LTPrivacyPermissionAuthorizationStatus status) {
                
            }];
        }
            break;
            
        case 3:
        {
            [LTPrivacyPermission.sharedPermission accessPrivacyPermissionWithType:LTPrivacyPermissionTypeMicrophone completion:^(BOOL authorized, LTPrivacyPermissionAuthorizationStatus status) {
                
            }];
        }
            break;
            
        case 4:
        {
            [LTPrivacyPermission.sharedPermission accessPrivacyPermissionWithType:LTPrivacyPermissionTypeLocationAlwaysAndWhenInUse completion:^(BOOL authorized, LTPrivacyPermissionAuthorizationStatus status) {
                
            }];
        }
            break;
            
        case 5:
        {
            [LTPrivacyPermission.sharedPermission accessPrivacyPermissionWithType:LTPrivacyPermissionTypePushNotification completion:^(BOOL authorized, LTPrivacyPermissionAuthorizationStatus status) {
                
            }];
        }
            break;
            
        case 6:
        {
            [LTPrivacyPermission.sharedPermission accessPrivacyPermissionWithType:LTPrivacyPermissionTypeSpeech completion:^(BOOL authorized, LTPrivacyPermissionAuthorizationStatus status) {
                
            }];
        }
            break;
            
        case 7:
        {
            [LTPrivacyPermission.sharedPermission accessPrivacyPermissionWithType:LTPrivacyPermissionTypeEvent completion:^(BOOL authorized, LTPrivacyPermissionAuthorizationStatus status) {
                
            }];
        }
            break;
            
        case 8:
        {
            [LTPrivacyPermission.sharedPermission accessPrivacyPermissionWithType:LTPrivacyPermissionTypeContact completion:^(BOOL authorized, LTPrivacyPermissionAuthorizationStatus status) {
                
            }];
        }
            break;
            
        case 9:
        {
            [LTPrivacyPermission.sharedPermission accessPrivacyPermissionWithType:LTPrivacyPermissionTypeReminder  completion:^(BOOL authorized, LTPrivacyPermissionAuthorizationStatus status) {
                
            }];
        }
            break;
            
        default:
            break;
    }
    [tableView reloadData];
}


@end
