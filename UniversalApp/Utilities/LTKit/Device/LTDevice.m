//
//  LTDevice.m
//  UniversalApp
//
//  Created by huanyu.li on 2018/5/20.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import "LTDevice.h"

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

#define kDeviceInfoPlaceHolder nil

@implementation LTDevice

+ (NSString *)deviceModel
{
    // Get the device model
    if ([[UIDevice currentDevice] respondsToSelector:@selector(model)])
    {
        // Make a string for the device model
        NSString *deviceModel = [[UIDevice currentDevice] model];
        // Set the output to the device model
        return deviceModel;
    }
    else
    {
        // Device model not found
        return kDeviceInfoPlaceHolder;
    }
}

+ (NSString *)deviceName
{
    // Get the current device name
    if ([[UIDevice currentDevice] respondsToSelector:@selector(name)])
    {
        // Make a string for the device name
        NSString *deviceName = [[UIDevice currentDevice] name];
        // Set the output to the device name
        return deviceName;
    }
    else
    {
        // Device name not found
        return kDeviceInfoPlaceHolder;
    }
}

/// @see http://theiphonewiki.com/wiki/Models
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

/// @see http://theiphonewiki.com/wiki/Models
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
                              @"Watch4,1" : @"Apple Watch Series 4 40mm",
                              @"Watch4,2" : @"Apple Watch Series 4 44mm",
                              @"Watch4,3" : @"Apple Watch Series 4 40mm",
                              @"Watch4,4" : @"Apple Watch Series 4 44mm",
                              
                              @"AudioAccessory1,1" : @"HomePod",
                              
                              @"AirPods1,1" : @"AirPods",
                              
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
                              @"iPhone11,2" : @"iPhone XS",
                              @"iPhone11,4" : @"iPhone XS Max",
                              @"iPhone11,6" : @"iPhone XS Max China",
                              @"iPhone11,8" : @"iPhone XR",
                              
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
                              @"iPad7,5" : @"iPad 6",
                              @"iPad7,6" : @"iPad 6",
                              @"iPad8,1" : @"iPad Pro (11-inch)",
                              @"iPad8,2" : @"iPad Pro (11-inch)",
                              @"iPad8,3" : @"iPad Pro (11-inch)",
                              @"iPad8,4" : @"iPad Pro (11-inch)",
                              @"iPad8,5" : @"iPad Pro (12.9-inch) (3rd generation)",
                              @"iPad8,6" : @"iPad Pro (12.9-inch) (3rd generation)",
                              @"iPad8,7" : @"iPad Pro (12.9-inch) (3rd generation)",
                              @"iPad8,8" : @"iPad Pro (12.9-inch) (3rd generation)",
                              @"iPad11,1" : @"iPad mini (5th generation)",
                              @"iPad11,2" : @"iPad mini (5th generation)",
                              @"iPad11,3" : @"iPad Air (3rd generation)",
                              @"iPad11,4" : @"iPad Air (3rd generation)",
                              
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

