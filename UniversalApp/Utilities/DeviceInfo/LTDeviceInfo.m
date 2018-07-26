//
//  LTDeviceInfo.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/20.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTDeviceInfo.h"

#if __has_include(<FCUUID/UIDevice+FCUUID.h>)
#import <FCUUID/UIDevice+FCUUID.h>
#else
#import "UIDevice+FCUUID.h"
#endif

// utsname
#import <sys/utsname.h>
#import <LocalAuthentication/LAContext.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <mach/mach.h>
#include <arpa/inet.h>
#include <ifaddrs.h>

#if __has_include(<YYKit/YYReachability.h>)
#import <YYKit/YYReachability.h>
#else
#import "YYReachability.h"
#endif


#define kDeviceInfoPlaceHolder @"none"

@implementation LTDeviceInfo

+ (NSString *)uuid
{
    return [UIDevice currentDevice].uuid;
}

+ (NSString *)deviceModel
{
    // Get the device model
    if ([[UIDevice currentDevice] respondsToSelector:@selector(model)]) {
        // Make a string for the device model
        NSString *deviceModel = [[UIDevice currentDevice] model];
        // Set the output to the device model
        return deviceModel;
    } else {
        // Device model not found
        return kDeviceInfoPlaceHolder;
    }
}

+ (NSString *)deviceName
{
    // Get the current device name
    if ([[UIDevice currentDevice] respondsToSelector:@selector(name)]) {
        // Make a string for the device name
        NSString *deviceName = [[UIDevice currentDevice] name];
        // Set the output to the device name
        return deviceName;
    } else {
        // Device name not found
        return kDeviceInfoPlaceHolder;
    }
}

//@see http://theiphonewiki.com/wiki/Models
+ (NSString *)machineModel
{
    // Set up a Device Type String
    static NSString *model;
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        // Set up a struct
        struct utsname DT;
        // Get the system information
        uname(&DT);
        // Set the device type to the machine type
        model = [NSString stringWithFormat:@"%s", DT.machine];
    });
    return model;
}

