//
//  LTLocalizations.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/11/19.
//  Copyright © 2018 huanyu.li. All rights reserved.
//

#import "LTLocalizations.h"

LTLocalizations *LTLocalizationsInstance = nil;


@interface LTLocalizations ()

/**  导航控制器  */
@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation LTLocalizations

@dynamic currentLanguage;

+ (void)initialize
{
    if (self == [LTLocalizations class])
    {
        [self sharedInstance];
    }
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    //static LTLocalizations *instance = nil;
    dispatch_once(&onceToken,^{
        LTLocalizationsInstance = [[super allocWithZone:NULL] init];
    });
    return LTLocalizationsInstance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (void)initializeLocalization
{
    [self sharedInstance];
}

+ (UIViewController *)languageSettingViewController
{
    return [[NSClassFromString(@"LTLanguageSettingViewController") alloc] init];
}

/**  显示语言设置页面  */
+ (void)showLanguageSettingPage
{
    static NSString *title = @"lt_language_setting_page_navigation_controller_title";

    // 如果当前页面就是登录页面就不用跳转了
    if (kCurrentViewController.navigationController.title == title)
    {
        return;
    }
    
    UIViewController *languageSettingViewController = [self languageSettingViewController];
    NSAssert([languageSettingViewController isKindOfClass:[UIViewController class]], @"尚未设置登录界面");
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:languageSettingViewController];
    navigationController.title = title;
    LTLocalizationsInstance.navigationController = navigationController;
    [kCurrentViewController presentViewController:navigationController animated:YES completion:^{
        
    }];

}
/**  隐藏语言设置页面  */
+ (void)hiddenLanguageSettingPage
{
    if (!LTLocalizationsInstance.navigationController) return;
    [LTLocalizationsInstance.navigationController dismissViewControllerAnimated:YES completion:^{
        LTLocalizationsInstance.navigationController = nil;
    }];
}

+ (void)postLanguageDidSettingSuccessNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LTLanguageDidSettingSuccessNotification object:self userInfo:@{@"language" : [self currentLanguage]}];
}

#pragma mark - setter and getter
+ (NSArray<MOLLanguage *> *)localizatedLanguages
{
    static NSMutableArray<MOLLanguage *> *localizatedLanguages = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localizatedLanguages = [NSMutableArray array];
        for (NSString *languageName in [self localizationLanguageNames])
        {
            MOLLanguage *language = [[MOLLanguage alloc] init];
            language.abbreviations = languageName;
            language.name = [self languageDictionary][languageName];
            [localizatedLanguages addObject:language];
        }
    });
    return localizatedLanguages;
}

+ (NSString *)currentLanguage
{
    NSArray *languageArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *language = languageArray.firstObject;
    return language;
}

+ (void)setCurrentLanguage:(NSString *)currentLanguage
{
    if (!currentLanguage) return;
    BOOL changed = ![[self currentLanguage] containsString:currentLanguage];
    [[NSUserDefaults standardUserDefaults] setObject:@[currentLanguage] forKey:@"AppleLanguages"];
    if (changed)
    {
        [self postLanguageDidSettingSuccessNotification];
        [self hiddenLanguageSettingPage];
    }
}

+ (NSString *)currentlprojName
{
    NSString *prefix = [[self currentLanguage] componentsSeparatedByString:@"-"].firstObject;
    NSString *currentlprojName = [self lprojFileNameDictionary][prefix];
    return currentlprojName;
}

/**  当前有的本地化语言  */
+ (NSArray *)localizationLanguageNames
{
    return @[@"zh", @"en"];
}

/**  英文简称对应的本国语言名称  */
+ (NSDictionary<NSString *, NSString *> *)languageDictionary
{
    static NSDictionary<NSString *, NSString *> *languageDictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        languageDictionary = @{
                               @"en" : @"English",  //英语
                               @"fr" : @"Français", //法语
                               @"de" : @"Deutsch", //德语
                               @"zh" : @"简体中文", //简体中文
                               @"zh-Hans" : @"简体中文", //简体中文
                               @"zh-Hant" : @"繁體中文", //繁体中文
                               @"ja" : @"日本語", //德语
                               @"es" : @"Español", //西班牙语
                               @"ko" : @"한국어", //韩语
                               };
    });
    return languageDictionary;
}

/**  由于同为简体中文下,真机取语言为:zh-Hans-CN, 模拟器为:zh-Hans, 这个提供额外的语言前缀对应的lproj文件名,如果取不到值,就直接取当前语言名前缀  */
+ (NSDictionary<NSString *, NSString *> *)lprojFileNameDictionary
{
    static NSDictionary<NSString *, NSString *> *dictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dictionary = @{
                       @"zh" : @"zh-Hans",
                       @"en" : @"en",
                       @"ko" : @"ko",
                       @"ja" : @"ja",
                       };
    });
    return dictionary;
}


@end


@implementation MOLLanguage


@end


// 设置语言成功通知
NSString * const LTLanguageDidSettingSuccessNotification = @"LTLanguageDidSettingSuccessNotification";