/// @see http://theiphonewiki.com/wiki/Models
+ (NSString *)screenInchSize
{
    static dispatch_once_t one;
    static NSString *inchSize;
    dispatch_once(&one, ^{
        NSString *model = [self machineModel];
        
        NSDictionary *dic = @{
                              @"Watch1,1" : @"1.5",//@"Apple Watch (1st generation) 38mm",
                              @"Watch1,2" : @"1.65",//@"Apple Watch (1st generation) 42mm",
                              @"Watch2,3" : @"Apple Watch Series 2 38mm",
                              @"Watch2,4" : @"Apple Watch Series 2 42mm",
                              @"Watch2,6" : @"1.5",//@"Apple Watch Series 1 38mm",
                              @"Watch2,7" : @"1.65",//@"Apple Watch Series 1 42mm",
                              @"Watch3,1" : @"Apple Watch Series 3 38mm",
                              @"Watch3,2" : @"Apple Watch Series 3 42mm",
                              @"Watch3,3" : @"Apple Watch Series 3 38mm",
                              @"Watch3,4" : @"Apple Watch Series 3 42mm",
                              @"Watch4,1" : @"Apple Watch Series 4 40mm",
                              @"Watch4,2" : @"Apple Watch Series 4 44mm",
                              @"Watch4,3" : @"Apple Watch Series 4 40mm",
                              @"Watch4,4" : @"Apple Watch Series 4 44mm",
                              
                              @"AudioAccessory1,1" : @"HomePod",
                              
                              @"AirPods1,1" : @"AirPods",
                              
                              @"iPod1,1" : @"3.5",//@"iPod touch 1",
                              @"iPod2,1" : @"3.5",//@"iPod touch 2",
                              @"iPod3,1" : @"3.5",//@"iPod touch 3",
                              @"iPod4,1" : @"3.5",//@"iPod touch 4",
                              @"iPod5,1" : @"4.0",//@"iPod touch 5",
                              @"iPod7,1" : @"4.0",//@"iPod touch 6",
                              
                              @"iPhone1,1" : @"3.5",//@"iPhone 1G",
                              @"iPhone1,2" : @"3.5",//@"iPhone 3G",
                              @"iPhone2,1" : @"3.5",//@"iPhone 3GS",
                              @"iPhone3,1" : @"3.5",//@"iPhone 4 (GSM)",
                              @"iPhone3,2" : @"3.5",//@"iPhone 4",
                              @"iPhone3,3" : @"3.5",//@"iPhone 4 (CDMA)",
                              @"iPhone4,1" : @"3.5",//@"iPhone 4S",
                              @"iPhone5,1" : @"4.0",//@"iPhone 5",
                              @"iPhone5,2" : @"4.0",//@"iPhone 5",
                              @"iPhone5,3" : @"4.0",//@"iPhone 5c",
                              @"iPhone5,4" : @"4.0",//@"iPhone 5c",
                              @"iPhone6,1" : @"4.0",//@"iPhone 5s",
                              @"iPhone6,2" : @"4.0",//@"iPhone 5s",
                              @"iPhone7,1" : @"5.5",//@"iPhone 6 Plus",
                              @"iPhone7,2" : @"4.7",//@"iPhone 6",
                              @"iPhone8,1" : @"4.7",//@"iPhone 6s",
                              @"iPhone8,2" : @"5.5",//@"iPhone 6s Plus",
                              @"iPhone8,4" : @"4.0",//@"iPhone SE",
                              @"iPhone9,1" : @"4.7",//@"iPhone 7",
                              @"iPhone9,2" : @"5.5",//@"iPhone 7 Plus",
                              @"iPhone9,3" : @"4.7",//@"iPhone 7",
                              @"iPhone9,4" : @"5.5",//@"iPhone 7 Plus",
                              @"iPhone10,1" : @"4.7",//@"iPhone 8",
                              @"iPhone10,2" : @"5.5",//@"iPhone 8 Plus",
                              @"iPhone10,3" : @"5.8",//@"iPhone X",
                              @"iPhone10,4" : @"4.7",//@"iPhone 8",
                              @"iPhone10,5" : @"5.5",//@"iPhone 8 Plus",
                              @"iPhone10,6" : @"5.8",//@"iPhone X",
                              @"iPhone11,2" : @"5.8",//@"iPhone XS",
                              @"iPhone11,4" : @"6.5",//@"iPhone XS Max",
                              @"iPhone11,6" : @"6.5",//@"iPhone XS Max China",
                              @"iPhone11,8" : @"6.1",//@"iPhone XR",
                              
                              @"iPad1,1" : @"9.7",//@"iPad 1",
                              @"iPad2,1" : @"9.7",//@"iPad 2 (WiFi)",
                              @"iPad2,2" : @"9.7",//@"iPad 2 (GSM)",
                              @"iPad2,3" : @"9.7",//@"iPad 2 (CDMA)",
                              @"iPad2,4" : @"9.7",//@"iPad 2",
                              @"iPad2,5" : @"7.9",//@"iPad mini 1",
                              @"iPad2,6" : @"7.9",//@"iPad mini 1",
                              @"iPad2,7" : @"7.9",//@"iPad mini 1",
                              @"iPad3,1" : @"9.7",//@"iPad 3 (WiFi)",
                              @"iPad3,2" : @"9.7",//@"iPad 3 (4G)",
                              @"iPad3,3" : @"9.7",//@"iPad 3 (4G)",
                              @"iPad3,4" : @"9.7",//@"iPad 4",
                              @"iPad3,5" : @"9.7",//@"iPad 4",
                              @"iPad3,6" : @"9.7",//@"iPad 4",
                              @"iPad4,1" : @"9.7",//@"iPad Air",
                              @"iPad4,2" : @"9.7",//@"iPad Air",
                              @"iPad4,3" : @"9.7",//@"iPad Air",
                              @"iPad4,4" : @"7.9",//@"iPad mini 2",
                              @"iPad4,5" : @"7.9",//@"iPad mini 2",
                              @"iPad4,6" : @"7.9",//@"iPad mini 2",
                              @"iPad4,7" : @"7.9",//@"iPad mini 3",
                              @"iPad4,8" : @"7.9",//@"iPad mini 3",
                              @"iPad4,9" : @"7.9",//@"iPad mini 3",
                              @"iPad5,1" : @"7.9",//@"iPad mini 4",
                              @"iPad5,2" : @"7.9",//@"iPad mini 4",
                              @"iPad5,3" : @"9.7",//@"iPad Air 2",
                              @"iPad5,4" : @"9.7",//@"iPad Air 2",
                              @"iPad6,3" : @"9.7",//@"iPad Pro (9.7 inch)",
                              @"iPad6,4" : @"9.7",//@"iPad Pro (9.7 inch)",
                              @"iPad6,7" : @"12.9",//@"iPad Pro (12.9 inch)",
                              @"iPad6,8" : @"12.9",//@"iPad Pro (12.9 inch)",
                              @"iPad6,11" : @"9.7",//@"iPad 5",
                              @"iPad6,12" : @"9.7",//@"iPad 5",
                              @"iPad7,1" : @"12.9",//@"iPad Pro (12.9-inch, 2nd generation)",
                              @"iPad7,2" : @"12.9",//@"iPad Pro (12.9-inch, 2nd generation)",
                              @"iPad7,3" : @"10.5",//@"iPad Pro (10.5-inch)",
                              @"iPad7,4" : @"10.5",//@"iPad Pro (10.5-inch)",
                              @"iPad7,5" : @"9.7",//@"iPad 6",
                              @"iPad7,6" : @"9.7",//@"iPad 6",
                              @"iPad8,1" : @"11.0",//@"iPad Pro (11-inch)",
                              @"iPad8,2" : @"11.0",//@"iPad Pro (11-inch)",
                              @"iPad8,3" : @"11.0",//@"iPad Pro (11-inch)",
                              @"iPad8,4" : @"11.0",//@"iPad Pro (11-inch)",
                              @"iPad8,5" : @"12.9",//@"iPad Pro (12.9-inch) (3rd generation)",
                              @"iPad8,6" : @"12.9",//@"iPad Pro (12.9-inch) (3rd generation)",
                              @"iPad8,7" : @"12.9",//@"iPad Pro (12.9-inch) (3rd generation)",
                              @"iPad8,8" : @"12.9",//@"iPad Pro (12.9-inch) (3rd generation)",
                              @"iPad11,1" : @"7.9",//@"iPad mini (5th generation)",
                              @"iPad11,2" : @"7.9",//@"iPad mini (5th generation)",
                              @"iPad11,3" : @"10.5",//@"iPad Air (3rd generation)",
                              @"iPad11,4" : @"10.5",//@"iPad Air (3rd generation)",
                              
                              @"AppleTV2,1" : @"Apple TV 2",
                              @"AppleTV3,1" : @"Apple TV 3",
                              @"AppleTV3,2" : @"Apple TV 3",
                              @"AppleTV5,3" : @"Apple TV 4",
                              @"AppleTV6,2" : @"Apple TV 4K",
                              
                              @"i386" : @"Simulator x86",
                              @"x86_64" : @"Simulator x64",
                              };
        inchSize = dic[model];
        if (!inchSize) inchSize = model;
    });
    return inchSize;
}

