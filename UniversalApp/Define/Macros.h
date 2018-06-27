//
//  Macros.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/19.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#define kAppStringPlaceholder @"none"

//屏幕缩放因子
#define kScale ([UIScreen mainScreen].scale)

#pragma mark - 系统版本/APP版本
//如果是iOS11
#define IF_IOS_10(Stuff) \
if (@available(iOS 10.0, *)) {  \
Stuff; \
}
//如果是iOS11
#define IF_IOS_11(Stuff) \
if (@available(iOS 11.0, *)) {  \
Stuff; \
}

#pragma mark - 屏幕尺寸
//需要横屏或者竖屏，获取屏幕宽度与高度
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上
#define kScreenWidth ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
//向上取整
#define kScreenHeight ceilf([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define kScreenSize ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#define kScreenBounds ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGRectMake(0, 0,[UIScreen mainScreen].nativeBounds.size.width / [UIScreen mainScreen].nativeScale, [UIScreen mainScreen].nativeBounds.size.height / [UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds)
#else
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenSize [UIScreen mainScreen].bounds.size
#define kScreenBounds [UIScreen mainScreen].bounds
#endif
//导航栏到顶部的高度
#define kNavigationToTopHeight (IPHONE_SIZE_58INCH ? 88.f : 64.f)
//Home Indicator的高度
#define kHomeIndicatorHeight (IPHONE_SIZE_58INCH ? 34.f : 0.f)
//tabBar的高度
#define kTabBarHeight (IPHONE_SIZE_58INCH ? (49.f + 34.f) : 49.f)
//statusBar的高度
#define kStatusBarHeight (IPHONE_SIZE_58INCH ? (20.f + 22.f) : 20.f)


//不同屏幕尺寸,字体适配（375 x 667是因为效果图为iPhone 6s 如果不是则根据实际情况修改）
#define kScreenWidthRatio (kScreenWidth / 375.f)
#define kScreenHeightRatio (kScreenHeight / 667.f)
#define kAdaptedWidth(x) (ceilf((x) * kScreenWidthRatio))  //向上取整
#define kAdaptedHeight(x) (ceilf((x) * kScreenHeightRatio))  //向上取整

#pragma mark - 颜色相关
//可使用YYKit中的UIColorHex宏定义,eg:UIColorHex(e1e8ed)
#define UIColorRGBA(r, g, b, a) ([UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a])
#define UIColorRGB(r, g, b) (UIColorRGBA(r, g, b, 1.0f))
#define UIColorRandom ([UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0])
// 将16进制颜色转换成UIColor eg: UIColorWithHEX(0x5cacee)
#define UIColorHEX_Alpha(hex, a) ([UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:a])
#define UIColorHEX(hex) (UIColorHEX_Alpha(hex, 1.0f))


#pragma mark - 字体大小(常规/粗体)
//常规
#define kSystemFontOfSize(fontSize) ([UIFont systemFontOfSize:fontSize])
//粗体
#define KBoldSystemFontOfSize(fontSize) ([UIFont boldSystemFontOfSize:fontSize])
//斜体
#define KItalicSystemFontOfSize(fontSize) ([UIFont italicSystemFontOfSize:fontSize])
#define kFont(name, fontSize) ([UIFont fontWithName:(name) size:(fontSize)])
//中文字体
#define kChineseFontName (@"Heiti SC")
#define kChineseFontWithSize(x) ([UIFont fontWithName:kChineseFontName size:x])

#pragma mark - 字符串相关
#define kStringIsNULL(string) ([string isKindOfClass:[NSNull class]] || (string.length < 1))
//拼接字符串
#define NSStringWithFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]
//BOOL值转字符串
#define NSStringFromBOOL(_flag) (_flag ? @"YES" : @"NO")
//数值转字符串
#define NSStringFromValue(value) (@(value).stringValue)
//ASCII数值转字符串
#define NSStringFromASCIICode(asciiCode) ([NSString stringWithFormat:@"%C", asciiCode])
//数据验证
#define NSStringValid(string) (string != nil && [string isKindOfClass:[NSString class]] && ![string isEqualToString:@""])
#define NSStringSafe(string) (ValidString(string) ? string : kAppStringPlaceholder)
#define NSStringContainsString(string, key) ([string rangeOfString:key].location != NSNotFound)

#pragma mark -  编译相关
//消除performSelector:警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)