//@see http://theiphonewiki.com/wiki/Models
+ (NSString *)machineModelName
{
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSString *model = [self machineModel];
        
        NSDictionary *dic = @{
                              @"Watch1,1" : @"Apple Watch (1st generation) 38mm",
                              @"Watch1,2" : @"Apple Watch (1st generation) 42mm",
                              @"Watch2,3" : @"Apple Watch Series 2 38mm",
                              @"Watch2,4" : @"Apple Watch Series 2 42mm",
                              @"Watch2,6" : @"Apple Watch Series 1 38mm",
                              @"Watch2,7" : @"Apple Watch Series 1 42mm",
                              @"Watch3,1" : @"Apple Watch Series 3 38mm",
                              @"Watch3,2" : @"Apple Watch Series 3 42mm",
                              @"Watch3,3" : @"Apple Watch Series 3 38mm",
                              @"Watch3,4" : @"Apple Watch Series 3 42mm",
                              
                              @"AudioAccessory1,1" : @"HomePod",
                              
                              @"iPod1,1" : @"iPod touch 1",
                              @"iPod2,1" : @"iPod touch 2",
                              @"iPod3,1" : @"iPod touch 3",
                              @"iPod4,1" : @"iPod touch 4",
                              @"iPod5,1" : @"iPod touch 5",
                              @"iPod7,1" : @"iPod touch 6",
                              
                              @"iPhone1,1" : @"iPhone 1G",
                              @"iPhone1,2" : @"iPhone 3G",
                              @"iPhone2,1" : @"iPhone 3GS",
                              @"iPhone3,1" : @"iPhone 4 (GSM)",
                              @"iPhone3,2" : @"iPhone 4",
                              @"iPhone3,3" : @"iPhone 4 (CDMA)",
                              @"iPhone4,1" : @"iPhone 4S",
                              @"iPhone5,1" : @"iPhone 5",
                              @"iPhone5,2" : @"iPhone 5",
                              @"iPhone5,3" : @"iPhone 5c",
                              @"iPhone5,4" : @"iPhone 5c",
                              @"iPhone6,1" : @"iPhone 5s",
                              @"iPhone6,2" : @"iPhone 5s",
                              @"iPhone7,1" : @"iPhone 6 Plus",
                              @"iPhone7,2" : @"iPhone 6",
                              @"iPhone8,1" : @"iPhone 6s",
                              @"iPhone8,2" : @"iPhone 6s Plus",
                              @"iPhone8,4" : @"iPhone SE",
                              @"iPhone9,1" : @"iPhone 7",
                              @"iPhone9,2" : @"iPhone 7 Plus",
                              @"iPhone9,3" : @"iPhone 7",
                              @"iPhone9,4" : @"iPhone 7 Plus",
                              @"iPhone10,1" : @"iPhone 8",
                              @"iPhone10,2" : @"iPhone 8 Plus",
                              @"iPhone10,3" : @"iPhone X",
                              @"iPhone10,4" : @"iPhone 8",
                              @"iPhone10,5" : @"iPhone 8 Plus",
                              @"iPhone10,6" : @"iPhone X",
                              
                              @"iPad1,1" : @"iPad 1",
                              @"iPad2,1" : @"iPad 2 (WiFi)",
                              @"iPad2,2" : @"iPad 2 (GSM)",
                              @"iPad2,3" : @"iPad 2 (CDMA)",
                              @"iPad2,4" : @"iPad 2",
                              @"iPad2,5" : @"iPad mini 1",
                              @"iPad2,6" : @"iPad mini 1",
                              @"iPad2,7" : @"iPad mini 1",
                              @"iPad3,1" : @"iPad 3 (WiFi)",
                              @"iPad3,2" : @"iPad 3 (4G)",
                              @"iPad3,3" : @"iPad 3 (4G)",
                              @"iPad3,4" : @"iPad 4",
                              @"iPad3,5" : @"iPad 4",
                              @"iPad3,6" : @"iPad 4",
                              @"iPad4,1" : @"iPad Air",
                              @"iPad4,2" : @"iPad Air",
                              @"iPad4,3" : @"iPad Air",
                              @"iPad4,4" : @"iPad mini 2",
                              @"iPad4,5" : @"iPad mini 2",
                              @"iPad4,6" : @"iPad mini 2",
                              @"iPad4,7" : @"iPad mini 3",
                              @"iPad4,8" : @"iPad mini 3",
                              @"iPad4,9" : @"iPad mini 3",
                              @"iPad5,1" : @"iPad mini 4",
                              @"iPad5,2" : @"iPad mini 4",
                              @"iPad5,3" : @"iPad Air 2",
                              @"iPad5,4" : @"iPad Air 2",
                              @"iPad6,3" : @"iPad Pro (9.7 inch)",
                              @"iPad6,4" : @"iPad Pro (9.7 inch)",
                              @"iPad6,7" : @"iPad Pro (12.9 inch)",
                              @"iPad6,8" : @"iPad Pro (12.9 inch)",
                              @"iPad6,11" : @"iPad 5",
                              @"iPad6,12" : @"iPad 5",
                              @"iPad7,1" : @"iPad Pro (12.9-inch, 2nd generation)",
                              @"iPad7,2" : @"iPad Pro (12.9-inch, 2nd generation)",
                              @"iPad7,3" : @"iPad Pro (10.5-inch)",
                              @"iPad7,4" : @"iPad Pro (10.5-inch)",
                              
                              @"AppleTV2,1" : @"Apple TV 2",
                              @"AppleTV3,1" : @"Apple TV 3",
                              @"AppleTV3,2" : @"Apple TV 3",
                              @"AppleTV5,3" : @"Apple TV 4",
                              @"AppleTV6,2" : @"Apple TV 4K",
                              
                              @"i386" : @"Simulator x86",
                              @"x86_64" : @"Simulator x64",
                              };
        name = dic[model];
        if (!name) name = model;
    });
    return name;
}

+ (BOOL)isSimulator
{
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

+ (BOOL)isJailbroken
{
    if ([self isSimulator]) return NO; // Dont't check simulator
    
    // iOS9 URL Scheme query changed ...
    // NSURL *cydiaURL = [NSURL URLWithString:@"cydia://package"];
    // if ([[UIApplication sharedApplication] canOpenURL:cydiaURL]) return YES;
    
    NSArray *paths = @[@"/Applications/Cydia.app",
                       @"/private/var/lib/apt/",
                       @"/private/var/lib/cydia",
                       @"/private/var/stash"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
    }
    
    FILE *bash = fopen("/bin/bash", "r");
    if (bash != NULL) {
        fclose(bash);
        return YES;
    }
    
    NSString *path = [NSString stringWithFormat:@"/private/%@", [NSString stringWithUUID]];
    if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return YES;
    }
    
    return NO;
}

+ (BOOL)isEnableTouchID
{
    static BOOL enTouchID = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        enTouchID = [[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL];
    });
    return enTouchID;
}

