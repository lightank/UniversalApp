//
//  LTLocalizations.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/11/19.
//  Copyright © 2018 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MOLLanguage;
@class LTLocalizations;

// 国际化
#define kLTCurrentlprojName ([LTLocalizations currentlprojName])
#define kLTCurrentLanguage (((NSArray *)([[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"])).firstObject)
#define LTLocalizedString(string) ([[NSBundle bundleWithPath:[NSBundle.mainBundle pathForResource:kLTCurrentlprojName ofType:@"lproj"]] localizedStringForKey:(string) value:@"" table:nil])
#define LTLocalizedStringWithTable(string, table) ([[NSBundle bundleWithPath:[NSBundle.mainBundle pathForResource:kLTCurrentlprojName ofType:@"lproj"]] localizedStringForKey:(string) value:@"" table:table])


// 设置语言成功通知
extern NSString * const LTLanguageDidSettingSuccessNotification;
// 单例
extern LTLocalizations *LTLocalizationsInstance;

NS_ASSUME_NONNULL_BEGIN

@interface LTLocalizations : NSObject

/**  服务器支持的语言  */
//@property (class, nonatomic, readonly) NSArray<MOLLanguage *> *languages;
/**  本地化语言数组  */
@property (class, nonatomic, readonly) NSArray<MOLLanguage *> *localizatedLanguages;
/**  当前语言  */
@property (class, nonatomic) NSString *currentLanguage;
/**  当前语言对应的lproj文件夹名字  */
@property (class, nonatomic, readonly)  NSString *currentlprojName;

/**  在.m里返回语言设置控制器  */
+ (UIViewController *)languageSettingViewController;
/**  显示语言设置页面  */
+ (void)showLanguageSettingPage;
/**  隐藏语言设置页面  */
+ (void)hiddenLanguageSettingPage;

@end

@interface MOLLanguage : NSObject

/**  英文缩写  */
@property (nonatomic, copy) NSString *abbreviations;
/**  中文名称  */
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END


