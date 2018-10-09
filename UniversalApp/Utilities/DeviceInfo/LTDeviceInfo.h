//
//  LTDeviceInfo.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/20.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>

// 判断当前编译使用的 Base SDK 版本是否为 iOS 8.0 及以上
#define IOS8_OR_LATER ([LTDeviceInfo iOS8OrLater])
// 判断当前编译使用的 Base SDK 版本是否为 iOS 9.0 及以上
#define IOS9_OR_LATER ([LTDeviceInfo iOS9OrLater])
// 判断当前编译使用的 Base SDK 版本是否为 iOS 10.0 及以上
#define IOS10_OR_LATER ([LTDeviceInfo iOS10OrLater])
// 判断当前编译使用的 Base SDK 版本是否为 iOS 11.0 及以上
#define IOS11_OR_LATER ([LTDeviceInfo iOS11OrLater])

// 判断是否为 5.8英寸 iPhone X pt:375x812，px:1125x2436，@3x
#define IPHONE_SIZE_58INCH ([LTDeviceInfo is58InchScreen])
// 判断是否为 5.5英寸 iPhone 6Plus/6sPlus pt:414x736，px:1242x2208，@3x
#define IPHONE_SIZE_55INCH ([LTDeviceInfo is55InchScreen])
// 判断是否为 4.7英寸 iPhone 6/6s pt:375x667，px:750x1334，@2x
#define IPHONE_SIZE_47INCH ([LTDeviceInfo is47InchScreen])
// 判断是否为 4.0英寸 iPhone 5/SE pt:320x568，px:640x1136，@2x
#define IPHONE_SIZE_40INCH ([LTDeviceInfo is40InchScreen])
// 判断是否为 3.5英寸 iPhone 4/4S pt:320x480，px:640x960，@2x
#define IPHONE_SIZE_35INCH ([LTDeviceInfo is35InchScreen])

// 字体相关的宏，用于快速创建一个字体对象，更多创建宏可查看 UIFont+QMUI.h
#define UIFontOfSize(size) ([UIFont systemFontOfSize:size]) //常规
#define UIFontItalicOfSize(size) ([UIFont italicSystemFontOfSize:size]) //斜体,只对数字和字母有效，中文无效
#define UIFontBoldOfSize(size) ([UIFont boldSystemFontOfSize:size]) //粗体
//#define UIFontBoldWithFont(_font) ([UIFont boldSystemFontOfSize:_font.pointSize])


@interface LTDeviceInfo : NSObject

#pragma mark - 设备相关
/**  系统设备类型(如iPhone, iPod touch)  */
@property (nonatomic, readonly) NSString *deviceModel;
@property (class, nonatomic, readonly) NSString *deviceModel;
/**  设备名称(如xxx的iPhone)  */
@property (nonatomic, readonly) NSString *deviceName;
@property (class, nonatomic, readonly) NSString *deviceName;
/**  无格式的系统设备类型(如:i386, iPhone6,1)  */
@property (nonatomic, readonly) NSString *machineModel;
@property (class, nonatomic, readonly) NSString *machineModel;
/**  格式化的系统设备类型(如:iPhone 6s, iPhone 6s Plus)  */
@property (nonatomic, readonly) NSString *machineModelName;
@property (class, nonatomic, readonly) NSString *machineModelName;
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
@property (nonatomic, readonly) NSString *resolutionRatio;
@property (class, nonatomic, readonly) NSString *resolutionRatio;;
/**  是否是iPad  */
@property (nonatomic, readonly) BOOL isIPad;
@property (class, nonatomic, readonly) BOOL isIPad;
/**  是否是iPod  */
@property (nonatomic, readonly) BOOL isIPod;
@property (class, nonatomic, readonly) BOOL isIPod;
/**  是否是iPhone  */
@property (nonatomic, readonly) BOOL isIPhone;
@property (class, nonatomic, readonly) BOOL isIPhone;

#pragma mark - 屏幕相关
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
/**  状态栏高度(来电等情况下，状态栏高度会发生变化，所以应该实时计算)  */
@property (nonatomic, readonly) CGFloat statusBarHeight;
@property (class, nonatomic, readonly) CGFloat statusBarHeight;
/**  判断是否为 5.8英寸 iPhone X pt:375x812，px:1125x2436，@3x  */
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