+ (NSString *)resolutionRatio
{
    CGSize size = [UIScreen mainScreen].nativeBounds.size;
    return [NSString stringWithFormat:@"%@ x %@", @(size.width).stringValue, @(size.height).stringValue];
}

/**  是否是iPad  */
+ (BOOL)isIPad
{
    static BOOL device = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    });
    return device;
}
/**  是否是iPod  */
+ (BOOL)isIPod
{
    static BOOL device = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *string = [[UIDevice currentDevice] model];
        device = [string rangeOfString:@"iPod touch"].location != NSNotFound;
    });
    return device;
}

/**  是否是iPhone  */
+ (BOOL)isIPhone
{
    static BOOL device = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    });
    return device;
}


#pragma mark - 屏幕相关
+ (BOOL)isLandscape
{
    return UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
}
+ (BOOL)isDeviceLandscape
{
    return UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
}
+ (CGFloat)deviceWidth
{
    static CGFloat width = 0.f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        width = (IOS8_OR_LATER ? ([LTDeviceInfo isLandscape] ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width) : [[UIScreen mainScreen] bounds].size.width);
    });
    return width;
}
+ (CGFloat)deviceHeight
{
    static CGFloat height = 0.f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        height = ((IOS8_OR_LATER ? ([LTDeviceInfo isLandscape] ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height) : [[UIScreen mainScreen] bounds].size.height));
    });
    return height;
}
+ (CGFloat)screenWidth
{
    return ((IOS8_OR_LATER ? [[UIScreen mainScreen] bounds].size.width : ([LTDeviceInfo isLandscape] ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)));
}
+ (CGFloat)screenHeight
{
    return ((IOS8_OR_LATER ? [[UIScreen mainScreen] bounds].size.height : ([LTDeviceInfo isLandscape] ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)));
}

+ (BOOL)is58InchScreen
{
    static BOOL size = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = CGSizeEqualToSize([self screenSizeFor58Inch], CGSizeMake([self deviceWidth], [self deviceHeight]));
    });
    return size;
}

+ (BOOL)is55InchScreen
{
    static BOOL size = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = CGSizeEqualToSize([self screenSizeFor55Inch], CGSizeMake([self deviceWidth], [self deviceHeight]));
    });
    return size;
}
+ (BOOL)is47InchScreen
{
    static BOOL size = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = CGSizeEqualToSize([self screenSizeFor47Inch], CGSizeMake([self deviceWidth], [self deviceHeight]));
    });
    return size;
}

+ (BOOL)is40InchScreen
{
    static BOOL size = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = CGSizeEqualToSize([self screenSizeFor40Inch], CGSizeMake([self deviceWidth], [self deviceHeight]));
    });
    return size;
}

+ (BOOL)is35InchScreen
{
    static BOOL size = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = CGSizeEqualToSize([self screenSizeFor35Inch], CGSizeMake([self deviceWidth], [self deviceHeight]));
    });
    return size;
}

+ (CGSize)screenSizeFor58Inch
{
    return CGSizeMake(375.f, 812.f);
}

+ (CGSize)screenSizeFor55Inch
{
    return CGSizeMake(414.f, 736.f);
}

+ (CGSize)screenSizeFor47Inch
{
    return CGSizeMake(375.f, 667.f);
}

+ (CGSize)screenSizeFor40Inch
{
    return CGSizeMake(320.f, 568.f);
}

+ (CGSize)screenSizeFor35Inch
{
    return CGSizeMake(320.f, 480.f);
}

+ (BOOL)isRetinaScreen
{
    static BOOL retina = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        retina = ([[UIScreen mainScreen] scale] >= 2.0);
    });
    return retina;
}

+ (CGFloat)pixelOne
{
    static CGFloat pixelOne = 0.f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pixelOne = 1 / [[UIScreen mainScreen] scale];
    });
    return pixelOne;
}

#pragma mark - 系统版本,软件相关
+ (NSString *)systemName
{
    // Get the current system name
    if ([[UIDevice currentDevice] respondsToSelector:@selector(systemName)]) {
        // Make a string for the system name
        NSString *systemName = [[UIDevice currentDevice] systemName];
        // Set the output to the system name
        return systemName;
    } else {
        // System name not found
        return kDeviceInfoPlaceHolder;
    }
}

