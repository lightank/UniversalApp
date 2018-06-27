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


@interface LTDeviceInfo : NSObject

#pragma mark - 设备相关
/**  设备唯一标识码  */
@property (nonatomic, readonly) NSString *uuid;
+ (NSString *)uuid;
/**  系统设备类型(如iPhone, iPod touch)  */
@property (nonatomic, readonly) NSString *deviceModel;
+ (NSString *)deviceModel;
/**  设备名称(如xxx的iPhone)  */
@property (nonatomic, readonly) NSString *deviceName;
+ (NSString *)deviceName;
/**  无格式的系统设备类型(如:i386, iPhone6,1)  */
@property (nonatomic, readonly) NSString *machineModel;
+ (NSString *)machineModel;
/**  格式化的系统设备类型(如:iPhone 6s, iPhone 6s Plus)  */
@property (nonatomic, readonly) NSString *machineModelName;
+ (NSString *)machineModelName;
/**  是否为模拟器  */
@property (nonatomic, readonly) BOOL isSimulator;
+ (BOOL)isSimulator;
/**  是否越狱  */
@property (nonatomic, readonly) BOOL isJailbroken;
+ (BOOL)isJailbroken;
/**  是否支持指纹识别  */
@property (nonatomic, readonly) BOOL isEnableTouchID;
+ (BOOL)isEnableTouchID;
/**  屏幕分辨率  */
@property (nonatomic, readonly) NSString *resolutionRatio;
+ (NSString *)resolutionRatio;
/**  是否是iPad  */
@property (nonatomic, readonly) BOOL isIPad;
+ (BOOL)isIPad;
/**  是否是iPod  */
@property (nonatomic, readonly) BOOL isIPod;
+ (BOOL)isIPod;
/**  是否是iPhone  */
@property (nonatomic, readonly) BOOL isIPhone;
+ (BOOL)isIPhone;

#pragma mark - 屏幕相关
/**  用户界面横屏了才会返回YES  */
@property (nonatomic, readonly) BOOL isLandscape;
+ (BOOL)isLandscape;
/**  无论支不支持横屏，只要设备横屏了，就会返回YES  */
@property (nonatomic, readonly) BOOL isDeviceLandscape;
+ (BOOL)isDeviceLandscape;
/**  屏幕宽度，跟横竖屏无关  */
@property (nonatomic, readonly) CGFloat deviceWidth;
+ (CGFloat)deviceWidth;
/**  屏幕高度，跟横竖屏无关  */
@property (nonatomic, readonly) CGFloat deviceHeight;
+ (CGFloat)deviceHeight;
/**  屏幕宽度，会根据横竖屏的变化而变化  */
@property (nonatomic, readonly) CGFloat screenWidth;
+ (CGFloat)screenWidth;
/**  屏幕高度，会根据横竖屏的变化而变化  */
@property (nonatomic, readonly) CGFloat screenHeight;
+ (CGFloat)screenHeight;
/**  判断是否为 5.8英寸 iPhone X pt:375x812，px:1125x2436，@3x  */
@property (nonatomic, readonly) BOOL is58InchScreen;
+ (BOOL)is58InchScreen;
/**  判断是否为 5.5英寸 iPhone 6Plus/6sPlus pt:414x736，px:1242x2208，@3x  */
@property (nonatomic, readonly) BOOL is55InchScreen;
+ (BOOL)is55InchScreen;
/**  判断是否为 4.7英寸 iPhone 6/6s pt:375x667，px:750x1334，@2x  */
@property (nonatomic, readonly) BOOL is47InchScreen;
+ (BOOL)is47InchScreen;
/**  判断是否为 4.0英寸 iPhone 5/SE pt:320x568，px:640x1136，@2x  */
@property (nonatomic, readonly) BOOL is40InchScreen;
+ (BOOL)is40InchScreen;
/**  判断是否为 3.5英寸 iPhone 4/4S pt:320x480，px:640x960，@2x  */
@property (nonatomic, readonly) BOOL is35InchScreen;
+ (BOOL)is35InchScreen;
/**  5.8英寸 屏幕尺寸375x812   */
@property (nonatomic, readonly) CGSize screenSizeFor58Inch;
+ (CGSize)screenSizeFor58Inch;
/**  5.5英寸 屏幕尺寸414x736   */
@property (nonatomic, readonly) CGSize screenSizeFor55Inch;
+ (CGSize)screenSizeFor55Inch;
/**  4.7英寸 屏幕尺寸375x667   */
@property (nonatomic, readonly) CGSize screenSizeFor47Inch;
+ (CGSize)screenSizeFor47Inch;
/**  4.0英寸 屏幕尺寸320x568   */
@property (nonatomic, readonly) CGSize screenSizeFor40Inch;
+ (CGSize)screenSizeFor40Inch;
/**  3.5英寸 屏幕尺寸320x480   */
@property (nonatomic, readonly) CGSize screenSizeFor35Inch;
+ (CGSize)screenSizeFor35Inch;
/**  是否Retina  */
@property (nonatomic, readonly) BOOL isRetinaScreen;
+ (BOOL)isRetinaScreen;
/**  获取一像素的大小  */
@property (nonatomic, readonly) CGFloat pixelOne;
+ (CGFloat)pixelOne;

