//
//  LTPrivacyPermission.h
//  UniversalApp
//
//  Created by huanyu.li on 2018/8/24.
//  Copyright © 2018年 huanyu.li. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef NS_ENUM(NSUInteger, LTPrivacyPermissionType) {
    LTPrivacyPermissionTypePhoto = 0,
    LTPrivacyPermissionTypeCamera,
    LTPrivacyPermissionTypeMedia,
    LTPrivacyPermissionTypeMicrophone,
    LTPrivacyPermissionTypeLocationAlwaysAndWhenInUse,
    LTPrivacyPermissionTypeLocationAlways,
    LTPrivacyPermissionTypeLocationWhenInUse,
    LTPrivacyPermissionTypePushNotification,
    LTPrivacyPermissionTypeSpeech,
    LTPrivacyPermissionTypeEvent,
    LTPrivacyPermissionTypeContact,
    LTPrivacyPermissionTypeReminder,
    LTPrivacyPermissionTypeNetwork,
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
    LTPrivacyPermissionAuthorizationStatusServicesDisabled, // 服务不可用,或当前版本没有相应的api,这个时候 |CompletionBlock| 里的 |authorized| 默认返回NO,可以通过修改
};

typedef void(^CompletionBlock)(BOOL authorized, LTPrivacyPermissionAuthorizationStatus status);

@interface LTPrivacyPermission : NSObject

/* Methods for creating LTPrivacyPermission instances. */
@property (class, readonly, strong) LTPrivacyPermission *sharedPermission;

/**  当 |CompletionBlock| 返回 |status| 值为 LTPrivacyPermissionAuthorizationStatusServicesDisabled时的 |authorized| 值,默认是NO  */
@property (nonatomic, assign, getter=isServicesDisabledAuthorize) BOOL servicesDisabledAuthorize;

/**
 * @brief `Function for access the permissions` -> 获取权限函数
 * @param type `The enumeration type for access permission` -> 获取权限枚举类型
 * @param completion `A block for the permission result and the value of authorization status` -> 获取权限结果和对应权限状态的block
 */
- (void)accessPrivacyPermissionWithType:(LTPrivacyPermissionType)type
                             completion:(CompletionBlock)completion;


+ (void)showOpenApplicationSettingsAlertWithTitle:(NSString *)title message:(NSString *)message;

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
 <string>NFCReader</string>
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
 NSBluetoothPeripheralUsageDescription = "BluetoothUsage";
 NSAppleMusicUsageDescription = "AppleMusicUsage";
 NSCalendarsUsageDescription = "CalendarsUsage";
 NSCameraUsageDescription = "CameraUsage";
 NSContactsUsageDescription = "ContactsUsage";
 NSHealthShareUsageDescription = "HealthShareUsage";
 NSHealthUpdateUsageDescription = "HealthUpdateUsage";
 NSLocationWhenInUseUsageDescription = "LocationWhenInUseUsage";
 NSLocationUsageDescription = "LocationUsage";
 NSLocationAlwaysUsageDescription = "LocationAlwaysUsage";
 NSMicrophoneUsageDescription = "MicrophoneUsage";
 NSMotionUsageDescription = "MotionUsage";
 NSPhotoLibraryUsageDescription = "PhotoLibraryUsage";
 NSRemindersUsageDescription = "RemindersUsage";
 NSSpeechRecognitionUsageDescription = "SpeechRecognitionUsage";
 
 zh:
 NSBluetoothPeripheralUsageDescription = "需要你的同意,才能访问蓝牙";
 NSAppleMusicUsageDescription = "需要你的同意,才能访问媒体资料库";
 NSCalendarsUsageDescription = "需要你的同意,才能访问日历";
 NSCameraUsageDescription = "需要你的同意,才能访问相机";
 NSContactsUsageDescription = "需要你的同意,才能访问通讯录";
 NSHealthShareUsageDescription = "需要你的同意,才能访问健康分享";
 NSHealthUpdateUsageDescription = "需要你的同意,才能访问健康更新";
 NSLocationWhenInUseUsageDescription = "需要你的同意,才能在使用期间访问位置";
 NSLocationUsageDescription = "需要你的同意,才能访问位置";
 NSLocationAlwaysUsageDescription = "需要你的同意,才能始终访问位置";
 NSMicrophoneUsageDescription = "需要你的同意,才能访问麦克风";
 NSMotionUsageDescription = "需要你的同意,才能访问运动与健身";
 NSPhotoLibraryUsageDescription = "需要你的同意,才能媒体资料库";
 NSRemindersUsageDescription = "需要你的同意,才能访问备忘录";
 NSSpeechRecognitionUsageDescription = "需要你的同意,才能访问语音识别";
 
 */