+ (NSString *)systemVersion {
    // Get the current system version
    if ([[UIDevice currentDevice] respondsToSelector:@selector(systemVersion)]) {
        // Make a string for the system version
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        // Set the output to the system version
        return systemVersion;
    } else {
        // System version not found
        return kDeviceInfoPlaceHolder;
    }
}

+ (NSString *)systemUptime
{
    // Set up the days/hours/minutes
    NSNumber *Days, *Hours, *Minutes;
    
    // Get the info about a process
    NSProcessInfo * processInfo = [NSProcessInfo processInfo];
    // Get the uptime of the system
    NSTimeInterval UptimeInterval = [processInfo systemUptime];
    // Get the calendar
    NSCalendar *Calendar = [NSCalendar currentCalendar];
    // Create the Dates
    NSDate *Date = [[NSDate alloc] initWithTimeIntervalSinceNow:(0-UptimeInterval)];
    unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *Components = [Calendar components:unitFlags fromDate:Date toDate:[NSDate date]  options:0];
    
    // Get the day, hour and minutes
    Days = [NSNumber numberWithLong:[Components day]];
    Hours = [NSNumber numberWithLong:[Components hour]];
    Minutes = [NSNumber numberWithLong:[Components minute]];
    
    // Format the dates
    NSString *Uptime = [NSString stringWithFormat:@"%@天%@小时%@分钟",//@"%@ Days %@ Hours %@ Minutes"
                        [Days stringValue],
                        [Hours stringValue],
                        [Minutes stringValue]];
    
    // Error checking
    if (!Uptime)
    {
        // No uptime found
        // Return nil
        return kDeviceInfoPlaceHolder;
    }
    
    // Return the uptime
    return Uptime;
}

/**  系统版本是否是iOS 8及以上  */
+ (BOOL)iOS8OrLater
{
    static BOOL version = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 8.0, *))
        {
            version = YES;
        }
    });
    return version;
}
/**  系统版本是否是iOS 9及以上  */
+ (BOOL)iOS9OrLater
{
    static BOOL version = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 9.0, *))
        {
            version = YES;
        }
    });
    return version;
}
/**  系统版本是否是iOS 10及以上  */
+ (BOOL)iOS10OrLater
{
    static BOOL version = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 10.0, *))
        {
            version = YES;
        }
    });
    return version;
}
/**  系统版本是否是iOS 11及以上  */
+ (BOOL)iOS11OrLater
{
    static BOOL version = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *))
        {
            version = YES;
        }
    });
    return version;
}
+ (NSString *)clipboardContent
{
    // Get the Pasteboard
    UIPasteboard *PasteBoard = [UIPasteboard generalPasteboard];
    // Get the string value of the pasteboard
    NSString *ClipboardContent = [PasteBoard string];
    // Check for validity
    if (ClipboardContent == nil || ClipboardContent.length <= 0) {
        // Error, invalid pasteboard
        return kDeviceInfoPlaceHolder;
    }
    // Successful
    return ClipboardContent;
}

#pragma mark - 本地区域相关
+ (NSString *)country
{
    NSLocale *Locale = [NSLocale currentLocale];
    // Get the country from the locale
    NSString *Country = [Locale localeIdentifier];
    // Check for validity
    if (Country == nil || Country.length <= 0) {
        // Error, invalid country
        return kDeviceInfoPlaceHolder;
    }
    // Completed Successfully
    return Country;
}

+ (NSString *)language
{
    // Get the list of languages
    NSArray *LanguageArray = [NSLocale preferredLanguages];
    // Get the user's language
    NSString *Language = [LanguageArray objectAtIndex:0];
    // Check for validity
    if (Language == nil || Language.length <= 0) {
        // Error, invalid language
        return kDeviceInfoPlaceHolder;
    }
    // Completed Successfully
    return Language;
}

+ (NSString *)timeZone
{
    // Get the system timezone
    NSTimeZone *LocalTime = [NSTimeZone systemTimeZone];
    // Convert the time zone to a string
    NSString *TimeZone = [LocalTime name];
    // Check for validity
    if (TimeZone == nil || TimeZone.length <= 0) {
        // Error, invalid TimeZone
        return kDeviceInfoPlaceHolder;
    }
    // Completed Successfully
    return TimeZone;
}

+ (NSString *)currency
{
    // Get the system currency
    NSString *Currency = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
    // Check for validity
    if (Currency == nil || Currency.length <= 0) {
        // Error, invalid Currency
        return kDeviceInfoPlaceHolder;
    }
    // Completed Successfully
    return Currency;
}

