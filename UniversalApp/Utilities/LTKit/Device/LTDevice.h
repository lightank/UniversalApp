//
//  LTDevice.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/20.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CFNetwork/CFNetwork.h>

#pragma mark - 系统版本相关
// 手机系统版本是否为 iOS 8.0 及以上
#define LT_IOS8_OR_LATER ([LTDevice iOS8OrLater])
// 手机系统版本是否为 iOS 9.0 及以上
#define LT_IOS9_OR_LATER ([LTDevice iOS9OrLater])
// 手机系统版本是否为 iOS 10.0 及以上
#define LT_IOS10_OR_LATER ([LTDevice iOS10OrLater])
// 手机系统版本是否为 iOS 11.0 及以上
#define LT_IOS11_OR_LATER ([LTDevice iOS11OrLater])
// 手机系统版本是否为 iOS 12.0 及以上
#define LT_IOS12_OR_LATER ([LTDevice iOS12OrLater])

#pragma mark - 尺寸相关
/**  判断是否为 iPhone X 系列刘海设计  */
#define LT_IPHONE_Notched_Screen ([LTDevice isNotchedScreen])
// 判断是否为 6.5英寸 iPhone XS Max pt:414x896，px:1242x2688 ，@3x
#define LT_IPHONE_SIZE_65INCH ([LTDevice is65InchScreen])
// 判断是否为 6.1英寸 iPhone XR pt:414x896，px:828x1792，@2x
#define LT_IPHONE_SIZE_61INCH ([LTDevice is61InchScreen])
// 判断是否为 5.8英寸 iPhone X/XS pt:375x812，px:1125x2436，@3x
#define LT_IPHONE_SIZE_58INCH ([LTDevice is58InchScreen])
// 判断是否为 5.5英寸 iPhone 6Plus/6sPlus pt:414x736，px:1242x2208，@3x
#define LT_IPHONE_SIZE_55INCH ([LTDevice is55InchScreen])
// 判断是否为 4.7英寸 iPhone 6/6s pt:375x667，px:750x1334，@2x
#define LT_IPHONE_SIZE_47INCH ([LTDevice is47InchScreen])
// 判断是否为 4.0英寸 iPhone 5/SE pt:320x568，px:640x1136，@2x
#define LT_IPHONE_SIZE_40INCH ([LTDevice is40InchScreen])
// 判断是否为 3.5英寸 iPhone 4/4S pt:320x480，px:640x960，@2x
#define LT_IPHONE_SIZE_35INCH ([LTDevice is35InchScreen])

//Home Indicator的高度
#define kLTHomeIndicatorHeight ([LTDevice homeIndicatorHeight])
//tabBar的高度
#define kLTTabBarHeight ([LTDevice tabBarHeight])
//statusBar的高度
#define kLTStatusBarHeight ([LTDevice statusBarHeight])
//navigationBar高度
#define kLTNavigationBarHeight ([LTDevice navigationBarHeigh])
//导航栏到顶部的高度
#define kLTNavigationPlusStatusBarHeight ([LTDevice navigationPlusStatusBarHeight])

//不同屏幕尺寸适配（375 x 667是因为效果图为iPhone 6s 如果不是则根据实际情况修改）
#define kLTScreenWidthRatio (kScreenWidth / 375.f)
#define kLTScreenHeightRatio (kScreenHeight / 667.f)
#define kLTAdaptedWidth(x) ((x) * kLTScreenWidthRatio)  //不向上取整
#define kLTAdaptedHeight(x) ((x) * kLTScreenHeightRatio)  //不向上取整
//#define kAdaptedWidth(x) (ceilf((x) * kScreenWidthRatio))  //向上取整
//#define kAdaptedHeight(x) (ceilf((x) * kScreenHeightRatio))  //向上取整

#pragma mark - 字体相关
// 字体相关的宏，用于快速创建一个字体对象，更多创建宏可查看 UIFont+QMUI.h
#define UIFontOfSize(size) ([UIFont systemFontOfSize:size]) //常规
#define UIFontItalicOfSize(size) ([UIFont italicSystemFontOfSize:size]) //斜体,只对数字和字母有效，中文无效
#define UIFontBoldOfSize(size) ([UIFont boldSystemFontOfSize:size]) //粗体
//#define UIFontBoldWithFont(_font) ([UIFont boldSystemFontOfSize:_font.pointSize])

