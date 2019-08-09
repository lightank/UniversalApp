//
//  LTPrivacyPermission.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/8/24.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#if __has_include("LTPrivacyPermissionHeader.h")
#import "LTPrivacyPermissionHeader.h"
#endif

/*
 
 由于某个版本后,写了申请权限的代码,但是没有在 /Info.plist/ 中配置相应的key,会导致提交审核的二进制被拒,被拒示例信息如下:
 
 This app attempts to access privacy-sensitive data without a usage description. The app's Info.plist must contain an NSPhotoLibraryUsageDescription key with a string value explaining to the user how the app uses this data.
 
 所以此库采用宏来条件编译,由于支持 /cocoapods/,所以可能不能修改.h文件,估建议在pch文件里定义下面的宏定义,需要哪一个权限就选用哪一个宏,或者自建一个 /LTPrivacyPermissionHeader.h/ 在这.h文件中定义所需宏
 
 #define LT_Permission_Photo    //0, 相册
 #define LT_Permission_Camera   //1, 相机
 #define LT_Permission_Microphone //2, 麦克风
 #define LT_Permission_Location_WhenInUse   //3, 使用期间访问地理位置
 #define LT_Permission_Location_Always  //4, 始终访问地理位置
 #define LT_Permission_Location_AlwaysAndWhenInUse  //5, 使用期间/始终访问地理位置
 #define LT_Permission_Contact   //6, 通讯录
 #define LT_Permission_PushNotification //7, 推送
 #define LT_Permission_MediaLibrary //8, 媒体资源库
 #define LT_Permission_Speech   //9, 语音识别
 #define LT_Permission_Calendar //10, 日历
 #define LT_Permission_Reminder  //11, 提醒事项
 #define LT_Permission_Network //12, 网络
 
 */

#define LT_Permission_Contact   //6, 通讯录

typedef NS_ENUM(NSUInteger, LTPrivacyPermissionType)
{
#ifdef LT_Permission_Photo
    // Privacy - Photo Library Usage Description : NSPhotoLibraryUsageDescription
    // Privacy - Photo Library Additions Usage Description (after iOS 11) : NSPhotoLibraryAddUsageDescription
    LTPrivacyPermissionTypePhoto = 0,   // 相册
#endif
    
#ifdef LT_Permission_Camera
    // Privacy - Camera Usage Description : NSCameraUsageDescription
    LTPrivacyPermissionTypeCamera = 1,  // 相机
#endif
    
#ifdef LT_Permission_Microphone
    // Privacy - Microphone Usage Description : NSMicrophoneUsageDescription
    LTPrivacyPermissionTypeMicrophone = 2,  // 麦克风
#endif
    
#ifdef LT_Permission_Location_WhenInUse
    // Privacy - Location When In Use Usage Description : NSLocationWhenInUseUsageDescription
    LTPrivacyPermissionTypeLocationWhenInUse = 3,   // 使用期间访问地理位置
#endif
    
#ifdef LT_Permission_Location_Always
    // Privacy - Location Always Usage Description : NSLocationAlwaysUsageDescription
    LTPrivacyPermissionTypeLocationAlways = 4,  // 始终访问地理位置
#endif
    
#ifdef LT_Permission_Location_AlwaysAndWhenInUse
    // Privacy - Location Always and When In Use Usage Description : NSLocationAlwaysAndWhenInUseUsageDescription
    LTPrivacyPermissionTypeLocationAlwaysAndWhenInUse = 5,  // 使用期间/始终访问地理位置
#endif
    
#ifdef LT_Permission_Contact
    // Privacy - Contacts Usage Description : NSContactsUsageDescription
    LTPrivacyPermissionTypeContact = 6, // 通讯录
#endif
    
#ifdef LT_Permission_PushNotification
    // 在iOS 10 以下,由于无法取得回调,故回调 |status| 返回 |Unkonwn|, |authorized| 返回 NO
    LTPrivacyPermissionTypePushNotification = 7,    // 推送
#endif
    
#ifdef LT_Permission_MediaLibrary
    // Privacy - Media Library Usage Description : NSAppleMusicUsageDescription
    LTPrivacyPermissionTypeMediaLibrary = 8,    // 媒体资源库
#endif
    
#ifdef LT_Permission_Speech
    // Privacy - Speech Recognition Usage Description : NSSpeechRecognitionUsageDescription
    LTPrivacyPermissionTypeSpeech = 9,  // 语音识别
#endif
    
#ifdef LT_Permission_Calendar
    // Privacy - Calendars Usage Description : NSCalendarsUsageDescription
    LTPrivacyPermissionTypeCalendar = 10,    // 日历
#endif
    
#ifdef LT_Permission_Reminder
    // Privacy - Reminders Usage Description : NSRemindersUsageDescription
    LTPrivacyPermissionTypeReminder = 11,    // 提醒事项
#endif
    
#ifdef LT_Permission_Network
    // For China
    LTPrivacyPermissionTypeNetwork = 12, // 网络
#endif
    // For null enum
    LTPrivacyPermissionTypeUnknown = 13, // 未知
};