+ (NSString *)CUPType
{
    // Set up a Device Type String
    static NSString *CUPType = @"CPU_TYPE_ARM64";
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        host_basic_info_data_t hostInfo;
        mach_msg_type_number_t infoCount;
        infoCount = HOST_BASIC_INFO_COUNT;
        host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
        switch (hostInfo.cpu_type)
        {
            case CPU_TYPE_ARM:
            {
                CUPType = @"CPU_TYPE_ARM";
            }
                break;
            case CPU_TYPE_ARM64:
            {
                CUPType = @"CPU_TYPE_ARM64";
            }
                break;
            case CPU_TYPE_ARM64_32:
            {
                CUPType = @"CPU_TYPE_ARM64_32";
            }
                break;
                
            case CPU_TYPE_X86:
            {
                CUPType = @"CPU_TYPE_X86";
            }
                break;
                
            case CPU_TYPE_X86_64:
            {
                CUPType = @"CPU_TYPE_X86_64";
            }
                break;
                
            default:
                break;
        }
    });
    return CUPType;
}

+ (NSString *)SIMType
{
    // Set up a Device Type String
    static NSString *SIMType = @"";
    static dispatch_once_t one;
    dispatch_once(&one, ^{
        if ([self isIPhone])
        {
            NSString *machineModel = [self machineModel];
            NSString *iPhone4s = @"iPhone4,1";
            NSComparisonResult result =[iPhone4s compare:machineModel];
            switch (result)
            {
                case NSOrderedAscending:
                {
                    SIMType = @"Nano";
                }
                    break;
                 
                case NSOrderedSame:
                {
                    SIMType = @"Micro";
                }
                    break;
                    
                case NSOrderedDescending:
                {
                    SIMType = @"Micro";
                }
                    break;
                    
                default:
                    break;
            }
        }
    });
    return SIMType;
}