#pragma mark - 字符串相关
//BOOL值转字符串
#define NSStringFromBOOL(_flag) (_flag ? @"YES" : @"NO")
//数值转字符串
#define NSStringFromValue(value) (@(value).stringValue)
//ASCII数值转字符串
#define NSStringFromASCIICode(asciiCode) ([NSString stringWithFormat:@"%C", asciiCode])

#pragma mark - 颜色相关
//可使用YYKit中的UIColorHex宏定义,eg:UIColorHex(e1e8ed)
#define UIColorRGBA(r, g, b, a) ([UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a])
#define UIColorRGB(r, g, b) (UIColorRGBA(r, g, b, 1.0f))
#define UIColorRandom ([UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0])
// 将16进制颜色转换成UIColor eg: UIColorWithHEX(0x5cacee)
//#define UIColorHEX_Alpha(hex, a) ([UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:a])
//#define UIColorWithHEX(hex) (UIColorHEX_Alpha(hex, 1.0f))


@interface LTDevice : NSObject

#pragma mark - 设备相关
/**  系统设备类型(如iPhone, iPod touch)  */
@property (nonatomic, readonly, nullable) NSString *deviceModel;
@property (class, nonatomic, readonly, nullable) NSString *deviceModel;
/**  设备名称(如xxx的iPhone)  */
@property (nonatomic, readonly, nullable) NSString *deviceName;
@property (class, nonatomic, readonly, nullable) NSString *deviceName;
/**  无格式的系统设备类型(如:i386, iPhone6,1)  */
@property (nonatomic, readonly, nullable) NSString *machineModel;
@property (class, nonatomic, readonly, nullable) NSString *machineModel;
/**  格式化的系统设备类型(如:iPhone 6s, iPhone 6s Plus)  */
@property (nonatomic, readonly, nullable) NSString *machineModelName;
@property (class, nonatomic, readonly, nullable) NSString *machineModelName;
/**  屏幕尺寸:3.5 4.0 4.7 5.5 ...  */
@property (nonatomic, readonly, nullable) NSString *screenInchSize;
@property (class, nonatomic, readonly, nullable) NSString *screenInchSize;
/**  CPU类型:arm arm64 x86 x86_64  */
@property (nonatomic, readonly, nullable) NSString *CUPType;
@property (class, nonatomic, readonly, nullable) NSString *CUPType;
/**  SIM卡类型:Micro Nano, iPhone 4s之后都是Nano卡  */
@property (nonatomic, readonly, nullable) NSString *SIMType;
@property (class, nonatomic, readonly, nullable) NSString *SIMType;
/**  电池状态:充电,放电,充满100%等  */
@property(nonatomic, readonly) UIDeviceBatteryState batteryState;
@property(class, nonatomic, readonly) UIDeviceBatteryState batteryState;
/**  电池电量,0 .. 1.0. -1.0 if UIDeviceBatteryStateUnknown  */
@property (nonatomic, readonly) CGFloat batteryLevel;
@property (class, nonatomic, readonly) CGFloat batteryLevel;
/**  是否为模拟器  */
@property (nonatomic, readonly) BOOL isSimulator;
@property (class, nonatomic, readonly) BOOL isSimulator;
/**  是否越狱  */
@property (nonatomic, readonly) BOOL isJailbroken;
@property (class, nonatomic, readonly) BOOL isJailbroken;
/**  是否支持指纹识别  */
@property (nonatomic, readonly) BOOL isEnableTouchID;
@property (class, nonatomic, readonly) BOOL isEnableTouchID;
/**  屏幕分辨率  */
@property (nonatomic, readonly, nullable) NSString *resolutionRatio;
@property (class, nonatomic, readonly, nullable) NSString *resolutionRatio;;
/**  是否是iPad  */
@property (nonatomic, readonly) BOOL isIPad;
@property (class, nonatomic, readonly) BOOL isIPad;
/**  是否是iPod  */
@property (nonatomic, readonly) BOOL isIPod;
@property (class, nonatomic, readonly) BOOL isIPod;
/**  是否是iPhone  */
@property (nonatomic, readonly) BOOL isIPhone;
@property (class, nonatomic, readonly) BOOL isIPhone;