typedef NS_ENUM(NSInteger, LTPrivacyPermissionAuthorizationStatus)
{
    LTPrivacyPermissionAuthorizationStatusAuthorized = 0,
    LTPrivacyPermissionAuthorizationStatusDenied,
    LTPrivacyPermissionAuthorizationStatusNotDetermined,
    LTPrivacyPermissionAuthorizationStatusRestricted,
    LTPrivacyPermissionAuthorizationStatusLocationAlways,
    LTPrivacyPermissionAuthorizationStatusLocationWhenInUse,
    LTPrivacyPermissionAuthorizationStatusUnkonwn,
    // 服务不可用,或当前版本没有相应的api,这个时候 |CompletionBlock| 里的 |authorized| 默认返回NO,可以通过 |servicesDisabledAuthorize| 来修改
    LTPrivacyPermissionAuthorizationStatusServicesDisabled,
};

typedef void(^LTPrivacyPermissionCompletionBlock)(BOOL authorized, LTPrivacyPermissionType type, LTPrivacyPermissionAuthorizationStatus status);

@interface LTPrivacyPermission : NSObject

/* Methods for creating LTPrivacyPermission instances. */
@property (class, readonly, strong) LTPrivacyPermission *sharedPermission;
/**  Topmost KeyWindow Controller  */
@property (class, readonly, strong) UIViewController *topmostKeyWindowController;


/**  当 |CompletionBlock| 返回 |status| 值为 LTPrivacyPermissionAuthorizationStatusServicesDisabled时的 |authorized| 值,默认是NO  */
@property (nonatomic, assign, getter=isServicesDisabledAuthorize) BOOL servicesDisabledAuthorize;

/**
 * @brief `Function for access the permissions` -> 获取权限函数
 * @param type `The enumeration type for access permission` -> 获取权限枚举类型
 * @param completion `A block for the permission result and the value of authorization status` -> 获取权限结果和对应权限状态的block
 */
- (void)accessPrivacyPermissionWithType:(LTPrivacyPermissionType)type
                             completion:(LTPrivacyPermissionCompletionBlock)completion;

/**
 * @brief `Function for check the permissions` -> 检查是否有无权限函数,仅做检测
 * @param type `The enumeration type for check permission` -> 检测权限枚举类型
 * @param completion `A block for the permission result and the value of authorization status` -> 检测权限结果和对应权限状态的block
 */
- (void)checkPrivacyPermissionWithType:(LTPrivacyPermissionType)type
                            completion:(LTPrivacyPermissionCompletionBlock)completion;


+ (void)openApplicationSettings;

+ (void)showOpenApplicationSettingsAlertWithTitle:(NSString *)title
                                          message:(NSString *)message
                                cancelActionTitle:(NSString *)cancelActionTitle
                               settingActionTitle:(NSString *)settingActionTitle;

@end

