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
#import <UIKit/UIKit.h>

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
#define UIColorWithRGBA(r, g, b, a) ([UIColor colorWithRed:(r / 255.f) green:(g / 255.f) blue:(b / 255.f) alpha:(a / 1.f)])
#define UIColorWithRGB(r, g, b) (UIColorWithRGBA(r, g, b, 1.0f))
#define UIColorRandom ([UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1.0])
// 将16进制颜色转换成UIColor eg: UIColorWithHEX(0x5cacee)
//#define UIColorHEX_Alpha(hex, a) ([UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:a])
//#define UIColorWithHEX(hex) (UIColorHEX_Alpha(hex, 1.0f))

NS_ASSUME_NONNULL_BEGIN

@interface LTDevice : NSObject

#pragma mark - 设备相关
/**  系统设备类型(如iPhone, iPod touch)  */
@property (class, nonatomic, readonly, nullable) NSString *deviceModel;
/**  设备名称(如xxx的iPhone)  */
@property (class, nonatomic, readonly, nullable) NSString *deviceName;
/**  无格式的系统设备类型(如:i386, iPhone6,1)  */
@property (class, nonatomic, readonly, nullable) NSString *machineModel;
/**  格式化的系统设备类型(如:iPhone 6s, iPhone 6s Plus)  */
@property (class, nonatomic, readonly, nullable) NSString *machineModelName;
/**  屏幕尺寸:3.5 4.0 4.7 5.5 ...  */
@property (class, nonatomic, readonly, nullable) NSString *screenInchSize;
/**  CPU类型:arm arm64 x86 x86_64  */
@property (class, nonatomic, readonly, nullable) NSString *CUPType;
/**  SIM卡类型:Micro Nano, iPhone 4s之后都是Nano卡  */
@property (class, nonatomic, readonly, nullable) NSString *SIMType;
/**  电池状态:充电,放电,充满100%等  */
@property(class, nonatomic, readonly) UIDeviceBatteryState batteryState;
/**  电池电量,0 .. 1.0. -1.0 if UIDeviceBatteryStateUnknown  */
@property (class, nonatomic, readonly) CGFloat batteryLevel;
/**  是否为模拟器  */
@property (class, nonatomic, readonly) BOOL isSimulator;
/**  是否越狱  */
@property (class, nonatomic, readonly) BOOL isJailbroken;
/**  是否支持指纹识别  */
@property (class, nonatomic, readonly) BOOL isEnableTouchID;
/**  屏幕分辨率  */
@property (class, nonatomic, readonly, nullable) NSString *resolutionRatio;;
/**  是否是iPad  */
@property (class, nonatomic, readonly) BOOL isIPad;
/**  是否是iPod  */
@property (class, nonatomic, readonly) BOOL isIPod;
/**  是否是iPhone  */
@property (class, nonatomic, readonly) BOOL isIPhone;

#pragma mark - 屏幕/尺寸相关
/*
 iPhone屏幕尺寸
 手机型号            屏幕尺寸      物理尺寸         像素尺寸      倍图
 XS Max/11Pro Max  6.5inch     414*896 pt    1242*2688 px   @3x
 XR/11             6.1inch     414*896 pt     828*1792 px   @2x
 X/XS/11 Pro       5.8inch     375*812 pt    1125*2436 px   @3x
 6+/6S+/7+/8+      5.5inch     414*736 pt    1242*2208 px   @3x
 6/6S/7/8          4.7inch     375*667 pt     750*1334 px   @2x
 5/5S/5C           4.0inch     320*568 pt     640*1136 px   @2x
 4/4S              3.5inch     320*480 pt     640*960  px   @2x
 
 iPad屏幕尺寸
 手机型号            屏幕尺寸      物理尺寸         像素尺寸      倍图
 Pro 12.9          12.9inch   1024*1366 pt   2048*2732 px   @2x
 Pro 10.5          10.5inch    834*1112 pt   1668*2224 px   @2x
 Pro/Air 2/Retina  9.7inch     768*1024 pt   1536*2048 px   @2x
 mini 2/4          7.9inch     768*1024 pt   1536*2048 px   @2x
 1/2               9.7inch     768*1024 pt   768*1024 px    @1x
*/