#pragma mark - 屏幕/尺寸相关
/**  屏幕亮度,系统取值是0-1,这里取值在系统基础上 *100 取值范围为0-100  */
@property (nonatomic, readonly) CGFloat screenBrightness;
@property (class, nonatomic, readonly) CGFloat screenBrightness;
/**  用户界面横屏了才会返回YES  */
@property (nonatomic, readonly) BOOL isLandscape;
@property (class, nonatomic, readonly) BOOL isLandscape;
/**  无论支不支持横屏，只要设备横屏了，就会返回YES  */
@property (nonatomic, readonly) BOOL isDeviceLandscape;
@property (class, nonatomic, readonly) BOOL isDeviceLandscape;
/**  屏幕宽度，跟横竖屏无关  */
@property (nonatomic, readonly) CGFloat deviceWidth;
@property (class, nonatomic, readonly) CGFloat deviceWidth;
/**  屏幕高度，跟横竖屏无关  */
@property (nonatomic, readonly) CGFloat deviceHeight;
@property (class, nonatomic, readonly) CGFloat deviceHeight;
/**  屏幕宽度，会根据横竖屏的变化而变化  */
@property (nonatomic, readonly) CGFloat screenWidth;
@property (class, nonatomic, readonly) CGFloat screenWidth;
/**  屏幕高度，会根据横竖屏的变化而变化  */
@property (nonatomic, readonly) CGFloat screenHeight;
@property (class, nonatomic, readonly) CGFloat screenHeight;
/**  状态栏高度(来电等情况下，状态栏高度会发生变化，所以应该实时计算),普通的是20pt,刘海屏是44pt.来电时普通的40pt,刘海屏还是44pt,状态栏高度变化会发送UIApplicationWillChangeStatusBarFrameNotification通知  */
@property (nonatomic, readonly) CGFloat statusBarHeight;
@property (class, nonatomic, readonly) CGFloat statusBarHeight;
/**  判断是否为 iPhone X 系列刘海设计  */
@property (nonatomic, readonly) BOOL isNotchedScreen;
@property (class, nonatomic, readonly) BOOL isNotchedScreen;
/**  判断是否为 6.5英寸 iPhone XR pt:414x896，px:1242x2688，@3x  */
@property (nonatomic, readonly) BOOL is65InchScreen;
@property (class, nonatomic, readonly) BOOL is65InchScreen;
/**  判断是否为 6.1英寸 iPhone XR pt:414x896，px:828x1792，@2x  */
@property (nonatomic, readonly) BOOL is61InchScreen;
@property (class, nonatomic, readonly) BOOL is61InchScreen;
/**  判断是否为 5.8英寸 iPhone X/XS pt:375x812，px:1125x2436，@3x  */
@property (nonatomic, readonly) BOOL is58InchScreen;
@property (class, nonatomic, readonly) BOOL is58InchScreen;
/**  判断是否为 5.5英寸 iPhone 6Plus/6sPlus pt:414x736，px:1242x2208，@3x  */
@property (nonatomic, readonly) BOOL is55InchScreen;
@property (class, nonatomic, readonly) BOOL is55InchScreen;
/**  判断是否为 4.7英寸 iPhone 6/6s pt:375x667，px:750x1334，@2x  */
@property (nonatomic, readonly) BOOL is47InchScreen;
@property (class, nonatomic, readonly) BOOL is47InchScreen;
/**  判断是否为 4.0英寸 iPhone 5/SE pt:320x568，px:640x1136，@2x  */
@property (nonatomic, readonly) BOOL is40InchScreen;
@property (class, nonatomic, readonly) BOOL is40InchScreen;
/**  判断是否为 3.5英寸 iPhone 4/4S pt:320x480，px:640x960，@2x  */
@property (nonatomic, readonly) BOOL is35InchScreen;
@property (class, nonatomic, readonly) BOOL is35InchScreen;
/**  6.5英寸 屏幕尺寸414x896   */
@property (nonatomic, readonly) CGSize screenSizeFor65Inch;
@property (class, nonatomic, readonly) CGSize screenSizeFor65Inch;
/**  6.1英寸 屏幕尺寸414x896   */
@property (nonatomic, readonly) CGSize screenSizeFor61Inch;
@property (class, nonatomic, readonly) CGSize screenSizeFor61Inch;
/**  5.8英寸 屏幕尺寸375x812   */
@property (nonatomic, readonly) CGSize screenSizeFor58Inch;
@property (class, nonatomic, readonly) CGSize screenSizeFor58Inch;
/**  5.5英寸 屏幕尺寸414x736   */
@property (nonatomic, readonly) CGSize screenSizeFor55Inch;
@property (class, nonatomic, readonly) CGSize screenSizeFor55Inch;
/**  4.7英寸 屏幕尺寸375x667   */
@property (nonatomic, readonly) CGSize screenSizeFor47Inch;
@property (class, nonatomic, readonly) CGSize screenSizeFor47Inch;
/**  4.0英寸 屏幕尺寸320x568   */
@property (nonatomic, readonly) CGSize screenSizeFor40Inch;
@property (class, nonatomic, readonly) CGSize screenSizeFor40Inch;
/**  3.5英寸 屏幕尺寸320x480   */
@property (nonatomic, readonly) CGSize screenSizeFor35Inch;
@property (class, nonatomic, readonly) CGSize screenSizeFor35Inch;
/**  是否Retina  */
@property (nonatomic, readonly) BOOL isRetinaScreen;
@property (class, nonatomic, readonly) BOOL isRetinaScreen;
/**  获取一像素的大小  */
@property (nonatomic, readonly) CGFloat pixelOne;
@property (class, nonatomic, readonly) CGFloat pixelOne;
/**  homeIndicator Height:竖屏为34pt,横屏为21pt */
@property (nonatomic, readonly) CGFloat homeIndicatorHeight;
@property (class, nonatomic, readonly) CGFloat homeIndicatorHeight;
/**  tabBarHeight:固定高度49pt + homeIndicatorHeight  */
@property (nonatomic, readonly) CGFloat tabBarHeight;
@property (class, nonatomic, readonly) CGFloat tabBarHeight;
/**  导航栏固定高度:44pt  */
@property (nonatomic, readonly) CGFloat navigationBarHeigh;
@property (class, nonatomic, readonly) CGFloat navigationBarHeigh;
/**  导航栏 + 状态栏高度:固定高度44pt + statusBarHeight  */
@property (nonatomic, readonly) CGFloat navigationPlusStatusBarHeight;
@property (class, nonatomic, readonly) CGFloat navigationPlusStatusBarHeight;