+ (UIDeviceBatteryState)batteryState
{
    return [UIDevice currentDevice].batteryState;;
}

+ (CGFloat)batteryLevel
{
    return [[UIDevice currentDevice] batteryLevel];
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
    if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL])
    {
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
+ (CGFloat)screenBrightness
{
    return [UIScreen mainScreen].brightness * 100;
}

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
        width = ([self iOS8OrLater] ? ([self.class isLandscape] ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width) : [[UIScreen mainScreen] bounds].size.width);
    });
    return width;
}
+ (CGFloat)deviceHeight
{
    static CGFloat height = 0.f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        height = (([self iOS8OrLater]  ? ([self.class isLandscape] ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height) : [[UIScreen mainScreen] bounds].size.height));
    });
    return height;
}
+ (CGFloat)screenWidth
{
    return (([self iOS8OrLater]  ? [[UIScreen mainScreen] bounds].size.width : ([self.class isLandscape] ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)));
}
+ (CGFloat)screenHeight
{
    return (([self iOS8OrLater]  ? [[UIScreen mainScreen] bounds].size.height : ([self.class isLandscape] ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)));
}

+ (CGFloat)statusBarHeight
{
    CGFloat height = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    if (height <= 0)
    {
        static CGFloat staticHeight = 20.f;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (@available(iOS 11.0, *))
            {
                if (@available(iOS 12.0, *))
                {
                    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                    UIEdgeInsets peripheryInsets = window.safeAreaInsets;
                    if (peripheryInsets.bottom <= 0)
                    {
                        UIViewController *viewController = [UIViewController new];
                        [viewController loadViewIfNeeded];
                        window.rootViewController = viewController;
                        if (CGRectGetMinY(viewController.view.frame) > 20)
                        {
                            staticHeight = peripheryInsets.bottom;
                        }
                    }
                }
                else
                {
                    staticHeight = [self.class is58InchScreen] ? 44.f : 20.f;
                }
            }
        });
        height = staticHeight;
    }
    return height;

}

+ (BOOL)isNotchedScreen
{
    static BOOL isNotchedScreen = NO;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 11.0, *))
        {
            if (@available(iOS 12.0, *))
            {
                /*
                 检测方式解释/测试要点：
                 1. iOS 11 与 iOS 12 可能行为不同，所以要分别测试。
                 2. 与触发 [QMUIHelper isNotchedScreen] 方法时的进程有关，例如 https://github.com/Tencent/QMUI_iOS/issues/482#issuecomment-456051738 里提到的 [NSObject performSelectorOnMainThread:withObject:waitUntilDone:NO] 就会导致较多的异常。
                 3. iOS 12 下，在非第2点里提到的情况下，iPhone、iPad 均可通过 UIScreen -_peripheryInsets 方法的返回值区分，但如果满足了第2点，则 iPad 无法使用这个方法，这种情况下要依赖第4点。
                 4. iOS 12 下，不管是否满足第2点，不管是什么设备类型，均可以通过一个满屏的 UIWindow 的 rootViewController.view.frame.origin.y 的值来区分，如果是非全面屏，这个值必定为20，如果是全面屏，则可能是24或44等不同的值。但由于创建 UIWindow、UIViewController 等均属于较大消耗，所以只在前面的步骤无法区分的情况下才会使用第4点。
                 5. 对于第4点，经测试与当前设备的方向、是否有勾选 project 里的 General - Hide status bar、当前是否处于来电模式的状态栏这些都没关系。
                 */
                SEL peripheryInsetsSelector = NSSelectorFromString([NSString stringWithFormat:@"_%@%@", @"periphery", @"Insets"]);
                UIEdgeInsets peripheryInsets = UIEdgeInsetsZero;
            
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[UIScreen mainScreen] methodSignatureForSelector:peripheryInsetsSelector]];
                [invocation setTarget:[UIScreen mainScreen]];
                [invocation setSelector:peripheryInsetsSelector];
                [invocation invoke];
                [invocation getReturnValue:&peripheryInsets];
                
                if (peripheryInsets.bottom <= 0)
                {
                    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
                    peripheryInsets = window.safeAreaInsets;
                    if (peripheryInsets.bottom <= 0)
                    {
                        UIViewController *viewController = [UIViewController new];
                        [viewController loadViewIfNeeded];
                        window.rootViewController = viewController;
                        if (CGRectGetMinY(viewController.view.frame) > 20)
                        {
                            peripheryInsets.bottom = 1;
                        }
                    }
                }
                isNotchedScreen = peripheryInsets.bottom > 0;
            }
            else
            {
                isNotchedScreen = [self.class is58InchScreen];
            }
        }
        else
        {
            isNotchedScreen = NO;
        }
    });
    return isNotchedScreen;
}