#pragma mark - 系统版本,软件相关
/**  系统名称(如iOS)  */
@property (nonatomic, readonly) NSString *systemName;
+ (NSString *)systemName;
/**  系统版本(如iOS 10.3)  */
@property (nonatomic, readonly) NSString *systemVersion;
+ (NSString *)systemVersion;
/**  系统正常待机时间  */
@property (nonatomic, readonly) NSString *systemUptime;
+ (NSString *)systemUptime;
/**  系统版本是否是iOS 8及以上  */
@property (nonatomic, readonly) BOOL iOS8OrLater;
+ (BOOL)iOS8OrLater;
/**  系统版本是否是iOS 9及以上  */
@property (nonatomic, readonly) BOOL iOS9OrLater;
+ (BOOL)iOS9OrLater;
/**  系统版本是否是iOS 10及以上  */
@property (nonatomic, readonly) BOOL iOS10OrLater;
+ (BOOL)iOS10OrLater;
/**  系统版本是否是iOS 11及以上  */
@property (nonatomic, readonly) BOOL iOS11OrLater;
+ (BOOL)iOS11OrLater;
/**  剪切板上内容  */
@property (nonatomic, readonly) NSString *clipboardContent;
+ (NSString *)clipboardContent;


#pragma mark - 本地区域相关
/**  所属国家  */
@property (nonatomic, readonly) NSString *country;
+ (NSString *)country;
/**  本地语言  */
@property (nonatomic, readonly) NSString *language;
+ (NSString *)language;
/**  时间区域  */
@property (nonatomic, readonly) NSString *timeZone;
+ (NSString *)timeZone;
/**  货币  */
@property (nonatomic, readonly) NSString *currency;
+ (NSString *)currency;


#pragma mark - 网络相关
/**  运营商名字(如:中国移动)  */
@property (nonatomic, readonly) NSString *carrierName;
+ (NSString *)carrierName;
/**  运营商所属国家  */
@property (nonatomic, readonly) NSString *carrierCountry;
+ (NSString *)carrierCountry;
/**  运营商在所属国家的code  */
@property (nonatomic, readonly) NSString *carrierISOCountryCode;
+ (NSString *)carrierISOCountryCode;
/**  运营商是否允许VOIP  */
@property (nonatomic, readonly) BOOL carrierAllowsVOIP;
+ (BOOL)carrierAllowsVOIP;
/**  连接的网络类型:(如:移动网络,WIFI)  */
@property (nonatomic, readonly) NSString *networkStatus;
+ (NSString *)networkStatus;
/**  连接的是否WIFI  */
@property (nonatomic, readonly) BOOL isConnectedToWiFi;
+ (BOOL)isConnectedToWiFi;
/**  当前WIFI名称  */
@property (nonatomic, readonly) NSString *WIFIName;
+ (NSString *)WIFIName;

#pragma mark - APP相关
/**  app版本  */
@property (nonatomic, readonly) NSString *appVersion;
+ (NSString *)appVersion;
/**  app展示的名字  */
@property (nonatomic, readonly) NSString *appDisplayName;
+ (NSString *)appDisplayName;
/**  app build版本号  */
@property (nonatomic, readonly) NSString *appBuildVersion;
+ (NSString *)appBuildVersion;

#pragma mark - 磁盘与内存
/**  总存储空间大小(如:16 GB)  */
@property (nonatomic, readonly) NSString *totalDiskSpace;
+ (NSString *)totalDiskSpace;
/**  已使用存储空间大小(如:7.5 GB)  */
@property (nonatomic, readonly) NSString *usedDiskSpace;
+ (NSString *)usedDiskSpace;
/**  空余存储空间大小(如:8.5 GB)  */
@property (nonatomic, readonly) NSString *freeDiskSpace;
+ (NSString *)freeDiskSpace;

#pragma mark - 类方法
/**  NSUserDefaults所有字典  */
+ (NSDictionary<NSString *, id> *)userDefaultsDictionaryRepresentation;
/**  对指定key取cookie  */
+ (NSString *)cookieValueForKey:(const NSString *)key;

@end