#pragma mark - 系统版本,软件相关
/**  系统名称(如iOS)  */
@property (nonatomic, readonly, nullable) NSString *systemName;
@property (class, nonatomic, readonly, nullable) NSString *systemName;
/**  系统版本(如iOS 10.3)  */
@property (nonatomic, readonly, nullable) NSString *systemVersion;
@property (class, nonatomic, readonly, nullable) NSString *systemVersion;
/**  系统正常待机时间  */
@property (nonatomic, readonly, nullable) NSString *systemUptime;
@property (class, nonatomic, readonly, nullable) NSString *systemUptime;
/**  系统版本是否是iOS 8及以上  */
@property (nonatomic, readonly) BOOL iOS8OrLater;
@property (class, nonatomic, readonly) BOOL iOS8OrLater;
/**  系统版本是否是iOS 9及以上  */
@property (nonatomic, readonly) BOOL iOS9OrLater;
@property (class, nonatomic, readonly) BOOL iOS9OrLater;
/**  系统版本是否是iOS 10及以上  */
@property (nonatomic, readonly) BOOL iOS10OrLater;
@property (class, nonatomic, readonly) BOOL iOS10OrLater;
/**  系统版本是否是iOS 11及以上  */
@property (nonatomic, readonly) BOOL iOS11OrLater;
@property (class, nonatomic, readonly) BOOL iOS11OrLater;
/**  系统版本是否是iOS 12及以上  */
@property (nonatomic, readonly) BOOL iOS12OrLater;
@property (class, nonatomic, readonly) BOOL iOS12OrLater;
/**  剪切板上内容  */
@property (nonatomic, readonly, nullable) NSString *clipboardContent;
@property (class, nonatomic, readonly, nullable) NSString *clipboardContent;