#pragma mark - 网络相关
+ (NSString *)carrierName
{
    // Get the Telephony Network Info
    CTTelephonyNetworkInfo *TelephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    // Get the carrier
    CTCarrier *Carrier = [TelephonyInfo subscriberCellularProvider];
    // Get the carrier name
    NSString *CarrierName = Carrier.isoCountryCode ? [Carrier carrierName] : @"不支持或无SIM卡";
    
    // Check to make sure it's valid
    if (CarrierName == nil || CarrierName.length <= 0) {
        // Return unknown
        return kDeviceInfoPlaceHolder;
    }
    
    // Return the name
    return CarrierName;
}

+ (NSString *)carrierCountry
{
    // Get the locale
    NSLocale *CurrentCountry = [NSLocale currentLocale];
    // Get the country Code
    NSString *Country = [CurrentCountry objectForKey:NSLocaleCountryCode];
    // Check if it returned anything
    if (Country == nil || Country.length <= 0) {
        // No country found
        return kDeviceInfoPlaceHolder;
    }
    // Return the country
    return Country;
}

+ (NSString *)carrierISOCountryCode
{
    // Get the Telephony Network Info
    CTTelephonyNetworkInfo *TelephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    // Get the carrier
    CTCarrier *Carrier = [TelephonyInfo subscriberCellularProvider];
    // Get the carrier ISO country code
    NSString *CarrierCode = [Carrier isoCountryCode];
    
    // Check to make sure it's valid
    if (CarrierCode == nil || CarrierCode.length <= 0) {
        // Return unknown
        return kDeviceInfoPlaceHolder;
    }
    
    // Return the name
    return CarrierCode;
}

+ (BOOL)carrierAllowsVOIP
{
    // Get the Telephony Network Info
    CTTelephonyNetworkInfo *TelephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    // Get the carrier
    CTCarrier *Carrier = [TelephonyInfo subscriberCellularProvider];
    // Get the carrier VOIP Status
    BOOL CarrierVOIP = [Carrier allowsVOIP];
    
    // Return the VOIP Status
    return CarrierVOIP;
}

static YYReachability *_reachability = nil;
+ (NSString *)networkStatus
{
    if (!_reachability) _reachability = [YYReachability reachability];
    YYReachabilityStatus status = _reachability.status;
    YYReachabilityWWANStatus wwanStatus = _reachability.wwanStatus;
    NSString *net = nil;
    
    switch (status)
    {
        case YYReachabilityStatusNone: //无网络
        {
            net = @"notReachable";
        }
            break;
            
        case YYReachabilityStatusWWAN: //蜂窝网络
        {
            switch (wwanStatus)
            {
                case YYReachabilityWWANStatusNone:
                {
                    net = @"notReachable";
                }
                    break;
                    
                case YYReachabilityWWANStatus2G:
                {
                    net = @"2G";
                }
                    break;
                    
                case YYReachabilityWWANStatus3G:
                {
                    net = @"3G";
                }
                    break;
                    
                case YYReachabilityWWANStatus4G:
                {
                    net = @"4G";
                }
                    break;
            }
        }
            break;
            
        case YYReachabilityStatusWiFi: //WIFI
        {
            net = @"WiFi";
        }
            break;
    }
    
    return net;
}

+ (BOOL)isConnectedToWiFi
{
    if (!_reachability) _reachability = [YYReachability reachability];
    YYReachabilityStatus status = _reachability.status;
    BOOL wifi = NO;    
    if (status == YYReachabilityStatusWiFi) wifi = YES;

    return wifi;
}

+ (NSString *)WIFIName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return kDeviceInfoPlaceHolder;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

+ (NSString *)ipAddressWIFI
{
    return [self ipAddressWithIfaName:@"en0"];
}

+ (NSString *)ipAddressCell
{
    return [self ipAddressWithIfaName:@"pdp_ip0"];
}

+ (NSString *)ipAddressWithIfaName:(NSString *)name {
    if (name.length == 0) return nil;
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr) {
            if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:name]) {
                sa_family_t family = addr->ifa_addr->sa_family;
                switch (family) {
                    case AF_INET: { // IPv4
                        char str[INET_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in *)addr->ifa_addr)->sin_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    } break;
                        
                    case AF_INET6: { // IPv6
                        char str[INET6_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    }
                        
                    default: break;
                }
                if (address) break;
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address;
}