+ (BOOL)is65InchScreen
{
    static BOOL size = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSSet *inchScreenSet = [NSSet setWithObjects:@"iPhone11,4", @"iPhone11,6", nil];
        size = CGSizeEqualToSize([self screenSizeFor65Inch], CGSizeMake([self deviceWidth], [self deviceHeight])) && [inchScreenSet containsObject:[self machineModel]];
    });
    return size;
}

+ (BOOL)is61InchScreen
{
    static BOOL size = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSSet *inchScreenSet = [NSSet setWithObjects:@"iPhone11,8", nil];
        size = CGSizeEqualToSize([self screenSizeFor61Inch], CGSizeMake([self deviceWidth], [self deviceHeight])) && [inchScreenSet containsObject:[self machineModel]];
    });
    return size;
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

+ (CGSize)screenSizeFor65Inch
{
    return CGSizeMake(414.f, 896.f);
}

+ (CGSize)screenSizeFor61Inch
{
    return CGSizeMake(414.f, 896.f);
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

+ (CGFloat)homeIndicatorHeight
{
    CGFloat homeIndicatorHeight = 0.f;
    
    if (![self isNotchedScreen])
    {
        return homeIndicatorHeight;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            homeIndicatorHeight = 34.f;
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            homeIndicatorHeight = 21.f;
            break;
            
        case UIInterfaceOrientationUnknown:
        default:
            homeIndicatorHeight = 34.f;
            break;
    }
    
    return homeIndicatorHeight;
}

+ (CGFloat)tabBarHeight
{
    CGFloat tabBarHeight = 49.f + [self homeIndicatorHeight];
    return tabBarHeight;
}

+ (CGFloat)navigationBarHeigh
{
    return 44.f;
}

+ (CGFloat)navigationPlusStatusBarHeight
{
    return 44.f + [self statusBarHeight];
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
    return [self systemVersion].doubleValue >= 8.0;
}
/**  系统版本是否是iOS 9及以上  */
+ (BOOL)iOS9OrLater
{
    return [self systemVersion].doubleValue >= 9.0;
}
/**  系统版本是否是iOS 10及以上  */
+ (BOOL)iOS10OrLater
{
    return [self systemVersion].doubleValue >= 10.0;
}
/**  系统版本是否是iOS 11及以上  */
+ (BOOL)iOS11OrLater
{
    return [self systemVersion].doubleValue >= 11.0;
}
/**  系统版本是否是iOS 11及以上  */
+ (BOOL)iOS12OrLater
{
    return [self systemVersion].doubleValue >= 12.0;
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
    //NSArray *LanguageArray = [NSLocale preferredLanguages];
    NSArray *LanguageArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    // Get the user's language
    NSString *Language = LanguageArray.firstObject;
    // Check for validity
    if (Language == nil || Language.length <= 0) {
        // Error, invalid language
        return kDeviceInfoPlaceHolder;
    }
    // Completed Successfully
    return Language;
}

+ (void)setLanguage:(NSString *)language
{
    if (language && [language isKindOfClass:[NSString class]])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@[language] forKey:@"AppleLanguages"];
    }
}

+ (void)resetLanguage
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AppleLanguages"];
    //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"AppleLanguages"];
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

+ (BOOL)isOpenProxy
{
    CFDictionaryRef proxySettings = CFNetworkCopySystemProxySettings();
    NSDictionary *dictProxy = (__bridge_transfer id)proxySettings;
    //NSString *proxyAddress = [dictProxy objectForKey:@"HTTPProxy"]; //代理地址
    //NSInteger proxyPort = [[dictProxy objectForKey:@"HTTPPort"] integerValue];  //代理端口号
    //是否开启了http代理
    return [[dictProxy objectForKey:@"HTTPEnable"] boolValue];
}