#pragma mark - 本地区域相关
/**  所属国家  */
@property (nonatomic, readonly, nullable) NSString *country;
@property (class, nonatomic, readonly, nullable) NSString *country;
/**  本地语言  */
@property (nonatomic, readonly, nullable) NSString *language;
@property (class, nonatomic, readonly, nullable) NSString *language;
+ (void)resetLanguage;
/**  时间区域  */
@property (nonatomic, readonly, nullable) NSString *timeZone;
@property (class, nonatomic, readonly, nullable) NSString *timeZone;
/**  货币  */
@property (nonatomic, readonly, nullable) NSString *currency;
@property (class, nonatomic, readonly, nullable) NSString *currency;


#pragma mark - 网络相关
/**  运营商名字(如:中国移动)  */
@property (nonatomic, readonly, nullable) NSString *carrierName;
@property (class, nonatomic, readonly, nullable) NSString *carrierName;
/**  运营商所属国家  */
@property (nonatomic, readonly, nullable) NSString *carrierCountry;
@property (class, nonatomic, readonly, nullable) NSString *carrierCountry;
/**  运营商在所属国家的code  */
@property (nonatomic, readonly, nullable) NSString *carrierISOCountryCode;
@property (class, nonatomic, readonly, nullable) NSString *carrierISOCountryCode;
/**  运营商是否允许VOIP  */
@property (nonatomic, readonly) BOOL carrierAllowsVOIP;
@property (class, nonatomic, readonly) BOOL carrierAllowsVOIP;
/**  是否开启代理  */
@property (nonatomic, readonly) BOOL isOpenProxy;
@property (class, nonatomic, readonly) BOOL isOpenProxy;
/**  是否开启VPN  */
@property (nonatomic, readonly) BOOL isOpenVPN;
@property (class, nonatomic, readonly) BOOL isOpenVPN;
/**  当前蜂窝网络类型:2G/3G/4G等  */
@property (nonatomic, readonly, nullable) NSString *cellNetworkType;
@property (class, nonatomic, readonly, nullable) NSString *cellNetworkType;
/**  是否连接到蜂窝网络  */
@property (nonatomic, readonly) BOOL isConnectedToCellNetwork;
@property (class, nonatomic, readonly) BOOL isConnectedToCellNetwork;
/**  是否连接到WIFI  */
@property (nonatomic, readonly) BOOL isConnectedToWiFi;
@property (class, nonatomic, readonly) BOOL isConnectedToWiFi;
/**  当前WIFI名称  */
@property (nonatomic, readonly, nullable) NSString *WiFiName;
@property (class, nonatomic, readonly, nullable) NSString *WiFiName;
/**  当前连接WIFI MAC 地址  */
@property (nonatomic, readonly, nullable) NSString *WiFiMacAddress;
@property (class, nonatomic, readonly, nullable) NSString *WiFiMacAddress;
/**  WIFI IP address of this device (can be nil). e.g. @"192.168.1.111"  */
@property (nonatomic, readonly, nullable) NSString *ipAddressWiFi;
@property (class, nonatomic, readonly, nullable) NSString *ipAddressWiFi;
/**  Cell IP address of this device (can be nil). e.g. @"10.2.2.222"  */
@property (nonatomic, readonly, nullable) NSString *ipAddressCell;
@property (class, nonatomic, readonly, nullable) NSString *ipAddressCell;
/**  外网IP地址 (can be nil). e.g. @"10.2.2.222"  */
@property (nonatomic, readonly, nullable) NSString *externalIPAddress;
@property (class, nonatomic, readonly, nullable) NSString *externalIPAddress;


#pragma mark - APP相关
/**  app版本  */
@property (nonatomic, readonly, nullable) NSString *appVersion;
@property (class, nonatomic, readonly, nullable) NSString *appVersion;
/**  app展示的名字  */
@property (nonatomic, readonly, nullable) NSString *appDisplayName;
@property (class, nonatomic, readonly, nullable) NSString *appDisplayName;
/**  app build版本号  */
@property (nonatomic, readonly, nullable) NSString *appBuildVersion;
@property (class, nonatomic, readonly, nullable) NSString *appBuildVersion;

