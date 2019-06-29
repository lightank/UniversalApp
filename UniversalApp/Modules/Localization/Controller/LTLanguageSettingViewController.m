//
//  LTLanguageSettingViewController.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/11/19.
//  Copyright © 2018 huanyu.li. All rights reserved.
//

#import "LTLanguageSettingViewController.h"
#import "LTLocalizations.h"
#import "LTLanguageTableViewCell.h"

@interface LTLanguageSettingViewController ()

/**  语言表  */
@property (nonatomic, strong) NSArray<MOLLanguage *> *languages;
/**  当前语言index  */
@property (nonatomic, strong) NSIndexPath *selectedIndex;

@end

@implementation LTLanguageSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.languages = [NSArray array];
    [self initSubviews];
    [self requestLanguages];
}

- (void)requestLanguages
{
    self.languages = LTLocalizations.localizatedLanguages;
    
    if (self.languages.count == 0)
    {
        //[QMUITips showError:LTLocalizedString(@"Global.NetworkError") inView:self.view hideAfterDelay:1.f];
    }
    
    __block NSString *currentLanguage = LTLocalizations.currentLanguage;
    __block NSInteger selectedIndex = 0;
    [self.languages enumerateObjectsUsingBlock:^(MOLLanguage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = obj.abbreviations;
        if ([currentLanguage containsString:name])
        {
            selectedIndex = idx;
            *stop = YES;
        }
    }];
    NSIndexPath *index = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self.tableView reloadData];
    self.selectedIndex = index;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
        UIButton *button = self.navigationItem.rightBarButtonItem.customView;
        button.enabled = NO;
    });
}

- (void)initSubviews
{
    self.title = LTLocalizedString(@"User.LanguageSettings");
    
    self.navigationItem.leftBarButtonItem = [self closeBarButtonItem];
    self.navigationItem.rightBarButtonItem = [self finishBarButtonItem];
    
    [self.tableView registerClass:[LTLanguageTableViewCell class] forCellReuseIdentifier:[LTLanguageTableViewCell lt_reuseIdentifier]];
}

- (UIBarButtonItem *)closeBarButtonItem
{
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setTitle:LTLocalizedString(@"Global.Cancel") forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton sizeToFit];
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    return close;
}

- (UIBarButtonItem *)finishBarButtonItem
{
    UIButton *finishButton = [[UIButton alloc] init];
    [finishButton setTitle:LTLocalizedString(@"Global.Complete") forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [finishButton sizeToFit];
    [finishButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
    finishButton.enabled = NO;
    UIBarButtonItem *finish = [[UIBarButtonItem alloc] initWithCustomView:finishButton];
    return finish;
}

#pragma mark - actions
- (void)closeButtonAction
{
    [LTLocalizations hiddenLanguageSettingPage];
}
- (void)finishButtonAction
{
    NSUInteger row = self.tableView.indexPathForSelectedRow.row;
    LTLocalizations.currentLanguage = self.languages[row].abbreviations;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.languages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LTLanguageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LTLanguageTableViewCell lt_reuseIdentifier]];
    NSString *language = self.languages[indexPath.row].name;
    cell.textLabel.text = language;
    cell.tintColor = [UIColor blackColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIButton *button = self.navigationItem.rightBarButtonItem.customView;
    button.enabled = indexPath.row != self.selectedIndex.row;
    
    if (indexPath.row != self.selectedIndex.row)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedIndex];
        cell.selected = NO;
    }
}


@end