#pragma mark - 弱引用/强引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type
#define kStrongSelf(type)  __strong typeof(type) type = weak##type

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


#pragma mark - 自定义高效率的 NSLog
#ifdef DEBUG
#define NSLog(...) NSLog(@"%s 第%d行 \n%@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif

#pragma mark - 设置 view 圆角和边框
#define kViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

#pragma mark - 由角度转换弧度 由弧度转换角度
#define kDegreesToRadian(x) (M_PI * (x) / 180.0)
#define kRadianToDegrees(radian) (radian * 180.0)/(M_PI)

#pragma mark - 获取图片资源
#define UIImageWithName(imageName) ([UIImage imageNamed:imageName])
#define UIImageWithPathName(imageName) ([UIImage imageNamed:([[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]])])
#define UIImageWithPathNameAndType(imageName, type) ([UIImage imageNamed:([[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, type]])])
#pragma mark - 获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])


#pragma mark - info.plist 字典
//app info.plist 字典
#define kInfoDictionary ([[NSBundle mainBundle] infoDictionary])
//当前app版本
#define kAPPVersion ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
//app展示的名字
#define kAPPDisplayName ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"])
//打开系统app设置页面
#define kOpenApplicationSettings ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])


#pragma mark - 判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

// 判断当前是否debug编译模式
#ifdef DEBUG
#define IS_DEBUG YES
#else
#define IS_DEBUG NO
#endif

#pragma mark - 沙盒目录文件
//获取沙盒 home路径
#define kPathHome (NSHomeDirectory())
//获取沙盒 temp路径
#define kPathTmp (NSTemporaryDirectory())
//获取沙盒 Document路径
#define kPathDocument ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject])
//获取沙盒 Cache路径
#define kPathCache ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject])
//获取沙盒 library路径
#define kPathLibrary ([NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject])

#pragma mark - 系统单例
//应用程序实例
#define kApplication ([UIApplication sharedApplication])
//当前KeyWindow
#define kKeyWindow ([UIApplication sharedApplication].keyWindow)
//应用程序实例代理
#define kApplicationDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
//数据存储
#define kUserDefaults ([NSUserDefaults standardUserDefaults])
//消息中心
#define kNotificationCenter ([NSNotificationCenter defaultCenter])
//文件管理
#define kFileManager ([NSFileManager defaultManager])
//请求缓存
#define kURLCache ([NSURLCache sharedURLCache])
//应用程序cookies池
#define kHTTPCookieStorage ([NSHTTPCookieStorage sharedHTTPCookieStorage])
//发送网络请求会话
#define kURLSession ([NSURLSession sharedSession])
//弹出的菜单可以选择，复制，剪切，粘贴的功能
#define kMenuController ([UIMenuController sharedMenuController])
//统一外观
#define kAppearance ([UIAppearance appearance])
//当前设备
#define kCurrentDevice ([UIDevice currentDevice])
//当前主屏幕
#define kMainScreen ([UIScreen mainScreen])
//主线程运行循环
#define kMainRunLoop ([NSRunLoop mainRunLoop])
//当前RunloopMode
#define kCurrentRunLoopMode ([NSRunLoopMode currentMode])
//当前线程
#define kCurrentThread ([NSThread currentThread])
//主线程
#define kMainThread ([NSThread mainThread])
//根控制器
#define krootViewController (kKeyWindow.rootViewController)


#pragma mark - APP跳转
// 需要到 Targets ->Info ->URL Type 的 URL Schemes 添加跳转的唯一标识
//打开一个url字符串
#define kOpenURLString(urlString) ([kApplication openURL:[NSURL URLWithString:(urlString)]])
//拨打电话
#define kOpenTelPhone(phoneNum) ([kApplication openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", (phoneNum)]]])
// 发短信
#define kOpenMassage(massage) ([kApplication openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", (massage)]]])

//单例化一个类
#define SINGLETON_FOR_H \
\
+ (instancetype)sharedInstance;

#define SINGLETON_FOR_M \
\
+ (instancetype)sharedInstance  \
{ \
    static id instance = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        instance = [[self alloc] init]; \
    }); \
    return instance; \
}

//发送通知
#define KPostNotification(name) ([[NSNotificationCenter defaultCenter] postNotificationName:name object:nil])
#define KPostNotificationWithObject(name,obj) ([[NSNotificationCenter defaultCenter] postNotificationName:name object:obj])