#pragma mark - APP相关
// @see https://github.com/nst/iOS-Runtime-Headers/blob/master/Frameworks/MobileCoreServices.framework/LSApplicationProxy.h
+ (NSString *)appVersion
{
    return [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}
+ (NSString *)appDisplayName
{
    return [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
}
+ (NSString *)appBuildVersion
{
    return [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
}

#pragma mark - 磁盘与内存
+ (NSString *)totalDiskSpace
{
    // Get the long total disk space
    long long Space = [self longDiskSpace];
    
    // Check to make sure it's valid
    if (Space <= 0) {
        // Error, no disk space found
        return kDeviceInfoPlaceHolder;
    }
    
    // Turn that long long into a string
    NSString *DiskSpace = [self formatMemory:Space];
    
    // Check to make sure it's valid
    if (DiskSpace == nil || DiskSpace.length <= 0) {
        // Error, diskspace not given
        return kDeviceInfoPlaceHolder;
    }
    
    // Return successful
    return DiskSpace;
}

+ (long long)longDiskSpace
{
    // Set up variables
    long long DiskSpace = 0L;
    NSError *Error = nil;
    NSDictionary *FileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&Error];
    
    // Get the file attributes of the home directory assuming no errors
    if (Error == nil) {
        // Get the size of the filesystem
        DiskSpace = [[FileAttributes objectForKey:NSFileSystemSize] longLongValue];
    } else {
        // Error, return nil
        return -1;
    }
    
    // Check to make sure it's a valid size
    if (DiskSpace <= 0) {
        // Invalid size
        return -1;
    }
    
    // Successful
    return DiskSpace;
}

+ (NSString *)formatMemory:(long long)Space
{
    // Set up the string
    NSString *FormattedBytes = nil;
    
    // Get the bytes, megabytes, and gigabytes
    double NumberBytes = 1.0 * Space;
    double TotalGB = NumberBytes / (1024 * 1024 * 1024);
    double TotalMB = NumberBytes / (1024 * 1024);
    
    // Display them appropriately
    if (TotalGB >= 1.0) {
        FormattedBytes = [NSString stringWithFormat:@"%.2f GB", TotalGB];
    } else if (TotalMB >= 1)
        FormattedBytes = [NSString stringWithFormat:@"%.2f MB", TotalMB];
    else {
        FormattedBytes = [self formattedMemory:Space];
        FormattedBytes = [FormattedBytes stringByAppendingString:@" bytes"];
    }
    
    // Check for errors
    if (FormattedBytes == nil || FormattedBytes.length <= 0) {
        // Error, invalid string
        return kDeviceInfoPlaceHolder;
    }
    
    // Completed Successfully
    return FormattedBytes;
}

+ (NSString *)formattedMemory:(unsigned long long)Space
{
    // Set up the string variable
    NSString *FormattedBytes = nil;
    
    // Set up the format variable
    NSNumberFormatter *Formatter = [[NSNumberFormatter alloc] init];
    
    // Format the bytes
    [Formatter setPositiveFormat:@"###,###,###,###"];
    
    // Get the bytes
    NSNumber * theNumber = [NSNumber numberWithLongLong:Space];
    
    // Format the bytes appropriately
    FormattedBytes = [Formatter stringFromNumber:theNumber];
    
    // Check for errors
    if (FormattedBytes == nil || FormattedBytes.length <= 0) {
        // Error, invalid value
        return kDeviceInfoPlaceHolder;
    }
    
    // Completed Successfully
    return FormattedBytes;
}

+ (NSString *)usedDiskSpace
{
    return [self usedDiskSpace:NO];
}

+ (NSString *)usedDiskSpace:(BOOL)inPercent
{
    // Make a variable to hold the Used Disk Space
    long long UDS;
    // Get the long total disk space
    long long TDS = [self longDiskSpace];
    // Get the long free disk space
    long long FDS = [self longFreeDiskSpace];
    
    // Make sure they're valid
    if (TDS <= 0 || FDS <= 0) {
        // Error, invalid values
        return kDeviceInfoPlaceHolder;
    }
    
    // Now subtract the free space from the total space
    UDS = TDS - FDS;
    
    // Make sure it's valid
    if (UDS <= 0) {
        // Error, invalid value
        return kDeviceInfoPlaceHolder;
    }
    
    // Set up the string output variable
    NSString *UsedDiskSpace;
    
    // If the user wants the output in percentage
    if (inPercent) {
        // Make a float to get the percent of those values
        float PercentUsedDiskSpace = (UDS * 100) / TDS;
        // Check it to make sure it's okay
        if (PercentUsedDiskSpace <= 0) {
            // Error, invalid percent
            return kDeviceInfoPlaceHolder;
        }
        // Convert that float to a string
        UsedDiskSpace = [NSString stringWithFormat:@"%.f%%", PercentUsedDiskSpace];
    } else {
        // Turn that long long into a string
        UsedDiskSpace = [self formatMemory:UDS];
    }
    
    // Check to make sure it's valid
    if (UsedDiskSpace == nil || UsedDiskSpace.length <= 0) {
        // Error, diskspace not given
        return kDeviceInfoPlaceHolder;
    }
    
    // Return successful
    return UsedDiskSpace;
}

+ (long long)longFreeDiskSpace
{
    // Set up the variables
    long long FreeDiskSpace = 0L;
    NSError *Error = nil;
    NSDictionary *FileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&Error];
    
    // Get the file attributes of the home directory assuming no errors
    if (Error == nil) {
        FreeDiskSpace = [[FileAttributes objectForKey:NSFileSystemFreeSize] longLongValue];
    } else {
        // There was an error
        return -1;
    }
    
    // Check for valid size
    if (FreeDiskSpace <= 0) {
        // Invalid size
        return -1;
    }
    
    // Successful
    return FreeDiskSpace;
}

+ (NSString *)freeDiskSpace
{
    return [self freeDiskSpace:NO];
}

+ (NSString *)freeDiskSpace:(BOOL)inPercent
{
    // Get the long size of free space
    long long Space = [self longFreeDiskSpace];
    
    // Check to make sure it's valid
    if (Space <= 0) {
        // Error, no disk space found
        return kDeviceInfoPlaceHolder;
    }
    
    // Set up the string output variable
    NSString *DiskSpace;
    
    // If the user wants the output in percentage
    if (inPercent) {
        // Get the total amount of space
        long long TotalSpace = [self longDiskSpace];
        // Make a float to get the percent of those values
        float PercentDiskSpace = (Space * 100) / TotalSpace;
        // Check it to make sure it's okay
        if (PercentDiskSpace <= 0) {
            // Error, invalid percent
            return kDeviceInfoPlaceHolder;
        }
        // Convert that float to a string
        DiskSpace = [NSString stringWithFormat:@"%.f%%", PercentDiskSpace];
    } else {
        // Turn that long long into a string
        DiskSpace = [self formatMemory:Space];
    }
    
    // Check to make sure it's valid
    if (DiskSpace == nil || DiskSpace.length <= 0) {
        // Error, diskspace not given
        return kDeviceInfoPlaceHolder;
    }
    
    // Return successful
    return DiskSpace;
}

+ (NSString *)memoryTotal
{
    int64_t mem = [[NSProcessInfo processInfo] physicalMemory];
    if (mem < -1) mem = -1;
    double TotalGB = mem / (1024 * 1024 * 1024);
    return [NSString stringWithFormat:@"%.lf", TotalGB < 0.f ? -1.0 : TotalGB];
}

+ (NSDictionary<NSString *, id> *)userDefaultsDictionaryRepresentation
{
    return [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
}

#pragma mark - cookie相关
+ (BOOL)addCookieWithName:(nonnull NSString *)name value:(nonnull NSString *)value domain:(nonnull NSString *)domain path:(nonnull NSString *)path
{
    /*
     [NSHTTPCookie cookieWithProperties:@{
         NSHTTPCookieName: @"name",
         NSHTTPCookieValue: @"value",
         NSHTTPCookieDomain: @"*.baidu.com",
         NSHTTPCookiePath: @"/"
     }];
     */
    if (name && [name isKindOfClass:[NSString class]] && value && [value isKindOfClass:[NSString class]] && domain && [domain isKindOfClass:[NSString class]] && path && [path isKindOfClass:[NSString class]])
    {
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:@{
                                                                    NSHTTPCookieName: name,
                                                                    NSHTTPCookieValue: value,
                                                                    NSHTTPCookieDomain: domain,
                                                                    NSHTTPCookiePath: path,
                                                                    }];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        return YES;
    }
    return NO;
}

+ (NSString *)cookieValueForKey:(const NSString *)key
{
    NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    __block NSString *value = nil;
    
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([key isEqualToString:obj.name])
        {
            value = obj.value;
            *stop = YES;
        }
    }];
    
    return value;
}