/*
 info.plist:
 
 <key>NSBluetoothPeripheralUsageDescription</key>
 <string>蓝牙/Bluetooth</string>
 <key>NSCalendarsUsageDescription</key>
 <string>日历/Calendars</string>
 <key>NSCameraUsageDescription</key>
 <string>相机/Camera</string>
 <key>NSContactsUsageDescription</key>
 <string>通讯录/Contacts</string>
 <key>NSFaceIDUsageDescription</key>
 <string>FaceID</string>
 <key>NSHealthShareUsageDescription</key>
 <string>健康数据分享/HealthShare</string>
 <key>NSHealthUpdateUsageDescription</key>
 <string>健康数据更新/HealthUpdate</string>
 <key>NSHomeKitUsageDescription</key>
 <string>HomeKit</string>
 <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
 <string>始终/使用期间使用位置信息/LocationAlwaysAndWhenInUse</string>
 <key>NSLocationWhenInUseUsageDescription</key>
 <string>使用期间访问位置</string>
 <key>NSLocationAlwaysUsageDescription</key>
 <string>始终使用位置信息/LocationAlways</string>
 <key>NSLocationUsageDescription</key>
 <string>位置信息/Location</string>
 <key>NSAppleMusicUsageDescription</key>
 <string>媒体资料库/Music</string>
 <key>NSMicrophoneUsageDescription</key>
 <string>麦克风/Microphone</string>
 <key>NSMotionUsageDescription</key>
 <string>运动与健身/Motion</string>
 <key>kTCCServiceMediaLibrary</key>
 <string>MediaLibrary</string>
 <key>NFCReaderUsageDescription</key>
 <string>NFC Reader</string>
 <key>NSPhotoLibraryAddUsageDescription</key>
 <string>向相册添加/PhotoLibraryAdd</string>
 <key>NSPhotoLibraryUsageDescription</key>
 <string>相册/PhotoLibrary</string>
 <key>NSRemindersUsageDescription</key>
 <string>提醒事项/Reminders</string>
 <key>NSSiriUsageDescription</key>
 <string>Siri</string>
 <key>NSSpeechRecognitionUsageDescription</key>
 <string>语音识别/Speech Recognition</string>
 <key>NSVideoSubscriberAccountUsageDescription</key>
 <string>视频订阅账号/VideoSubscriberAccount</string>
 
 国际化:
 
 en:
 NSBluetoothPeripheralUsageDescription = "BluetoothPeripheralUsage";
 NSCalendarsUsageDescription = "CalendarsUsage";
 NSCameraUsageDescription = "CameraUsage";
 NSContactsUsageDescription = "ContactsUsage";
 NSFaceIDUsageDescription = "FaceIDUsage";
 NSHealthShareUsageDescription = "HealthShare";
 NSHealthUpdateUsageDescription = "HealthUpdate";
 NSHomeKitUsageDescription = "HomeKit";
 NSLocationAlwaysAndWhenInUseUsageDescription = "LocationAlwaysAndWhenInUseUsage";
 NSLocationWhenInUseUsageDescription = "LocationWhenInUseUsage";
 NSLocationAlwaysUsageDescription = "LocationAlways";
 NSLocationUsageDescription = "LocationUsage";
 NSAppleMusicUsageDescription = "AppleMusicUsage";
 NSMicrophoneUsageDescription = "MicrophoneUsage";
 NSMotionUsageDescription = "MotionUsage";
 kTCCServiceMediaLibrary = "MediaLibraryUsage";
 NFCReaderUsageDescription = "NFCReaderUsage";
 NSPhotoLibraryAddUsageDescription = "PhotoLibraryAddUsage";
 NSPhotoLibraryUsageDescription = "PhotoLibraryUsage";
 NSRemindersUsageDescription = "RemindersUsage";
 NSSiriUsageDescription = "SiriUsage";
 NSSpeechRecognitionUsageDescription = "SpeechRecognitionUsage";
 NSVideoSubscriberAccountUsageDescription = "VideoSubscriberAccount";
 
 zh:
 NSBluetoothPeripheralUsageDescription = "需要你的同意,才能访问蓝牙";
 NSCalendarsUsageDescription = "需要你的同意,才能访问日历";
 NSCameraUsageDescription = "需要你的同意,才能访问相机";
 NSContactsUsageDescription = "需要你的同意,才能访问通讯录";
 NSFaceIDUsageDescription = "需要你的同意,才能访问FaceID";
 NSHealthShareUsageDescription = "需要你的同意,才能访问健康分享";
 NSHealthUpdateUsageDescription = "需要你的同意,才能访问健康更新";
 NSHomeKitUsageDescription = "需要你的同意,才能访问HomeKit";
 NSLocationAlwaysAndWhenInUseUsageDescription = "需要你的同意,才能始终访问位置";
 NSLocationWhenInUseUsageDescription = "需要你的同意,才能在使用期间访问位置";
 NSLocationAlwaysUsageDescription = "需要你的同意,才能始终访问位置";
 NSLocationUsageDescription = "需要你的同意,才能访问位置";
 NSAppleMusicUsageDescription = "需要你的同意,才能访问媒体资料库";
 NSMicrophoneUsageDescription = "需要你的同意,才能访问麦克风";
 NSMotionUsageDescription = "需要你的同意,才能访问运动与健身";
 kTCCServiceMediaLibrary = "需要你的同意,才能访问媒体库";
 NFCReaderUsageDescription = "需要你的同意,才能访问NFC Reader";
 NSPhotoLibraryAddUsageDescription = "需要你的同意,才能向相册添加图片";
 NSPhotoLibraryUsageDescription = "需要你的同意,才能访问相册";
 NSRemindersUsageDescription = "需要你的同意,才能访问提醒事项";
 NSSiriUsageDescription = "需要你的同意,才能访问Siri";
 NSSpeechRecognitionUsageDescription = "需要你的同意,才能访问语音识别";
 NSVideoSubscriberAccountUsageDescription = "需要你的同意,才能访问视频订阅账号";
 
 */