/**  屏幕亮度,系统取值是0-1,这里取值在系统基础上 *100 取值范围为0-100  */
@property (class, nonatomic, readonly) CGFloat screenBrightness;
/**  用户界面横屏了才会返回YES  */
@property (class, nonatomic, readonly) BOOL isLandscape;
/**  无论支不支持横屏，只要设备横屏了，就会返回YES  */
@property (class, nonatomic, readonly) BOOL isDeviceLandscape;
/**  屏幕宽度，跟横竖屏无关  */
@property (class, nonatomic, readonly) CGFloat deviceWidth;
/**  屏幕高度，跟横竖屏无关  */
@property (class, nonatomic, readonly) CGFloat deviceHeight;
/**  屏幕宽度，会根据横竖屏的变化而变化  */
@property (class, nonatomic, readonly) CGFloat screenWidth;
/**  屏幕高度，会根据横竖屏的变化而变化  */
@property (class, nonatomic, readonly) CGFloat screenHeight;
/**  状态栏高度(来电等情况下，状态栏高度会发生变化，所以应该实时计算),普通的是20pt,刘海屏是44pt.来电时普通的40pt,刘海屏还是44pt,状态栏高度变化会发送UIApplicationWillChangeStatusBarFrameNotification通知  */
@property (class, nonatomic, readonly) CGFloat statusBarHeight;
/**  判断是否为 iPhone X 系列刘海设计  */
@property (class, nonatomic, readonly) BOOL isNotchedScreen;
/**  判断是否为 6.5英寸 iPhone XR pt:414x896，px:1242x2688，@3x  */
@property (class, nonatomic, readonly) BOOL is65InchScreen;
/**  判断是否为 6.1英寸 iPhone XR pt:414x896，px:828x1792，@2x  */
@property (class, nonatomic, readonly) BOOL is61InchScreen;
/**  判断是否为 5.8英寸 iPhone X/XS pt:375x812，px:1125x2436，@3x  */
@property (class, nonatomic, readonly) BOOL is58InchScreen;
/**  判断是否为 5.5英寸 iPhone 6Plus/6sPlus pt:414x736，px:1242x2208，@3x  */
@property (class, nonatomic, readonly) BOOL is55InchScreen;
/**  判断是否为 4.7英寸 iPhone 6/6s pt:375x667，px:750x1334，@2x  */
@property (class, nonatomic, readonly) BOOL is47InchScreen;
/**  判断是否为 4.0英寸 iPhone 5/SE pt:320x568，px:640x1136，@2x  */
@property (class, nonatomic, readonly) BOOL is40InchScreen;
/**  判断是否为 3.5英寸 iPhone 4/4S pt:320x480，px:640x960，@2x  */
@property (class, nonatomic, readonly) BOOL is35InchScreen;
/**  6.5英寸 屏幕尺寸414x896   */
@property (class, nonatomic, readonly) CGSize screenSizeFor65Inch;
/**  6.1英寸 屏幕尺寸414x896   */
@property (class, nonatomic, readonly) CGSize screenSizeFor61Inch;
/**  5.8英寸 屏幕尺寸375x812   */
@property (class, nonatomic, readonly) CGSize screenSizeFor58Inch;
/**  5.5英寸 屏幕尺寸414x736   */
@property (class, nonatomic, readonly) CGSize screenSizeFor55Inch;
/**  4.7英寸 屏幕尺寸375x667   */
@property (class, nonatomic, readonly) CGSize screenSizeFor47Inch;
/**  4.0英寸 屏幕尺寸320x568   */
@property (class, nonatomic, readonly) CGSize screenSizeFor40Inch;
/**  3.5英寸 屏幕尺寸320x480   */
@property (class, nonatomic, readonly) CGSize screenSizeFor35Inch;
/**  是否Retina  */
@property (class, nonatomic, readonly) BOOL isRetinaScreen;
/**  获取一像素的大小  */
@property (class, nonatomic, readonly) CGFloat pixelOne;
/**  homeIndicator Height:竖屏为34pt,横屏为21pt */
@property (class, nonatomic, readonly) CGFloat homeIndicatorHeight;
/**  tabBarHeight:固定高度49pt + homeIndicatorHeight  */
@property (class, nonatomic, readonly) CGFloat tabBarHeight;
/**  导航栏固定高度:44pt  */
@property (class, nonatomic, readonly) CGFloat navigationBarHeigh;
/**  导航栏 + 状态栏高度:固定高度44pt + statusBarHeight  */
@property (class, nonatomic, readonly) CGFloat navigationPlusStatusBarHeight;