+ (NSDictionary *)requestHeaderFields
{
    NSArray *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    return [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
}

#pragma mark - 构造方法
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 设备相关
        _uuid = [LTDeviceInfo uuid];
        _deviceModel =[LTDeviceInfo deviceModel];
        _deviceName = [LTDeviceInfo deviceName];
        _machineModel = [LTDeviceInfo machineModel];
        _machineModelName = [LTDeviceInfo machineModelName];
        _isSimulator = [LTDeviceInfo isSimulator];
        _isJailbroken = [LTDeviceInfo isJailbroken];
        _isEnableTouchID = [LTDeviceInfo isEnableTouchID];
        _resolutionRatio = [LTDeviceInfo resolutionRatio];
        
        // 屏幕相关
        _isLandscape = [LTDeviceInfo isLandscape];
        _isDeviceLandscape = [LTDeviceInfo isDeviceLandscape];
        _deviceWidth = [LTDeviceInfo deviceWidth];
        _deviceHeight = [LTDeviceInfo deviceHeight];
        _screenWidth = [LTDeviceInfo screenWidth];
        _screenHeight = [LTDeviceInfo screenHeight];
        _is58InchScreen = [LTDeviceInfo is58InchScreen];
        _is55InchScreen = [LTDeviceInfo is55InchScreen];
        _is47InchScreen = [LTDeviceInfo is47InchScreen];
        _is40InchScreen = [LTDeviceInfo is40InchScreen];
        _is35InchScreen = [LTDeviceInfo is35InchScreen];
        _screenSizeFor58Inch = [LTDeviceInfo screenSizeFor58Inch];
        _screenSizeFor55Inch = [LTDeviceInfo screenSizeFor55Inch];
        _screenSizeFor47Inch = [LTDeviceInfo screenSizeFor47Inch];
        _screenSizeFor40Inch = [LTDeviceInfo screenSizeFor40Inch];
        _screenSizeFor35Inch = [LTDeviceInfo screenSizeFor35Inch];
        _isRetinaScreen = [LTDeviceInfo isRetinaScreen];
        _pixelOne = [LTDeviceInfo pixelOne];
        
        // 系统版本,软件相关
        _systemName = [LTDeviceInfo systemName];
        _systemVersion = [LTDeviceInfo systemVersion];
        _systemUptime = [LTDeviceInfo systemUptime];
        _iOS8OrLater = [LTDeviceInfo iOS8OrLater];
        _iOS9OrLater = [LTDeviceInfo iOS9OrLater];
        _iOS10OrLater = [LTDeviceInfo iOS10OrLater];
        _iOS11OrLater = [LTDeviceInfo iOS11OrLater];
        _clipboardContent = [LTDeviceInfo clipboardContent];
        
        // 本地区域相关
        _country = [LTDeviceInfo country];
        _language = [LTDeviceInfo language];
        _timeZone = [LTDeviceInfo timeZone];
        _currency = [LTDeviceInfo currency];
        
        //网络相关
        _carrierName = [LTDeviceInfo carrierName];
        _carrierCountry = [LTDeviceInfo carrierCountry];
        _carrierISOCountryCode = [LTDeviceInfo carrierISOCountryCode];
        _carrierAllowsVOIP = [LTDeviceInfo carrierAllowsVOIP];
        _networkStatus = [LTDeviceInfo networkStatus];
        _isConnectedToWiFi = [LTDeviceInfo isConnectedToWiFi];
        _WIFIName = [LTDeviceInfo WIFIName];
        _ipAddressWIFI = [LTDeviceInfo ipAddressWIFI];
        _ipAddressCell = [LTDeviceInfo ipAddressCell];
        
        //APP相关
        _appVersion = [LTDeviceInfo appVersion];
        _appDisplayName = [LTDeviceInfo appDisplayName];
        _appBuildVersion = [LTDeviceInfo appBuildVersion];
        
        //磁盘与内存
        _totalDiskSpace = [LTDeviceInfo totalDiskSpace];
        _usedDiskSpace = [LTDeviceInfo usedDiskSpace];
        _freeDiskSpace = [LTDeviceInfo freeDiskSpace];
        _memoryTotal = [LTDeviceInfo memoryTotal];
    }
    return self;
}

#pragma mark - 额外的
// 最近一次系统启动时间
+ (double)getLaunchSystemTime
{
    NSTimeInterval timer = [NSProcessInfo processInfo].systemUptime;
    NSDate *currentDate = [NSDate new];
    
    NSDate *startTime = [currentDate dateByAddingTimeInterval:(-timer)];
    NSTimeInterval convertStartTimeToSecond = [startTime timeIntervalSince1970];
    
    return convertStartTimeToSecond;
}


@end