#pragma mark - 磁盘与内存
/**  总存储空间大小(如:16 GB)  */
@property (nonatomic, readonly, nullable) NSString *totalDiskSpace;
@property (class, nonatomic, readonly, nullable) NSString *totalDiskSpace;
/**  已使用存储空间大小(如:7.5 GB)  */
@property (nonatomic, readonly, nullable) NSString *usedDiskSpace;
@property (class, nonatomic, readonly, nullable) NSString *usedDiskSpace;
/**  空余存储空间大小(如:8.5 GB)  */
@property (nonatomic, readonly, nullable) NSString *freeDiskSpace;
@property (class, nonatomic, readonly, nullable) NSString *freeDiskSpace;
/**  总运行内存大小(如 2 G)  */
@property (nonatomic, readonly, nullable) NSString *memoryTotal;
@property (class, nonatomic, readonly, nullable) NSString *memoryTotal;


#pragma mark - 沙盒路径相关
/**  documents 路径  */
@property (class, nonatomic, readonly) NSURL *documentsURL;
@property (class, nonatomic, readonly) NSString *documentsPath;
/**  library 路径  */
@property (class, nonatomic, readonly) NSURL *libraryURL;
@property (class, nonatomic, readonly) NSString *libraryPath;
/**  caches 路径  */
@property (class, nonatomic, readonly) NSURL *cachesURL;
@property (class, nonatomic, readonly) NSString *cachesPath;

/**  创建指定路径的文件夹  */
+ (BOOL)createFolderAtPath:(NSString *)folderPath;
/**  单个文件的大小  */
+ (long long)fileSizeAtPath:(NSString*)filePath;
/**  遍历文件夹获得文件夹大小，返回多少M  */
+ (float)folderSizeAtPath:(NSString *)folderPath;
/**  清除指定文件  */
+ (BOOL)clearItemAtPath:(NSString *)filePath;
/**  清除指定文件夹缓存  */
+ (BOOL)clearfolderItemsAtPath:(NSString *)folderPath;
/**  将数据写入文件  */
+ (BOOL)writeDataItem:(NSData *)itemData withName:(NSString *)savedName toFolder:(NSString *)folderPath;
/**  添加特别的文件标识,防止iCloud同步这个路径的文件  */
+ (BOOL)addSkipBackupAttributeToFile:(NSString *)path;

#pragma mark - 二进制和资源包的自检
// 从iOS8开始沙盒机制有所变化，文稿和资源文件分开在不同的路径，而且文稿是一个动态的路径，所以获取方法要区分系统版本。
/**  app的二进制包路径  */
+ (NSString *)applicationBinaryPath;
/**  app的所有资源校验码路径,可通过修改为.plist文件来访问  */
+ (NSString *)applicationCodeResourcesPath;


#pragma mark - 类方法
/**  NSUserDefaults所有字典  */
+ (nullable NSDictionary<NSString *, id> *)userDefaultsDictionaryRepresentation;
/**  app info.plist 字典  */
+ (nullable NSDictionary *)infoDictionary;

#pragma mark - cookie相关

/**
 添加一个cookie

 @param name cookie name,不能为空
 @param value cookie value
 @param domain 域名
 @param path 路径
 @return 是否添加成功,如有有name/value/domain/path有一个空的话就返回NO,如果
 */
+ (BOOL)addCookieWithName:(nonnull NSString *)name
                    value:(nonnull NSString *)value
                   domain:(nonnull NSString *)domain
                     path:(nonnull NSString *)path;
/**  对指定key取cookie  */
+ (nullable NSString *)cookieValueForKey:(const NSString *_Nonnull)key;

/**
 将[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies转换为NSURLRequest的请求头
 得到的字典如下:
 {
    Cookie = "key1=value1; key2=value2";
 }
 用法如下:
 NSURLRequest *request = [NSURLRequest requestWithURL:@""];
 request.allHTTPHeaderFields = requestHeaderFields;
 */
+ (NSDictionary *_Nullable)requestHeaderFields;


@end