+ (BOOL)isOpenVPN
{
    BOOL flag = NO;
    NSString *version = [UIDevice currentDevice].systemVersion;
    // need two ways to judge this.
    if (version.doubleValue >= 9.0)
    {
        NSDictionary *dict = CFBridgingRelease(CFNetworkCopySystemProxySettings());
        NSArray *keys = [dict[@"__SCOPED__"] allKeys];
        for (NSString *key in keys)
        {
            if ([key rangeOfString:@"tap"].location != NSNotFound ||
                [key rangeOfString:@"tun"].location != NSNotFound ||
                [key rangeOfString:@"ipsec"].location != NSNotFound ||
                [key rangeOfString:@"ppp"].location != NSNotFound)
            {
                flag = YES;
                break;
            }
        }
    }
    else
    {
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        int success = 0;
        
        // retrieve the current interfaces - returns 0 on success
        success = getifaddrs(&interfaces);
        if (success == 0)
        {
            // Loop through linked list of interfaces
            temp_addr = interfaces;
            while (temp_addr != NULL)
            {
                NSString *string = [NSString stringWithFormat:@"%s" , temp_addr->ifa_name];
                if ([string rangeOfString:@"tap"].location != NSNotFound ||
                    [string rangeOfString:@"tun"].location != NSNotFound ||
                    [string rangeOfString:@"ipsec"].location != NSNotFound ||
                    [string rangeOfString:@"ppp"].location != NSNotFound)
                {
                    flag = YES;
                    break;
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        
        // Free memory
        freeifaddrs(interfaces);
    }
    return flag;
}

+ (NSString *)cellNetworkType
{
    NSString *netWorkType = nil;
    NSArray *typeStrings2G = @[CTRadioAccessTechnologyEdge,
                               CTRadioAccessTechnologyGPRS,
                               CTRadioAccessTechnologyCDMA1x,];
    NSArray *typeStrings3G = @[CTRadioAccessTechnologyHSDPA,
                               CTRadioAccessTechnologyWCDMA,
                               CTRadioAccessTechnologyHSUPA,
                               CTRadioAccessTechnologyCDMAEVDORev0,
                               CTRadioAccessTechnologyCDMAEVDORevA,
                               CTRadioAccessTechnologyCDMAEVDORevB,
                               CTRadioAccessTechnologyeHRPD,];
    NSArray *typeStrings4G = @[CTRadioAccessTechnologyLTE,];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CTTelephonyNetworkInfo *teleInfo= [[CTTelephonyNetworkInfo alloc] init];
        NSString *accessString = teleInfo.currentRadioAccessTechnology;
        if ([typeStrings4G containsObject:accessString])
        {
            netWorkType = @"4G";
        }
        else if ([typeStrings3G containsObject:accessString])
        {
            netWorkType = @"3G";
        }
        else if ([typeStrings2G containsObject:accessString])
        {
            netWorkType = @"2G";
        }
    }
    return netWorkType;
}

// Connected to Cellular Network?
+ (BOOL)isConnectedToCellNetwork
{
    // Check if we're connected to cell network
    NSString *cellAddress = [self ipAddressCell];
    // Check if the string is populated
    if (cellAddress == nil || cellAddress.length <= 0)
    {
        // Nothing found
        return false;
    }
    else
    {
        // Cellular Network in use
        return true;
    }
}

// Connected to WiFi?
+ (BOOL)isConnectedToWiFi\
{
    // Check if we're connected to WiFi
    NSString *wiFiAddress = [self ipAddressWiFi];
    // Check if the string is populated
    if (wiFiAddress == nil || wiFiAddress.length <= 0)
    {
        // Nothing found
        return false;
    }
    else
    {
        // WiFi in use
        return true;
    }
}

+ (NSString *)WiFiName
{
    NSString *wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces)
    {
        return kDeviceInfoPlaceHolder;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces)
    {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef)
        {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            //NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

+ (NSString *)WiFiMacAddress
{
    NSString *wifiMacAddress = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces)
    {
        return kDeviceInfoPlaceHolder;
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces)
    {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef)
        {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            //NSLog(@"network info -> %@", networkInfo);
            wifiMacAddress = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeyBSSID];
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiMacAddress;
}

+ (NSString *)ipAddressWiFi
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

// Get the External IP Address
+ (nullable NSString *)externalIPAddress
{
    @try {
        // Check if we have an internet connection then try to get the External IP Address
        if (![self isConnectedToCellNetwork] && ![self isConnectedToWiFi])
        {
            // Not connected to anything, return nil
            return kDeviceInfoPlaceHolder;
        }
        
        // Get the external IP Address based on icanhazip.com
        NSError *error = nil;
        
        // Using https://icanhazip.com
        NSString *externalIP = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://icanhazip.com/"] encoding:NSUTF8StringEncoding error:&error];
        
        if (!error)
        {
            // Format the IP Address
            externalIP = [externalIP stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            // Check that you get something back
            if (externalIP == nil || externalIP.length <= 0) {
                // Error, no address found
                return kDeviceInfoPlaceHolder;
            }
            
            // Return External IP
            return externalIP;
        } else {
            // Error, no address found
            return kDeviceInfoPlaceHolder;
        }
    }
    @catch (NSException *exception) {
        // Error, no address found
        return kDeviceInfoPlaceHolder;
    }
}



#pragma mark - APP相关
// @see https://github.com/nst/iOS-Runtime-Headers/blob/master/Frameworks/MobileCoreServices.framework/LSApplicationProxy.h
+ (NSString *)appVersion
{
    return [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}
+ (NSString *)appDisplayName
{
    return [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
}
+ (NSString *)appBuildVersion
{
    return [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
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

+ (NSDictionary *)infoDictionary
{
    return [[NSBundle mainBundle] infoDictionary];
}

#pragma mark - 沙盒路径相关
/*
 沙盒
    Bundle Container
        MyApp.app:由于应用程序必须经过签名，所以不能在运行时对这个目录中的内容进行修改，否则会导致应用程序无法启动
    Data Container
        Documents:保存应用运行时生成的需要持久化的数据,iTunes会自动备份该目录。苹果建议将在应用程序中浏览到的文件数据保存在该目录下。
        Library:
            Caches: 一般存储的是缓存文件，例如图片视频等，此目录下的文件不会在应用程序退出时删除。
                    *在手机备份的时候，iTunes不会备份该目录。例如音频,视频等文件存放其中
            Preferences:保存应用程序的所有偏好设置iOS的Settings(设置)，我们不应该直接在这里创建文件，而是需要通过NSUserDefault这个类来访问应用程序的偏好设置。
                    *iTunes会自动备份该文件目录下的内容。比如说:是否允许访问图片,是否允许访问地理位置......
            tmp:临时文件目录，在程序重新运行的时候，和开机的时候，会清空tmp文件夹
    iCloud Container
 …
 */
+ (NSURL *)documentsURL
{
    return [self URLForDirectory:NSDocumentDirectory];
}

+ (NSString *)documentsPath
{
    return [self pathForDirectory:NSDocumentDirectory];
}

+ (NSURL *)libraryURL
{
    return [self URLForDirectory:NSLibraryDirectory];
}

+ (NSString *)libraryPath
{
    return [self pathForDirectory:NSLibraryDirectory];
}

+ (NSURL *)cachesURL
{
    return [self URLForDirectory:NSCachesDirectory];
}

+ (NSString *)cachesPath
{
    return [self pathForDirectory:NSCachesDirectory];
}

+ (BOOL)createFolderAtPath:(NSString *)folderPath
{
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
    return success;
}

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
+ (float)folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
    {
        return 0.0;
    }
    NSEnumerator *childFilesEnumerator=[[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName = nil;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject])!=nil)
    {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize / (1024.0 * 1024.0);
}

//清除指定文件
+ (BOOL)clearItemAtPath:(NSString *)filePath
{
    NSError *error = nil;
    BOOL success = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
    return success;
}

//清除指定文件夹缓存
+ (BOOL)clearfolderItemsAtPath:(NSString *)folderPath
{
    NSArray<NSString *> *files = [[NSFileManager defaultManager] subpathsAtPath:folderPath];
    BOOL success = NO;
    for (NSString *item in files)
    {
        NSError *error = nil;
        NSString *path = [folderPath stringByAppendingPathComponent:item];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
        success = YES;
    }
    return success;
}

+ (BOOL)writeDataItem:(NSData *)itemData withName:(NSString *)savedName toFolder:(NSString *)folderPath
{
    BOOL success = NO;
    [self createFolderAtPath:folderPath];
    NSString *filePath = [folderPath stringByAppendingPathComponent:savedName];
    
    success = [[NSFileManager defaultManager] createFileAtPath:filePath contents:itemData attributes:nil];
    return success;
}

+ (BOOL)addSkipBackupAttributeToFile:(NSString *)path
{
    return [[NSURL.alloc initFileURLWithPath:path] setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:nil];
}

+ (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory
{
    return [NSFileManager.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)pathForDirectory:(NSSearchPathDirectory)directory
{
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES).firstObject;
}


#pragma mark - cookie相关
+ (BOOL)addCookieWithName:(nonnull NSString *)name
                    value:(nonnull NSString *)value
                   domain:(nonnull NSString *)domain
                     path:(nonnull NSString *)path
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
        _deviceModel =[self.class deviceModel];
        _deviceName = [self.class deviceName];
        _machineModel = [self.class machineModel];
        _machineModelName = [self.class machineModelName];
        _screenInchSize = [self.class screenInchSize];
        _CUPType = [self.class CUPType];
        _SIMType = [self.class SIMType];
        _batteryState = [self.class batteryState];
        _batteryLevel = [self.class batteryLevel];
        _isSimulator = [self.class isSimulator];
        _isJailbroken = [self.class isJailbroken];
        _isEnableTouchID = [self.class isEnableTouchID];
        _resolutionRatio = [self.class resolutionRatio];
        
        // 屏幕/尺寸相关
        _screenBrightness = [self.class screenBrightness];
        _isLandscape = [self.class isLandscape];
        _isDeviceLandscape = [self.class isDeviceLandscape];
        _deviceWidth = [self.class deviceWidth];
        _deviceHeight = [self.class deviceHeight];
        _screenWidth = [self.class screenWidth];
        _screenHeight = [self.class screenHeight];
        _statusBarHeight = [self.class statusBarHeight];
        _isNotchedScreen = [self.class isNotchedScreen];
        _is65InchScreen = [self.class is65InchScreen];
        _is61InchScreen = [self.class is61InchScreen];
        _is58InchScreen = [self.class is58InchScreen];
        _is55InchScreen = [self.class is55InchScreen];
        _is47InchScreen = [self.class is47InchScreen];
        _is40InchScreen = [self.class is40InchScreen];
        _is35InchScreen = [self.class is35InchScreen];
        _screenSizeFor65Inch = [self.class screenSizeFor65Inch];
        _screenSizeFor61Inch = [self.class screenSizeFor61Inch];
        _screenSizeFor58Inch = [self.class screenSizeFor58Inch];
        _screenSizeFor55Inch = [self.class screenSizeFor55Inch];
        _screenSizeFor47Inch = [self.class screenSizeFor47Inch];
        _screenSizeFor40Inch = [self.class screenSizeFor40Inch];
        _screenSizeFor35Inch = [self.class screenSizeFor35Inch];
        _isRetinaScreen = [self.class isRetinaScreen];
        _pixelOne = [self.class pixelOne];
        _homeIndicatorHeight = [self.class homeIndicatorHeight];
        _tabBarHeight = [self.class tabBarHeight];
        _navigationBarHeigh = [self.class navigationBarHeigh];
        _navigationPlusStatusBarHeight = [self.class navigationPlusStatusBarHeight];
        
        // 系统版本,软件相关
        _systemName = [self.class systemName];
        _systemVersion = [self.class systemVersion];
        _systemUptime = [self.class systemUptime];
        _iOS8OrLater = [self.class iOS8OrLater];
        _iOS9OrLater = [self.class iOS9OrLater];
        _iOS10OrLater = [self.class iOS10OrLater];
        _iOS11OrLater = [self.class iOS11OrLater];
        _iOS12OrLater = [self.class iOS12OrLater];
        _clipboardContent = [self.class clipboardContent];
        
        // 本地区域相关
        _country = [self.class country];
        _language = [self.class language];
        _timeZone = [self.class timeZone];
        _currency = [self.class currency];
        
        //网络相关
        _carrierName = [self.class carrierName];
        _carrierCountry = [self.class carrierCountry];
        _carrierISOCountryCode = [self.class carrierISOCountryCode];
        _carrierAllowsVOIP = [self.class carrierAllowsVOIP];
        _isOpenProxy = [self.class isOpenProxy];
        _isOpenVPN = [self.class isOpenVPN];
        _cellNetworkType = [self.class cellNetworkType];
        _isConnectedToCellNetwork = [self.class isConnectedToCellNetwork];
        _isConnectedToWiFi = [self.class isConnectedToWiFi];
        _WiFiName = [self.class WiFiName];
        _WiFiMacAddress = [self.class WiFiMacAddress];
        _ipAddressWiFi = [self.class ipAddressWiFi];
        _ipAddressCell = [self.class ipAddressCell];
        _externalIPAddress = [self.class externalIPAddress];
        
        //APP相关
        _appVersion = [self.class appVersion];
        _appDisplayName = [self.class appDisplayName];
        _appBuildVersion = [self.class appBuildVersion];
        
        //磁盘与内存
        _totalDiskSpace = [self.class totalDiskSpace];
        _usedDiskSpace = [self.class usedDiskSpace];
        _freeDiskSpace = [self.class freeDiskSpace];
        _memoryTotal = [self.class memoryTotal];
    }
    return self;
}

#pragma mark - setter and getter
- (void)setLanguage:(NSString *)language
{
    _language = language.copy;
    if (_language)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@[_language] forKey:@"AppleLanguages"];
    }
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