#pragma mark - 系统版本,软件相关
/**  系统名称(如iOS)  */
@property (class, nonatomic, readonly, nullable) NSString *systemName;
/**  系统版本(如iOS 10.3)  */
@property (class, nonatomic, readonly, nullable) NSString *systemVersion;
/**  系统正常待机时间  */
@property (class, nonatomic, readonly, nullable) NSString *systemUptime;
/**  系统版本是否是iOS 8及以上  */
@property (class, nonatomic, readonly) BOOL iOS8OrLater;
/**  系统版本是否是iOS 9及以上  */
@property (class, nonatomic, readonly) BOOL iOS9OrLater;
/**  系统版本是否是iOS 10及以上  */
@property (class, nonatomic, readonly) BOOL iOS10OrLater;
/**  系统版本是否是iOS 11及以上  */
@property (class, nonatomic, readonly) BOOL iOS11OrLater;
/**  系统版本是否是iOS 12及以上  */
@property (class, nonatomic, readonly) BOOL iOS12OrLater;
/**  剪切板上内容  */
@property (class, nonatomic, readonly, nullable) NSString *clipboardContent;

#pragma mark - 本地区域相关
/**  是否在中国:
    系统语言:中文
    设备机型:iPhone
    当前系统时区:Asia/Hong_Kong、Asia/Shanghai、Asia/Harbin
    当前地区国家:zh_CN
 */
@property (class, nonatomic, readonly) BOOL isInChina;
/**  所属国家  */
@property (class, nonatomic, readonly, nullable) NSString *country;
/**  本地语言  */
@property (class, nonatomic, nullable) NSString *language;
+ (void)resetLanguage;
/**  时间区域  */
@property (class, nonatomic, readonly, nullable) NSString *timeZone;
/**  货币  */
@property (class, nonatomic, readonly, nullable) NSString *currency;

#pragma mark - 网络相关
/**  运营商名字(如:中国移动)  */
@property (class, nonatomic, readonly, nullable) NSString *carrierName;
/**  运营商所属国家  */
@property (class, nonatomic, readonly, nullable) NSString *carrierCountry;
/**  运营商在所属国家的code  */
@property (class, nonatomic, readonly, nullable) NSString *carrierISOCountryCode;
/**  运营商是否允许VOIP  */
@property (class, nonatomic, readonly) BOOL carrierAllowsVOIP;
/**  是否开启代理  */
@property (class, nonatomic, readonly) BOOL isOpenProxy;
/**  是否开启VPN  */
@property (class, nonatomic, readonly) BOOL isOpenVPN;
/**  当前蜂窝网络类型:2G/3G/4G等  */
@property (class, nonatomic, readonly, nullable) NSString *cellNetworkType;
/**  是否连接到蜂窝网络  */
@property (class, nonatomic, readonly) BOOL isConnectedToCellNetwork;
/**  是否连接到WIFI  */
@property (class, nonatomic, readonly) BOOL isConnectedToWiFi;
/**  当前WIFI名称  */
@property (class, nonatomic, readonly, nullable) NSString *WiFiName;
/**  当前连接WIFI MAC 地址  */
@property (class, nonatomic, readonly, nullable) NSString *WiFiMacAddress;
/**  WIFI IP address of this device (can be nil). e.g. @"192.168.1.111"  */
@property (class, nonatomic, readonly, nullable) NSString *ipAddressWiFi;
/**  Cell IP address of this device (can be nil). e.g. @"10.2.2.222"  */
@property (class, nonatomic, readonly, nullable) NSString *ipAddressCell;
/**  外网IP地址 (can be nil). e.g. @"10.2.2.222"  */
@property (class, nonatomic, readonly, nullable) NSString *externalIPAddress;

#pragma mark - APP相关
/**  app版本  */
@property (class, nonatomic, readonly, nullable) NSString *appVersion;
/**  app展示的名字  */
@property (class, nonatomic, readonly, nullable) NSString *appDisplayName;
/**  app build版本号  */
@property (class, nonatomic, readonly, nullable) NSString *appBuildVersion;

#pragma mark - 磁盘与内存
/**  总存储空间大小(如:16 GB)  */
@property (class, nonatomic, readonly, nullable) NSString *totalDiskSpace;
/**  已使用存储空间大小(如:7.5 GB)  */
@property (class, nonatomic, readonly, nullable) NSString *usedDiskSpace;
/**  空余存储空间大小(如:8.5 GB)  */
@property (class, nonatomic, readonly, nullable) NSString *freeDiskSpace;
/**  总运行内存大小(如 2 G)  */
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
/**  设置状态栏背景颜色,如果为nil则恢复默认透明颜色  */
+ (void)setStatusBarBackgroundColor:(nullable UIColor *)color;


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


#pragma mark - scheme相关
+ (BOOL)call:(NSString *)phoneNumber;
+ (BOOL)faceTime:(NSString *)faceTimeID;
+ (BOOL)appStore:(NSString *)url;
+ (BOOL)openURLScheme:(NSURL *)url;

#pragma mark - 手电筒
+ (void)openFlashlight;
+ (void)closeFlashlight;

@end

NS_ASSUME_NONNULL_END