#pragma mark - 系统版本,软件相关
/**  系统名称(如iOS)  */
@property (nonatomic, readonly) NSString *systemName;
@property (class, nonatomic, readonly) NSString *systemName;
/**  系统版本(如iOS 10.3)  */
@property (nonatomic, readonly) NSString *systemVersion;
@property (class, nonatomic, readonly) NSString *systemVersion;
/**  系统正常待机时间  */
@property (nonatomic, readonly) NSString *systemUptime;
@property (class, nonatomic, readonly) NSString *systemUptime;
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
/**  剪切板上内容  */
@property (nonatomic, readonly) NSString *clipboardContent;
@property (class, nonatomic, readonly) NSString *clipboardContent;


#pragma mark - 本地区域相关
/**  所属国家  */
@property (nonatomic, readonly) NSString *country;
@property (class, nonatomic, readonly) NSString *country;
/**  本地语言  */
@property (nonatomic, copy) NSString *language;
@property (class, nonatomic, copy) NSString *language;
+ (void)resetLanguage;
/**  时间区域  */
@property (nonatomic, readonly) NSString *timeZone;
@property (class, nonatomic, readonly) NSString *timeZone;
/**  货币  */
@property (nonatomic, readonly) NSString *currency;
@property (class, nonatomic, readonly) NSString *currency;


#pragma mark - 网络相关
/**  运营商名字(如:中国移动)  */
@property (nonatomic, readonly) NSString *carrierName;
@property (class, nonatomic, readonly) NSString *carrierName;
/**  运营商所属国家  */
@property (nonatomic, readonly) NSString *carrierCountry;
@property (class, nonatomic, readonly) NSString *carrierCountry;
/**  运营商在所属国家的code  */
@property (nonatomic, readonly) NSString *carrierISOCountryCode;
@property (class, nonatomic, readonly) NSString *carrierISOCountryCode;
/**  运营商是否允许VOIP  */
@property (nonatomic, readonly) BOOL carrierAllowsVOIP;
@property (class, nonatomic, readonly) BOOL carrierAllowsVOIP;
/**  连接的网络类型:(如:移动网络,WIFI)  */
@property (nonatomic, readonly) NSString *networkStatus;
@property (class, nonatomic, readonly) NSString *networkStatus;
/**  连接的是否WIFI  */
@property (nonatomic, readonly) BOOL isConnectedToWiFi;
@property (class, nonatomic, readonly) BOOL isConnectedToWiFi;
/**  当前WIFI名称  */
@property (nonatomic, readonly) NSString *WIFIName;
@property (class, nonatomic, readonly) NSString *WIFIName;
/**  WIFI IP address of this device (can be nil). e.g. @"192.168.1.111"  */
@property (nullable, nonatomic, readonly) NSString *ipAddressWIFI;
@property (class, nullable, nonatomic, readonly) NSString *ipAddressWIFI;
/**  Cell IP address of this device (can be nil). e.g. @"10.2.2.222"  */
@property (nullable, nonatomic, readonly) NSString *ipAddressCell;
@property (class, nullable, nonatomic, readonly) NSString *ipAddressCell;

#pragma mark - APP相关
/**  app版本  */
@property (nonatomic, readonly) NSString *appVersion;
@property (class, nonatomic, readonly) NSString *appVersion;
/**  app展示的名字  */
@property (nonatomic, readonly) NSString *appDisplayName;
@property (class, nonatomic, readonly) NSString *appDisplayName;
/**  app build版本号  */
@property (nonatomic, readonly) NSString *appBuildVersion;
@property (class, nonatomic, readonly) NSString *appBuildVersion;

#pragma mark - 磁盘与内存
/**  总存储空间大小(如:16 GB)  */
@property (nonatomic, readonly) NSString *totalDiskSpace;
@property (class, nonatomic, readonly) NSString *totalDiskSpace;
/**  已使用存储空间大小(如:7.5 GB)  */
@property (nonatomic, readonly) NSString *usedDiskSpace;
@property (class, nonatomic, readonly) NSString *usedDiskSpace;
/**  空余存储空间大小(如:8.5 GB)  */
@property (nonatomic, readonly) NSString *freeDiskSpace;
@property (class, nonatomic, readonly) NSString *freeDiskSpace;
/**  总运行内存大小(如 2 G)  */
@property (nonatomic, readonly) NSString *memoryTotal;
@property (class, nonatomic, readonly) NSString *memoryTotal;


#pragma mark - 类方法
/**  NSUserDefaults所有字典  */
+ (NSDictionary<NSString *, id> *)userDefaultsDictionaryRepresentation;
/**  app info.plist 字典  */
+ (NSDictionary *)infoDictionary;

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
+ (NSString *)cookieValueForKey:(const NSString *)key;

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
+ (NSDictionary *)requestHeaderFields;


@end
